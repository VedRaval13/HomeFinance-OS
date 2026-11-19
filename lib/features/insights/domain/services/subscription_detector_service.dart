import 'package:intl/intl.dart';

import '../../../../core/models/money.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../models/financial_insight.dart';
import '../models/recurring_bill_metric.dart';

/// Service analyzing transaction history to detect recurring subscriptions,
/// price creep / hikes, upcoming bill due dates, and cumulative recurring burden.
class SubscriptionDetectorService {
  const SubscriptionDetectorService();

  /// Analyzes transactions and generates actionable financial insights.
  List<FinancialInsight> analyzeSubscriptions({
    required List<TransactionItem> transactions,
    DateTime? referenceDate,
    Money? monthlyExpenseBaseline,
  }) {
    final report = generateReport(
      transactions: transactions,
      referenceDate: referenceDate,
      monthlyExpenseBaseline: monthlyExpenseBaseline,
    );

    final insights = <FinancialInsight>[];
    final now = referenceDate ?? DateTime.now();

    // 1. Price Hike Alerts (High Priority Warnings)
    for (final item in report.priceHikeAlerts) {
      insights.add(
        FinancialInsight(
          id: 'sub_hike_${item.id}',
          type: InsightType.subscription,
          severity: InsightSeverity.warning,
          title: 'Price Hike: ${item.title}',
          message:
              '${item.title} increased from ${item.previousAmount?.formatted ?? 'earlier'} '
              'to ${item.latestAmount.formatted} (+${item.priceHikePercent.toStringAsFixed(0)}%). '
              'Review if you are on the right subscription tier.',
          metricBadge: '+${item.priceHikePercent.toStringAsFixed(0)}% hike',
          actionLabel: 'View Transactions',
          actionRoute: '/transactions',
          createdAt: now,
          metadata: {
            'merchant': item.title,
            'latestAmountPaise': item.latestAmount.paise,
            'previousAmountPaise': item.previousAmount?.paise,
            'hikePercent': item.priceHikePercent,
          },
        ),
      );
    }

    // 2. Upcoming Due Date Alerts (Due in <= 4 days)
    for (final item in report.dueSoonAlerts) {
      final days = item.daysUntilDue ?? 0;
      final dueText = days == 0
          ? 'Today'
          : days == 1
              ? 'Tomorrow'
              : 'in $days days';
      final formattedDate = item.predictedNextDate != null
          ? DateFormat('d MMM').format(item.predictedNextDate!)
          : '';

      insights.add(
        FinancialInsight(
          id: 'sub_due_${item.id}',
          type: InsightType.subscription,
          severity: InsightSeverity.info,
          title: 'Upcoming Bill: ${item.title}',
          message:
              'Estimated payment of ${item.latestAmount.formatted} is due $dueText '
              '($formattedDate). Ensure account has sufficient balance.',
          metricBadge: 'Due $dueText',
          actionLabel: 'View Transactions',
          actionRoute: '/transactions',
          createdAt: now,
          metadata: {
            'merchant': item.title,
            'amountPaise': item.latestAmount.paise,
            'daysUntilDue': days,
          },
        ),
      );
    }

    // 3. Overall Recurring Commitment / Burden Alert
    if (report.items.isNotEmpty) {
      final ratio = report.commitmentRatio;
      if (ratio != null && ratio >= 0.25 && report.totalMonthlyCommitment.paise >= 200000) {
        // More than 25% of monthly spend is locked in fixed recurring bills
        final pct = (ratio * 100).toStringAsFixed(0);
        insights.add(
          FinancialInsight(
            id: 'sub_burden_high',
            type: InsightType.subscription,
            severity: InsightSeverity.warning,
            title: 'High Recurring Commitments',
            message:
                'You have ${report.items.length} recurring subscriptions & bills totaling '
                '${report.totalMonthlyCommitment.formatted}/mo (~$pct% of monthly spending). '
                'Review subscriptions to eliminate unused services.',
            metricBadge: '$pct% fixed spend',
            actionLabel: 'Review Bills',
            actionRoute: '/transactions',
            createdAt: now,
            metadata: {
              'recurringCount': report.items.length,
              'monthlyTotalPaise': report.totalMonthlyCommitment.paise,
              'burdenRatio': ratio,
            },
          ),
        );
      } else if (report.items.length >= 2) {
        insights.add(
          FinancialInsight(
            id: 'sub_burden_summary',
            type: InsightType.subscription,
            severity: InsightSeverity.info,
            title: 'Recurring Subscriptions Tracked',
            message:
                'Tracking ${report.items.length} recurring services totaling '
                '${report.totalMonthlyCommitment.formatted}/month.',
            metricBadge: '${report.totalMonthlyCommitment.formatted}/mo',
            actionLabel: 'View Transactions',
            actionRoute: '/transactions',
            createdAt: now,
            metadata: {
              'recurringCount': report.items.length,
              'monthlyTotalPaise': report.totalMonthlyCommitment.paise,
            },
          ),
        );
      }
    }

    return insights;
  }

