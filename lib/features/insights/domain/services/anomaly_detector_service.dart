import 'dart:math' as math;

import '../../../../core/models/money.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../models/anomaly_insight_metric.dart';
import '../models/financial_insight.dart';

/// Statistical intelligence service that detects unusual transaction outliers and category spending surges.
class AnomalyDetectorService {
  const AnomalyDetectorService();

  /// Analyzes recent transactions against a trailing historical baseline to identify anomalies.
  List<FinancialInsight> detectAnomalies({
    required List<TransactionItem> recentTransactions,
    required List<TransactionItem> historicalTransactions,
    DateTime? referenceDate,
  }) {
    if (historicalTransactions.isEmpty || recentTransactions.isEmpty) {
      return [];
    }

    final insights = <FinancialInsight>[];

    // Filter to expenses only
    final historicalExpenses =
        historicalTransactions.where((t) => t.isExpense).toList();
    final recentExpenses =
        recentTransactions.where((t) => t.isExpense).toList();

    if (historicalExpenses.isEmpty || recentExpenses.isEmpty) {
      return [];
    }

    // 1. Build statistical baselines per category from historical data
    final baselines = _buildCategoryBaselines(historicalExpenses);

    // 2. Detect single-transaction outliers in recent transactions
    final transactionOutliers = _detectTransactionOutliers(
      recentExpenses,
      baselines,
    );

    // 3. Detect macro category spending surges in recent transactions
    final categorySurges = _detectCategorySurges(
      recentExpenses,
      baselines,
    );

    // Convert transaction outliers to insights (limit to top 1)
    for (final outlier in transactionOutliers.take(1)) {
      final tx = outlier.outlierTransaction;
      final ratioStr = outlier.deviationRatio.toStringAsFixed(1);

      insights.add(
        FinancialInsight(
          id: 'anomaly_tx_${tx?.id ?? outlier.categoryId}',
          type: InsightType.anomaly,
          severity: outlier.deviationRatio >= 4.0
              ? InsightSeverity.critical
              : InsightSeverity.warning,
          title: 'Unusual Outlier in ${outlier.categoryName}',
          message:
              'A payment of ${outlier.currentAmount.formatted} is $ratioStr× higher than your historical average (${outlier.baselineAmount.formatted}) in this category.',
          metricBadge: '$ratioStr× typical spend',
          actionLabel: 'View Entry',
          actionRoute: '/transactions',
          createdAt: DateTime.now(),
        ),
      );
    }

    // Convert category surges to insights (limit to top 1)
    for (final surge in categorySurges.take(1)) {
      final ratioStr = surge.deviationRatio.toStringAsFixed(1);
      final increasePercent =
          ((surge.deviationRatio - 1.0) * 100).toInt().clamp(0, 999);

      insights.add(
        FinancialInsight(
          id: 'anomaly_surge_${surge.categoryId}',
          type: InsightType.anomaly,
          severity: surge.deviationRatio >= 2.5
              ? InsightSeverity.critical
              : InsightSeverity.warning,
          title: '${surge.categoryName} Spending Surge',
          message:
              'Spending in ${surge.categoryName} (${surge.currentAmount.formatted}) is $ratioStr× higher (+$increasePercent%) than your 3-month trailing baseline (${surge.baselineAmount.formatted}).',
          metricBadge: '+$increasePercent% surge',
          actionLabel: 'Review Outflows',
          actionRoute: '/transactions',
          createdAt: DateTime.now(),
        ),
      );
    }

    return insights;
  }

