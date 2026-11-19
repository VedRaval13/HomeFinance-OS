import '../../../../core/models/money.dart';
import '../../../budgets/domain/models/budget_category_allocation.dart';
import '../../../budgets/domain/models/budget_item.dart';
import '../models/budget_pacing_metric.dart';
import '../models/financial_insight.dart';

/// Statistical intelligence service analyzing budget burn rates and forecasting month-end exhaustion.
class BudgetPacingService {
  const BudgetPacingService();

  /// Analyzes overall budget and category limits to produce actionable pacing insights.
  List<FinancialInsight> analyzeBudgetPacing({
    required BudgetItem? budget,
    required List<BudgetCategoryAllocation> categories,
    DateTime? referenceDate,
  }) {
    if (budget == null || budget.totalLimit.isZero) {
      return [];
    }

    final now = referenceDate ?? DateTime.now();

    // Pacing calculations only apply to the current active calendar month
    final isCurrentMonth = budget.year == now.year && budget.month == now.month;
    if (!isCurrentMonth) {
      return [];
    }

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dayOfMonth = now.day.clamp(1, daysInMonth);
    final remainingDays = (daysInMonth - dayOfMonth).clamp(0, daysInMonth);

    final insights = <FinancialInsight>[];

    // 1. Calculate overall budget metrics
    Money totalSpent = const Money.zero();
    for (final cat in categories) {
      totalSpent = totalSpent + cat.spentAmount;
    }

    final overallMetric = _calculateMetric(
      name: budget.name,
      allocatedLimit: budget.totalLimit,
      spentSoFar: totalSpent,
      dayOfMonth: dayOfMonth,
      daysInMonth: daysInMonth,
      remainingDays: remainingDays,
    );

    // Generate overall insight
    final overallInsight = _generateOverallInsight(overallMetric);
    if (overallInsight != null) {
      insights.add(overallInsight);
    }

    // 2. Calculate category-level metrics
    final categoryMetrics = categories.map((cat) {
      return _calculateMetric(
        categoryId: cat.categoryId,
        name: cat.categoryName,
        allocatedLimit: cat.allocatedLimit,
        spentSoFar: cat.spentAmount,
        dayOfMonth: dayOfMonth,
        daysInMonth: daysInMonth,
        remainingDays: remainingDays,
      );
    }).toList();

    // Sort categories: Most critical over-runs first
    categoryMetrics.sort((a, b) {
      final aDeficit = (a.projectedTotalSpend - a.allocatedLimit).paise;
      final bDeficit = (b.projectedTotalSpend - b.allocatedLimit).paise;
      return bDeficit.compareTo(aDeficit);
    });

    // Generate insights for top 2 most urgent category alerts
    int categoryInsightsCount = 0;
    for (final catMetric in categoryMetrics) {
      if (categoryInsightsCount >= 2) break;

      final catInsight = _generateCategoryInsight(catMetric);
      if (catInsight != null) {
        insights.add(catInsight);
        categoryInsightsCount++;
      }
    }

    return insights;
  }

  BudgetPacingMetric _calculateMetric({
    String? categoryId,
    required String name,
    required Money allocatedLimit,
    required Money spentSoFar,
    required int dayOfMonth,
    required int daysInMonth,
    required int remainingDays,
  }) {
    final spentPaise = spentSoFar.paise;
    final limitPaise = allocatedLimit.paise;

    // Daily velocity using integer paise division
    final dailyRatePaise = dayOfMonth > 0 ? (spentPaise ~/ dayOfMonth) : 0;
    final dailyBurnRate = Money.fromPaise(dailyRatePaise);

    // Projected spend if current velocity persists throughout month
    final projectedTotalPaise = dailyRatePaise * daysInMonth;
    final projectedTotalSpend = Money.fromPaise(projectedTotalPaise);

    // Remaining capacity
    final remainingPaise = limitPaise - spentPaise;

    // Recommended daily ceiling to finish the month exactly at or below limit
    final recommendedDailyPaise = (remainingDays > 0 && remainingPaise > 0)
        ? (remainingPaise ~/ remainingDays)
        : 0;
    final recommendedDailyLimit = Money.fromPaise(recommendedDailyPaise);

    final pacingRatio = limitPaise > 0 ? (projectedTotalPaise / limitPaise) : 0.0;
    final isOverspent = spentPaise > limitPaise;
    final isOverPacing = pacingRatio > 1.05 && !isOverspent;
    final isUnderPacing = pacingRatio < 0.75 && !isOverspent && spentPaise > 0;

    int? projectedExhaustionDay;
    if (isOverspent) {
      projectedExhaustionDay = dayOfMonth;
    } else if (dailyRatePaise > 0 && remainingPaise > 0) {
      final daysToExhaustion = remainingPaise ~/ dailyRatePaise;
      final calculatedDay = dayOfMonth + daysToExhaustion;
      if (calculatedDay <= daysInMonth) {
        projectedExhaustionDay = calculatedDay;
      }
    }

    return BudgetPacingMetric(
      categoryId: categoryId,
      name: name,
      allocatedLimit: allocatedLimit,
      spentSoFar: spentSoFar,
      dayOfMonth: dayOfMonth,
      daysInMonth: daysInMonth,
      remainingDays: remainingDays,
      dailyBurnRate: dailyBurnRate,
      recommendedDailyLimit: recommendedDailyLimit,
      projectedTotalSpend: projectedTotalSpend,
      pacingRatio: pacingRatio,
      projectedExhaustionDay: projectedExhaustionDay,
      isOverspent: isOverspent,
      isOverPacing: isOverPacing,
      isUnderPacing: isUnderPacing,
    );
  }

