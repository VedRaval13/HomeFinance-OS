import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_dimensions.dart';
import '../providers/app_lock_provider.dart';

/// Modal dialog to create an authenticated, encrypted AES-256 backup archive.
class CreateBackupDialog extends ConsumerStatefulWidget {
  const CreateBackupDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateBackupDialog(),
    );
  }

  @override
  ConsumerState<CreateBackupDialog> createState() => _CreateBackupDialogState();
}

class _CreateBackupDialogState extends ConsumerState<CreateBackupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passphraseController = TextEditingController();
  final _confirmPassphraseController = TextEditingController();
  bool _obscure = true;
  bool _isCreating = false;

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmPassphraseController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final pass = _passphraseController.text.trim();
    final confirm = _confirmPassphraseController.text.trim();

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passphrases do not match.')),
      );
      return;
    }

    setState(() => _isCreating = true);
    final backupService = ref.read(backupServiceProvider);

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${docDir.path}/backups');
      if (!backupDir.existsSync()) {
        backupDir.createSync(recursive: true);
      }

      final file = await backupService.createEncryptedBackup(
        passphrase: pass,
        targetDirectoryPath: backupDir.path,
      );

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.income),
                SizedBox(width: 8),
                Text('Backup Created'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your encrypted backup file has been securely saved to:',
                ),
                const SizedBox(height: 8),
                SelectableText(
                  file.path,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Keep your passphrase in a secure password manager. It is required to restore this archive.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create backup: $e')));
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: AppDimensions.borderRadiusSmall,
                      ),
                      child: Icon(
                        Icons.enhanced_encryption_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Encrypted Backup',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Protect financial records with AES-256 encryption',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space16),

                Container(
                  padding: const EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusMedium,
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your passphrase is never stored. If you lose it, this backup file cannot be decrypted.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),

                TextFormField(
                  controller: _passphraseController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Backup Passphrase (min 6 chars) *',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'Passphrase must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                TextFormField(
                  controller: _confirmPassphraseController,
                  obscureText: _obscure,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Passphrase *',
                    prefixIcon: Icon(Icons.check_circle_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val != _passphraseController.text) {
                      return 'Passphrases must match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isCreating
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton(
                      onPressed: _isCreating ? null : _handleCreate,
                      child: _isCreating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Generate Archive'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

/// Modal dialog to restore financial records from an encrypted backup archive.
class RestoreBackupDialog extends ConsumerStatefulWidget {
  const RestoreBackupDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const RestoreBackupDialog(),
    );
  }

  @override
  ConsumerState<RestoreBackupDialog> createState() =>
      _RestoreBackupDialogState();
}

class _RestoreBackupDialogState extends ConsumerState<RestoreBackupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pathController = TextEditingController();
  final _passphraseController = TextEditingController();
  bool _obscure = true;
  bool _isRestoring = false;
  List<File> _availableBackups = [];

  @override
  void initState() {
    super.initState();
    _scanAvailableBackups();
  }

  Future<void> _scanAvailableBackups() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${docDir.path}/backups');
      if (backupDir.existsSync()) {
        final files = backupDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.hfbk'))
            .toList();
        setState(() {
          _availableBackups = files;
          if (files.isNotEmpty) {
            _pathController.text = files.last.path;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pathController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  Future<void> _handleRestore() async {
    if (!_formKey.currentState!.validate()) return;

    final targetFile = File(_pathController.text.trim());
    if (!targetFile.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup file does not exist at the specified path.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace Local Database?'),
        content: const Text(
          'Restoring an encrypted backup replaces existing records on this device with the contents of the archive. This cannot be undone.\n\nDo you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Proceed & Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isRestoring = true);
    final backupService = ref.read(backupServiceProvider);

    try {
      final result = await backupService.restoreEncryptedBackup(
        backupFile: targetFile,
        passphrase: _passphraseController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.income),
                SizedBox(width: 8),
                Text('Restoration Complete'),
              ],
            ),
            content: Text(
              'Successfully restored:\n• ${result.members} Family Members\n• ${result.accounts} Accounts\n• ${result.transactions} Transactions\n• ${result.transfers} Transfers',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Restoration failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.12),
                        borderRadius: AppDimensions.borderRadiusSmall,
                      ),
                      child: Icon(
                        Icons.restore_page_rounded,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restore Encrypted Backup',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Recover records from a .hfbk archive',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space16),

                if (_availableBackups.isNotEmpty) ...[
                  Text(
                    'Discovered Backups on Device:',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: AppDimensions.borderRadiusSmall,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _availableBackups.length,
                      itemBuilder: (ctx, i) {
                        final file = _availableBackups[i];
                        final name = file.path
                            .split(Platform.pathSeparator)
                            .last;
                        return ListTile(
                          dense: true,
                          title: Text(
                            name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: const Icon(
                            Icons.file_open_outlined,
                            size: 16,
                          ),
                          onTap: () =>
                              setState(() => _pathController.text = file.path),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                ],

                TextFormField(
                  controller: _pathController,
                  decoration: const InputDecoration(
                    labelText: 'Backup File Absolute Path *',
                    hintText: '/path/to/homefinance_backup.hfbk',
                    prefixIcon: Icon(Icons.folder_open_rounded),
                    border: OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please specify backup file path';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                TextFormField(
                  controller: _passphraseController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Passphrase *',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter decryption passphrase';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isRestoring
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton(
                      onPressed: _isRestoring ? null : _handleRestore,
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: _isRestoring
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verify & Restore'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
