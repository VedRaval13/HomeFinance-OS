import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/security/presentation/widgets/app_lock_gate.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/app_router.dart';

/// Root application widget configuring Theme, GoRouter navigation, and AppLock security.
class HomeFinanceApp extends ConsumerWidget {
  const HomeFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      builder: (context, child) =>
          AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
