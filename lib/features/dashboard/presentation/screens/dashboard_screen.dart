import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../budgets/domain/models/budget_item.dart';
import '../../../budgets/presentation/providers/budgets_provider.dart';
import '../../../budgets/presentation/widgets/set_budget_dialog.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../../transactions/presentation/widgets/add_edit_transaction_dialog.dart';
import '../../../transactions/presentation/widgets/transaction_list_tile.dart';
import '../../../transfers/presentation/widgets/transfer_dialog.dart';
import '../../../insights/presentation/widgets/smart_insights_card.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/income_expense_bar_chart.dart';

/// Complete, local-first financial dashboard providing real-time balances,
/// cashflow metrics, budget status, category breakdowns, and financial trends.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final isHousehold = activeSpace.scope.isHousehold;
    final theme = Theme.of(context);
    final selectedMonth = ref.watch(dashboardSelectedMonthProvider);
    final cashflowSummaryAsync = ref.watch(
      dashboardCashflowSummaryStreamProvider,
    );
    final expenseBreakdownAsync = ref.watch(
      dashboardExpenseBreakdownStreamProvider,
    );
    final monthlyTrendAsync = ref.watch(dashboardMonthlyTrendStreamProvider);
    final recentTransactionsAsync = ref.watch(
      dashboardRecentTransactionsStreamProvider,
    );
    final netBalance = ref.watch(totalCombinedBalanceProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final budgetAsync = ref.watch(activeBudgetStreamProvider);
    final budgetUtilization = ref.watch(overallBudgetUtilizationProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          // Month Selector Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space12,
              vertical: AppDimensions.space4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: AppDimensions.borderRadiusMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: 'Previous Month',
                  onPressed: () {
                    final curr = ref.read(dashboardSelectedMonthProvider);
                    ref.read(dashboardSelectedMonthProvider.notifier).state =
                        DateTime(curr.year, curr.month - 1, 1);
                  },
                ),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedMonth,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) {
                      ref.read(dashboardSelectedMonthProvider.notifier).state =
                          DateTime(picked.year, picked.month, 1);
                    }
                  },
                  borderRadius: AppDimensions.borderRadiusSmall,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space12,
                      vertical: AppDimensions.space4,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 18),
                        const SizedBox(width: AppDimensions.space8),
                        Text(
                          DateFormatters.formatMonthYear(selectedMonth),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  tooltip: 'Next Month',
                  onPressed: () {
                    final curr = ref.read(dashboardSelectedMonthProvider);
                    ref.read(dashboardSelectedMonthProvider.notifier).state =
                        DateTime(curr.year, curr.month + 1, 1);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Total Net Balance Hero Card
          _buildHeroBalanceCard(
            context,
            activeSpace.scope,
            netBalance,
            accountsAsync.value?.length ?? 0,
          ),
          const SizedBox(height: AppDimensions.space16),

          // Quick Action Bar
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => AddEditTransactionDialog.show(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Add Transaction'),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: activeSpace.scope.color,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => TransferDialog.show(context),
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Transfer'),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Automated On-Device Financial Intelligence & Recommendations (Module 1)
          const SmartInsightsCard(),
          const SizedBox(height: AppDimensions.space4),

          // Monthly Cashflow Metrics Grid (Income, Expense, Net Cashflow, Savings Rate)
          cashflowSummaryAsync.when(
            data: (summary) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Monthly Income',
                          amount: summary.totalIncome,
                          icon: Icons.arrow_downward_rounded,
                          color: AppColors.income,
                          subtitle: isHousehold
                              ? 'Family Inflows'
                              : 'Personal Salary',
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Monthly Expenses',
                          amount: summary.totalExpense,
                          icon: Icons.arrow_upward_rounded,
                          color: AppColors.expense,
                          subtitle: isHousehold
                              ? 'Rent & Groceries'
                              : 'Personal Outflows',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Net Cash Flow',
                          amount: summary.netCashflow,
                          icon: summary.netCashflow.isNegative
                              ? Icons.trending_down_rounded
                              : Icons.trending_up_rounded,
                          color: summary.netCashflow.isNegative
                              ? AppColors.expense
                              : AppColors.income,
                          subtitle: summary.netCashflow.isNegative
                              ? 'Deficit'
                              : 'Surplus',
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Savings Rate',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  Icon(
                                    Icons.savings_outlined,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.space8),
                              Text(
                                '${summary.savingsRatePercent}%',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: summary.savingsRatePercent >= 20
                                      ? AppColors.income
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                summary.savingsRatePercent >= 20
                                    ? 'Healthy Savings'
                                    : 'Build More Buffer',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error loading cashflow: $err'),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Budget Utilization Card
          _buildBudgetUtilizationCard(
            context,
            ref,
            budgetAsync.value,
            budgetUtilization,
          ),
          const SizedBox(height: AppDimensions.space16),

          // Responsive Charts Layout: Side-by-side on desktop/web (width >= 720), stacked on mobile
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;

              final pieWidget = expenseBreakdownAsync.when(
                data: (breakdown) => ExpensePieChart(breakdown: breakdown),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading expense breakdown: $err'),
              );

              final barWidget = monthlyTrendAsync.when(
                data: (trend) => IncomeExpenseBarChart(trendItems: trend),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading monthly trend: $err'),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: pieWidget),
                    const SizedBox(width: AppDimensions.space16),
                    Expanded(child: barWidget),
                  ],
                );
              }

              return Column(
                children: [
                  pieWidget,
                  const SizedBox(height: AppDimensions.space16),
                  barWidget,
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.space16),

          // Recent Activity Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/transactions'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),

          recentTransactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 36,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          Text(
                            'No transactions recorded yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: transactions
                    .map(
                      (tx) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.space8,
                        ),
                        child: TransactionListTile(transaction: tx),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading transactions: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBalanceCard(
    BuildContext context,
    FinancialScope scope,
    Money balance,
    int accountsCount,
  ) {
    final theme = Theme.of(context);
    final isHousehold = scope.isHousehold;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHousehold
              ? [const Color(0xFF004D40), const Color(0xFF00796B)]
              : [const Color(0xFF1E293B), const Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimensions.borderRadiusLarge,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isHousehold
                      ? 'TOTAL HOUSEHOLD NET BALANCE'
                      : 'TOTAL PERSONAL NET WORTH',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Icon(
                scope.icon,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          MoneyDisplay(
            amount: balance,
            textStyle: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Row(
            children: [
              Icon(
                Icons.account_balance_outlined,
                size: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              const SizedBox(width: AppDimensions.space4),
              Expanded(
                child: Text(
                  '$accountsCount Active Accounts (Liquid Assets - Debt)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required Money amount,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimensions.space4),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          MoneyDisplay(
            amount: amount,
            textStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetUtilizationCard(
    BuildContext context,
    WidgetRef ref,
    BudgetItem? budget,
    OverallBudgetUtilization utilization,
  ) {
    final theme = Theme.of(context);
    final activeSpace = ref.watch(activeFinancialSpaceProvider);

    if (budget == null) {
      return AppCard(
        backgroundColor: activeSpace.scope.color.withValues(alpha: 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Monthly Budget Set',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Set spending limits to monitor budget utilization in real-time.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () => SetBudgetDialog.show(context),
              child: const Text('Set Budget'),
            ),
          ],
        ),
      );
    }

    final isOver = utilization.isOverspent;
    final ratio = utilization.utilizationRatio.clamp(0.0, 1.0);
    final progressColor = isOver
        ? AppColors.expense
        : (utilization.utilizationRatio >= 0.85
              ? AppColors.warning
              : AppColors.income);

    return InkWell(
      onTap: () => context.go('/budgets'),
      borderRadius: AppDimensions.borderRadiusLarge,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Budget Utilization',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: progressColor.withValues(alpha: 0.15),
                    borderRadius: AppDimensions.borderRadiusPill,
                  ),
                  child: Text(
                    isOver
                        ? 'Overspent!'
                        : '${(utilization.utilizationRatio * 100).toInt()}% Used',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            ClipRRect(
              borderRadius: AppDimensions.borderRadiusPill,
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Spent: ${utilization.totalSpent.formatted}',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    'Limit: ${utilization.totalLimit.formatted}',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
