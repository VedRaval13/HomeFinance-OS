import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/features/budgets/domain/models/budget_category_allocation.dart';
import 'package:home_finance_os/features/budgets/domain/models/budget_item.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/services/budget_pacing_service.dart';

void main() {
  const service = BudgetPacingService();

  test('Module 1: Budget pacing flags over-burn when spending exceeds expected pace', () {
    final refDate = DateTime(2026, 3, 10); // Day 10 of 31 days (~32% elapsed)
    final budget = BudgetItem(
      id: 'b1',
      name: 'March Budget',
      totalLimit: const Money.fromPaise(3000000), // ₹30,000 limit
      month: 3,
      year: 2026,
      scope: FinancialScope.household,
      createdAt: refDate,
    );

    // Day 10, spent ₹20,000 out of ₹30,000 (66.7% spent, pace is 206%!)
    final categories = <BudgetCategoryAllocation>[
      const BudgetCategoryAllocation(
        id: 'c1',
        budgetId: 'b1',
        categoryId: 'cat_groceries',
        categoryName: 'Groceries',
        categoryIcon: 'shopping_cart',
        categoryColorHex: '#4CAF50',
        allocatedLimit: Money.fromPaise(3000000),
        spentAmount: Money.fromPaise(2000000),
      ),
    ];

    final insights = service.analyzeBudgetPacing(
      budget: budget,
      categories: categories,
      referenceDate: refDate,
    );

    expect(insights.isNotEmpty, isTrue);
    final warning = insights.firstWhere((i) => i.severity == InsightSeverity.warning);
    expect(warning.title, contains('Overall Budget Pacing Fast'));
    expect(warning.message, contains('₹2,000.00/day'));
  });

  test('Module 1: Budget pacing confirms healthy pace when well under budget', () {
    final refDate = DateTime(2026, 3, 20); // Day 20 of 31 days (~64% elapsed)
    final budget = BudgetItem(
      id: 'b1',
      name: 'March Budget',
      totalLimit: const Money.fromPaise(3000000), // ₹30,000 limit
      month: 3,
      year: 2026,
      scope: FinancialScope.household,
      createdAt: refDate,
    );

    // Day 20, spent only ₹10,000 out of ₹30,000 (33% spent, very healthy)
    final categories = <BudgetCategoryAllocation>[
      const BudgetCategoryAllocation(
        id: 'c1',
        budgetId: 'b1',
        categoryId: 'cat_groceries',
        categoryName: 'Groceries',
        categoryIcon: 'shopping_cart',
        categoryColorHex: '#4CAF50',
        allocatedLimit: Money.fromPaise(3000000),
        spentAmount: Money.fromPaise(1000000),
      ),
    ];

    final insights = service.analyzeBudgetPacing(
      budget: budget,
      categories: categories,
      referenceDate: refDate,
    );

    expect(insights.isNotEmpty, isTrue);
    final healthy = insights.firstWhere((i) => i.severity == InsightSeverity.success);
    expect(healthy.title, contains('Healthy Budget Pace'));
  });
}
