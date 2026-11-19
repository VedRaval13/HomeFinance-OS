import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../accounts/presentation/screens/account_detail_screen.dart';
import '../accounts/presentation/screens/accounts_screen.dart';
import '../budgets/presentation/screens/budgets_screen.dart';
import '../dashboard/presentation/screens/dashboard_screen.dart';
import '../family_members/presentation/screens/family_members_screen.dart';
import '../settings/presentation/screens/settings_screen.dart';
import '../transactions/presentation/screens/transactions_screen.dart';
import 'presentation/main_navigation_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNav',
);

/// Central GoRouter configuration with StatefulShellRoute for tabs.
abstract class AppRouter {
  static const String dashboardPath = '/';
  static const String transactionsPath = '/transactions';
  static const String budgetsPath = '/budgets';
  static const String accountsPath = '/accounts';
  static const String familyPath = '/family';
  static const String settingsPath = '/settings';

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: dashboardPath,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboardPath,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Branch 1: Transactions Ledger
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: transactionsPath,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),

          // Branch 2: Budgets & Goals
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: budgetsPath,
                builder: (context, state) => const BudgetsScreen(),
              ),
            ],
          ),

          // Branch 3: Accounts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: accountsPath,
                builder: (context, state) => const AccountsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AccountDetailScreen(accountId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 4: Family Members
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: familyPath,
                builder: (context, state) => const FamilyMembersScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Routes
      GoRoute(
        path: settingsPath,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
