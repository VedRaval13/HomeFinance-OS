import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/budgets/data/repositories/budgets_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/categories_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/transactions_repository_impl.dart';

void main() {
  late AppDatabase db;
  late BudgetsRepositoryImpl budgetRepo;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;
  late TransactionsRepositoryImpl txRepo;
  late CategoriesRepositoryImpl catRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    budgetRepo = BudgetsRepositoryImpl(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
    txRepo = TransactionsRepositoryImpl(db);
    catRepo = CategoriesRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BudgetsRepository Tests', () {
    test('Set and update monthly budget limit', () async {
      // 1. Set budget of ₹50,000.00 for November 2026
      final budget = await budgetRepo.setBudget(
        name: 'Nov 2026 Household Budget',
        scope: FinancialScope.household,
        month: 11,
        year: 2026,
        totalLimit: const Money.fromPaise(5000000), // ₹50,000.00
      );

      expect(budget.name, 'Nov 2026 Household Budget');
      expect(budget.totalLimit.paise, 5000000);
      expect(budget.month, 11);
      expect(budget.year, 2026);

      // 2. Retrieve it
      final retrieved = await budgetRepo.getBudget(
        scope: FinancialScope.household,
        month: 11,
        year: 2026,
      );
      expect(retrieved, isNotNull);
      expect(retrieved!.totalLimit.paise, 5000000);

      // 3. Update limit to ₹65,000.00
      final updated = await budgetRepo.setBudget(
        name: 'Updated Nov 2026 Budget',
        scope: FinancialScope.household,
        month: 11,
        year: 2026,
        totalLimit: const Money.fromPaise(6500000), // ₹65,000.00
      );

      expect(updated.id, budget.id);
      expect(updated.totalLimit.paise, 6500000);
    });

    test('Category spending limit with live spending calculation and overspending detection', () async {
      final member = (await memberRepo.getAllMembers()).first;

      // Seeded accounts and categories exist
      final account = await accRepo.createAccount(
        name: 'Household Primary',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(10000000), // ₹1,00,000.00
      );

      final categories = await catRepo
          .watchCategories(
            type: TransactionType.expense,
            scope: FinancialScope.household,
          )
          .first;
      final groceriesCat = categories.firstWhere(
        (c) => c.name.toLowerCase().contains('groceries'),
      );

      // Create budget
      final budget = await budgetRepo.setBudget(
        name: 'Nov 2026 Household Budget',
        scope: FinancialScope.household,
        month: 11,
        year: 2026,
        totalLimit: const Money.fromPaise(6000000), // ₹60,000.00
      );

      // Allocate ₹10,000.00 for Groceries
      await budgetRepo.setCategoryLimit(
        budgetId: budget.id,
        categoryId: groceriesCat.id,
        allocatedLimit: const Money.fromPaise(1000000), // ₹10,000.00
      );

      // Watch categories initially (spending should be 0)
      var allocations = await budgetRepo
          .watchBudgetCategories(
            budgetId: budget.id,
            month: 11,
            year: 2026,
            scope: FinancialScope.household,
          )
          .first;

      expect(allocations.length, 1);
      final alloc = allocations.first;
      expect(alloc.categoryId, groceriesCat.id);
      expect(alloc.allocatedLimit.paise, 1000000);
      expect(alloc.spentAmount.paise, 0);
      expect(alloc.remaining.paise, 1000000);
      expect(alloc.isOverspent, isFalse);

      // Add transaction in Nov 2026 for ₹8,800.00 in Groceries (88% of limit -> should trigger near limit)
      await txRepo.createTransaction(
        scope: FinancialScope.household,
        transactionType: TransactionType.expense,
        amount: const Money.fromPaise(880000), // ₹8,800.00
        categoryId: groceriesCat.id,
        accountId: account.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 10),
        paymentMethod: PaymentMethod.upi,
        notes: 'Monthly Groceries Supermarket',
      );

      allocations = await budgetRepo
          .watchBudgetCategories(
            budgetId: budget.id,
            month: 11,
            year: 2026,
            scope: FinancialScope.household,
          )
          .first;

      final allocAfter = allocations.first;
      expect(allocAfter.spentAmount.paise, 880000);
      expect(allocAfter.remaining.paise, 120000); // ₹1,200.00
      expect(allocAfter.utilizationPercent, 88);
      expect(allocAfter.isNearLimit, isTrue);
      expect(allocAfter.isOverspent, isFalse);

      // Add another transaction for ₹2,500.00 (Total spent = ₹11,300.00 > ₹10,000.00 limit -> overspent!)
      await txRepo.createTransaction(
        scope: FinancialScope.household,
        transactionType: TransactionType.expense,
        amount: const Money.fromPaise(250000), // ₹2,500.00
        categoryId: groceriesCat.id,
        accountId: account.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 15),
        paymentMethod: PaymentMethod.debitCard,
        notes: 'Gourmet market',
      );

      allocations = await budgetRepo
          .watchBudgetCategories(
            budgetId: budget.id,
            month: 11,
            year: 2026,
            scope: FinancialScope.household,
          )
          .first;

      final overspentAlloc = allocations.first;
      expect(overspentAlloc.spentAmount.paise, 1130000);
      expect(overspentAlloc.isOverspent, isTrue);
      expect(overspentAlloc.remaining.isNegative, isTrue);
      expect(overspentAlloc.remaining.paise, -130000); // Over by ₹1,300.00
    });

    test('Remove category limit successfully', () async {
      final categories = await catRepo
          .watchCategories(
            type: TransactionType.expense,
            scope: FinancialScope.household,
          )
          .first;
      final cat = categories.first;

      final budget = await budgetRepo.setBudget(
        name: 'Nov 2026 Household Budget',
        scope: FinancialScope.household,
        month: 11,
        year: 2026,
        totalLimit: const Money.fromPaise(5000000),
      );

      await budgetRepo.setCategoryLimit(
        budgetId: budget.id,
        categoryId: cat.id,
        allocatedLimit: const Money.fromPaise(1000000),
      );

      var allocations = await budgetRepo
          .watchBudgetCategories(
            budgetId: budget.id,
            month: 11,
            year: 2026,
            scope: FinancialScope.household,
          )
          .first;
      expect(allocations.length, 1);

      // Remove limit
      await budgetRepo.removeCategoryLimit(
        budgetId: budget.id,
        categoryId: cat.id,
      );

      allocations = await budgetRepo
          .watchBudgetCategories(
            budgetId: budget.id,
            month: 11,
            year: 2026,
            scope: FinancialScope.household,
          )
          .first;
      expect(allocations.isEmpty, isTrue);
    });
  });
}
