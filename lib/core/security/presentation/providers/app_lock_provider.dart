import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database_provider.dart';
import '../../backup/backup_service.dart';
import '../../services/app_lock_service.dart';

/// Provider for [AppLockService].
final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

/// Provider for [BackupService].
final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BackupService(db);
});

/// State of App Security configuration.
class SecuritySettingsState {
  final bool isLockEnabled;
  final bool isBiometricsEnabled;
  final bool hasPinSet;
  final bool canUseBiometrics;
  final int pinLength;
  final bool isLoading;

  const SecuritySettingsState({
    required this.isLockEnabled,
    required this.isBiometricsEnabled,
    required this.hasPinSet,
    required this.canUseBiometrics,
    this.pinLength = 4,
    this.isLoading = false,
  });

  static const initial = SecuritySettingsState(
    isLockEnabled: false,
    isBiometricsEnabled: false,
    hasPinSet: false,
    canUseBiometrics: false,
    pinLength: 4,
    isLoading: true,
  );

  SecuritySettingsState copyWith({
    bool? isLockEnabled,
    bool? isBiometricsEnabled,
    bool? hasPinSet,
    bool? canUseBiometrics,
    int? pinLength,
    bool? isLoading,
  }) {
    return SecuritySettingsState(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      hasPinSet: hasPinSet ?? this.hasPinSet,
      canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
      pinLength: pinLength ?? this.pinLength,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// StateNotifier for Security Settings.
class SecuritySettingsNotifier extends StateNotifier<SecuritySettingsState> {
  final AppLockService _service;

  SecuritySettingsNotifier(this._service)
    : super(SecuritySettingsState.initial) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final lockEnabled = await _service.isLockEnabled();
    final bioEnabled = await _service.isBiometricsEnabled();
    final hasPin = await _service.hasPinSet();
    final canBio = await _service.canUseBiometrics();
    final pinLength = await _service.getPinLength();

    state = SecuritySettingsState(
      isLockEnabled: lockEnabled,
      isBiometricsEnabled: bioEnabled,
      hasPinSet: hasPin,
      canUseBiometrics: canBio,
      pinLength: pinLength,
      isLoading: false,
    );
  }

  Future<void> setPin(String pin) async {
    await _service.setPin(pin);
    await loadSettings();
  }

  Future<void> toggleLock(bool enabled) async {
    await _service.setLockEnabled(enabled);
    await loadSettings();
  }

  Future<void> toggleBiometrics(bool enabled) async {
    await _service.setBiometricsEnabled(enabled);
    await loadSettings();
  }

  Future<void> disableAndRemovePin() async {
    await _service.removePinAndDisableLock();
    await loadSettings();
  }
}

final securitySettingsProvider =
    StateNotifierProvider<SecuritySettingsNotifier, SecuritySettingsState>((
      ref,
    ) {
      final service = ref.watch(appLockServiceProvider);
      return SecuritySettingsNotifier(service);
    });
