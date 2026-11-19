import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';

void main() {
  late AppDatabase db;
  late AccountsRepositoryImpl repo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    repo = AccountsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AccountsRepository & Multi-Type Ledger Management', () {
    test('Default seeded accounts are present', () async {
      final householdAccounts = await repo.getAccounts(
        scope: FinancialScope.household,
      );
      expect(householdAccounts.length, 2);
      expect(
        householdAccounts.any((a) => a.accountType == AccountType.cash),
        isTrue,
      );
      expect(
        householdAccounts.any((a) => a.accountType == AccountType.bank),
        isTrue,
      );
    });

    test(
      'Creates and persists accounts with exact integer paise balances',
      () async {
        final bankAccount = await repo.createAccount(
          name: 'HDFC Savings Premium',
          accountType: AccountType.savings,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(15000050), // ₹1,50,000.50
          institutionName: 'HDFC Bank',
          accountNumberLast4: '4021',
        );

        expect(bankAccount.id.isNotEmpty, isTrue);
        expect(bankAccount.currentBalance.paise, 15000050);
        expect(bankAccount.institutionName, 'HDFC Bank');
        expect(bankAccount.accountNumberLast4, '4021');

        final fetched = await repo.getAccountById(bankAccount.id);
        expect(fetched, isNotNull);
        expect(fetched!.currentBalance.paise, 15000050);
        expect(fetched.currentBalance.rupeesPart, 150000);
        expect(fetched.currentBalance.paisePart, 50);
      },
    );

    test(
      'Credit card liability is subtracted from total net balance',
      () async {
        // 1. Add Bank Asset: ₹1,00,000.00
        await repo.createAccount(
          name: 'Salary Bank Account',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(10000000), // ₹1,00,000.00
        );

        // 2. Add Credit Card Liability: ₹25,000.00
        await repo.createAccount(
          name: 'Amazon ICICI Credit Card',
          accountType: AccountType.creditCard,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(-2500000), // -₹25,000.00
        );

        // Total balance must be: ₹1,00,000 - ₹25,000 = ₹75,000.00
        final totalBalance = await repo.computeTotalBalance(
          scope: FinancialScope.household,
        );
        expect(totalBalance.paise, 7500000);
        expect(totalBalance.format(), '₹75,000.00');
      },
    );

    test('Updates account metadata', () async {
      final created = await repo.createAccount(
        name: 'My Old Wallet',
        accountType: AccountType.cash,
        scope: FinancialScope.household,
        initialBalance: const Money.zero(),
      );

      final updated = created.copyWith(
        name: 'Home Cash Vault',
        institutionName: 'Home Safe',
      );

      await repo.updateAccount(updated);

      final fetched = await repo.getAccountById(created.id);
      expect(fetched!.name, 'Home Cash Vault');
      expect(fetched.institutionName, 'Home Safe');
    });

    test(
      'Archiving hides account from active list while preserving ledger',
      () async {
        final created = await repo.createAccount(
          name: 'Temporary Account',
          accountType: AccountType.custom,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(500000),
        );

        var activeAccounts = await repo.getAccounts(
          scope: FinancialScope.household,
        );
        expect(activeAccounts.any((a) => a.id == created.id), isTrue);

        // Archive
        await repo.archiveAccount(created.id);

        activeAccounts = await repo.getAccounts(
          scope: FinancialScope.household,
        );
        expect(activeAccounts.any((a) => a.id == created.id), isFalse);

        // Still retrievable with includeArchived: true
        final allAccounts = await repo.getAccounts(
          scope: FinancialScope.household,
          includeArchived: true,
        );
        expect(allAccounts.any((a) => a.id == created.id), isTrue);
      },
    );
  });
}
