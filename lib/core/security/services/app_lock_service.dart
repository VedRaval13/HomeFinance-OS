import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Secure service managing App PIN and Biometric authentication.
class AppLockService {
  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  static const String _keyLockEnabled = 'app_lock_enabled';
  static const String _keyBiometricsEnabled = 'app_lock_biometrics_enabled';
  static const String _keyPinHash = 'app_lock_pin_hash';
  static const String _keyPinSalt = 'app_lock_pin_salt';
  static const String _keyPinLength = 'app_lock_pin_length';
  static const String _keyFailedAttempts = 'app_lock_failed_attempts';
  static const String _keyLockoutUntil = 'app_lock_lockout_until';

  /// Maximum failed PIN attempts allowed before progressive lockout tiers trigger.
  static const int maxFailedAttemptsBeforeShortLockout = 5;
  static const int maxFailedAttemptsBeforeLongLockout = 10;

  bool _isLocked = false;

  AppLockService({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  }) : _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           ),
       _localAuth = localAuth ?? LocalAuthentication();

  /// Whether the app is currently in a locked state requiring authentication.
  bool get isLocked => _isLocked;

  /// Manually lock the app.
  void lock() {
    _isLocked = true;
  }

  /// Mark the app as unlocked.
  void unlock() {
    _isLocked = false;
  }

  /// Whether App Lock is currently enabled by the user.
  Future<bool> isLockEnabled() async {
    final val = await _storage.read(key: _keyLockEnabled);
    return val == 'true';
  }

  /// Whether Biometric authentication is enabled.
  Future<bool> isBiometricsEnabled() async {
    final val = await _storage.read(key: _keyBiometricsEnabled);
    return val == 'true';
  }

  /// Whether a PIN has already been set.
  Future<bool> hasPinSet() async {
    final hash = await _storage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  /// Checks if the hardware supports biometrics.
  Future<bool> canUseBiometrics() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Gets the configured PIN length (4 or 6). Defaults to 4.
  Future<int> getPinLength() async {
    final val = await _storage.read(key: _keyPinLength);
    final len = int.tryParse(val ?? '');
    return (len == 6) ? 6 : 4;
  }

  /// Sets or updates the master App PIN.
  Future<void> setPin(String pin) async {
    if (pin.length != 4 && pin.length != 6) {
      throw ArgumentError('PIN must be either 4 or 6 digits');
    }

    final salt = _generateRandomSalt(16);
    final hash = _hashPin(pin, salt);

    await _storage.write(key: _keyPinSalt, value: salt);
    await _storage.write(key: _keyPinHash, value: hash);
    await _storage.write(key: _keyPinLength, value: pin.length.toString());
    await _storage.write(key: _keyLockEnabled, value: 'true');
    await resetFailedAttempts();
    _isLocked = false;
  }

  /// Returns remaining lockout time in seconds, or 0 if not locked out.
  Future<int> getRemainingLockoutSeconds() async {
    final val = await _storage.read(key: _keyLockoutUntil);
    if (val == null || val.isEmpty) return 0;

    final lockoutUntil = DateTime.tryParse(val);
    if (lockoutUntil == null) return 0;

    final diff = lockoutUntil.difference(DateTime.now()).inSeconds;
    if (diff <= 0) {
      await _storage.delete(key: _keyLockoutUntil);
      return 0;
    }
    return diff;
  }

  /// Returns count of consecutive failed attempts.
  Future<int> getFailedAttempts() async {
    final val = await _storage.read(key: _keyFailedAttempts);
    return int.tryParse(val ?? '0') ?? 0;
  }

  /// Resets failed attempt counter and active lockout timers.
  Future<void> resetFailedAttempts() async {
    await _storage.delete(key: _keyFailedAttempts);
    await _storage.delete(key: _keyLockoutUntil);
  }

  /// Verifies entered PIN against stored salted hash with brute-force rate limiting.
  Future<bool> verifyPin(String enteredPin) async {
    // 1. Guard against active lockout period
    final remainingLockout = await getRemainingLockoutSeconds();
    if (remainingLockout > 0) {
      return false;
    }

    final storedHash = await _storage.read(key: _keyPinHash);
    final storedSalt = await _storage.read(key: _keyPinSalt);

    if (storedHash == null || storedSalt == null) return false;

    final computedHash = _hashPin(enteredPin, storedSalt);
    final isValid = _constantTimeCompare(storedHash, computedHash);

    if (isValid) {
      await resetFailedAttempts();
      _isLocked = false;
      return true;
    } else {
      final currentAttempts = (await getFailedAttempts()) + 1;
      await _storage.write(
        key: _keyFailedAttempts,
        value: currentAttempts.toString(),
      );

      if (currentAttempts >= maxFailedAttemptsBeforeLongLockout) {
        // 5-minute lockout (300 seconds)
        final lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
        await _storage.write(
          key: _keyLockoutUntil,
          value: lockoutUntil.toIso8601String(),
        );
      } else if (currentAttempts >= maxFailedAttemptsBeforeShortLockout) {
        // 30-second lockout
        final lockoutUntil = DateTime.now().add(const Duration(seconds: 30));
        await _storage.write(
          key: _keyLockoutUntil,
          value: lockoutUntil.toIso8601String(),
        );
      }
      return false;
    }
  }

  /// Authenticates using biometrics (fingerprint / face ID).
  Future<bool> authenticateBiometrics({
    String reason = 'Authenticate to access HomeFinance OS',
  }) async {
    final canAuth = await canUseBiometrics();
    if (!canAuth) return false;

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await resetFailedAttempts();
        _isLocked = false;
      }
      return authenticated;
    } catch (_) {
      return false;
    }
  }

  /// Enables or disables App Lock.
  Future<void> setLockEnabled(bool enabled) async {
    await _storage.write(
      key: _keyLockEnabled,
      value: enabled ? 'true' : 'false',
    );
    if (!enabled) {
      await resetFailedAttempts();
      _isLocked = false;
    }
  }

  /// Enables or disables Biometrics.
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(
      key: _keyBiometricsEnabled,
      value: enabled ? 'true' : 'false',
    );
  }

  /// Completely removes PIN and disables App Lock.
  Future<void> removePinAndDisableLock() async {
    await _storage.delete(key: _keyPinHash);
    await _storage.delete(key: _keyPinSalt);
    await _storage.delete(key: _keyPinLength);
    await resetFailedAttempts();
    await _storage.write(key: _keyLockEnabled, value: 'false');
    await _storage.write(key: _keyBiometricsEnabled, value: 'false');
    _isLocked = false;
  }

  /// Hashes a PIN using a random salt with 10,000 PBKDF2 HMAC-SHA256 iterations.
  static String _hashPin(String pin, String saltHex) {
    final pinBytes = utf8.encode(pin);
    final saltBytes = _hexToBytes(saltHex);

    List<int> current = Hmac(sha256, pinBytes).convert(saltBytes).bytes;
    for (int i = 1; i < 10000; i++) {
      current = Hmac(sha256, pinBytes).convert(current).bytes;
    }

    return _bytesToHex(current);
  }

  static String _generateRandomSalt(int length) {
    final rnd = Random.secure();
    final bytes = List<int>.generate(length, (_) => rnd.nextInt(256));
    return _bytesToHex(bytes);
  }

  static bool _constantTimeCompare(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
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
