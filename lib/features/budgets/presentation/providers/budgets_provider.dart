import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/money.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../data/repositories/budgets_repository_impl.dart';
import '../../domain/models/budget_category_allocation.dart';
import '../../domain/models/budget_item.dart';
import '../../domain/repositories/budgets_repository.dart';

/// Provider for [BudgetsRepository].
final budgetsRepositoryProvider = Provider<BudgetsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetsRepositoryImpl(db);
});

/// Selected month and year for budget view.
final selectedBudgetMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Watches the active budget for currently selected scope, member, and month.
final activeBudgetStreamProvider = StreamProvider<BudgetItem?>((ref) {
  final repo = ref.watch(budgetsRepositoryProvider);
  final activeSpace = ref.watch(activeFinancialSpaceProvider);
  final monthDate = ref.watch(selectedBudgetMonthProvider);

  return repo.watchBudget(
    scope: activeSpace.scope,
    month: monthDate.month,
    year: monthDate.year,
    memberId: activeSpace.scope.isPersonal ? activeSpace.activeMemberId : null,
  );
});

/// Watches category allocations and live spending for the active budget.
final activeBudgetCategoriesStreamProvider =
    StreamProvider<List<BudgetCategoryAllocation>>((ref) {
      final repo = ref.watch(budgetsRepositoryProvider);
      final budgetAsync = ref.watch(activeBudgetStreamProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);
      final monthDate = ref.watch(selectedBudgetMonthProvider);

      final budget = budgetAsync.value;
      if (budget == null) return Stream.value([]);

      return repo.watchBudgetCategories(
        budgetId: budget.id,
        month: monthDate.month,
        year: monthDate.year,
        scope: activeSpace.scope,
        memberId: activeSpace.scope.isPersonal
            ? activeSpace.activeMemberId
            : null,
      );
    });

/// Overall budget utilization calculation model.
class OverallBudgetUtilization {
  final Money totalLimit;
  final Money totalSpent;
  final Money remaining;
  final double utilizationRatio;
  final bool isOverspent;

  const OverallBudgetUtilization({
    required this.totalLimit,
    required this.totalSpent,
    required this.remaining,
    required this.utilizationRatio,
    required this.isOverspent,
  });

  static const zero = OverallBudgetUtilization(
    totalLimit: Money.zero(),
    totalSpent: Money.zero(),
    remaining: Money.zero(),
    utilizationRatio: 0.0,
    isOverspent: false,
  );
}

/// Computes overall utilization of the active monthly budget.
final overallBudgetUtilizationProvider = Provider<OverallBudgetUtilization>((
  ref,
) {
  final budget = ref.watch(activeBudgetStreamProvider).value;
  final categoriesAsync = ref.watch(activeBudgetCategoriesStreamProvider);

  if (budget == null) return OverallBudgetUtilization.zero;

  return categoriesAsync.when(
    data: (categories) {
      Money totalSpent = const Money.zero();
      for (final cat in categories) {
        totalSpent = totalSpent + cat.spentAmount;
      }

      final limit = budget.totalLimit;
      final remaining = limit - totalSpent;
      final ratio = limit.isZero ? 0.0 : (totalSpent.paise / limit.paise);

      return OverallBudgetUtilization(
        totalLimit: limit,
        totalSpent: totalSpent,
        remaining: remaining,
        utilizationRatio: ratio,
        isOverspent: totalSpent > limit,
      );
    },
    loading: () => OverallBudgetUtilization.zero,
    error: (_, _) => OverallBudgetUtilization.zero,
  );
});
