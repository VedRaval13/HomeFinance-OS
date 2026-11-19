import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../budgets/presentation/providers/budgets_provider.dart';
import '../../../budgets/presentation/providers/savings_goals_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';
import '../../domain/models/financial_insight.dart';
import '../../domain/services/anomaly_detector_service.dart';
import '../../domain/services/budget_pacing_service.dart';
import '../../domain/services/budget_rule_service.dart';
import '../../domain/services/goal_velocity_service.dart';
import '../../domain/services/liquidity_runway_service.dart';
import '../../domain/services/subscription_detector_service.dart';

/// Provider for the budget pacing calculation service (Module 1).
final budgetPacingServiceProvider = Provider<BudgetPacingService>((ref) {
  return const BudgetPacingService();
});

/// Provider for the statistical anomaly detector service (Module 2).
final anomalyDetectorServiceProvider = Provider<AnomalyDetectorService>((ref) {
  return const AnomalyDetectorService();
});

/// Provider for the savings goal velocity & feasibility engine (Module 3).
final goalVelocityServiceProvider = Provider<GoalVelocityService>((ref) {
  return const GoalVelocityService();
});

/// Provider for recurring bills and subscription leak detection service (Module 4).
final subscriptionDetectorServiceProvider =
    Provider<SubscriptionDetectorService>((ref) {
  return const SubscriptionDetectorService();
});

/// Provider for liquidity runway and emergency buffer analysis service (Module 5).
final liquidityRunwayServiceProvider =
    Provider<LiquidityRunwayService>((ref) {
  return const LiquidityRunwayService();
});

/// Provider for 50/30/20 budget optimization rule engine (Module 6).
final budgetRuleServiceProvider = Provider<BudgetRuleService>((ref) {
  return const BudgetRuleService();
});

/// Set of insight IDs dismissed by the user during the current session.
final dismissedInsightsProvider = StateProvider<Set<String>>((ref) => {});

/// Computes live budget burn rate & pacing recommendations (Module 1).
final budgetPacingInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(budgetPacingServiceProvider);
  final budget = ref.watch(activeBudgetStreamProvider).value;
  final categories = ref.watch(activeBudgetCategoriesStreamProvider).value ?? [];

  return service.analyzeBudgetPacing(
    budget: budget,
    categories: categories,
  );
});

/// Stream of transactions over the trailing 90 days for statistical anomaly detection.
final trailing90DaysTransactionsStreamProvider =
    StreamProvider<List<TransactionItem>>((ref) {
  final repo = ref.watch(transactionsRepositoryProvider);
  final activeSpace = ref.watch(activeFinancialSpaceProvider);
  final now = DateTime.now();
  final ninetyDaysAgo = now.subtract(const Duration(days: 90));

  return repo.watchTransactions(
    scope: activeSpace.scope,
    memberId: activeSpace.scope.isPersonal ? activeSpace.activeMemberId : null,
    startDate: ninetyDaysAgo,
    endDate: now,
    limit: 1000,
  );
});

/// Computes statistical outlier transactions and category spending surges (Module 2).
final anomalyInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(anomalyDetectorServiceProvider);
  final transactionsAsync = ref.watch(trailing90DaysTransactionsStreamProvider);

  return transactionsAsync.when(
    data: (transactions) {
      if (transactions.isEmpty) return [];

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final recent = <TransactionItem>[];
      final historical = <TransactionItem>[];

      for (final tx in transactions) {
        if (tx.transactionDate.isAfter(thirtyDaysAgo)) {
          recent.add(tx);
        } else {
          historical.add(tx);
        }
      }

      final effectiveHistorical =
          historical.isNotEmpty ? historical : recent;

      return service.detectAnomalies(
        recentTransactions: recent,
        historicalTransactions: effectiveHistorical,
        referenceDate: now,
      );
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Computes savings goal completion forecasts, pacing status, and milestone alerts (Module 3).
final goalVelocityInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(goalVelocityServiceProvider);
  final goalsAsync = ref.watch(savingsGoalsStreamProvider);

  return goalsAsync.when(
    data: (goals) => service.analyzeGoalVelocities(goals: goals),
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Computes recurring bill detection, subscription price hikes, and leak alerts (Module 4).
final subscriptionInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(subscriptionDetectorServiceProvider);
  final transactionsAsync = ref.watch(trailing90DaysTransactionsStreamProvider);
  final budget = ref.watch(activeBudgetStreamProvider).value;

  return transactionsAsync.when(
    data: (transactions) => service.analyzeSubscriptions(
      transactions: transactions,
      monthlyExpenseBaseline: budget?.totalLimit,
    ),
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Computes liquid emergency buffer, runway months, and solvency alerts (Module 5).
final liquidityRunwayInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(liquidityRunwayServiceProvider);
  final accountsAsync = ref.watch(accountsStreamProvider);
  final transactionsAsync = ref.watch(trailing90DaysTransactionsStreamProvider);
  final budget = ref.watch(activeBudgetStreamProvider).value;

  final accounts = accountsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];

  if (accounts.isEmpty) return [];

  return service.analyzeLiquidityRunway(
    accounts: accounts,
    trailingTransactions: transactions,
    activeBudget: budget,
  );
});

/// Computes 50/30/20 budget optimization and rebalancing recommendations (Module 6).
final budgetRuleInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final service = ref.watch(budgetRuleServiceProvider);
  final transactionsAsync = ref.watch(trailing90DaysTransactionsStreamProvider);

  return transactionsAsync.when(
    data: (transactions) {
      if (transactions.isEmpty) return [];

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Filter to current month or trailing 30 days
      final recent = transactions
          .where((t) => t.transactionDate.isAfter(thirtyDaysAgo))
          .toList();

      return service.analyzeBudgetRule(
        monthlyTransactions: recent.isNotEmpty ? recent : transactions,
        referenceDate: now,
      );
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Combined master provider collecting, filtering, and prioritizing all financial insights.
final activeInsightsProvider = Provider<List<FinancialInsight>>((ref) {
  final pacingInsights = ref.watch(budgetPacingInsightsProvider);
  final anomalyInsights = ref.watch(anomalyInsightsProvider);
  final goalInsights = ref.watch(goalVelocityInsightsProvider);
  final subscriptionInsights = ref.watch(subscriptionInsightsProvider);
  final runwayInsights = ref.watch(liquidityRunwayInsightsProvider);
  final ruleInsights = ref.watch(budgetRuleInsightsProvider);
  final dismissed = ref.watch(dismissedInsightsProvider);

  // Combine All 6 Modules:
  // Module 1 (Pacing), Module 2 (Anomalies), Module 3 (Goals),
  // Module 4 (Subscriptions), Module 5 (Runway), and Module 6 (50/30/20 Rule)
  final all = [
    ...pacingInsights,
    ...anomalyInsights,
    ...goalInsights,
    ...subscriptionInsights,
    ...runwayInsights,
    ...ruleInsights,
  ];

  // Filter out user-dismissed insights
  final active = all.where((insight) => !dismissed.contains(insight.id)).toList();

  // Sort by urgency: Critical first, then Warning, then Info, then Success
  active.sort((a, b) {
    const priority = {
      InsightSeverity.critical: 0,
      InsightSeverity.warning: 1,
      InsightSeverity.info: 2,
      InsightSeverity.success: 3,
    };
    final pA = priority[a.severity] ?? 99;
    final pB = priority[b.severity] ?? 99;
    return pA.compareTo(pB);
  });

  return active;
});
