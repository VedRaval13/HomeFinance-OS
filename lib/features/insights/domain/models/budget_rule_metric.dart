import '../../../../core/models/money.dart';

/// The three foundational allocation buckets of the 50/30/20 budgeting rule.
enum BudgetBucket {
  needs,
  wants,
  savings;

  String get label {
    switch (this) {
      case BudgetBucket.needs:
        return 'Needs (50%)';
      case BudgetBucket.wants:
        return 'Wants (30%)';
      case BudgetBucket.savings:
        return 'Savings & Debt (20%)';
    }
  }

  double get benchmarkRatio {
    switch (this) {
      case BudgetBucket.needs:
        return 0.50;
      case BudgetBucket.wants:
        return 0.30;
      case BudgetBucket.savings:
        return 0.20;
    }
  }
}

/// Evaluation metric of the user's spending against the 50/30/20 rule.
class BudgetRuleMetric {
  final Money needsAmount;
  final Money wantsAmount;
  final Money savingsAmount;
  final Money totalAllocation;

  final double needsRatio;
  final double wantsRatio;
  final double savingsRatio;

  final bool isNeedsHigh;
  final bool isWantsHigh;
  final bool isSavingsLow;
  final bool isOptimal;

  final Money recommendedWantsTrim;
  final Money recommendedSavingsBoost;

  const BudgetRuleMetric({
    required this.needsAmount,
    required this.wantsAmount,
    required this.savingsAmount,
    required this.totalAllocation,
    required this.needsRatio,
    required this.wantsRatio,
    required this.savingsRatio,
    required this.isNeedsHigh,
    required this.isWantsHigh,
    required this.isSavingsLow,
    required this.isOptimal,
    required this.recommendedWantsTrim,
    required this.recommendedSavingsBoost,
  });

  int get needsPercent => (needsRatio * 100).round();
  int get wantsPercent => (wantsRatio * 100).round();
  int get savingsPercent => (savingsRatio * 100).round();
}