  Map<String, CategoryStatisticalBaseline> _buildCategoryBaselines(
    List<TransactionItem> expenses,
  ) {
    final grouped = <String, List<TransactionItem>>{};
    final categoryNames = <String, String>{};

    for (final tx in expenses) {
      final catId = tx.categoryId ?? 'uncategorized';
      grouped.putIfAbsent(catId, () => []).add(tx);
      if (tx.categoryName != null) {
        categoryNames[catId] = tx.categoryName!;
      }
    }

    final baselines = <String, CategoryStatisticalBaseline>{};

    for (final entry in grouped.entries) {
      final catId = entry.key;
      final items = entry.value;
      final count = items.length;

      Money total = const Money.zero();
      for (final item in items) {
        total = total + item.amount;
      }

      final meanPaise = count > 0 ? (total.paise ~/ count) : 0;
      final meanMoney = Money.fromPaise(meanPaise);
      final meanRupees = meanMoney.toChartDouble();

      // Calculate sample standard deviation
      double varianceSum = 0.0;
      for (final item in items) {
        final diff = item.amount.toChartDouble() - meanRupees;
        varianceSum += diff * diff;
      }

      final stdDevRupees =
          count > 1 ? math.sqrt(varianceSum / (count - 1)) : 0.0;

      // Approximate monthly average: historical transactions span ~3 months (90 days)
      final monthlyAveragePaise = total.paise ~/ 3;

      baselines[catId] = CategoryStatisticalBaseline(
        categoryId: catId,
        categoryName: categoryNames[catId] ?? 'Category',
        transactionCount: count,
        totalAmount: total,
        meanAmount: meanMoney,
        standardDeviationRupees: stdDevRupees,
        monthlyAverage: Money.fromPaise(monthlyAveragePaise),
      );
    }

    return baselines;
  }

  List<AnomalyDetectionResult> _detectTransactionOutliers(
    List<TransactionItem> recentExpenses,
    Map<String, CategoryStatisticalBaseline> baselines,
  ) {
    final outliers = <AnomalyDetectionResult>[];

    for (final tx in recentExpenses) {
      final catId = tx.categoryId ?? 'uncategorized';
      final baseline = baselines[catId];
      if (baseline == null || baseline.transactionCount < 3) continue;

      // Minimum threshold of ₹1,000 (100,000 paise) to prevent noise on minor items
      if (tx.amount.paise < 100000) continue;

      final amountRupees = tx.amount.toChartDouble();
      final meanRupees = baseline.meanAmount.toChartDouble();
      final stdDev = baseline.standardDeviationRupees;

      final zScore = stdDev > 0 ? (amountRupees - meanRupees) / stdDev : 0.0;
      final ratio =
          baseline.meanAmount.paise > 0
              ? (tx.amount.paise / baseline.meanAmount.paise)
              : 1.0;

      // Outlier flagged if Z-Score >= 2.5 OR amount is >= 3x category average with Z >= 1.8
      if (zScore >= 2.5 || (ratio >= 3.0 && zScore >= 1.8)) {
        outliers.add(
          AnomalyDetectionResult(
            categoryId: catId,
            categoryName: baseline.categoryName,
            outlierTransaction: tx,
            currentAmount: tx.amount,
            baselineAmount: baseline.meanAmount,
            deviationRatio: ratio,
            zScore: zScore,
            isSingleTransactionOutlier: true,
          ),
        );
      }
    }

    // Sort by largest deviation ratio first
    outliers.sort((a, b) => b.deviationRatio.compareTo(a.deviationRatio));
    return outliers;
  }

  List<AnomalyDetectionResult> _detectCategorySurges(
    List<TransactionItem> recentExpenses,
    Map<String, CategoryStatisticalBaseline> baselines,
  ) {
    final recentTotals = <String, Money>{};
    for (final tx in recentExpenses) {
      final catId = tx.categoryId ?? 'uncategorized';
      recentTotals[catId] = (recentTotals[catId] ?? const Money.zero()) + tx.amount;
    }

    final surges = <AnomalyDetectionResult>[];

    for (final entry in recentTotals.entries) {
      final catId = entry.key;
      final currentTotal = entry.value;
      final baseline = baselines[catId];
      if (baseline == null || baseline.monthlyAverage.isZero) continue;

      final baselineMonthlyPaise = baseline.monthlyAverage.paise;
      final currentPaise = currentTotal.paise;

      final ratio = currentPaise / baselineMonthlyPaise;
      final absoluteDiffPaise = currentPaise - baselineMonthlyPaise;

      // Flag if category spend is >= 1.75x baseline AND exceeded by at least ₹2,000
      if (ratio >= 1.75 && absoluteDiffPaise >= 200000) {
        surges.add(
          AnomalyDetectionResult(
            categoryId: catId,
            categoryName: baseline.categoryName,
            currentAmount: currentTotal,
            baselineAmount: baseline.monthlyAverage,
            deviationRatio: ratio,
            zScore: 0.0,
            isSingleTransactionOutlier: false,
          ),
        );
      }
    }

    // Sort by highest surge ratio first
    surges.sort((a, b) => b.deviationRatio.compareTo(a.deviationRatio));
    return surges;
  }
}
