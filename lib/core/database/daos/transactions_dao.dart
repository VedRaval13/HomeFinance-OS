import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [TransactionsTable, AccountsTable])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Stream<List<TransactionEntry>> watchTransactions({
    required String scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    int limit = 100,
  }) {
    return (select(transactionsTable)
          ..where((tbl) {
            Expression<bool> predicate = tbl.scope.equals(scope);
            if (scope == 'personal' && memberId != null) {
              predicate = predicate & tbl.memberId.equals(memberId);
            }
            if (startDate != null) {
              predicate =
                  predicate &
                  tbl.transactionDate.isBiggerOrEqualValue(startDate);
            }
            if (endDate != null) {
              predicate =
                  predicate &
                  tbl.transactionDate.isSmallerOrEqualValue(endDate);
            }
            if (categoryId != null) {
              predicate = predicate & tbl.categoryId.equals(categoryId);
            }
            if (accountId != null) {
              predicate = predicate & tbl.accountId.equals(accountId);
            }
            return predicate;
          })
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.transactionDate)])
          ..limit(limit))
        .watch();
  }

  Future<TransactionEntry?> getTransactionById(String id) {
    return (select(
      transactionsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Inserts a transaction and adjusts the associated account balance atomically.
  Future<void> insertTransactionWithBalanceUpdate(
    TransactionsTableCompanion entry,
  ) {
    return transaction(() async {
      final accountId = entry.accountId.value;
      final amount = entry.amount.value;
      final type = entry.transactionType.value;

      final account = await (select(
        accountsTable,
      )..where((tbl) => tbl.id.equals(accountId))).getSingleOrNull();
      if (account == null) throw StateError('Account $accountId not found');

      // Calculate balance delta based on transaction type
      if (type == 'income') {
        final newBalance = account.currentBalance + amount;
        await (update(
          accountsTable,
        )..where((tbl) => tbl.id.equals(accountId))).write(
          AccountsTableCompanion(
            currentBalance: Value(newBalance),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else if (type == 'expense') {
        final newBalance = account.currentBalance - amount;
        await (update(
          accountsTable,
        )..where((tbl) => tbl.id.equals(accountId))).write(
          AccountsTableCompanion(
            currentBalance: Value(newBalance),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      await into(transactionsTable).insert(entry);
    });
  }

  /// Deletes a transaction and restores the previous account balance atomically.
  Future<void> deleteTransactionWithBalanceReversal(String id) {
    return transaction(() async {
      final tx = await getTransactionById(id);
      if (tx == null) return;

      final account = await (select(
        accountsTable,
      )..where((tbl) => tbl.id.equals(tx.accountId))).getSingleOrNull();
      if (account != null) {
        if (tx.transactionType == 'income') {
          final restoredBalance = account.currentBalance - tx.amount;
          await (update(
            accountsTable,
          )..where((tbl) => tbl.id.equals(tx.accountId))).write(
            AccountsTableCompanion(
              currentBalance: Value(restoredBalance),
              updatedAt: Value(DateTime.now()),
            ),
          );
        } else if (tx.transactionType == 'expense') {
          final restoredBalance = account.currentBalance + tx.amount;
          await (update(
            accountsTable,
          )..where((tbl) => tbl.id.equals(tx.accountId))).write(
            AccountsTableCompanion(
              currentBalance: Value(restoredBalance),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      await (delete(transactionsTable)..where((tbl) => tbl.id.equals(id))).go();
    });
  }
}
