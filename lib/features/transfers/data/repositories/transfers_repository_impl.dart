import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/transfer_item.dart';
import '../../domain/models/transfer_type_enum.dart';
import '../../domain/repositories/transfers_repository.dart';

/// Concrete Drift implementation of [TransfersRepository].
class TransfersRepositoryImpl implements TransfersRepository {
  final AppDatabase db;

  TransfersRepositoryImpl(this.db);

  @override
  Stream<List<TransferItem>> watchTransfers({int limit = 50}) {
    final query = _buildJoinedTransferQuery(limit: limit);
    return query.watch().map(
      (rows) => rows.map(_mapRowToTransferItem).toList(),
    );
  }

  @override
  Future<List<TransferItem>> getTransfers({int limit = 50}) async {
    final query = _buildJoinedTransferQuery(limit: limit);
    final rows = await query.get();
    return rows.map(_mapRowToTransferItem).toList();
  }

  @override
  Future<TransferItem?> getTransferById(String id) async {
    final sourceAccounts = db.alias(db.accountsTable, 'source_acc');
    final destAccounts = db.alias(db.accountsTable, 'dest_acc');

    final query = db.select(db.transfersTable).join([
      leftOuterJoin(
        sourceAccounts,
        sourceAccounts.id.equalsExp(db.transfersTable.sourceAccountId),
      ),
      leftOuterJoin(
        destAccounts,
        destAccounts.id.equalsExp(db.transfersTable.destinationAccountId),
      ),
      leftOuterJoin(
        db.familyMembersTable,
        db.familyMembersTable.id.equalsExp(db.transfersTable.memberId),
      ),
    ])..where(db.transfersTable.id.equals(id));

    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToTransferItem(row) : null;
  }

  @override
  Future<TransferItem> executeTransfer({
    required String sourceAccountId,
    required String destinationAccountId,
    required Money amount,
    required TransferType transferType,
    required String memberId,
    required DateTime transferDate,
    String? notes,
  }) async {
    if (sourceAccountId == destinationAccountId) {
      throw ArgumentError('Source and destination accounts must be different');
    }
    if (amount.isNegative || amount.isZero) {
      throw ArgumentError('Transfer amount must be strictly positive');
    }

    final transferId = UuidUtil.generate();

    // Executes atomic two-legged balance transfer in Drift DAO
    await db.transfersDao.executeTransfer(
      transferId: transferId,
      sourceAccountId: sourceAccountId,
      destinationAccountId: destinationAccountId,
      amount: amount,
      transferType: transferType.name,
      memberId: memberId,
      transferDate: transferDate,
      notes: notes?.trim(),
    );

    final item = await getTransferById(transferId);
    if (item == null) {
      throw StateError('Failed to fetch newly executed transfer');
    }
    return item;
  }

  @override
  Future<Money> computeMemberMonthlyContributions({
    required String memberId,
    required DateTime month,
  }) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final query = db.select(db.transfersTable)
      ..where(
        (tbl) =>
            tbl.memberId.equals(memberId) &
            tbl.transferType.equals(TransferType.householdContribution.name) &
            tbl.transferDate.isBiggerOrEqualValue(startOfMonth) &
            tbl.transferDate.isSmallerOrEqualValue(endOfMonth),
      );

    final rows = await query.get();
    Money total = const Money.zero();
    for (final r in rows) {
      total = total + r.amount;
    }
    return total;
  }

  @override
  Future<void> reverseTransfer(String transferId) async {
    await db.transfersDao.reverseTransfer(transferId);
  }

  JoinedSelectStatement _buildJoinedTransferQuery({int limit = 50}) {
    final sourceAccounts = db.alias(db.accountsTable, 'source_acc');
    final destAccounts = db.alias(db.accountsTable, 'dest_acc');

    final query = db.select(db.transfersTable).join([
      leftOuterJoin(
        sourceAccounts,
        sourceAccounts.id.equalsExp(db.transfersTable.sourceAccountId),
      ),
      leftOuterJoin(
        destAccounts,
        destAccounts.id.equalsExp(db.transfersTable.destinationAccountId),
      ),
      leftOuterJoin(
        db.familyMembersTable,
        db.familyMembersTable.id.equalsExp(db.transfersTable.memberId),
      ),
    ]);

    query.orderBy([OrderingTerm.desc(db.transfersTable.transferDate)]);
    query.limit(limit);
    return query;
  }

  TransferItem _mapRowToTransferItem(TypedResult row) {
    final transfer = row.readTable(db.transfersTable);
    final sourceAccount = row.readTableOrNull(
      db.alias(db.accountsTable, 'source_acc'),
    );
    final destAccount = row.readTableOrNull(
      db.alias(db.accountsTable, 'dest_acc'),
    );
    final member = row.readTableOrNull(db.familyMembersTable);

    return TransferItem(
      id: transfer.id,
      sourceAccountId: transfer.sourceAccountId,
      sourceAccountName: sourceAccount?.name,
      sourceAccountType: sourceAccount != null
          ? AccountType.values.firstWhere(
              (t) => t.name == sourceAccount.accountType,
              orElse: () => AccountType.custom,
            )
          : null,
      destinationAccountId: transfer.destinationAccountId,
      destinationAccountName: destAccount?.name,
      destinationAccountType: destAccount != null
          ? AccountType.values.firstWhere(
              (t) => t.name == destAccount.accountType,
              orElse: () => AccountType.custom,
            )
          : null,
      amount: transfer.amount,
      transferType: TransferType.fromString(transfer.transferType),
      memberId: transfer.memberId,
      memberName: member?.name,
      transferDate: transfer.transferDate,
      notes: transfer.notes,
      createdAt: transfer.createdAt,
    );
  }
}
