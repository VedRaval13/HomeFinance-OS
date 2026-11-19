import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/budget_category_allocation.dart';
import '../../domain/models/budget_item.dart';
import '../../domain/models/savings_goal_item.dart';
import '../providers/budgets_provider.dart';
import '../providers/savings_goals_provider.dart';
import '../widgets/contribute_goal_dialog.dart';
import '../widgets/create_savings_goal_dialog.dart';
import '../widgets/set_budget_dialog.dart';
import '../widgets/set_category_limit_dialog.dart';

/// Budgets & Savings Goals screen providing monthly spending caps, category allocations,
/// live spending utilization tracking, and savings milestones.
class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    final current = ref.read(selectedBudgetMonthProvider);
    ref.read(selectedBudgetMonthProvider.notifier).state = DateTime(
      current.year,
      current.month - 1,
      1,
    );
  }

  void _nextMonth() {
    final current = ref.read(selectedBudgetMonthProvider);
    ref.read(selectedBudgetMonthProvider.notifier).state = DateTime(
      current.year,
      current.month + 1,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final theme = Theme.of(context);
    final isHousehold = activeSpace.scope.isHousehold;
    final selectedMonth = ref.watch(selectedBudgetMonthProvider);
    final budgetAsync = ref.watch(activeBudgetStreamProvider);
    final overallUtilization = ref.watch(overallBudgetUtilizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHousehold
              ? 'Household Budgets & Goals'
              : 'Personal Budgets & Goals',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.pie_chart_outline_rounded),
              text: 'Category Budgets',
            ),
            Tab(icon: Icon(Icons.savings_outlined), text: 'Savings Goals'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Month Selector Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: 'Previous Month',
                  onPressed: _previousMonth,
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
                      ref.read(selectedBudgetMonthProvider.notifier).state =
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
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),

          // High-level Budget Progress Summary Card
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              AppDimensions.space12,
              AppDimensions.space16,
              AppDimensions.space8,
            ),
            child: budgetAsync.when(
              data: (budget) {
                if (budget == null) {
                  return AppCard(
                    backgroundColor: activeSpace.scope.color.withValues(
                      alpha: 0.05,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.space8,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 32,
                            color: activeSpace.scope.color,
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          Text(
                            'No budget configured for ${DateFormatters.formatMonthYear(selectedMonth)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space4),
                          Text(
                            'Set a monthly spending limit to keep family expenses on track.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          FilledButton.icon(
                            onPressed: () => SetBudgetDialog.show(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Set Monthly Budget'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Budget exists: Show full utilization metric
                final isOver = overallUtilization.isOverspent;
                final ratio = overallUtilization.utilizationRatio.clamp(
                  0.0,
                  1.0,
                );
                final progressColor = isOver
                    ? AppColors.expense
                    : (overallUtilization.utilizationRatio >= 0.85
                          ? AppColors.warning
                          : AppColors.income);

                return AppCard(
                  backgroundColor: activeSpace.scope.color.withValues(
                    alpha: 0.06,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                budget.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Monthly Cap: ${budget.totalLimit.formatted}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit Budget Limit',
                            onPressed: () => SetBudgetDialog.show(
                              context,
                              existingBudget: budget,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.space12),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: AppDimensions.borderRadiusPill,
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 10,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Spent: ${overallUtilization.totalSpent.formatted} (${(overallUtilization.utilizationRatio * 100).toInt()}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isOver ? AppColors.expense : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.space8),
                          if (isOver)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.expense.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: AppDimensions.borderRadiusSmall,
                                ),
                                child: Text(
                                  'Overspent by ${(overallUtilization.totalSpent - overallUtilization.totalLimit).formatted}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.expense,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            )
                          else
                            Flexible(
                              child: Text(
                                'Remaining: ${overallUtilization.remaining.formatted}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.income,
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
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error loading budget: $err'),
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryBudgetsTab(context, ref, budgetAsync.value),
                _buildSavingsGoalsTab(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBudgetsTab(
    BuildContext context,
    WidgetRef ref,
    BudgetItem? activeBudget,
  ) {
    final theme = Theme.of(context);

    if (activeBudget == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: AppDimensions.space12),
              Text(
                'Set a monthly budget first to allocate limits across spending categories.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final categoriesAsync = ref.watch(activeBudgetCategoriesStreamProvider);

    return categoriesAsync.when(
      data: (categories) {
        return ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category Allocations (${categories.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => SetCategoryLimitDialog.show(
                    context,
                    budgetId: activeBudget.id,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Limit'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),

            if (categories.isEmpty)
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 40,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: AppDimensions.space8),
                        Text(
                          'No category limits allocated yet',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          'Assign spending caps to categories (e.g. Groceries, Utilities, Shopping) to prevent overspending.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...categories.map(
                (allocation) => _buildCategoryAllocationTile(
                  context,
                  activeBudget,
                  allocation,
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildCategoryAllocationTile(
    BuildContext context,
    BudgetItem budget,
    BudgetCategoryAllocation allocation,
  ) {
    final theme = Theme.of(context);
    final ratio = allocation.utilizationRatio.clamp(0.0, 1.0);
    final progressColor = allocation.isOverspent
        ? AppColors.expense
        : (allocation.isNearLimit ? AppColors.warning : allocation.color);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space8),
      child: AppCard(
        onTap: () => SetCategoryLimitDialog.show(
          context,
          budgetId: budget.id,
          existingAllocation: allocation,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: allocation.color.withValues(alpha: 0.15),
                  child: Icon(
                    allocation.icon,
                    color: allocation.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allocation.categoryName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${allocation.spentAmount.formatted} of ${allocation.allocatedLimit.formatted}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: progressColor.withValues(alpha: 0.12),
                    borderRadius: AppDimensions.borderRadiusSmall,
                  ),
                  child: Text(
                    allocation.isOverspent
                        ? 'Overspent (${allocation.utilizationPercent}%)'
                        : '${allocation.utilizationPercent}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
            ClipRRect(
              borderRadius: AppDimensions.borderRadiusPill,
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                allocation.isOverspent
                    ? 'Over budget by ${(allocation.spentAmount - allocation.allocatedLimit).formatted}'
                    : '${allocation.remaining.formatted} remaining',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: allocation.isOverspent
                      ? AppColors.expense
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoalsTab(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return goalsAsync.when(
      data: (goals) {
        return ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Savings Goals (${goals.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => CreateSavingsGoalDialog.show(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Goal'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),

            if (goals.isEmpty)
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.savings_outlined,
                          size: 40,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: AppDimensions.space8),
                        Text(
                          'No savings goals created yet',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          'Define target goals like Emergency Fund, Vacation, or New Vehicle to build wealth intentionally.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        FilledButton.icon(
                          onPressed: () =>
                              CreateSavingsGoalDialog.show(context),
                          icon: const Icon(Icons.flag_outlined, size: 18),
                          label: const Text('Create First Goal'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...goals.map((goal) => _buildSavingsGoalCard(context, goal)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSavingsGoalCard(BuildContext context, SavingsGoalItem goal) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: goal.color.withValues(alpha: 0.15),
                  child: Icon(goal.icon, color: goal.color, size: 22),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (goal.targetDate != null)
                        Text(
                          'Target: ${DateFormatters.formatDayMonthYear(goal.targetDate!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: goal.isAchieved
                        ? AppColors.income.withValues(alpha: 0.15)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimensions.borderRadiusSmall,
                  ),
                  child: Text(
                    goal.isAchieved ? 'Achieved!' : goal.status.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: goal.isAchieved
                          ? AppColors.income
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit Goal',
                  onPressed: () =>
                      CreateSavingsGoalDialog.show(context, existingGoal: goal),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),

            // Progress Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MoneyDisplay(
                  amount: goal.currentAmount,
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: goal.color,
                  ),
                ),
                Text(
                  '${goal.progressPercent}% of ${goal.targetAmount.formatted}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
            ClipRRect(
              borderRadius: AppDimensions.borderRadiusPill,
              child: LinearProgressIndicator(
                value: goal.progressRatio,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(goal.color),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.isAchieved
                        ? 'Goal Complete!'
                        : '${goal.remaining.formatted} remaining',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: goal.isAchieved
                          ? AppColors.income
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (!goal.isAchieved) ...[
                  const SizedBox(width: AppDimensions.space8),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        ContributeGoalDialog.show(context, goal: goal),
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 16,
                    ),
                    label: const Text('Contribute'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
