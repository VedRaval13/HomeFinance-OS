import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/app.dart';
import 'package:home_finance_os/core/constants/app_strings.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/database/database_provider.dart';

void main() {
  group('HomeFinance OS — Full End-to-End User Journey Tests', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase(openDatabaseConnection(inMemory: true));
    });

    tearDown(() async {
      await testDb.close();
    });

    testWidgets(
      'Complete user flow: Dashboard -> Scope Switch -> Accounts -> Budgets -> Family -> Settings',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // 1. Launch the complete application with real in-memory SQLite database
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWithValue(testDb)],
            child: const HomeFinanceApp(),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // 2. VERIFY DASHBOARD
        // Check title and hero balance card
        expect(find.text(AppStrings.appName), findsWidgets);
        expect(find.text('TOTAL HOUSEHOLD NET BALANCE'), findsOneWidget);
        expect(find.text('Monthly Income'), findsOneWidget);
        expect(find.text('Monthly Expenses'), findsOneWidget);
        expect(find.text('Net Cash Flow'), findsOneWidget);
        expect(find.text('Savings Rate'), findsOneWidget);

        // Verify Quick Action Buttons
        expect(find.text('Add Transaction'), findsOneWidget);
        expect(find.text('Transfer'), findsOneWidget);

        // 3. TEST SCOPE SWITCHER (Household <-> Personal)
        expect(find.text(AppStrings.scopeHousehold), findsOneWidget);
        // Tap on the Scope dropdown / button to open scope switcher
        final scopeButton = find.text(AppStrings.scopeHousehold);
        await tester.tap(scopeButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // 4. NAVIGATE TO TRANSACTIONS SCREEN
        final transactionsNav = find.text(AppStrings.navTransactions);
        expect(transactionsNav, findsOneWidget);
        await tester.tap(transactionsNav);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Transactions Screen Loaded
        expect(find.text('Household Ledger'), findsOneWidget);
        expect(find.text('Add Entry'), findsOneWidget);

        // 5. NAVIGATE TO BUDGETS SCREEN
        final budgetsNav = find.text(AppStrings.navBudgets);
        expect(budgetsNav, findsOneWidget);
        await tester.tap(budgetsNav);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Budgets Screen Tabs
        expect(find.text('Category Budgets'), findsOneWidget);
        expect(find.text('Savings Goals'), findsOneWidget);

        // Switch to Savings Goals tab
        await tester.tap(find.text('Savings Goals'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify Savings Goals empty state or content
        expect(find.text('New Goal'), findsOneWidget);

        // 6. NAVIGATE TO ACCOUNTS SCREEN
        final accountsNav = find.text(AppStrings.navAccounts);
        expect(accountsNav, findsOneWidget);
        await tester.tap(accountsNav);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Seeded Accounts are visible
        expect(find.text('Household Cash Box'), findsOneWidget);
        expect(find.text('Family Joint Bank Account'), findsOneWidget);

        // 7. NAVIGATE TO FAMILY SCREEN
        final familyNav = find.text(AppStrings.navFamily);
        expect(familyNav, findsOneWidget);
        await tester.tap(familyNav);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Primary Admin Member is displayed
        expect(find.text('Primary User'), findsOneWidget);
        expect(find.text('Admin / Primary User'), findsOneWidget);

        // 8. NAVIGATE TO SETTINGS SCREEN
        // Go back to Dashboard and tap Settings icon
        await tester.tap(find.text(AppStrings.navDashboard));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final settingsIcon = find.byIcon(Icons.settings_outlined);
        expect(settingsIcon, findsOneWidget);
        await tester.tap(settingsIcon);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Settings Screen components
        expect(find.text('Settings & Security'), findsOneWidget);
        expect(find.text('App Lock (PIN Protection)'), findsOneWidget);
        expect(find.text('Create Encrypted Backup'), findsOneWidget);
        expect(find.text('Restore Encrypted Backup'), findsOneWidget);
        expect(
          find.text('Indian Rupee (₹ INR) • Exact Integer Paise Units'),
          findsOneWidget,
        );
        expect(find.text('Local SQLite Architecture'), findsOneWidget);

        // Cleanly unmount widget tree to drain Drift stream timers
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 500));
        await testDb.close();
      },
    );
  });
}
