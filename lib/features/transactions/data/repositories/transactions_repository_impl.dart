import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/transaction_item.dart';
import '../../domain/repositories/transactions_repository.dart';

/// Concrete Drift implementation of [TransactionsRepository].
class TransactionsRepositoryImpl implements TransactionsRepository {
  final AppDatabase db;

  TransactionsRepositoryImpl(this.db);

  @override
  Stream<List<TransactionItem>> watchTransactions({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    TransactionType? type,
    int limit = 100,
  }) {
    final query = _buildJoinedQuery(
      scope: scope,
      memberId: memberId,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      accountId: accountId,
      type: type,
      limit: limit,
    );

    return query.watch().map(
      (rows) => rows.map(_mapRowToTransactionItem).toList(),
    );
  }

  @override
  Future<List<TransactionItem>> getTransactions({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    TransactionType? type,
    int limit = 100,
  }) async {
    final query = _buildJoinedQuery(
      scope: scope,
      memberId: memberId,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      accountId: accountId,
      type: type,
      limit: limit,
    );

    final rows = await query.get();
    return rows.map(_mapRowToTransactionItem).toList();
  }

  @override
  Future<TransactionItem?> getTransactionById(String id) async {
    final query = db.select(db.transactionsTable).join([
      leftOuterJoin(
        db.accountsTable,
        db.accountsTable.id.equalsExp(db.transactionsTable.accountId),
      ),
      leftOuterJoin(
        db.categoriesTable,
        db.categoriesTable.id.equalsExp(db.transactionsTable.categoryId),
      ),
      leftOuterJoin(
        db.familyMembersTable,
        db.familyMembersTable.id.equalsExp(db.transactionsTable.memberId),
      ),
    ])..where(db.transactionsTable.id.equals(id));

    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToTransactionItem(row) : null;
  }

  @override
  Future<TransactionItem> createTransaction({
    required Money amount,
    required TransactionType transactionType,
    required FinancialScope scope,
    required String accountId,
    String? categoryId,
    required String memberId,
    required DateTime transactionDate,
    required PaymentMethod paymentMethod,
    String? notes,
    bool hasReceipt = false,
    String? receiptPath,
  }) async {
    final id = UuidUtil.generate();
    final now = DateTime.now();

    final companion = TransactionsTableCompanion.insert(
      id: id,
      amount: amount,
      transactionType: transactionType.name,
      scope: scope.name,
      accountId: accountId,
      categoryId: Value(categoryId),
      memberId: memberId,
      transactionDate: transactionDate,
      paymentMethod: paymentMethod.name,
      notes: Value(notes?.trim()),
      hasReceipt: Value(hasReceipt),
      receiptPath: Value(receiptPath),
      createdAt: now,
      updatedAt: now,
    );

    // Atomically inserts transaction and updates account balance
    await db.transactionsDao.insertTransactionWithBalanceUpdate(companion);

    final item = await getTransactionById(id);
    if (item == null) {
      throw StateError('Failed to fetch newly created transaction');
    }
    return item;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await db.transactionsDao.deleteTransactionWithBalanceReversal(id);
  }

  @override
  Future<Money> computeTotalIncome({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await getTransactions(
      scope: scope,
      memberId: memberId,
      startDate: startDate,
      endDate: endDate,
      type: TransactionType.income,
      limit: 10000,
    );

    Money total = const Money.zero();
    for (final tx in transactions) {
      total = total + tx.amount;
    }
    return total;
  }

  @override
  Future<Money> computeTotalExpense({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await getTransactions(
      scope: scope,
      memberId: memberId,
      startDate: startDate,
      endDate: endDate,
      type: TransactionType.expense,
      limit: 10000,
    );

    Money total = const Money.zero();
    for (final tx in transactions) {
      total = total + tx.amount;
    }
    return total;
  }

  JoinedSelectStatement _buildJoinedQuery({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    TransactionType? type,
    int limit = 100,
  }) {
    final query = db.select(db.transactionsTable).join([
      leftOuterJoin(
        db.accountsTable,
        db.accountsTable.id.equalsExp(db.transactionsTable.accountId),
      ),
      leftOuterJoin(
        db.categoriesTable,
        db.categoriesTable.id.equalsExp(db.transactionsTable.categoryId),
      ),
      leftOuterJoin(
        db.familyMembersTable,
        db.familyMembersTable.id.equalsExp(db.transactionsTable.memberId),
      ),
    ]);

    query.where(db.transactionsTable.scope.equals(scope.name));

    if (scope.isPersonal && memberId != null) {
      query.where(db.transactionsTable.memberId.equals(memberId));
    }
    if (startDate != null) {
      query.where(
        db.transactionsTable.transactionDate.isBiggerOrEqualValue(startDate),
      );
    }
    if (endDate != null) {
      query.where(
        db.transactionsTable.transactionDate.isSmallerOrEqualValue(endDate),
      );
    }
    if (categoryId != null) {
      query.where(db.transactionsTable.categoryId.equals(categoryId));
    }
    if (accountId != null) {
      query.where(db.transactionsTable.accountId.equals(accountId));
    }
    if (type != null) {
      query.where(db.transactionsTable.transactionType.equals(type.name));
    }

    query.orderBy([OrderingTerm.desc(db.transactionsTable.transactionDate)]);
    query.limit(limit);

    return query;
  }

  TransactionItem _mapRowToTransactionItem(TypedResult row) {
    final tx = row.readTable(db.transactionsTable);
    final account = row.readTableOrNull(db.accountsTable);
    final category = row.readTableOrNull(db.categoriesTable);
    final member = row.readTableOrNull(db.familyMembersTable);

    return TransactionItem(
      id: tx.id,
      amount: tx.amount,
      transactionType: TransactionType.values.firstWhere(
        (t) => t.name == tx.transactionType,
        orElse: () => TransactionType.expense,
      ),
      scope: tx.scope == 'household'
          ? FinancialScope.household
          : FinancialScope.personal,
      accountId: tx.accountId,
      accountName: account?.name,
      categoryId: tx.categoryId,
      categoryName: category?.name,
      categoryIcon: category?.iconName,
      categoryColorHex: category?.colorHex,
      memberId: tx.memberId,
      memberName: member?.name,
      transactionDate: tx.transactionDate,
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == tx.paymentMethod,
        orElse: () => PaymentMethod.other,
      ),
      notes: tx.notes,
      hasReceipt: tx.hasReceipt,
      receiptPath: tx.receiptPath,
      transferId: tx.transferId,
      recurringId: tx.recurringId,
      createdAt: tx.createdAt,
      updatedAt: tx.updatedAt,
    );
  }
}
