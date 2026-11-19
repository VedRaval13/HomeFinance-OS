import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../accounts/domain/models/account.dart';
import '../../../budgets/domain/models/budget_item.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../models/financial_insight.dart';
import '../models/liquidity_runway_metric.dart';

/// Statistical intelligence service computing liquid emergency reserves,
/// survival runway in months, and emergency fund target adequacy.
class LiquidityRunwayService {
  const LiquidityRunwayService();

  /// Analyzes accounts and spending velocity to generate actionable liquidity insights.
  List<FinancialInsight> analyzeLiquidityRunway({
    required List<Account> accounts,
    required List<TransactionItem> trailingTransactions,
    BudgetItem? activeBudget,
    DateTime? referenceDate,
    double targetMonths = 6.0,
  }) {
    final metric = computeMetric(
      accounts: accounts,
      trailingTransactions: trailingTransactions,
      activeBudget: activeBudget,
      referenceDate: referenceDate,
      targetMonths: targetMonths,
    );

    if (metric == null) return [];

    final insights = <FinancialInsight>[];
    final now = referenceDate ?? DateTime.now();

    // 1. Primary Runway Insight based on Health Status
    switch (metric.healthStatus) {
      case RunwayHealthStatus.critical:
        insights.add(
          FinancialInsight(
            id: 'runway_critical',
            type: InsightType.emergencyRunway,
            severity: InsightSeverity.critical,
            title: 'Critical Cash Runway (${metric.runwayDays} Days)',
            message:
                'Liquid reserves (${metric.netLiquidReserves.formatted}) cover only ${metric.runwayDays} days '
                'at your current monthly burn of ${metric.monthlyBurnRate.formatted}/mo. '
                'Prioritize building immediate liquid cash reserves.',
            metricBadge: '< 1 mo buffer',
            actionLabel: 'View Accounts',
            actionRoute: '/accounts',
            createdAt: now,
            metadata: {
              'runwayMonths': metric.runwayMonths,
              'runwayDays': metric.runwayDays,
              'netLiquidPaise': metric.netLiquidReserves.paise,
              'monthlyBurnPaise': metric.monthlyBurnRate.paise,
            },
          ),
        );
        break;

      case RunwayHealthStatus.fragile:
        insights.add(
          FinancialInsight(
            id: 'runway_fragile',
            type: InsightType.emergencyRunway,
            severity: InsightSeverity.warning,
            title: 'Thin Emergency Buffer (${metric.runwayMonths.toStringAsFixed(1)} mo)',
            message:
                'Your liquid reserves (${metric.netLiquidReserves.formatted}) cover ${metric.runwayMonths.toStringAsFixed(1)} months. '
                'Targeting a 3–6 month emergency fund (${metric.targetEmergencyFund.formatted}) '
                'protects against unexpected income disruptions.',
            metricBadge: '${metric.runwayMonths.toStringAsFixed(1)} mo runway',
            actionLabel: 'Plan Savings',
            actionRoute: '/budgets',
            createdAt: now,
            metadata: {
              'runwayMonths': metric.runwayMonths,
              'targetDeficitPaise': metric.deficitOrSurplus.paise,
            },
          ),
        );
        break;

      case RunwayHealthStatus.adequate:
        insights.add(
          FinancialInsight(
            id: 'runway_adequate',
            type: InsightType.emergencyRunway,
            severity: InsightSeverity.info,
            title: 'Healthy Emergency Runway (${metric.runwayMonths.toStringAsFixed(1)} mo)',
            message:
                'Your liquid reserves (${metric.netLiquidReserves.formatted}) provide ${metric.runwayMonths.toStringAsFixed(1)} months '
                'of financial runway against your monthly burn (${metric.monthlyBurnRate.formatted}/mo).',
            metricBadge: '${metric.runwayMonths.toStringAsFixed(1)} mo runway',
            actionLabel: 'View Accounts',
            actionRoute: '/accounts',
            createdAt: now,
            metadata: {
              'runwayMonths': metric.runwayMonths,
            },
          ),
        );
        break;

      case RunwayHealthStatus.resilient:
        insights.add(
          FinancialInsight(
            id: 'runway_resilient',
            type: InsightType.emergencyRunway,
            severity: InsightSeverity.success,
            title: 'Fortress Cash Runway (${metric.runwayMonths.toStringAsFixed(1)} mo)',
            message:
                'Exceptional emergency preparedness! Your net liquid reserves (${metric.netLiquidReserves.formatted}) '
                'exceed the 6-month gold standard, fully protecting your household from financial shocks.',
            metricBadge: '${metric.runwayMonths.toStringAsFixed(1)} mo runway',
            actionLabel: 'View Accounts',
            actionRoute: '/accounts',
            createdAt: now,
            metadata: {
              'runwayMonths': metric.runwayMonths,
            },
          ),
        );
        break;
    }

    // 2. High Credit Card Debt Caution (Liabilities exceed 50% of liquid assets)
    if (metric.totalLiabilities.paise > 0 &&
        metric.totalLiquidCash.paise > 0 &&
        metric.totalLiabilities.paise >= (metric.totalLiquidCash.paise ~/ 2)) {
      final ratioPct = ((metric.totalLiabilities.paise / metric.totalLiquidCash.paise) * 100).toStringAsFixed(0);
      insights.add(
        FinancialInsight(
          id: 'runway_high_liabilities',
          type: InsightType.emergencyRunway,
          severity: InsightSeverity.warning,
          title: 'High Credit Card Burden',
          message:
              'Outstanding credit card balances (${metric.totalLiabilities.formatted}) represent $ratioPct% '
              'of your available liquid cash (${metric.totalLiquidCash.formatted}). Pay down high-interest balances promptly.',
          metricBadge: '$ratioPct% cash ratio',
          actionLabel: 'View Accounts',
          actionRoute: '/accounts',
          createdAt: now,
        ),
      );
    }

    return insights;
  }

