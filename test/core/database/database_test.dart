import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/utils/uuid_util.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    // Open in-memory SQLite instance with WAL and foreign key enforcement enabled
    db = AppDatabase(openDatabaseConnection(inMemory: true));
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift AppDatabase & Local-First Invariants', () {
    test(
      'Database seeds initial member, accounts, and categories on create',
      () async {
        final members = await db.familyMembersDao.getAllActiveMembers();
        expect(members.length, 1);
        expect(members.first.name, 'Primary User');

        final householdAccounts = await db.accountsDao.getAccounts(
          scope: 'household',
        );
        expect(
          householdAccounts.length,
          2,
        ); // Household Cash Box and Joint Bank

        final personalAccounts = await db.accountsDao.getAccounts(
          scope: 'personal',
          memberId: members.first.id,
        );
        expect(personalAccounts.length, 1); // Personal Cash & Wallet

        final categories = await db.categoriesDao.getCategories();
        expect(categories.isNotEmpty, isTrue);
        // Check that system categories exist
        expect(categories.any((c) => c.name == 'Rent & Housing'), isTrue);
        expect(
          categories.any((c) => c.name == 'Salary & Professional Income'),
          isTrue,
        );
      },
    );

    test('Strict integer paise storage without floating point loss', () async {
      final member = (await db.familyMembersDao.getAllActiveMembers()).first;

      final accountId = UuidUtil.generate();
      await db.accountsDao.insertAccount(
        AccountsTableCompanion.insert(
          id: accountId,
          name: 'High Yield Savings',
          accountType: 'savings',
          scope: 'personal',
          memberId: Value(member.id),
          initialBalance: const Money.fromPaise(12500075), // ₹1,25,000.75
          currentBalance: const Money.fromPaise(12500075),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final account = await db.accountsDao.getAccountById(accountId);
      expect(account, isNotNull);
      expect(account!.currentBalance.paise, 12500075);
      expect(account.currentBalance.rupeesPart, 125000);
      expect(account.currentBalance.paisePart, 75);
    });

    test('Transactions atomically update account balances', () async {
      final member = (await db.familyMembersDao.getAllActiveMembers()).first;
      final accounts = await db.accountsDao.getAccounts(scope: 'household');
      final jointAccount = accounts.firstWhere((a) => a.accountType == 'bank');

      expect(jointAccount.currentBalance.paise, 0);

      // 1. Add Income Transaction: ₹50,000.00
      final incomeTxId = UuidUtil.generate();
      await db.transactionsDao.insertTransactionWithBalanceUpdate(
        TransactionsTableCompanion.insert(
          id: incomeTxId,
          amount: const Money.fromPaise(5000000), // ₹50,000.00
          transactionType: 'income',
          scope: 'household',
          accountId: jointAccount.id,
          memberId: member.id,
          transactionDate: DateTime.now(),
          paymentMethod: 'netBanking',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      var updatedAccount = await db.accountsDao.getAccountById(jointAccount.id);
      expect(updatedAccount!.currentBalance.paise, 5000000);

      // 2. Add Expense Transaction: ₹15,500.50
      final expenseTxId = UuidUtil.generate();
      await db.transactionsDao.insertTransactionWithBalanceUpdate(
        TransactionsTableCompanion.insert(
          id: expenseTxId,
          amount: const Money.fromPaise(1550050), // ₹15,500.50
          transactionType: 'expense',
          scope: 'household',
          accountId: jointAccount.id,
          memberId: member.id,
          transactionDate: DateTime.now(),
          paymentMethod: 'upi',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      updatedAccount = await db.accountsDao.getAccountById(jointAccount.id);
      expect(updatedAccount!.currentBalance.paise, 3449950); // ₹34,499.50

      // 3. Delete Expense Transaction -> balance restored
      await db.transactionsDao.deleteTransactionWithBalanceReversal(
        expenseTxId,
      );
      updatedAccount = await db.accountsDao.getAccountById(jointAccount.id);
      expect(
        updatedAccount!.currentBalance.paise,
        5000000,
      ); // Back to ₹50,000.00
    });

    test(
      'Transfers move money atomically and conserve total family net wealth',
      () async {
        final member = (await db.familyMembersDao.getAllActiveMembers()).first;
        final householdAccounts = await db.accountsDao.getAccounts(
          scope: 'household',
        );
        final jointAccount = householdAccounts.firstWhere(
          (a) => a.accountType == 'bank',
        );

        final personalAccounts = await db.accountsDao.getAccounts(
          scope: 'personal',
          memberId: member.id,
        );
        final personalAccount = personalAccounts.first;

        // Set initial personal balance: ₹40,000.00
        await db.accountsDao.adjustAccountBalance(
          personalAccount.id,
          const Money.fromPaise(4000000),
        );

        final initialTotal =
            (await db.accountsDao.getAccountById(personalAccount.id))!
                .currentBalance +
            (await db.accountsDao.getAccountById(jointAccount.id))!
                .currentBalance;
        expect(initialTotal.paise, 4000000);

        // Execute inter-scope transfer (Household Contribution): ₹25,000.00
        final transferId = UuidUtil.generate();
        await db.transfersDao.executeTransfer(
          transferId: transferId,
          sourceAccountId: personalAccount.id,
          destinationAccountId: jointAccount.id,
          amount: const Money.fromPaise(2500000), // ₹25,000.00
          transferType: 'household_contribution',
          memberId: member.id,
          transferDate: DateTime.now(),
          notes: 'Monthly contribution for rent',
        );

        final personalAfter = await db.accountsDao.getAccountById(
          personalAccount.id,
        );
        final jointAfter = await db.accountsDao.getAccountById(jointAccount.id);

        expect(personalAfter!.currentBalance.paise, 1500000); // ₹15,000.00
        expect(jointAfter!.currentBalance.paise, 2500000); // ₹25,000.00

        // Invariant: Total money across both accounts is conserved!
        final finalTotal =
            personalAfter.currentBalance + jointAfter.currentBalance;
        expect(finalTotal.paise, 4000000);

        final audit = await db.transfersDao.getTransferById(transferId);
        expect(audit, isNotNull);
        expect(audit!.amount.paise, 2500000);
        expect(audit.transferType, 'household_contribution');
      },
    );

    test('Savings Goal contributions update goal progress and deduct liquidity atomically', () async {
      final member = (await db.familyMembersDao.getAllActiveMembers()).first;
      final accounts = await db.accountsDao.getAccounts(scope: 'household');
      final jointAccount = accounts.firstWhere((a) => a.accountType == 'bank');

      // Fund joint account with ₹1,00,000.00
      await db.accountsDao.adjustAccountBalance(
        jointAccount.id,
        const Money.fromPaise(10000000),
      );

      // Create a Savings Goal: Emergency Fund (Target: ₹50,000.00)
      final goalId = UuidUtil.generate();
      await db.savingsGoalsDao.insertGoal(
        SavingsGoalsTableCompanion.insert(
          id: goalId,
          name: 'Emergency Fund',
          scope: 'household',
          targetAmount: const Money.fromPaise(5000000),
          currentAmount: const Money.zero(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Contribute ₹30,000.00
      final contribId = UuidUtil.generate();
      await db.savingsGoalsDao.contributeToGoal(
        contributionId: contribId,
        goalId: goalId,
        accountId: jointAccount.id,
        memberId: member.id,
        amount: const Money.fromPaise(3000000),
        contributionDate: DateTime.now(),
        notes: 'Initial allocation',
      );

      final updatedAccount = await db.accountsDao.getAccountById(
        jointAccount.id,
      );
      expect(
        updatedAccount!.currentBalance.paise,
        7000000,
      ); // ₹70,000.00 remaining

      final goals = await db.savingsGoalsDao
          .watchGoals(scope: 'household')
          .first;
      final goal = goals.firstWhere((g) => g.id == goalId);
      expect(goal.currentAmount.paise, 3000000); // ₹30,000.00 saved
      expect(goal.status, 'inProgress');
    });
  });
}
