import '../../../../core/models/money.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../models/budget_rule_metric.dart';
import '../models/financial_insight.dart';

/// Statistical intelligence service evaluating household and personal spending
/// against the 50/30/20 budgeting rule (Needs / Wants / Savings).
class BudgetRuleService {
  const BudgetRuleService();

  /// Analyzes transactions and produces actionable 50/30/20 optimization insights.
  List<FinancialInsight> analyzeBudgetRule({
    required List<TransactionItem> monthlyTransactions,
    Money? monthlyIncome,
    DateTime? referenceDate,
  }) {
    final metric = computeMetric(
      monthlyTransactions: monthlyTransactions,
      monthlyIncome: monthlyIncome,
      referenceDate: referenceDate,
    );

    if (metric == null) return [];

    final insights = <FinancialInsight>[];
    final now = referenceDate ?? DateTime.now();

    // 1. Balanced 50/30/20 Harmony (Success)
    if (metric.isOptimal) {
      insights.add(
        FinancialInsight(
          id: 'rule_balanced_50_30_20',
          type: InsightType.savingsRate,
          severity: InsightSeverity.success,
          title: 'Balanced 50/30/20 Budget',
          message:
              'Excellent financial harmony! Your allocation (${metric.needsPercent}% Needs / '
              '${metric.wantsPercent}% Wants / ${metric.savingsPercent}% Savings) '
              'matches the gold-standard budgeting framework.',
          metricBadge: 'Optimal 50/30/20',
          actionLabel: 'View Breakdown',
          actionRoute: '/dashboard',
          createdAt: now,
          metadata: {
            'needsRatio': metric.needsRatio,
            'wantsRatio': metric.wantsRatio,
            'savingsRatio': metric.savingsRatio,
          },
        ),
      );
      return insights;
    }

    // 2. High Needs Overhead (> 55%)
    if (metric.isNeedsHigh) {
      final isSevere = metric.needsRatio > 0.65;
      insights.add(
        FinancialInsight(
          id: 'rule_needs_high',
          type: InsightType.savingsRate,
          severity: isSevere ? InsightSeverity.critical : InsightSeverity.warning,
          title: 'Needs Overhead at ${metric.needsPercent}% (Target: 50%)',
          message:
              'Essential living costs (${metric.needsAmount.formatted}) consume '
              '${metric.needsPercent}% of your budget. High fixed overhead squeezes your '
              'savings potential. Review utilities and recurring bills to trim costs.',
          metricBadge: '${metric.needsPercent}% Needs',
          actionLabel: 'Review Outflows',
          actionRoute: '/transactions',
          createdAt: now,
          metadata: {
            'needsAmountPaise': metric.needsAmount.paise,
            'needsRatio': metric.needsRatio,
          },
        ),
      );
    }

    // 3. High Wants Discretionary Spend (> 35%)
    if (metric.isWantsHigh) {
      insights.add(
        FinancialInsight(
          id: 'rule_wants_high',
          type: InsightType.savingsRate,
          severity: InsightSeverity.warning,
          title: 'Discretionary Wants at ${metric.wantsPercent}% (Target: 30%)',
          message:
              'Lifestyle and non-essential spending (${metric.wantsAmount.formatted}) '
              'takes ${metric.wantsPercent}% of your outflow. Trimming '
              '${metric.recommendedWantsTrim.formatted} in dining or shopping will restore balance.',
          metricBadge: '${metric.wantsPercent}% Wants',
          actionLabel: 'View Transactions',
          actionRoute: '/transactions',
          createdAt: now,
          metadata: {
            'wantsAmountPaise': metric.wantsAmount.paise,
            'wantsRatio': metric.wantsRatio,
            'recommendedTrimPaise': metric.recommendedWantsTrim.paise,
          },
        ),
      );
    }

    // 4. Low Savings Rate (< 12%)
    if (metric.isSavingsLow) {
      insights.add(
        FinancialInsight(
          id: 'rule_savings_low',
          type: InsightType.savingsRate,
          severity: InsightSeverity.warning,
          title: 'Low Savings Rate (${metric.savingsPercent}%)',
          message:
              'Only ${metric.savingsPercent}% (${metric.savingsAmount.formatted}) was directed to '
              'savings or wealth accumulation this month. Aim to redirect '
              '${metric.recommendedSavingsBoost.formatted} to hit the 20% benchmark.',
          metricBadge: '${metric.savingsPercent}% Saved',
          actionLabel: 'Plan Savings',
          actionRoute: '/budgets',
          createdAt: now,
          metadata: {
            'savingsAmountPaise': metric.savingsAmount.paise,
            'savingsRatio': metric.savingsRatio,
            'recommendedBoostPaise': metric.recommendedSavingsBoost.paise,
          },
        ),
      );
    }

    return insights;
  }

