import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';

/// Domain entity representing a financial account in HomeFinance OS.
class Account {
  final String id;
  final String name;
  final AccountType accountType;
  final FinancialScope scope;
  final String? memberId;
  final Money initialBalance;
  final Money currentBalance;
  final String currencyCode;
  final String? institutionName;
  final String? accountNumberLast4;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.accountType,
    required this.scope,
    this.memberId,
    required this.initialBalance,
    required this.currentBalance,
    this.currencyCode = 'INR',
    this.institutionName,
    this.accountNumberLast4,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Credit cards are liabilities; positive balance represents debt/outstanding balance.
  bool get isLiability => accountType.isLiability;

  /// Whether this account is an asset (liquid cash, bank balance, savings, investment).
  bool get isAsset => !isLiability;

  /// Effective net worth contribution: assets add positive liquidity, liabilities subtract.
  Money get netWorthContribution =>
      isLiability ? -currentBalance.abs() : currentBalance;

  Account copyWith({
    String? id,
    String? name,
    AccountType? accountType,
    FinancialScope? scope,
    String? memberId,
    Money? initialBalance,
    Money? currentBalance,
    String? currencyCode,
    String? institutionName,
    String? accountNumberLast4,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      currencyCode: currencyCode ?? this.currencyCode,
      institutionName: institutionName ?? this.institutionName,
      accountNumberLast4: accountNumberLast4 ?? this.accountNumberLast4,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
