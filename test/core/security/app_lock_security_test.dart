import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/security/services/app_lock_service.dart';
import 'package:local_auth/local_auth.dart';

class MockLocalAuth extends Fake implements LocalAuthentication {
  bool shouldSucceed = true;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<bool> get canCheckBiometrics async => true;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<dynamic> authMessages = const [],
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async => shouldSucceed;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLockService — Security & Brute-Force Rate Limiting Tests', () {
    late FlutterSecureStorage storage;
    late MockLocalAuth mockAuth;
    late AppLockService lockService;

    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});
      storage = const FlutterSecureStorage();
      mockAuth = MockLocalAuth();
      lockService = AppLockService(storage: storage, localAuth: mockAuth);
      await lockService.setPin('1234');
    });

    test('Verifies correct PIN and resets failed attempts counter', () async {
      final valid = await lockService.verifyPin('1234');
      expect(valid, isTrue);
      expect(await lockService.getFailedAttempts(), equals(0));
      expect(await lockService.getRemainingLockoutSeconds(), equals(0));
    });

    test('Increments failed attempts on incorrect PIN entry', () async {
      final valid = await lockService.verifyPin('0000');
      expect(valid, isFalse);
      expect(await lockService.getFailedAttempts(), equals(1));
      expect(await lockService.getRemainingLockoutSeconds(), equals(0));
    });

    test('Triggers 30-second progressive lockout after 5 consecutive failed attempts', () async {
      for (int i = 0; i < 4; i++) {
        expect(await lockService.verifyPin('9999'), isFalse);
      }
      expect(await lockService.getFailedAttempts(), equals(4));
      expect(await lockService.getRemainingLockoutSeconds(), equals(0));

      // 5th failed attempt triggers lockout
      expect(await lockService.verifyPin('9999'), isFalse);
      expect(await lockService.getFailedAttempts(), equals(5));

      final remaining = await lockService.getRemainingLockoutSeconds();
      expect(remaining, greaterThan(0));
      expect(remaining, lessThanOrEqualTo(30));

      // During active lockout, even correct PIN is rejected
      expect(await lockService.verifyPin('1234'), isFalse);
    });

    test('Successful biometric authentication unlocks and resets lockout', () async {
      // Cause lockout with 5 failed attempts
      for (int i = 0; i < 5; i++) {
        await lockService.verifyPin('9999');
      }
      expect(await lockService.getRemainingLockoutSeconds(), greaterThan(0));

      // Authenticate via biometrics
      final authSuccess = await lockService.authenticateBiometrics();
      expect(authSuccess, isTrue);

      // Lockout is cleared
      expect(await lockService.getRemainingLockoutSeconds(), equals(0));
      expect(await lockService.getFailedAttempts(), equals(0));
      expect(lockService.isLocked, isFalse);
    });

    test('Resetting PIN clears any prior failed attempts or lockout timers', () async {
      for (int i = 0; i < 5; i++) {
        await lockService.verifyPin('9999');
      }
      expect(await lockService.getRemainingLockoutSeconds(), greaterThan(0));

      // User sets new PIN
      await lockService.setPin('5678');
      expect(await lockService.getRemainingLockoutSeconds(), equals(0));
      expect(await lockService.getFailedAttempts(), equals(0));

      // New PIN works immediately
      expect(await lockService.verifyPin('5678'), isTrue);
    });
  });
}