  /// Generates the complete recurring subscription report from transaction history.
  RecurringSubscriptionReport generateReport({
    required List<TransactionItem> transactions,
    DateTime? referenceDate,
    Money? monthlyExpenseBaseline,
  }) {
    final now = referenceDate ?? DateTime.now();

    // Filter to only expenses
    final expenses = transactions.where((tx) => tx.isExpense).toList();
    if (expenses.length < 2) {
      return RecurringSubscriptionReport(
        items: const [],
        totalMonthlyCommitment: const Money.zero(),
        priceHikeAlerts: const [],
        dueSoonAlerts: const [],
      );
    }

    // Group expenses by normalized merchant / title
    final groups = <String, List<TransactionItem>>{};
    for (final tx in expenses) {
      final key = _extractMerchantKey(tx);
      if (key == null) continue;
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final detectedItems = <DetectedRecurringItem>[];
    final priceHikes = <DetectedRecurringItem>[];
    final dueSoon = <DetectedRecurringItem>[];

    var totalMonthlyPaise = 0;

    for (final entry in groups.entries) {
      final groupKey = entry.key;
      final groupTxs = entry.value;

      // Need at least 2 transactions to establish periodicity
      if (groupTxs.length < 2) continue;

      // Sort chronologically ascending
      groupTxs.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));

      final cadence = _detectCadence(groupTxs);
      if (cadence == null) continue;

      final latestTx = groupTxs.last;
      final prevTx = groupTxs[groupTxs.length - 2];

      // Price Hike Detection:
      // If latest amount > previous amount by >= 5% and delta >= ₹50 (5,000 paise)
      var hasPriceHike = false;
      var priceHikePct = 0.0;
      var priceHikeDelta = const Money.zero();

      if (latestTx.amount.paise > prevTx.amount.paise) {
        final deltaPaise = latestTx.amount.paise - prevTx.amount.paise;
        final pct = (deltaPaise / prevTx.amount.paise) * 100;
        if (pct >= 5.0 && deltaPaise >= 5000) {
          hasPriceHike = true;
          priceHikePct = pct;
          priceHikeDelta = Money.fromPaise(deltaPaise);
        }
      }

      // Monthly Equivalent Cost (Integer paise arithmetic)
      final monthlyCost = _computeMonthlyEquivalent(latestTx.amount, cadence);
      totalMonthlyPaise += monthlyCost.paise;

      // Predict next payment date based on cadence
      final predictedNext = _predictNextDate(latestTx.transactionDate, cadence);
      final daysUntilDue = predictedNext.difference(now).inDays;

      final displayName = _formatDisplayName(groupKey, latestTx);

      final item = DetectedRecurringItem(
        id: groupKey,
        title: displayName,
        categoryName: latestTx.categoryName,
        frequency: cadence,
        occurrenceCount: groupTxs.length,
        latestAmount: latestTx.amount,
        previousAmount: prevTx.amount,
        lastPaymentDate: latestTx.transactionDate,
        predictedNextDate: predictedNext,
        hasPriceHike: hasPriceHike,
        priceHikePercent: priceHikePct,
        priceHikeDelta: priceHikeDelta,
        monthlyEquivalentCost: monthlyCost,
        daysUntilDue: daysUntilDue,
      );

      detectedItems.add(item);

      if (hasPriceHike) {
        priceHikes.add(item);
      }

      if (item.isDueSoon) {
        dueSoon.add(item);
      }
    }

    // Sort detected items by monthly cost descending
    detectedItems.sort((a, b) => b.monthlyEquivalentCost.compareTo(a.monthlyEquivalentCost));

    double? commitmentRatio;
    if (monthlyExpenseBaseline != null && monthlyExpenseBaseline.isPositive) {
      commitmentRatio = totalMonthlyPaise / monthlyExpenseBaseline.paise;
    }