  FinancialInsight? _generateOverallInsight(BudgetPacingMetric m) {
    if (m.isOverspent) {
      final overspentAmount = m.spentSoFar - m.allocatedLimit;
      return FinancialInsight(
        id: 'pacing_overall_overspent',
        type: InsightType.budgetPacing,
        severity: InsightSeverity.critical,
        title: 'Monthly Budget Cap Exceeded',
        message:
            'Total spending has exceeded your monthly limit by ${overspentAmount.formatted} with ${m.remainingDays} days remaining in the month.',
        metricBadge: 'Exceeded by ${overspentAmount.formatted}',
        actionLabel: 'Review Budget',
        actionRoute: '/budgets',
        createdAt: DateTime.now(),
      );
    }

    // Only forecast if at least 3 days into the month
    if (m.isOverPacing && m.dayOfMonth >= 3) {
      final exhaustionDayText = m.projectedExhaustionDay != null
          ? 'around Day ${m.projectedExhaustionDay}'
          : 'before month end';

      return FinancialInsight(
        id: 'pacing_overall_warning',
        type: InsightType.budgetPacing,
        severity: InsightSeverity.warning,
        title: 'Overall Budget Pacing Fast',
        message:
            'At ${m.dailyBurnRate.formatted}/day, total spending is projected to reach ${m.projectedTotalSpend.formatted} ($exhaustionDayText). Recommended daily cap: ${m.recommendedDailyLimit.formatted}/day.',
        metricBadge: '${m.recommendedDailyLimit.formatted}/day target',
        actionLabel: 'Adjust Limits',
        actionRoute: '/budgets',
        createdAt: DateTime.now(),
      );
    }

    // Significant surplus pacing (at least 8 days into the month)
    if (m.isUnderPacing && m.dayOfMonth >= 8) {
      final projectedSurplus = m.allocatedLimit - m.projectedTotalSpend;
      return FinancialInsight(
        id: 'pacing_overall_surplus',
        type: InsightType.budgetPacing,
        severity: InsightSeverity.success,
        title: 'Healthy Budget Pace',
        message:
            'Spending is pacing 25%+ under budget. You are on track for a projected surplus of ${projectedSurplus.formatted} this month.',
        metricBadge: '${projectedSurplus.formatted} projected surplus',
        actionLabel: 'View Breakdown',
        actionRoute: '/budgets',
        createdAt: DateTime.now(),
      );
    }

    return null;
  }

  FinancialInsight? _generateCategoryInsight(BudgetPacingMetric m) {
    if (m.allocatedLimit.isZero) return null;

    if (m.isOverspent) {
      final overspentAmount = m.spentSoFar - m.allocatedLimit;
      return FinancialInsight(
        id: 'pacing_cat_${m.categoryId ?? m.name}_overspent',
        type: InsightType.budgetPacing,
        severity: InsightSeverity.critical,
        title: '${m.name} Over Budget',
        message:
            '${m.name} is ${overspentAmount.formatted} over limit with ${m.remainingDays} days still left in the month.',
        metricBadge: 'Over by ${overspentAmount.formatted}',
        actionLabel: 'Adjust Limit',
        actionRoute: '/budgets',
        createdAt: DateTime.now(),
      );
    }

    if (m.isOverPacing && m.dayOfMonth >= 3) {
      final dayText = m.projectedExhaustionDay != null
          ? 'around Day ${m.projectedExhaustionDay}'
          : 'before month end';

      return FinancialInsight(
        id: 'pacing_cat_${m.categoryId ?? m.name}_burn_rate',
        type: InsightType.budgetPacing,
        severity: InsightSeverity.warning,
        title: '${m.name} Burn Rate Alert',
        message:
            'At ${m.dailyBurnRate.formatted}/day, ${m.name} will exhaust its limit $dayText. Recommended limit: ${m.recommendedDailyLimit.formatted}/day.',
        metricBadge: '${m.recommendedDailyLimit.formatted}/day limit',
        actionLabel: 'Review Category',
        actionRoute: '/budgets',
        createdAt: DateTime.now(),
      );
    }

    return null;
  }
}
