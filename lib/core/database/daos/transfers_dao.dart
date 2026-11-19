import 'package:drift/drift.dart';

import '../../models/money.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/transfers_table.dart';

part 'transfers_dao.g.dart';

@DriftAccessor(tables: [TransfersTable, AccountsTable])
class TransfersDao extends DatabaseAccessor<AppDatabase>
    with _$TransfersDaoMixin {
  TransfersDao(super.db);

  Stream<List<TransferEntry>> watchRecentTransfers({int limit = 50}) {
    return (select(transfersTable)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.transferDate)])
          ..limit(limit))
        .watch();
  }

  Future<TransferEntry?> getTransferById(String id) {
    return (select(
      transfersTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Executes an atomic two-legged balance transfer between two accounts.
  /// Deducts [amount] from source, adds [amount] to destination, and records transfer.
  Future<void> executeTransfer({
    required String transferId,
    required String sourceAccountId,
    required String destinationAccountId,
    required Money amount,
    required String transferType,
    required String memberId,
    required DateTime transferDate,
    String? notes,
  }) {
    return transaction(() async {
      // 1. Fetch and validate source account
      final source = await (select(
        accountsTable,
      )..where((tbl) => tbl.id.equals(sourceAccountId))).getSingleOrNull();
      if (source == null) {
        throw StateError('Source account $sourceAccountId not found');
      }

      // 2. Fetch and validate destination account
      final dest = await (select(
        accountsTable,
      )..where((tbl) => tbl.id.equals(destinationAccountId))).getSingleOrNull();
      if (dest == null) {
        throw StateError('Destination account $destinationAccountId not found');
      }

      // 3. Update source account balance (deduction)
      final newSourceBalance = source.currentBalance - amount;
      await (update(
        accountsTable,
      )..where((tbl) => tbl.id.equals(sourceAccountId))).write(
        AccountsTableCompanion(
          currentBalance: Value(newSourceBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 4. Update destination account balance (credit)
      final newDestBalance = dest.currentBalance + amount;
      await (update(
        accountsTable,
      )..where((tbl) => tbl.id.equals(destinationAccountId))).write(
        AccountsTableCompanion(
          currentBalance: Value(newDestBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 5. Insert transfer audit entry
      await into(transfersTable).insert(
        TransfersTableCompanion.insert(
          id: transferId,
          sourceAccountId: sourceAccountId,
          destinationAccountId: destinationAccountId,
          amount: amount,
          transferType: transferType,
          memberId: memberId,
          transferDate: transferDate,
          notes: Value(notes),
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  /// Reverses an existing transfer atomically:
  /// Credits source account, debits destination account, and deletes transfer audit record.
  Future<void> reverseTransfer(String transferId) {
    return transaction(() async {
      final transfer = await (select(
        transfersTable,
      )..where((tbl) => tbl.id.equals(transferId))).getSingleOrNull();
      if (transfer == null) throw StateError('Transfer $transferId not found');

      final source =
          await (select(accountsTable)
                ..where((tbl) => tbl.id.equals(transfer.sourceAccountId)))
              .getSingleOrNull();
      if (source == null) {
        throw StateError(
          'Source account ${transfer.sourceAccountId} not found',
        );
      }

      final dest =
          await (select(accountsTable)
                ..where((tbl) => tbl.id.equals(transfer.destinationAccountId)))
              .getSingleOrNull();
      if (dest == null) {
        throw StateError(
          'Destination account ${transfer.destinationAccountId} not found',
        );
      }

      // 1. Credit source account back
      final restoredSourceBalance = source.currentBalance + transfer.amount;
      await (update(
        accountsTable,
      )..where((tbl) => tbl.id.equals(source.id))).write(
        AccountsTableCompanion(
          currentBalance: Value(restoredSourceBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 2. Debit destination account back
      final restoredDestBalance = dest.currentBalance - transfer.amount;
      await (update(
        accountsTable,
      )..where((tbl) => tbl.id.equals(dest.id))).write(
        AccountsTableCompanion(
          currentBalance: Value(restoredDestBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 3. Delete transfer audit entry
      await (delete(
        transfersTable,
      )..where((tbl) => tbl.id.equals(transferId))).go();
    });
  }
}
