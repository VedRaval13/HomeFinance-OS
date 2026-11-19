import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/app.dart';
import 'package:home_finance_os/core/constants/app_strings.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/database/database_provider.dart';

void main() {
  testWidgets(
    'HomeFinance OS initializes with shell, database, and navigation tabs',
    (WidgetTester tester) async {
      final testDb = AppDatabase(openDatabaseConnection(inMemory: true));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(testDb)],
          child: const HomeFinanceApp(),
        ),
      );

      // Initial pump and allow async stream providers to resolve
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify App Name and core tabs appear
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.navDashboard), findsOneWidget);
      expect(find.text(AppStrings.navTransactions), findsOneWidget);
      expect(find.text(AppStrings.navBudgets), findsOneWidget);
      expect(find.text(AppStrings.navAccounts), findsOneWidget);
      expect(find.text(AppStrings.navFamily), findsOneWidget);

      // Verify Scope Switcher is present
      expect(find.text(AppStrings.scopeHousehold), findsOneWidget);

      // Clean up
      await testDb.close();
    },
  );
}