  /// Evaluates allocation numbers and returns a detailed [BudgetRuleMetric].
  BudgetRuleMetric? computeMetric({
    required List<TransactionItem> monthlyTransactions,
    Money? monthlyIncome,
    DateTime? referenceDate,
  }) {
    if (monthlyTransactions.isEmpty) return null;

    var needsPaise = 0;
    var wantsPaise = 0;
    var savingsPaise = 0;

    for (final tx in monthlyTransactions) {
      if (tx.isExpense) {
        final bucket = classifyCategory(tx.categoryName);
        switch (bucket) {
          case BudgetBucket.needs:
            needsPaise += tx.amount.paise;
            break;
          case BudgetBucket.wants:
            wantsPaise += tx.amount.paise;
            break;
          case BudgetBucket.savings:
            savingsPaise += tx.amount.paise;
            break;
        }
      } else if (tx.isContribution) {
        savingsPaise += tx.amount.paise;
      }
    }

    // Incorporate net unspent income as retained savings
    if (monthlyIncome != null && monthlyIncome.isPositive) {
      final totalSpent = needsPaise + wantsPaise + savingsPaise;
      if (monthlyIncome.paise > totalSpent) {
        savingsPaise += (monthlyIncome.paise - totalSpent);
      }
    }

    final totalPaise = needsPaise + wantsPaise + savingsPaise;

    // Minimum ₹1,000 (100,000 paise) required for meaningful statistical ratio
    if (totalPaise < 100000) return null;

    final needsRatio = needsPaise / totalPaise;
    final wantsRatio = wantsPaise / totalPaise;
    final savingsRatio = savingsPaise / totalPaise;

    final isNeedsHigh = needsRatio > 0.55;
    final isWantsHigh = wantsRatio > 0.35;
    final isSavingsLow = savingsRatio < 0.12;
    final isOptimal = needsRatio <= 0.55 && wantsRatio <= 0.35 && savingsRatio >= 0.18;

    // Recommendation calculations strictly in integer paise
    var excessWantsPaise = 0;
    if (wantsRatio > 0.30) {
      excessWantsPaise = (wantsPaise - (totalPaise * 0.30).round()).clamp(0, wantsPaise);
    }

    var deficitSavingsPaise = 0;
    if (savingsRatio < 0.20) {
      deficitSavingsPaise = ((totalPaise * 0.20).round() - savingsPaise).clamp(0, totalPaise);
    }

    return BudgetRuleMetric(
      needsAmount: Money.fromPaise(needsPaise),
      wantsAmount: Money.fromPaise(wantsPaise),
      savingsAmount: Money.fromPaise(savingsPaise),
      totalAllocation: Money.fromPaise(totalPaise),
      needsRatio: needsRatio,
      wantsRatio: wantsRatio,
      savingsRatio: savingsRatio,
      isNeedsHigh: isNeedsHigh,
      isWantsHigh: isWantsHigh,
      isSavingsLow: isSavingsLow,
      isOptimal: isOptimal,
      recommendedWantsTrim: Money.fromPaise(excessWantsPaise),
      recommendedSavingsBoost: Money.fromPaise(deficitSavingsPaise),
    );
  }

  /// Classifies a category name into one of the 50/30/20 buckets.
  BudgetBucket classifyCategory(String? categoryName) {
    if (categoryName == null || categoryName.trim().isEmpty) {
      return BudgetBucket.wants;
    }

    final name = categoryName.trim().toLowerCase();

    // 1. Needs Keywords
    const needsKeywords = [
      'rent',
      'housing',
      'mortgage',
      'maintenance',
      'society',
      'grocer',
      'supermarket',
      'household supplies',
      'provision',
      'milk',
      'vegetable',
      'ration',
      'electric',
      'water',
      'gas',
      'lpg',
      'cylinder',
      'utility',
      'utilities',
      'health',
      'medical',
      'medicine',
      'pharmacy',
      'hospital',
      'doctor',
      'clinic',
      'transport',
      'fuel',
      'petrol',
      'diesel',
      'cng',
      'commute',
      'metro',
      'bus',
      'train',
      'auto',
      'loan',
      'emi',
      'debt',
      'insurance',
      'education',
      'school',
      'tuition',
      'college',
      'repair',
      'internet',
      'wifi',
      'broadband',
    ];

    for (final kw in needsKeywords) {
      if (name.contains(kw)) {
        return BudgetBucket.needs;
      }
    }

    // 2. Savings & Debt Keywords
    const savingsKeywords = [
      'saving',
      'investment',
      'stocks',
      'mutual fund',
      'sip',
      'gold',
      'fixed deposit',
      'fd',
      'rd',
      'ppf',
      'nps',
      'epf',
      'wealth',
      'crypto',
      'fund',
    ];

    for (final kw in savingsKeywords) {
      if (name.contains(kw)) {
        return BudgetBucket.savings;
      }
    }

    // 3. Discretionary Wants (Dining, Shopping, Entertainment, Leisure Travel, Hobbies, etc.)
    return BudgetBucket.wants;
  }
}
