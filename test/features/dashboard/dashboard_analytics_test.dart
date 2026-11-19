import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/categories_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:home_finance_os/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:home_finance_os/features/transfers/domain/models/transfer_type_enum.dart';

void main() {
  late AppDatabase db;
  late TransactionsRepositoryImpl txRepo;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;
  late CategoriesRepositoryImpl catRepo;
  late TransfersRepositoryImpl transferRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    txRepo = TransactionsRepositoryImpl(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
    catRepo = CategoriesRepositoryImpl(db);
    transferRepo = TransfersRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Dashboard Analytics & Cashflow Invariants', () {
    test('Cashflow calculation accurately sums income, expense, net cashflow and savings rate', () async {
      final member = (await memberRepo.getAllMembers()).first;

      final account = await accRepo.createAccount(
        name: 'Household Current Account',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.zero(),
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

      // Income 1: ₹50,000.00
      await txRepo.createTransaction(
        amount: const Money.fromPaise(5000000),
        transactionType: TransactionType.income,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 1),
        paymentMethod: PaymentMethod.netBanking,
        notes: 'Monthly Payout',
      );

      // Income 2: ₹10,000.00
      await txRepo.createTransaction(
        amount: const Money.fromPaise(1000000),
        transactionType: TransactionType.income,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 5),
        paymentMethod: PaymentMethod.upi,
        notes: 'Bonus Income',
      );

      // Expense 1: ₹15,000.00
      await txRepo.createTransaction(
        amount: const Money.fromPaise(1500000),
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        categoryId: groceriesCat.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 8),
        paymentMethod: PaymentMethod.upi,
        notes: 'Groceries Mart',
      );

      // Expense 2: ₹5,000.00
      await txRepo.createTransaction(
        amount: const Money.fromPaise(500000),
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        categoryId: groceriesCat.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 12),
        paymentMethod: PaymentMethod.debitCard,
        notes: 'Household utilities',
      );

      // Query month transactions
      final startOfMonth = DateTime(2026, 11, 1);
      final endOfMonth = DateTime(2026, 11, 30, 23, 59, 59);

      final txs = await txRepo.getTransactions(
        scope: FinancialScope.household,
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      Money totalIncome = const Money.zero();
      Money totalExpense = const Money.zero();

      for (final tx in txs) {
        if (tx.isIncome) {
          totalIncome = totalIncome + tx.amount;
        } else if (tx.isExpense) {
          totalExpense = totalExpense + tx.amount;
        }
      }

      expect(totalIncome.paise, 6000000); // ₹60,000.00
      expect(totalExpense.paise, 2000000); // ₹20,000.00

      final netCashflow = totalIncome - totalExpense;
      expect(netCashflow.paise, 4000000); // ₹40,000.00

      final savingsRate = ((netCashflow.paise / totalIncome.paise) * 100)
          .toInt();
      expect(savingsRate, 66); // 66.6% -> 66%
    });

    test('Transfers and contributions are strictly excluded from income and expenses', () async {
      final member = (await memberRepo.getAllMembers()).first;

      // Personal Account: ₹1,00,000.00
      final personalAccount = await accRepo.createAccount(
        name: 'Personal HDFC',
        accountType: AccountType.bank,
        scope: FinancialScope.personal,
        memberId: member.id,
        initialBalance: const Money.fromPaise(10000000),
      );

      // Household Account: ₹20,000.00
      final householdAccount = await accRepo.createAccount(
        name: 'Household Pool',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(2000000),
      );

      // Member contributes ₹40,000.00 to household
      await transferRepo.executeTransfer(
        sourceAccountId: personalAccount.id,
        destinationAccountId: householdAccount.id,
        amount: const Money.fromPaise(4000000), // ₹40,000.00
        transferType: TransferType.householdContribution,
        memberId: member.id,
        transferDate: DateTime(2026, 11, 10),
        notes: 'Monthly contribution to family expenses',
      );

      // Verify that NO income or expense transactions were created for this transfer in either space!
      final householdTxs = await txRepo.getTransactions(
        scope: FinancialScope.household,
      );
      final personalTxs = await txRepo.getTransactions(
        scope: FinancialScope.personal,
        memberId: member.id,
      );

      expect(householdTxs.where((t) => t.isIncome).isEmpty, isTrue);
      expect(householdTxs.where((t) => t.isExpense).isEmpty, isTrue);
      expect(personalTxs.where((t) => t.isIncome).isEmpty, isTrue);
      expect(personalTxs.where((t) => t.isExpense).isEmpty, isTrue);
    });

    test('Category breakdown calculates accurate percentage of total monthly spending', () async {
      final member = (await memberRepo.getAllMembers()).first;

      final account = await accRepo.createAccount(
        name: 'Primary Household',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(50000000),
      );

      final categories = await catRepo
          .watchCategories(
            type: TransactionType.expense,
            scope: FinancialScope.household,
          )
          .first;

      final cat1 = categories[0];
      final cat2 = categories[1];

      // Cat1: ₹7,500.00 (75%)
      await txRepo.createTransaction(
        amount: const Money.fromPaise(750000),
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        categoryId: cat1.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 5),
        paymentMethod: PaymentMethod.upi,
      );

      // Cat2: ₹2,500.00 (25%)
      await txRepo.createTransaction(
        amount: const Money.fromPaise(250000),
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        categoryId: cat2.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 6),
        paymentMethod: PaymentMethod.upi,
      );

      final txs = await txRepo.getTransactions(
        scope: FinancialScope.household,
        type: TransactionType.expense,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 30),
      );

      Money total = const Money.zero();
      for (final t in txs) {
        total = total + t.amount;
      }

      expect(total.paise, 1000000); // ₹10,000.00

      final cat1Spent = txs
          .where((t) => t.categoryId == cat1.id)
          .fold<Money>(const Money.zero(), (prev, t) => prev + t.amount);
      final cat2Spent = txs
          .where((t) => t.categoryId == cat2.id)
          .fold<Money>(const Money.zero(), (prev, t) => prev + t.amount);

      expect(cat1Spent.paise, 750000);
      expect((cat1Spent.paise / total.paise) * 100, 75.0);

      expect(cat2Spent.paise, 250000);
      expect((cat2Spent.paise / total.paise) * 100, 25.0);
    });
  });
}
