import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Cryptographic engine providing authenticated encryption (HMAC-SHA256 in Counter Mode + Encrypt-then-MAC)
/// with PBKDF2 key derivation for local-first encrypted backups.
class BackupCrypto {
  static const String magicHeader = 'HFOS';
  static const int currentVersion = 1;
  static const int currentPbkdf2Iterations = 100000;
  static const int legacyPbkdf2Iterations = 10000;
  static const int pbkdf2Iterations = currentPbkdf2Iterations;

  /// Encrypts plaintext database payload with user passphrase.
  static String encryptBackup({
    required String plaintext,
    required String passphrase,
    int iterations = currentPbkdf2Iterations,
  }) {
    final salt = _randomBytes(16);
    final iv = _randomBytes(16);

    // Derive 64 bytes: 32 bytes for encryption, 32 bytes for authentication MAC
    final derivedKeys = _deriveKeys(passphrase, salt, 64, iterations: iterations);
    final encKey = derivedKeys.sublist(0, 32);
    final macKey = derivedKeys.sublist(32, 64);

    final plaintextBytes = utf8.encode(plaintext);
    final ciphertextBytes = _processCtr(plaintextBytes, encKey, iv);

    // Compute MAC over header + version + salt + iv + ciphertext (Encrypt-then-MAC)
    final macPayload = BytesBuilder()
      ..add(utf8.encode(magicHeader))
      ..add([currentVersion])
      ..add(salt)
      ..add(iv)
      ..add(ciphertextBytes);

    final mac = Hmac(sha256, macKey).convert(macPayload.toBytes()).bytes;

    final envelope = {
      'magic': magicHeader,
      'version': currentVersion,
      'iterations': iterations,
      'salt': _bytesToHex(salt),
      'iv': _bytesToHex(iv),
      'mac': _bytesToHex(mac),
      'ciphertext': base64.encode(ciphertextBytes),
      'timestamp': DateTime.now().toIso8601String(),
    };

    return jsonEncode(envelope);
  }

  /// Decrypts and authenticates an encrypted backup payload.
  /// Throws [FormatException] if structure is invalid or [StateError] if passphrase or MAC fails.
  static String decryptBackup({
    required String encryptedPayload,
    required String passphrase,
  }) {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(encryptedPayload) as Map<String, dynamic>;
    } catch (e) {
      throw const FormatException('Invalid backup file format.');
    }

    if (envelope['magic'] != magicHeader) {
      throw const FormatException(
        'Unrecognized file header. Not a HomeFinance OS backup.',
      );
    }

    final version = envelope['version'] as int? ?? 0;
    if (version > currentVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    final iterations = envelope['iterations'] as int? ?? legacyPbkdf2Iterations;
    final salt = _hexToBytes(envelope['salt'] as String);
    final iv = _hexToBytes(envelope['iv'] as String);
    final expectedMac = _hexToBytes(envelope['mac'] as String);
    final ciphertextBytes = base64.decode(envelope['ciphertext'] as String);

    // Derive keys with user passphrase
    final derivedKeys = _deriveKeys(
      passphrase,
      salt,
      64,
      iterations: iterations,
    );
    final encKey = derivedKeys.sublist(0, 32);
    final macKey = derivedKeys.sublist(32, 64);

    // Verify MAC before decryption (prevents padding/timing oracle and detects wrong passphrase)
    final macPayload = BytesBuilder()
      ..add(utf8.encode(magicHeader))
      ..add([version])
      ..add(salt)
      ..add(iv)
      ..add(ciphertextBytes);

    final actualMac = Hmac(sha256, macKey).convert(macPayload.toBytes()).bytes;

    if (!_constantTimeCompare(expectedMac, actualMac)) {
      throw StateError(
        'Authentication failed: Incorrect passphrase or corrupted backup.',
      );
    }

    // Decrypt ciphertext
    final decryptedBytes = _processCtr(ciphertextBytes, encKey, iv);
    return utf8.decode(decryptedBytes);
  }

  /// Processes bytes using HMAC-SHA256 in Counter Mode (symmetric for both encrypt and decrypt).
  static Uint8List _processCtr(List<int> input, List<int> key, List<int> iv) {
    final output = Uint8List(input.length);
    final hmac = Hmac(sha256, key);

    int blockCounter = 0;
    int offset = 0;

    while (offset < input.length) {
      // Counter block = IV (16 bytes) + 4-byte counter
      final counterBytes = ByteData(4)..setUint32(0, blockCounter, Endian.big);
      final blockInput = BytesBuilder()
        ..add(iv)
        ..add(counterBytes.buffer.asUint8List());

      final keystream = hmac.convert(blockInput.toBytes()).bytes;
      final chunkSize = min(32, input.length - offset);

      for (int i = 0; i < chunkSize; i++) {
        output[offset + i] = input[offset + i] ^ keystream[i];
      }

      offset += chunkSize;
      blockCounter++;
    }

    return output;
  }

  /// PBKDF2 implementation using HMAC-SHA256 with parameterized iterations.
  static List<int> _deriveKeys(
    String passphrase,
    List<int> salt,
    int targetLength, {
    int iterations = currentPbkdf2Iterations,
  }) {
    final passBytes = utf8.encode(passphrase);
    final hmac = Hmac(sha256, passBytes);

    final numBlocks = (targetLength + 31) ~/ 32;
    final derived = BytesBuilder();

    for (int blockIndex = 1; blockIndex <= numBlocks; blockIndex++) {
      // U1 = HMAC(passphrase, salt || INT_32_BE(blockIndex))
      final blockBytes = ByteData(4)..setUint32(0, blockIndex, Endian.big);
      final initialInput = BytesBuilder()
        ..add(salt)
        ..add(blockBytes.buffer.asUint8List());

      var u = hmac.convert(initialInput.toBytes()).bytes;
      final t = List<int>.from(u);

      for (int iter = 1; iter < iterations; iter++) {
        u = hmac.convert(u).bytes;
        for (int k = 0; k < 32; k++) {
          t[k] ^= u[k];
        }
      }

      derived.add(t);
    }

    return derived.toBytes().sublist(0, targetLength);
  }

  static List<int> _randomBytes(int count) {
    final rnd = Random.secure();
    return List<int>.generate(count, (_) => rnd.nextInt(256));
  }

  static bool _constantTimeCompare(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  static String _bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static List<int> _hexToBytes(String hex) {
    final result = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }
}
