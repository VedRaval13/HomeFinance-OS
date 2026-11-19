import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../models/transaction_item.dart';

/// Abstract contract for Transactions ledger operations.
abstract class TransactionsRepository {
  /// Watches transactions matching the specified criteria.
  Stream<List<TransactionItem>> watchTransactions({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    TransactionType? type,
    int limit = 100,
  });

  /// Fetches transactions matching the specified criteria once.
  Future<List<TransactionItem>> getTransactions({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    TransactionType? type,
    int limit = 100,
  });

  /// Fetches a specific transaction by ID.
  Future<TransactionItem?> getTransactionById(String id);

  /// Creates a new transaction and adjusts the associated account balance atomically.
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
  });

  /// Deletes a transaction and reverses the account balance change atomically.
  Future<void> deleteTransaction(String id);

  /// Computes total income for the given scope, member, and date range.
  Future<Money> computeTotalIncome({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Computes total expenses for the given scope, member, and date range.
  Future<Money> computeTotalExpense({
    required FinancialScope scope,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
