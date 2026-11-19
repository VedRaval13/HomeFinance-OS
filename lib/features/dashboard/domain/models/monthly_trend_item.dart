import '../../../../core/models/money.dart';

/// Represents income vs expense cash flow for a specific month in financial trend analytics.
class MonthlyTrendItem {
  final int month; // 1-12
  final int year;
  final String label; // e.g. "Jun", "Jul", "Nov 26"
  final Money totalIncome;
  final Money totalExpense;

  const MonthlyTrendItem({
    required this.month,
    required this.year,
    required this.label,
    required this.totalIncome,
    required this.totalExpense,
  });

  /// Net savings (Income - Expense).
  Money get netSavings => totalIncome - totalExpense;

  /// Savings rate percentage (0 to 100). Returns 0 if income is zero.
  int get savingsRatePercent {
    if (totalIncome.isZero || totalIncome.isNegative) return 0;
    if (netSavings.isNegative) return 0;
    return ((netSavings.paise / totalIncome.paise) * 100).toInt().clamp(0, 100);
  }
}
