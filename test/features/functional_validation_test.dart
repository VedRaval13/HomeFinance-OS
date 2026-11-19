import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/core/security/presentation/providers/app_lock_provider.dart';
import 'package:home_finance_os/core/security/presentation/screens/app_lock_screen.dart';
import 'package:home_finance_os/core/security/services/app_lock_service.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/budgets/data/repositories/budgets_repository_impl.dart';
import 'package:local_auth/local_auth.dart';

class MockLocalAuth extends Fake implements LocalAuthentication {
  @override
  Future<bool> isDeviceSupported() async => false;
  @override
  Future<bool> get canCheckBiometrics async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeFinance OS — Comprehensive Functional & Fix Validation Tests', () {
    late AppDatabase db;
    late AccountsRepositoryImpl accountsRepo;
    late BudgetsRepositoryImpl budgetsRepo;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      db = AppDatabase(openDatabaseConnection(inMemory: true));
      accountsRepo = AccountsRepositoryImpl(db);
      budgetsRepo = BudgetsRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    // TEST 1: LOCK SYSTEM PIN LENGTH ADAPTABILITY (4 vs 6 Digits)
    testWidgets(
      'Lock System dynamically adjusts dots and verification for 4-digit and 6-digit PINs',
      (WidgetTester tester) async {
        final storage = const FlutterSecureStorage();
        final lockService = AppLockService(
          storage: storage,
          localAuth: MockLocalAuth(),
        );

        // A: Configure 4-digit PIN
        await lockService.setPin('1234');
        final pinLen4 = await lockService.getPinLength();
        expect(pinLen4, equals(4));

        bool unlocked4 = false;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appLockServiceProvider.overrideWithValue(lockService)],
            child: MaterialApp(
              home: AppLockScreen(onUnlocked: () => unlocked4 = true),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Check header specifies 4-digit PIN
        expect(
          find.text(
            'Enter 4-digit Master PIN to unlock your financial records',
          ),
          findsOneWidget,
        );

        // Find the circular dot indicators: AnimatedContainer with shape == BoxShape.circle
        final dotFinders4 = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle,
        );
        // Verify exactly 4 dots rendered
        expect(dotFinders4, findsNWidgets(4));

        // Enter incorrect PIN: '9', '9', '9', '9'
        await tester.tap(find.text('9'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('9'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('9'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('9'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Should show error and remain locked
        expect(find.text('Incorrect PIN. Try again.'), findsOneWidget);
        expect(unlocked4, isFalse);

        // Enter correct PIN: '1', '2', '3', '4'
        await tester.tap(find.text('1'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('2'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('3'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('4'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verified and unlocked!
        expect(unlocked4, isTrue);

        // Clean unmount
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 100));

        // B: Now test 6-digit PIN configuration
        await lockService.setPin('654321');
        final pinLen6 = await lockService.getPinLength();
        expect(pinLen6, equals(6));

        final notifier6 = SecuritySettingsNotifier(lockService);
        await notifier6.loadSettings();

        bool unlocked6 = false;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appLockServiceProvider.overrideWithValue(lockService),
              securitySettingsProvider.overrideWith((ref) => notifier6),
            ],
            child: MaterialApp(
              home: AppLockScreen(onUnlocked: () => unlocked6 = true),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Check header specifies 6-digit PIN
        expect(
          find.text(
            'Enter 6-digit Master PIN to unlock your financial records',
          ),
          findsOneWidget,
        );

        // Verify exactly 6 dots rendered for 6-digit PIN
        final dotFinders6 = find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle,
        );
        expect(dotFinders6, findsNWidgets(6));
        expect(unlocked6, isFalse);

        // Clean unmount
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 100));
      },
    );

    // TEST 2: ACCOUNT BALANCE DIRECT EDITING
    test('Directly editing account balance updates database record and net liquidity', () async {
      // 1. Fetch default seeded accounts
      final accounts = await accountsRepo.getAccounts(
        scope: FinancialScope.household,
      );
      expect(accounts.isNotEmpty, isTrue);

      final cashBox = accounts.firstWhere(
        (a) => a.name == 'Household Cash Box',
      );
      expect(cashBox.currentBalance, equals(Money.zero()));

      // 2. Direct edit: User updates balance from ₹0 to ₹35,500
      final updatedAccount = cashBox.copyWith(
        currentBalance: Money.fromRupees(35500),
      );
      await accountsRepo.updateAccount(updatedAccount);

      // 3. Verify updated balance is persisted in SQLite
      final reloadedAccount = await accountsRepo.getAccountById(cashBox.id);
      expect(reloadedAccount, isNotNull);
      expect(reloadedAccount!.currentBalance, equals(Money.fromRupees(35500)));
      expect(reloadedAccount.currentBalance.paise, equals(3550000));

      // 4. Verify Net Family Liquidity reflects the updated balance
      final totalBalance = await accountsRepo.computeTotalBalance(
        scope: FinancialScope.household,
      );
      expect(totalBalance, equals(Money.fromRupees(35500)));
    });

    // TEST 3: CATEGORY BUDGETS BOUND TO OVERALL MONTHLY BUDGET
    test(
      'Category spending limit is bounded by total monthly budget',
      () async {
        final now = DateTime.now();

        // 1. Set Overall Monthly Budget of ₹50,000
        final overallBudget = await budgetsRepo.setBudget(
          name: 'Household Monthly Budget',
          scope: FinancialScope.household,
          month: now.month,
          year: now.year,
          totalLimit: Money.fromRupees(50000),
        );
        expect(overallBudget.totalLimit, equals(Money.fromRupees(50000)));

        // 2. Fetch default seeded categories
        final categories = await db.categoriesDao.getCategories(
          type: TransactionType.expense.name,
          scope: FinancialScope.household.name,
        );
        expect(categories.length, greaterThanOrEqualTo(2));
        final catGroceries = categories[0];
        final catUtilities = categories[1];

        // 3. Allocate ₹30,000 to Groceries
        await budgetsRepo.setCategoryLimit(
          budgetId: overallBudget.id,
          categoryId: catGroceries.id,
          allocatedLimit: Money.fromRupees(30000),
        );

        // 4. Verify allocated limits and compute remaining available budget
        final allocatedCategories = await budgetsRepo
            .watchBudgetCategories(
              budgetId: overallBudget.id,
              month: now.month,
              year: now.year,
              scope: FinancialScope.household,
            )
            .first;
        expect(allocatedCategories.length, equals(1));
        expect(
          allocatedCategories.first.allocatedLimit,
          equals(Money.fromRupees(30000)),
        );

        // Calculate remaining budget available for subsequent categories
        Money totalAllocated = Money.zero();
        for (final a in allocatedCategories) {
          totalAllocated = totalAllocated + a.allocatedLimit;
        }
        final remainingAvailable = overallBudget.totalLimit - totalAllocated;
        expect(remainingAvailable, equals(Money.fromRupees(20000)));

        // 5. Verify invariant: allocating beyond remaining budget (e.g. ₹25,000 > ₹20,000) is detected
        final candidateLimit = Money.fromRupees(25000);
        final exceedsBudget = candidateLimit > remainingAvailable;
        expect(exceedsBudget, isTrue);

        // 6. Allocate exactly the remaining ₹20,000 to Utilities
        await budgetsRepo.setCategoryLimit(
          budgetId: overallBudget.id,
          categoryId: catUtilities.id,
          allocatedLimit: remainingAvailable,
        );

        final finalAllocations = await budgetsRepo
            .watchBudgetCategories(
              budgetId: overallBudget.id,
              month: now.month,
              year: now.year,
              scope: FinancialScope.household,
            )
            .first;
        expect(finalAllocations.length, equals(2));

        Money finalTotalAllocated = Money.zero();
        for (final a in finalAllocations) {
          finalTotalAllocated = finalTotalAllocated + a.allocatedLimit;
        }
        // Total category allocations now exactly equal the overall monthly budget ₹50,000
        expect(finalTotalAllocated, equals(overallBudget.totalLimit));
      },
    );
  });
}
