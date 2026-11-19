import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/transactions_repository_impl.dart';

void main() {
  late AppDatabase db;
  late TransactionsRepositoryImpl txRepo;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    txRepo = TransactionsRepositoryImpl(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TransactionsRepository & Atomic Ledger Balance Updates', () {
    test(
      'Creating income transaction credits account balance atomically',
      () async {
        final members = await memberRepo.getAllMembers();
        final member = members.first;

        final account = await accRepo.createAccount(
          name: 'ICICI Salary Account',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: const Money.zero(),
        );

        expect(account.currentBalance.paise, 0);

        // Create Income Transaction: ₹75,000.50
        final tx = await txRepo.createTransaction(
          amount: const Money.fromPaise(7500050),
          transactionType: TransactionType.income,
          scope: FinancialScope.household,
          accountId: account.id,
          memberId: member.id,
          transactionDate: DateTime.now(),
          paymentMethod: PaymentMethod.netBanking,
          notes: 'Monthly consulting payout',
        );

        expect(tx.id.isNotEmpty, isTrue);
        expect(tx.amount.paise, 7500050);
        expect(tx.isIncome, isTrue);

        // Account balance must be credited to ₹75,000.50
        final updatedAccount = await accRepo.getAccountById(account.id);
        expect(updatedAccount!.currentBalance.paise, 7500050);
        expect(updatedAccount.currentBalance.format(), '₹75,000.50');
      },
    );

    test(
      'Creating expense transaction debits account balance atomically',
      () async {
        final members = await memberRepo.getAllMembers();
        final member = members.first;

        // Start with ₹50,000.00
        final account = await accRepo.createAccount(
          name: 'HDFC Checking',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(5000000),
        );

        // Record Expense: ₹12,450.75
        final tx = await txRepo.createTransaction(
          amount: const Money.fromPaise(1245075),
          transactionType: TransactionType.expense,
          scope: FinancialScope.household,
          accountId: account.id,
          memberId: member.id,
          transactionDate: DateTime.now(),
          paymentMethod: PaymentMethod.upi,
          notes: 'Grocery store provisions',
        );

        expect(tx.isExpense, isTrue);

        // Account balance must be: 50,000.00 - 12,450.75 = ₹37,549.25
        final updatedAccount = await accRepo.getAccountById(account.id);
        expect(updatedAccount!.currentBalance.paise, 3754925);
        expect(updatedAccount.currentBalance.format(), '₹37,549.25');
      },
    );

    test('Deleting a transaction restores previous account balance', () async {
      final members = await memberRepo.getAllMembers();
      final member = members.first;

      final account = await accRepo.createAccount(
        name: 'Daily Wallet',
        accountType: AccountType.cash,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(1000000), // ₹10,000.00
      );

      final tx = await txRepo.createTransaction(
        amount: const Money.fromPaise(300000), // ₹3,000.00 expense
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: DateTime.now(),
        paymentMethod: PaymentMethod.cash,
        notes: 'Dining out',
      );

      var updatedAccount = await accRepo.getAccountById(account.id);
      expect(updatedAccount!.currentBalance.paise, 700000); // ₹7,000.00

      // Delete transaction
      await txRepo.deleteTransaction(tx.id);

      // Balance must be restored to ₹10,000.00
      updatedAccount = await accRepo.getAccountById(account.id);
      expect(updatedAccount!.currentBalance.paise, 1000000);

      final deletedTx = await txRepo.getTransactionById(tx.id);
      expect(deletedTx, isNull);
    });

    test('Computes total income and expense for a period', () async {
      final members = await memberRepo.getAllMembers();
      final member = members.first;

      final account = await accRepo.createAccount(
        name: 'Main Bank',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.zero(),
      );

      final now = DateTime.now();

      // Income 1: ₹50,000
      await txRepo.createTransaction(
        amount: const Money.fromPaise(5000000),
        transactionType: TransactionType.income,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: now,
        paymentMethod: PaymentMethod.netBanking,
      );

      // Income 2: ₹20,000
      await txRepo.createTransaction(
        amount: const Money.fromPaise(2000000),
        transactionType: TransactionType.income,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: now,
        paymentMethod: PaymentMethod.netBanking,
      );

      // Expense 1: ₹15,000
      await txRepo.createTransaction(
        amount: const Money.fromPaise(1500000),
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        memberId: member.id,
        transactionDate: now,
        paymentMethod: PaymentMethod.upi,
      );

      final totalIncome = await txRepo.computeTotalIncome(
        scope: FinancialScope.household,
      );
      final totalExpense = await txRepo.computeTotalExpense(
        scope: FinancialScope.household,
      );

      expect(totalIncome.paise, 7000000); // ₹70,000.00
      expect(totalExpense.paise, 1500000); // ₹15,000.00
    });
  });
}
