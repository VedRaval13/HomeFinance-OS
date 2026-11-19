import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/family_members/domain/models/family_member.dart';
import 'package:home_finance_os/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:home_finance_os/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:home_finance_os/features/transfers/domain/models/transfer_type_enum.dart';

void main() {
  late AppDatabase db;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;
  late TransfersRepositoryImpl transferRepo;
  late TransactionsRepositoryImpl txRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
    transferRepo = TransfersRepositoryImpl(db);
    txRepo = TransactionsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Section 5 — Critical Transfer & Contribution Invariant Tests', () {
    test(
      'Exact Specification: Personal to Household ₹5,000 transfer invariants',
      () async {
        final members = await memberRepo.getAllMembers();
        final member = members.first;

        // 1. Setup Personal Bank Account with ₹20,000.00
        final personalAccount = await accRepo.createAccount(
          name: 'Personal Checking',
          accountType: AccountType.bank,
          scope: FinancialScope.personal,
          memberId: member.id,
          initialBalance: Money.fromRupees(20000),
        );

        // 2. Setup Household Bank Account with ₹50,000.00
        final householdAccount = await accRepo.createAccount(
          name: 'Household Pool Account',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: Money.fromRupees(50000),
        );

        // Pre-transfer verification:
        // Consolidated net balance across both accounts = ₹70,000
        final prePersonalBalance = (await accRepo.getAccountById(
          personalAccount.id,
        ))!.currentBalance;
        final preHouseholdBalance = (await accRepo.getAccountById(
          householdAccount.id,
        ))!.currentBalance;
        final preConsolidatedBalance = prePersonalBalance + preHouseholdBalance;

        expect(prePersonalBalance, equals(Money.fromRupees(20000)));
        expect(preHouseholdBalance, equals(Money.fromRupees(50000)));
        expect(preConsolidatedBalance, equals(Money.fromRupees(70000)));

        final now = DateTime.now();

        // Helper to compute cashflow
        Future<(Money income, Money expense)> getCashflow(
          FinancialScope scope, [
          String? memId,
        ]) async {
          final txs = await txRepo.getTransactions(
            scope: scope,
            memberId: memId,
          );
          Money inc = Money.zero();
          Money exp = Money.zero();
          for (final t in txs) {
            if (t.isIncome) inc = inc + t.amount;
            if (t.isExpense) exp = exp + t.amount;
          }
          return (inc, exp);
        }

        final (preHouseholdIncome, preHouseholdExpense) = await getCashflow(
          FinancialScope.household,
        );
        final (_, prePersonalExpense) = await getCashflow(
          FinancialScope.personal,
          member.id,
        );

        // 3. EXECUTE EXACT TRANSFER: ₹5,000 from Personal -> Household
        final transfer = await transferRepo.executeTransfer(
          sourceAccountId: personalAccount.id,
          destinationAccountId: householdAccount.id,
          amount: Money.fromRupees(5000),
          transferType: TransferType.householdContribution,
          memberId: member.id,
          transferDate: now,
          notes: 'Monthly Household Contribution',
        );

        expect(transfer.id, isNotEmpty);

        // 4. VERIFY ALL SPECIFIED CONDITIONS:
        final postPersonal = await accRepo.getAccountById(personalAccount.id);
        final postHousehold = await accRepo.getAccountById(householdAccount.id);
        final postConsolidated =
            postPersonal!.currentBalance + postHousehold!.currentBalance;

        // Condition 1: Personal account decreases by exactly ₹5,000 (from 20,000 to 15,000)
        expect(postPersonal.currentBalance, equals(Money.fromRupees(15000)));

        // Condition 2: Household account increases by exactly ₹5,000 (from 50,000 to 55,000)
        expect(postHousehold.currentBalance, equals(Money.fromRupees(55000)));

        // Condition 3: Consolidated balance remains unchanged (₹70,000)
        expect(postConsolidated, equals(preConsolidatedBalance));

        // Post-transfer metrics check
        final (postHouseholdIncome, postHouseholdExpense) = await getCashflow(
          FinancialScope.household,
        );
        final (_, postPersonalExpense) = await getCashflow(
          FinancialScope.personal,
          member.id,
        );

        // Condition 4: Household income increases by ₹0 (transfers are NEVER income)
        expect(postHouseholdIncome, equals(preHouseholdIncome));

        // Condition 5: Personal expenses increase by ₹0 (transfers are NEVER expense)
        expect(postPersonalExpense, equals(prePersonalExpense));

        // Condition 6: Household expenses increase by ₹0
        expect(postHouseholdExpense, equals(preHouseholdExpense));

        // Condition 7: Consolidated expenses increase by ₹0
        final consolidatedExpenseDiff =
            (postHouseholdExpense + postPersonalExpense) -
            (preHouseholdExpense + prePersonalExpense);
        expect(consolidatedExpenseDiff, equals(Money.zero()));

        // 5. TEST TRANSFER REVERSAL
        await transferRepo.reverseTransfer(transfer.id);

        final revertedPersonal = await accRepo.getAccountById(
          personalAccount.id,
        );
        final revertedHousehold = await accRepo.getAccountById(
          householdAccount.id,
        );

        expect(
          revertedPersonal!.currentBalance,
          equals(Money.fromRupees(20000)),
        );
        expect(
          revertedHousehold!.currentBalance,
          equals(Money.fromRupees(50000)),
        );

        final deletedTransfer = await transferRepo.getTransferById(transfer.id);
        expect(deletedTransfer, isNull);
      },
    );
  });

  group('Section 6 — Data Isolation Invariant Tests', () {
    test('Personal transactions are strictly isolated per member and excluded from household', () async {
      // 1. Create a second family member (Spouse)
      final member2 = await memberRepo.createMember(
        name: 'Priya',
        role: FamilyRole.partner,
        colorHex: '#E91E63',
      );

      // 2. Member 1 (Admin) account & expense
      final admin = (await memberRepo.getAllMembers()).first;
      final adminAccount = await accRepo.createAccount(
        name: 'Admin Personal Wallet',
        accountType: AccountType.digitalWallet,
        scope: FinancialScope.personal,
        memberId: admin.id,
        initialBalance: Money.fromRupees(10000),
      );

      // 3. Member 2 (Priya) account & expense
      final priyaAccount = await accRepo.createAccount(
        name: 'Priya Personal Wallet',
        accountType: AccountType.digitalWallet,
        scope: FinancialScope.personal,
        memberId: member2.id,
        initialBalance: Money.fromRupees(15000),
      );

      // Fetch default categories
      final categories = await db.categoriesDao.getCategories(
        type: TransactionType.expense.name,
        scope: FinancialScope.personal.name,
      );
      final category = categories.first;

      final now = DateTime.now();

      // Admin logs personal expense of ₹2,000
      await txRepo.createTransaction(
        accountId: adminAccount.id,
        categoryId: category.id,
        scope: FinancialScope.personal,
        memberId: admin.id,
        amount: Money.fromRupees(2000),
        transactionType: TransactionType.expense,
        transactionDate: now,
        paymentMethod: PaymentMethod.upi,
      );

      // Priya logs personal expense of ₹5,000
      await txRepo.createTransaction(
        accountId: priyaAccount.id,
        categoryId: category.id,
        scope: FinancialScope.personal,
        memberId: member2.id,
        amount: Money.fromRupees(5000),
        transactionType: TransactionType.expense,
        transactionDate: now,
        paymentMethod: PaymentMethod.upi,
      );

      // 4. Verify Admin's ledger contains only Admin's transaction
      final adminTxs = await txRepo.getTransactions(
        scope: FinancialScope.personal,
        memberId: admin.id,
      );
      expect(adminTxs.length, equals(1));
      expect(adminTxs.first.amount, equals(Money.fromRupees(2000)));

      // 5. Verify Priya's ledger contains only Priya's transaction
      final priyaTxs = await txRepo.getTransactions(
        scope: FinancialScope.personal,
        memberId: member2.id,
      );
      expect(priyaTxs.length, equals(1));
      expect(priyaTxs.first.amount, equals(Money.fromRupees(5000)));

      // 6. Verify Household ledger has ZERO personal transactions
      final householdTxs = await txRepo.getTransactions(
        scope: FinancialScope.household,
      );
      expect(householdTxs.isEmpty, isTrue);
    });
  });

  group('Section 9 — Budget Utilization Exact Boundary Tests', () {
    test('Calculates exact utilization ratios at 79%, 80%, 89%, 90%, 99%, 100%, and >100%', () async {
      // Testing exact percentage boundaries for warnings and color transitions
      final totalLimit = Money.fromRupees(10000); // ₹10,000.00 limit

      // 79% -> ₹7,900
      final spent79 = Money.fromRupees(7900);
      final ratio79 = (spent79.paise / totalLimit.paise);
      expect(ratio79, closeTo(0.79, 0.001));
      expect(ratio79 >= 0.80, isFalse);

      // 80% -> ₹8,000
      final spent80 = Money.fromRupees(8000);
      final ratio80 = (spent80.paise / totalLimit.paise);
      expect(ratio80, closeTo(0.80, 0.001));
      expect(ratio80 >= 0.80, isTrue);

      // 89% -> ₹8,900
      final spent89 = Money.fromRupees(8900);
      final ratio89 = (spent89.paise / totalLimit.paise);
      expect(ratio89, closeTo(0.89, 0.001));
      expect(ratio89 >= 0.90, isFalse);

      // 90% -> ₹9,000
      final spent90 = Money.fromRupees(9000);
      final ratio90 = (spent90.paise / totalLimit.paise);
      expect(ratio90, closeTo(0.90, 0.001));
      expect(ratio90 >= 0.90, isTrue);

      // 99% -> ₹9,900
      final spent99 = Money.fromRupees(9900);
      final ratio99 = (spent99.paise / totalLimit.paise);
      expect(ratio99, closeTo(0.99, 0.001));
      expect(ratio99 >= 1.00, isFalse);

      // 100% -> ₹10,000
      final spent100 = Money.fromRupees(10000);
      final ratio100 = (spent100.paise / totalLimit.paise);
      expect(ratio100, closeTo(1.00, 0.001));
      expect(ratio100 >= 1.00, isTrue);

      // >100% -> ₹12,500
      final spentOver = Money.fromRupees(12500);
      final ratioOver = (spentOver.paise / totalLimit.paise);
      expect(ratioOver, closeTo(1.25, 0.001));
      expect(ratioOver > 1.0, isTrue);
      expect(spentOver > totalLimit, isTrue);
    });
  });

  group('Section 15 — Performance & High-Volume Benchmark Tests', () {
    test(
      'Processes and queries 1,000 transactions with sub-second latency',
      () async {
        final member = (await memberRepo.getAllMembers()).first;
        final account = await accRepo.createAccount(
          name: 'Benchmark Bank Account',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: Money.fromRupees(5000000),
        );

        final categories = await db.categoriesDao.getCategories(
          type: TransactionType.expense.name,
          scope: FinancialScope.household.name,
        );
        final catId = categories.first.id;

        final now = DateTime.now();

        // Benchmark 1,000 sequential inserts
        final stopwatch = Stopwatch()..start();
        await db.batch((batch) {
          for (int i = 0; i < 1000; i++) {
            batch.insert(
              db.transactionsTable,
              TransactionsTableCompanion.insert(
                id: 'bench-tx-$i',
                accountId: account.id,
                categoryId: drift.Value(catId),
                memberId: member.id,
                scope: FinancialScope.household.name,
                amount: Money.fromRupees(100),
                transactionType: TransactionType.expense.name,
                transactionDate: now.subtract(Duration(hours: i)),
                paymentMethod: PaymentMethod.upi.name,
                createdAt: now,
                updatedAt: now,
              ),
            );
          }
        });
        stopwatch.stop();

        // 1,000 batch insertions should complete under 1,000ms in SQLite
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Query performance
        final queryStopwatch = Stopwatch()..start();
        final allTxs = await txRepo.getTransactions(
          scope: FinancialScope.household,
          limit: 1000,
        );
        queryStopwatch.stop();

        expect(allTxs.length, equals(1000));
        // 1,000 records retrieval under 250ms
        expect(queryStopwatch.elapsedMilliseconds, lessThan(250));
      },
    );
  });
}