  /// Calculates the liquidity runway metric.
  LiquidityRunwayMetric? computeMetric({
    required List<Account> accounts,
    required List<TransactionItem> trailingTransactions,
    BudgetItem? activeBudget,
    DateTime? referenceDate,
    double targetMonths = 6.0,
  }) {
    if (accounts.isEmpty) return null;

    final now = referenceDate ?? DateTime.now();

    // 1. Calculate liquid cash and liabilities strictly in integer paise
    var liquidPaise = 0;
    var liabilityPaise = 0;

    for (final acc in accounts) {
      if (acc.isArchived) continue;

      if (acc.accountType == AccountType.creditCard) {
        // Credit card positive balance represents debt
        if (acc.currentBalance.paise > 0) {
          liabilityPaise += acc.currentBalance.paise;
        }
      } else if (acc.accountType == AccountType.cash ||
          acc.accountType == AccountType.bank ||
          acc.accountType == AccountType.savings ||
          acc.accountType == AccountType.digitalWallet) {
        // Purely liquid assets
        if (acc.currentBalance.paise > 0) {
          liquidPaise += acc.currentBalance.paise;
        }
      }
    }

    final netLiquidPaise = liquidPaise - liabilityPaise;
    final totalLiquidCash = Money.fromPaise(liquidPaise);
    final totalLiabilities = Money.fromPaise(liabilityPaise);
    final netLiquidReserves = Money.fromPaise(netLiquidPaise);

    // 2. Determine monthly burn rate
    var monthlyBurnPaise = 0;

    final expenses = trailingTransactions.where((t) => t.isExpense).toList();
    if (expenses.isNotEmpty) {
      var earliest = now;
      var totalExpensePaise = 0;

      for (final tx in expenses) {
        totalExpensePaise += tx.amount.paise;
        if (tx.transactionDate.isBefore(earliest)) {
          earliest = tx.transactionDate;
        }
      }

      final spanDays = now.difference(earliest).inDays.clamp(30, 180);
      final effectiveMonths = spanDays / 30.0;
      monthlyBurnPaise = (totalExpensePaise / effectiveMonths).round();
    }

    // Fallback: use active budget totalLimit if no transactions
    if (monthlyBurnPaise == 0 && activeBudget != null && activeBudget.totalLimit.isPositive) {
      monthlyBurnPaise = activeBudget.totalLimit.paise;
    }

    // If still zero, we cannot calculate runway without a baseline burn rate
    if (monthlyBurnPaise <= 0) {
      return null;
    }

    final monthlyBurnRate = Money.fromPaise(monthlyBurnPaise);

    // 3. Compute runway months and days
    double runwayMonths;
    int runwayDays;
    RunwayHealthStatus healthStatus;

    if (netLiquidPaise <= 0) {
      runwayMonths = 0.0;
      runwayDays = 0;
      healthStatus = RunwayHealthStatus.critical;
    } else {
      runwayMonths = netLiquidPaise / monthlyBurnPaise;
      runwayDays = (runwayMonths * 30.0).round();

      if (runwayMonths < 1.0) {
        healthStatus = RunwayHealthStatus.critical;
      } else if (runwayMonths < 3.0) {
        healthStatus = RunwayHealthStatus.fragile;
      } else if (runwayMonths < 6.0) {
        healthStatus = RunwayHealthStatus.adequate;
      } else {
        healthStatus = RunwayHealthStatus.resilient;
      }
    }

    // 4. Target emergency fund (targetMonths = 6.0 default)
    final targetEmergencyPaise = (monthlyBurnPaise * targetMonths).round();
    final targetEmergencyFund = Money.fromPaise(targetEmergencyPaise);
    final deficitOrSurplus = Money.fromPaise(netLiquidPaise - targetEmergencyPaise);

    return LiquidityRunwayMetric(
      totalLiquidCash: totalLiquidCash,
      totalLiabilities: totalLiabilities,
      netLiquidReserves: netLiquidReserves,
      monthlyBurnRate: monthlyBurnRate,
      runwayMonths: runwayMonths,
      runwayDays: runwayDays,
      targetMonths: targetMonths,
      targetEmergencyFund: targetEmergencyFund,
      deficitOrSurplus: deficitOrSurplus,
      healthStatus: healthStatus,
    );
  }
}
