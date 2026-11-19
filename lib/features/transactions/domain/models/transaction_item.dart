import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';

/// Domain entity representing a transaction in HomeFinance OS.
class TransactionItem {
  final String id;
  final Money amount;
  final TransactionType transactionType;
  final FinancialScope scope;
  final String accountId;
  final String? accountName;
  final String? categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColorHex;
  final String memberId;
  final String? memberName;
  final DateTime transactionDate;
  final PaymentMethod paymentMethod;
  final String? notes;
  final bool hasReceipt;
  final String? receiptPath;
  final String? transferId;
  final String? recurringId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionItem({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.scope,
    required this.accountId,
    this.accountName,
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.categoryColorHex,
    required this.memberId,
    this.memberName,
    required this.transactionDate,
    required this.paymentMethod,
    this.notes,
    this.hasReceipt = false,
    this.receiptPath,
    this.transferId,
    this.recurringId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isIncome => transactionType.isIncome;
  bool get isExpense => transactionType.isExpense;
  bool get isTransfer => transactionType.isTransfer;
  bool get isContribution => transactionType.isContribution;

  /// Effective signed amount for net ledger calculation.
  Money get signedAmount => isExpense ? -amount.abs() : amount.abs();

  TransactionItem copyWith({
    String? id,
    Money? amount,
    TransactionType? transactionType,
    FinancialScope? scope,
    String? accountId,
    String? accountName,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColorHex,
    String? memberId,
    String? memberName,
    DateTime? transactionDate,
    PaymentMethod? paymentMethod,
    String? notes,
    bool? hasReceipt,
    String? receiptPath,
    String? transferId,
    String? recurringId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      scope: scope ?? this.scope,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColorHex: categoryColorHex ?? this.categoryColorHex,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      transactionDate: transactionDate ?? this.transactionDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptPath: receiptPath ?? this.receiptPath,
      transferId: transferId ?? this.transferId,
      recurringId: recurringId ?? this.recurringId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
