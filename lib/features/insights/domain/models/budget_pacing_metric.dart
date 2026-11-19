import '../../../../core/models/money.dart';

/// Detailed mathematical projection for a budget or category's monthly burn rate.
class BudgetPacingMetric {
  final String? categoryId;
  final String name;
  final Money allocatedLimit;
  final Money spentSoFar;
  final int dayOfMonth;
  final int daysInMonth;
  final int remainingDays;
  final Money dailyBurnRate;
  final Money recommendedDailyLimit;
  final Money projectedTotalSpend;
  final double pacingRatio; // projectedTotalSpend / allocatedLimit
  final int? projectedExhaustionDay;
  final bool isOverspent;
  final bool isOverPacing;
  final bool isUnderPacing;

  const BudgetPacingMetric({
    this.categoryId,
    required this.name,
    required this.allocatedLimit,
    required this.spentSoFar,
    required this.dayOfMonth,
    required this.daysInMonth,
    required this.remainingDays,
    required this.dailyBurnRate,
    required this.recommendedDailyLimit,
    required this.projectedTotalSpend,
    required this.pacingRatio,
    this.projectedExhaustionDay,
    required this.isOverspent,
    required this.isOverPacing,
    required this.isUnderPacing,
  });

  /// The projected surplus or deficit amount at current pacing.
  Money get projectedVariance => allocatedLimit - projectedTotalSpend;
}
