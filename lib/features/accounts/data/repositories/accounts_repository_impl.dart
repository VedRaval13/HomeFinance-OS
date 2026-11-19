import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/account.dart';
import '../../domain/repositories/accounts_repository.dart';

/// Concrete Drift implementation of [AccountsRepository].
class AccountsRepositoryImpl implements AccountsRepository {
  final AppDatabase db;

  AccountsRepositoryImpl(this.db);

  @override
  Stream<List<Account>> watchAccounts({
    required FinancialScope scope,
    String? memberId,
    bool includeArchived = false,
  }) {
    return db.accountsDao
        .watchAccounts(
          scope: scope.name,
          memberId: memberId,
          includeArchived: includeArchived,
        )
        .map((entries) => entries.map(_mapToDomain).toList());
  }

  @override
  Future<List<Account>> getAccounts({
    required FinancialScope scope,
    String? memberId,
    bool includeArchived = false,
  }) async {
    final entries = await db.accountsDao.getAccounts(
      scope: scope.name,
      memberId: memberId,
      includeArchived: includeArchived,
    );
    return entries.map(_mapToDomain).toList();
  }

  @override
  Future<Account?> getAccountById(String id) async {
    final entry = await db.accountsDao.getAccountById(id);
    return entry != null ? _mapToDomain(entry) : null;
  }

  @override
  Future<Account> createAccount({
    required String name,
    required AccountType accountType,
    required FinancialScope scope,
    String? memberId,
    required Money initialBalance,
    String? institutionName,
    String? accountNumberLast4,
  }) async {
    final id = UuidUtil.generate();
    final now = DateTime.now();

    final account = Account(
      id: id,
      name: name.trim(),
      accountType: accountType,
      scope: scope,
      memberId: memberId,
      initialBalance: initialBalance,
      currentBalance:
          initialBalance, // Initially currentBalance equals initialBalance
      currencyCode: 'INR',
      institutionName: institutionName?.trim(),
      accountNumberLast4: accountNumberLast4?.trim(),
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );

    await db.accountsDao.insertAccount(
      AccountsTableCompanion.insert(
        id: id,
        name: account.name,
        accountType: account.accountType.name,
        scope: account.scope.name,
        memberId: Value(memberId),
        initialBalance: initialBalance,
        currentBalance: initialBalance,
        currencyCode: const Value('INR'),
        institutionName: Value(institutionName?.trim()),
        accountNumberLast4: Value(accountNumberLast4?.trim()),
        isArchived: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return account;
  }

  @override
  Future<void> updateAccount(Account account) async {
    final now = DateTime.now();
    await (db.update(
      db.accountsTable,
    )..where((tbl) => tbl.id.equals(account.id))).write(
      AccountsTableCompanion(
        name: Value(account.name.trim()),
        accountType: Value(account.accountType.name),
        currentBalance: Value(account.currentBalance),
        institutionName: Value(account.institutionName?.trim()),
        accountNumberLast4: Value(account.accountNumberLast4?.trim()),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> archiveAccount(String id) async {
    await (db.update(
      db.accountsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      AccountsTableCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> unarchiveAccount(String id) async {
    await (db.update(
      db.accountsTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      AccountsTableCompanion(
        isArchived: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<Money> computeTotalBalance({
    required FinancialScope scope,
    String? memberId,
  }) async {
    final accounts = await getAccounts(scope: scope, memberId: memberId);
    Money total = const Money.zero();
    for (final acc in accounts) {
      total = total + acc.netWorthContribution;
    }
    return total;
  }

  Account _mapToDomain(AccountEntry entry) {
    return Account(
      id: entry.id,
      name: entry.name,
      accountType: AccountType.values.firstWhere(
        (t) => t.name.toLowerCase() == entry.accountType.toLowerCase(),
        orElse: () => AccountType.custom,
      ),
      scope: entry.scope == 'household'
          ? FinancialScope.household
          : FinancialScope.personal,
      memberId: entry.memberId,
      initialBalance: entry.initialBalance,
      currentBalance: entry.currentBalance,
      currencyCode: entry.currencyCode,
      institutionName: entry.institutionName,
      accountNumberLast4: entry.accountNumberLast4,
      isArchived: entry.isArchived,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}
