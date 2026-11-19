import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../models/budget_category_allocation.dart';
import '../models/budget_item.dart';

/// Abstract contract for Budget operations.
abstract class BudgetsRepository {
  /// Watches the monthly budget for the given scope, month, year, and optional member.
  Stream<BudgetItem?> watchBudget({
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
  });

  /// Gets the monthly budget once.
  Future<BudgetItem?> getBudget({
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
  });

  /// Sets or updates the overall monthly budget.
  Future<BudgetItem> setBudget({
    required String name,
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
    required Money totalLimit,
  });

  /// Watches category allocations and computes live spending for each category within the budget month.
  Stream<List<BudgetCategoryAllocation>> watchBudgetCategories({
    required String budgetId,
    required int month,
    required int year,
    required FinancialScope scope,
    String? memberId,
  });

  /// Sets or updates spending limit for a specific category within a budget.
  Future<void> setCategoryLimit({
    required String budgetId,
    required String categoryId,
    required Money allocatedLimit,
  });

  /// Removes a category limit allocation from a budget.
  Future<void> removeCategoryLimit({
    required String budgetId,
    required String categoryId,
  });
}
