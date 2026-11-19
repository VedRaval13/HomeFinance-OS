import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_dimensions.dart';
import '../../../constants/app_strings.dart';
import '../providers/app_lock_provider.dart';

/// Full-screen PIN authentication view presenting keypads, dot indicators,
/// and instant biometric authentication trigger.
class AppLockScreen extends ConsumerStatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockScreen({super.key, required this.onUnlocked});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _enteredPin = '';
  String? _errorMessage;
  bool _isChecking = false;
  int _remainingLockoutSeconds = 0;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLockoutAndBiometrics();
    });
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLockoutAndBiometrics() async {
    final service = ref.read(appLockServiceProvider);
    final remaining = await service.getRemainingLockoutSeconds();
    if (remaining > 0) {
      if (mounted) {
        setState(() {
          _remainingLockoutSeconds = remaining;
          _errorMessage =
              'Too many failed attempts. Try again in ${remaining}s.';
        });
        _startLockoutCountdown();
      }
    } else {
      _tryBiometricAuth();
    }
  }

  void _startLockoutCountdown() {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingLockoutSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingLockoutSeconds = 0;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _remainingLockoutSeconds--;
          _errorMessage =
              'Too many failed attempts. Try again in ${_remainingLockoutSeconds}s.';
        });
      }
    });
  }

  Future<void> _tryBiometricAuth() async {
    final security = ref.read(securitySettingsProvider);
    if (security.isBiometricsEnabled && security.canUseBiometrics) {
      final service = ref.read(appLockServiceProvider);
      final success = await service.authenticateBiometrics();
      if (success && mounted) {
        widget.onUnlocked();
      }
    }
  }

  void _onDigitPressed(String digit) {
    if (_remainingLockoutSeconds > 0) return;
    final pinLen = ref.read(securitySettingsProvider).pinLength;
    if (_enteredPin.length >= pinLen) return;
    setState(() {
      _errorMessage = null;
      _enteredPin += digit;
    });

    if (_enteredPin.length == pinLen) {
      _verifyCurrentPin();
    }
  }

  void _onBackspacePressed() {
    if (_remainingLockoutSeconds > 0) return;
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _errorMessage = null;
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  Future<void> _verifyCurrentPin() async {
    setState(() => _isChecking = true);
    final service = ref.read(appLockServiceProvider);
    final valid = await service.verifyPin(_enteredPin);

    if (valid) {
      if (mounted) widget.onUnlocked();
    } else {
      if (mounted) {
        final remaining = await service.getRemainingLockoutSeconds();
        if (remaining > 0) {
          setState(() {
            _remainingLockoutSeconds = remaining;
            _errorMessage =
                'Too many failed attempts. Try again in ${remaining}s.';
            _enteredPin = '';
            _isChecking = false;
          });
          _startLockoutCountdown();
        } else {
          setState(() {
            _errorMessage = 'Incorrect PIN. Try again.';
            _enteredPin = '';
            _isChecking = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final security = ref.watch(securitySettingsProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // App Logo & Branding
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shield_rounded,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space16),

                      Text(
                        AppStrings.appName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        'Enter ${security.pinLength}-digit Master PIN to unlock your financial records',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space24),

                      // PIN Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(security.pinLength, (index) {
                          final isFilled = index < _enteredPin.length;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: isFilled ? 18 : 14,
                            height: isFilled ? 18 : 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              border: Border.all(
                                color: isFilled
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppDimensions.space16),

                      // Error or loading message
                      if (_isChecking)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.expense,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        const SizedBox(height: 20),

                      const Spacer(),

                      // Numpad Grid
                      _buildNumpad(
                        security.canUseBiometrics && security.isBiometricsEnabled,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNumpad(bool showBiometrics) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: AppDimensions.space16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: AppDimensions.space16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: AppDimensions.space16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (showBiometrics)
              _buildActionButton(
                icon: Icons.fingerprint_rounded,
                onPressed: _tryBiometricAuth,
              )
            else
              const SizedBox(width: 72, height: 72),
            _buildDigitButton('0'),
            _buildActionButton(
              icon: Icons.backspace_outlined,
              onPressed: _onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map(_buildDigitButton).toList(),
    );
  }

  Widget _buildDigitButton(String digit) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _onDigitPressed(digit),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Icon(icon, size: 28, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