    return RecurringSubscriptionReport(
      items: detectedItems,
      totalMonthlyCommitment: Money.fromPaise(totalMonthlyPaise),
      commitmentRatio: commitmentRatio,
      priceHikeAlerts: priceHikes,
      dueSoonAlerts: dueSoon,
    );
  }

  /// Extracts a normalized merchant key from notes or category name.
  String? _extractMerchantKey(TransactionItem tx) {
    var raw = tx.notes?.trim();

    if (raw == null || raw.isEmpty) {
      // If notes are empty, check if category is an obvious subscription/bill category
      final cat = tx.categoryName?.trim().toLowerCase() ?? '';
      if (cat.contains('subscript') ||
          cat.contains('utility') ||
          cat.contains('bill') ||
          cat.contains('rent') ||
          cat.contains('recharge') ||
          cat.contains('internet')) {
        raw = tx.categoryName;
      }
    }

    if (raw == null || raw.trim().isEmpty) return null;

    var cleaned = raw.toLowerCase();

    // Strip common payment system noise
    cleaned = cleaned
        .replaceAll(RegExp(r'\b(payment to|paid to|bill payment|bill|sub-|subscription|autopay|upi|pos|recharge)\b'), '')
        .replaceAll(RegExp(r'[#\d\-_]+'), ' ') // Strip transaction numbers, dates, IDs
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .trim();

    // Collapse multi-spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    if (cleaned.length < 3) {
      // Fallback: if cleaning stripped everything (e.g. "Rent" or category name)
      final fallback = (tx.notes?.isNotEmpty == true ? tx.notes! : tx.categoryName ?? '').trim().toLowerCase();
      if (fallback.length >= 3) return fallback;
      return null;
    }

    return cleaned;
  }

  /// Formats normalized key into a title-cased display name.
  String _formatDisplayName(String key, TransactionItem sampleTx) {
    if (sampleTx.notes != null && sampleTx.notes!.trim().length >= 3) {
      final original = sampleTx.notes!.trim();
      // If original is short and clean, use it with capitalization
      if (original.length <= 25) {
        return original.split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + (word.length > 1 ? word.substring(1) : '');
        }).join(' ');
      }
    }

    // Title case the cleaned key
    return key.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + (word.length > 1 ? word.substring(1) : '');
    }).join(' ');
  }

  /// Detects periodic cadence from a list of sorted transactions.
  RecurringFrequency? _detectCadence(List<TransactionItem> sortedTxs) {
    if (sortedTxs.length < 2) return null;

    final intervals = <int>[];
    for (int i = 1; i < sortedTxs.length; i++) {
      final delta = sortedTxs[i]
          .transactionDate
          .difference(sortedTxs[i - 1].transactionDate)
          .inDays;
      if (delta > 0) {
        intervals.add(delta);
      }
    }

    if (intervals.isEmpty) return null;

    intervals.sort();
    final medianInterval = intervals[intervals.length ~/ 2];

    // Weekly: 5 to 9 days
    if (medianInterval >= 5 && medianInterval <= 9) {
      return RecurringFrequency.weekly;
    }

    // Bi-Weekly: 12 to 17 days
    if (medianInterval >= 12 && medianInterval <= 17) {
      return RecurringFrequency.biWeekly;
    }

    // Monthly: 23 to 38 days
    if (medianInterval >= 23 && medianInterval <= 38) {
      return RecurringFrequency.monthly;
    }

    // Quarterly: 75 to 110 days
    if (medianInterval >= 75 && medianInterval <= 110) {
      return RecurringFrequency.quarterly;
    }

    // Yearly: 330 to 400 days
    if (medianInterval >= 330 && medianInterval <= 400) {
      return RecurringFrequency.yearly;
    }

    // If amounts are identical across all transactions and intervals are roughly 20-50 days
    final firstAmount = sortedTxs.first.amount.paise;
    final allSameAmount = sortedTxs.every((tx) => (tx.amount.paise - firstAmount).abs() <= (firstAmount * 0.05));
    if (allSameAmount && medianInterval >= 20 && medianInterval <= 50) {
      return RecurringFrequency.monthly;
    }

    return null;
  }

  /// Converts any cadence to its integer monthly equivalent cost.
  Money _computeMonthlyEquivalent(Money amount, RecurringFrequency frequency) {
    switch (frequency) {
      case RecurringFrequency.weekly:
        // (paise * 52) / 12
        return Money.fromPaise((amount.paise * 52) ~/ 12);
      case RecurringFrequency.biWeekly:
        // (paise * 26) / 12
        return Money.fromPaise((amount.paise * 26) ~/ 12);
      case RecurringFrequency.monthly:
      case RecurringFrequency.irregular:
        return amount;
      case RecurringFrequency.quarterly:
        return Money.fromPaise(amount.paise ~/ 3);
      case RecurringFrequency.yearly:
        return Money.fromPaise(amount.paise ~/ 12);
    }
  }

  /// Predicts the next expected billing date based on cadence.
  DateTime _predictNextDate(DateTime lastDate, RecurringFrequency frequency) {
    if (frequency == RecurringFrequency.monthly) {
      // Safe next month computation handling month-end roll-overs
      final nextYear = lastDate.month == 12 ? lastDate.year + 1 : lastDate.year;
      final nextMonth = lastDate.month == 12 ? 1 : lastDate.month + 1;
      final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
      final safeDay = lastDate.day > daysInNextMonth ? daysInNextMonth : lastDate.day;
      return DateTime(nextYear, nextMonth, safeDay);
    }

    return lastDate.add(Duration(days: frequency.nominalDays));
  }
}
