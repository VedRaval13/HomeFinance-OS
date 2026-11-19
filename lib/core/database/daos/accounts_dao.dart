import 'package:drift/drift.dart';

import '../../models/money.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [AccountsTable])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Stream<List<AccountEntry>> watchAccounts({
    required String scope,
    String? memberId,
    bool includeArchived = false,
  }) {
    return (select(accountsTable)
          ..where((tbl) {
            final scopeMatch = tbl.scope.equals(scope);
            final archivedMatch = includeArchived
                ? const Constant(true)
                : tbl.isArchived.equals(false);
            if (scope == 'personal' && memberId != null) {
              return scopeMatch & archivedMatch & tbl.memberId.equals(memberId);
            }
            return scopeMatch & archivedMatch;
          })
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  Future<List<AccountEntry>> getAccounts({
    required String scope,
    String? memberId,
    bool includeArchived = false,
  }) {
    return (select(accountsTable)
          ..where((tbl) {
            final scopeMatch = tbl.scope.equals(scope);
            final archivedMatch = includeArchived
                ? const Constant(true)
                : tbl.isArchived.equals(false);
            if (scope == 'personal' && memberId != null) {
              return scopeMatch & archivedMatch & tbl.memberId.equals(memberId);
            }
            return scopeMatch & archivedMatch;
          })
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<AccountEntry?> getAccountById(String id) {
    return (select(
      accountsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertAccount(AccountsTableCompanion entry) {
    return into(accountsTable).insert(entry);
  }

  Future<bool> updateAccount(AccountEntry entry) {
    return update(accountsTable).replace(entry);
  }

  /// Atomically adjusts an account balance by [delta] (which can be positive or negative Money).
  Future<void> adjustAccountBalance(String accountId, Money delta) async {
    final account = await getAccountById(accountId);
    if (account == null) {
      throw StateError('Account $accountId not found');
    }
    final newBalance = account.currentBalance + delta;
    await (update(
      accountsTable,
    )..where((tbl) => tbl.id.equals(accountId))).write(
      AccountsTableCompanion(
        currentBalance: Value(newBalance),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
