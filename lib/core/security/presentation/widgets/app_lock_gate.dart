import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_lock_provider.dart';
import '../screens/app_lock_screen.dart';

/// Wraps the application root to enforce authentication whenever App Lock is active.
class AppLockGate extends ConsumerStatefulWidget {
  final Widget child;

  const AppLockGate({super.key, required this.child});

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialLockState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkInitialLockState() async {
    final service = ref.read(appLockServiceProvider);
    final enabled = await service.isLockEnabled();
    final hasPin = await service.hasPinSet();

    if (enabled && hasPin) {
      service.lock();
      setState(() => _isLocked = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final service = ref.read(appLockServiceProvider);
      final security = ref.read(securitySettingsProvider);
      if (security.isLockEnabled && security.hasPinSet) {
        service.lock();
        setState(() => _isLocked = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocked) {
      return AppLockScreen(
        onUnlocked: () {
          ref.read(appLockServiceProvider).unlock();
          setState(() => _isLocked = false);
        },
      );
    }

    return widget.child;
  }
}
