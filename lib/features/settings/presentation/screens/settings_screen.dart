import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/security/presentation/dialogs/backup_restore_dialogs.dart';
import '../../../../core/security/presentation/dialogs/set_pin_dialog.dart';
import '../../../../core/security/presentation/providers/app_lock_provider.dart';
import '../../../../shared/widgets/app_card.dart';

/// Complete Settings & Security management screen for HomeFinance OS.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final security = ref.watch(securitySettingsProvider);
    final securityNotifier = ref.read(securitySettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings & Security',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          // Security Section
          Text(
            'App Security & Protection',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('App Lock (PIN Protection)'),
                  subtitle: Text(
                    security.hasPinSet
                        ? (security.isLockEnabled
                              ? 'PIN lock active on app launch'
                              : 'PIN configured (currently disabled)')
                        : 'No PIN set (tap to configure)',
                  ),
                  value: security.isLockEnabled,
                  onChanged: (val) {
                    if (val) {
                      if (!security.hasPinSet) {
                        SetPinDialog.show(context);
                      } else {
                        securityNotifier.toggleLock(true);
                      }
                    } else {
                      securityNotifier.toggleLock(false);
                    }
                  },
                  secondary: const Icon(Icons.lock_outline_rounded),
                ),
                if (security.hasPinSet) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.pin_outlined),
                    title: const Text('Change Master App PIN'),
                    subtitle: const Text(
                      'Update your 4-6 digit local passcode',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => SetPinDialog.show(context, isChange: true),
                  ),
                ],
                if (security.canUseBiometrics) ...[
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Unlock with Fingerprint or Face ID'),
                    value: security.isBiometricsEnabled,
                    onChanged: security.isLockEnabled
                        ? (val) => securityNotifier.toggleBiometrics(val)
                        : null,
                    secondary: const Icon(Icons.fingerprint_rounded),
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: const Text('Hardware Key Protection'),
                  subtitle: const Text(
                    'Android Keystore & EncryptedSharedPreferences',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.income.withValues(alpha: 0.12),
                      borderRadius: AppDimensions.borderRadiusSmall,
                    ),
                    child: Text(
                      'Secured',
                      style: TextStyle(
                        color: AppColors.income,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Data & Backup Section
          Text(
            'Local-First Data & Backup',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.enhanced_encryption_rounded),
                  title: const Text('Create Encrypted Backup'),
                  subtitle: const Text(
                    'Export password-protected AES-256 archive (.hfbk)',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => CreateBackupDialog.show(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_page_rounded),
                  title: const Text('Restore Encrypted Backup'),
                  subtitle: const Text(
                    'Recover records from a previously exported archive',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => RestoreBackupDialog.show(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Local SQLite Architecture'),
                  subtitle: const Text(
                    'WAL Mode, PRAGMA foreign_keys = ON, Zero Cloud',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppDimensions.borderRadiusSmall,
                    ),
                    child: Text(
                      'Local-First',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Financial Preferences
          Text(
            'Financial Preferences',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.currency_rupee_rounded),
                  title: const Text('Default Currency'),
                  subtitle: const Text(
                    'Indian Rupee (₹ INR) • Exact Integer Paise Units',
                  ),
                  trailing: const Text(
                    '₹ INR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.pin_end_rounded),
                  title: const Text('Numbering System'),
                  subtitle: const Text(
                    'Indian Numbering Format (Lakhs & Crores: ₹1,23,456.78)',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // About Section
          Text(
            'About HomeFinance OS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local-First Family & Personal Financial Operating System\nVersion 1.0.0 (Build 1)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No backend server • No Firebase • No cloud database • 100% On-Device Data Sovereignty',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.income,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
