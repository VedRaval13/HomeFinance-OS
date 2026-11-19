import '../../../../core/models/money.dart';

/// Cadence of detected recurring expense transactions.
enum RecurringFrequency {
  weekly,
  biWeekly,
  monthly,
  quarterly,
  yearly,
  irregular;

  String get label {
    switch (this) {
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biWeekly:
        return 'Bi-weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.quarterly:
        return 'Quarterly';
      case RecurringFrequency.yearly:
        return 'Yearly';
      case RecurringFrequency.irregular:
        return 'Periodic';
    }
  }

  int get nominalDays {
    switch (this) {
      case RecurringFrequency.weekly:
        return 7;
      case RecurringFrequency.biWeekly:
        return 14;
      case RecurringFrequency.monthly:
        return 30;
      case RecurringFrequency.quarterly:
        return 91;
      case RecurringFrequency.yearly:
        return 365;
      case RecurringFrequency.irregular:
        return 30;
    }
  }
}

/// A recurring bill or subscription automatically detected from transaction logs.
class DetectedRecurringItem {
  final String id;
  final String title;
  final String? categoryName;
  final RecurringFrequency frequency;
  final int occurrenceCount;
  final Money latestAmount;
  final Money? previousAmount;
  final DateTime lastPaymentDate;
  final DateTime? predictedNextDate;
  final bool hasPriceHike;
  final double priceHikePercent;
  final Money priceHikeDelta;
  final Money monthlyEquivalentCost;
  final int? daysUntilDue;

  const DetectedRecurringItem({
    required this.id,
    required this.title,
    this.categoryName,
    required this.frequency,
    required this.occurrenceCount,
    required this.latestAmount,
    this.previousAmount,
    required this.lastPaymentDate,
    this.predictedNextDate,
    required this.hasPriceHike,
    required this.priceHikePercent,
    required this.priceHikeDelta,
    required this.monthlyEquivalentCost,
    this.daysUntilDue,
  });

  bool get isDueSoon => daysUntilDue != null && daysUntilDue! >= 0 && daysUntilDue! <= 5;
}

/// Aggregated report of all recurring bills and subscription commitments.
class RecurringSubscriptionReport {
  final List<DetectedRecurringItem> items;
  final Money totalMonthlyCommitment;
  final double? commitmentRatio; // Against total monthly outflow
  final List<DetectedRecurringItem> priceHikeAlerts;
  final List<DetectedRecurringItem> dueSoonAlerts;

  const RecurringSubscriptionReport({
    required this.items,
    required this.totalMonthlyCommitment,
    this.commitmentRatio,
    required this.priceHikeAlerts,
    required this.dueSoonAlerts,
  });
}
