import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';

/// Domain entity representing a monthly budget in HomeFinance OS.
class BudgetItem {
  final String id;
  final String name;
  final FinancialScope scope;
  final String? memberId;
  final int month;
  final int year;
  final Money totalLimit;
  final bool isActive;
  final DateTime createdAt;

  const BudgetItem({
    required this.id,
    required this.name,
    required this.scope,
    this.memberId,
    required this.month,
    required this.year,
    required this.totalLimit,
    this.isActive = true,
    required this.createdAt,
  });

  BudgetItem copyWith({
    String? id,
    String? name,
    FinancialScope? scope,
    String? memberId,
    int? month,
    int? year,
    Money? totalLimit,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BudgetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      month: month ?? this.month,
      year: year ?? this.year,
      totalLimit: totalLimit ?? this.totalLimit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
