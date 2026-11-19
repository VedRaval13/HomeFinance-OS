import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import 'widgets/scope_switch_bar.dart';

/// The root scaffold wrapping adaptive navigation (NavigationRail on desktop/web,
/// NavigationBar on mobile) and the persistent scope switcher.
class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktopOrWeb = width >= 840;

    if (isDesktopOrWeb) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                labelType: width >= 1100
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                extended: width >= 1100,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      if (width >= 1100) ...[
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard_rounded),
                    label: Text(AppStrings.navDashboard),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.receipt_long_outlined),
                    selectedIcon: Icon(Icons.receipt_long_rounded),
                    label: Text(AppStrings.navTransactions),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.pie_chart_outline_rounded),
                    selectedIcon: Icon(Icons.pie_chart_rounded),
                    label: Text(AppStrings.navBudgets),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_balance_outlined),
                    selectedIcon: Icon(Icons.account_balance_rounded),
                    label: Text(AppStrings.navAccounts),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people_outline_rounded),
                    selectedIcon: Icon(Icons.people_rounded),
                    label: Text(AppStrings.navFamily),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  children: [
                    const ScopeSwitchBar(),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: navigationShell,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard Mobile Layout with Bottom Navigation
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Persistent Financial Space Switcher Bar
            const ScopeSwitchBar(),
            // Active Tab Content
            Expanded(child: navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: AppStrings.navDashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: AppStrings.navTransactions,
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded),
            label: AppStrings.navBudgets,
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance_rounded),
            label: AppStrings.navAccounts,
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: AppStrings.navFamily,
          ),
        ],
      ),
    );
  }
}
