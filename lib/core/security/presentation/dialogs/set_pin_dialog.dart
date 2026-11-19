import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_dimensions.dart';
import '../providers/app_lock_provider.dart';

/// Modal dialog allowing the user to configure or update their master app PIN.
class SetPinDialog extends ConsumerStatefulWidget {
  final bool isChange;

  const SetPinDialog({super.key, this.isChange = false});

  static Future<void> show(BuildContext context, {bool isChange = false}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SetPinDialog(isChange: isChange),
    );
  }

  @override
  ConsumerState<SetPinDialog> createState() => _SetPinDialogState();
}

class _SetPinDialogState extends ConsumerState<SetPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  int _pinLength = 4;
  bool _obscurePin = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _pinLength = ref.read(securitySettingsProvider).pinLength;
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final pin = _pinController.text.trim();
    final confirm = _confirmPinController.text.trim();

    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match. Please re-enter.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(securitySettingsProvider.notifier).setPin(pin);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isChange
                  ? 'App PIN updated successfully!'
                  : 'App PIN set and lock enabled!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to set PIN: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
        constraints: const BoxConstraints(maxWidth: 440),
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
                        Icons.lock_outline_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isChange
                                ? 'Change Master App PIN'
                                : 'Set Master App PIN',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Choose a $_pinLength-digit security PIN',
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

                // PIN Length Selector
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    segments: const [
                      ButtonSegment(
                        value: 4,
                        label: Text('4-Digit PIN', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      ButtonSegment(
                        value: 6,
                        label: Text('6-Digit PIN', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                    selected: {_pinLength},
                    onSelectionChanged: (set) {
                      setState(() {
                        _pinLength = set.first;
                        _pinController.clear();
                        _confirmPinController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),

                TextFormField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_pinLength),
                  ],
                  decoration: InputDecoration(
                    labelText: 'New PIN ($_pinLength digits) *',
                    prefixIcon: const Icon(Icons.password_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePin ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePin = !_obscurePin),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.length != _pinLength) {
                      return 'PIN must be exactly $_pinLength digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                TextFormField(
                  controller: _confirmPinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_pinLength),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Confirm PIN ($_pinLength digits) *',
                    prefixIcon: const Icon(Icons.check_circle_outline_rounded),
                    border: const OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val != _pinController.text) {
                      return 'PINs must match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton(
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save PIN'),
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
