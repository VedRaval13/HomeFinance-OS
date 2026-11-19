import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/features/budgets/domain/models/savings_goal_item.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/services/goal_velocity_service.dart';

void main() {
  const service = GoalVelocityService();

  test('Module 3: Goal velocity detects near-finish milestone (>= 90%)', () {
    final now = DateTime(2026, 3, 20);
    final goal = SavingsGoalItem(
      id: 'g1',
      name: 'MacBook M3 Fund',
      iconName: 'laptop',
      colorHex: '#2196F3',
      targetAmount: const Money.fromPaise(15000000), // ₹1,50,000
      currentAmount: const Money.fromPaise(14000000), // ₹1,40,000 (93.3%)
      targetDate: DateTime(2026, 6, 1),
      status: GoalStatus.inProgress,
      scope: FinancialScope.household,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: now,
    );

    final insights = service.analyzeGoalVelocities(
      goals: [goal],
      referenceDate: now,
    );

    expect(insights.isNotEmpty, isTrue);
    final milestone = insights.firstWhere((i) => i.id == 'goal_near_finish_g1');
    expect(milestone.severity, InsightSeverity.success);
    expect(milestone.title, contains('Almost Complete'));
    expect(milestone.metricBadge, '₹10,000.00 to finish');
  });

  test('Module 3: Goal velocity detects overdue deadline', () {
    final now = DateTime(2026, 3, 20);
    final goal = SavingsGoalItem(
      id: 'g2',
      name: 'Tax Savings',
      iconName: 'receipt_long',
      colorHex: '#FF9800',
      targetAmount: const Money.fromPaise(5000000), // ₹50,000
      currentAmount: const Money.fromPaise(3000000), // ₹30,000
      targetDate: DateTime(2026, 3, 1), // Past deadline!
      status: GoalStatus.inProgress,
      scope: FinancialScope.household,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: now,
    );

    final insights = service.analyzeGoalVelocities(
      goals: [goal],
      referenceDate: now,
    );

    expect(insights.isNotEmpty, isTrue);
    final overdue = insights.firstWhere((i) => i.id == 'goal_overdue_g2');
    expect(overdue.severity, InsightSeverity.critical);
    expect(overdue.title, contains('Target Overdue'));
  });
}
