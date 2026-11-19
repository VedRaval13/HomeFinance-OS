import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/security/backup/backup_crypto.dart';

void main() {
  group('BackupCrypto Authenticated Encryption Engine', () {
    const testPlaintext =
        '{"app":"HomeFinance OS","accounts":[{"id":"acc-1","balance":5000000}]}';
    const validPassphrase = 'SuperSecretFamilyKey123!';

    test(
      'Encrypts and decrypts payload successfully with correct passphrase',
      () {
        final encrypted = BackupCrypto.encryptBackup(
          plaintext: testPlaintext,
          passphrase: validPassphrase,
        );

        expect(encrypted, isNotEmpty);
        expect(encrypted.contains(BackupCrypto.magicHeader), isTrue);

        final decrypted = BackupCrypto.decryptBackup(
          encryptedPayload: encrypted,
          passphrase: validPassphrase,
        );

        expect(decrypted, equals(testPlaintext));
      },
    );

    test('Fails authentication when incorrect passphrase is provided', () {
      final encrypted = BackupCrypto.encryptBackup(
        plaintext: testPlaintext,
        passphrase: validPassphrase,
      );

      expect(
        () => BackupCrypto.decryptBackup(
          encryptedPayload: encrypted,
          passphrase: 'WrongPassphrase456!',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('Fails authentication when ciphertext is tampered (Encrypt-then-MAC integrity check)', () {
      final encrypted = BackupCrypto.encryptBackup(
        plaintext: testPlaintext,
        passphrase: validPassphrase,
      );

      final envelope = jsonDecode(encrypted) as Map<String, dynamic>;
      final tamperedCiphertext = base64.encode(
        base64.decode(envelope['ciphertext'] as String)..first ^= 0xFF,
      );
      envelope['ciphertext'] = tamperedCiphertext;

      final tamperedPayload = jsonEncode(envelope);

      expect(
        () => BackupCrypto.decryptBackup(
          encryptedPayload: tamperedPayload,
          passphrase: validPassphrase,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('Throws FormatException on invalid file header or corrupted JSON', () {
      expect(
        () => BackupCrypto.decryptBackup(
          encryptedPayload: '{"magic":"INVALID_HEADER"}',
          passphrase: validPassphrase,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
