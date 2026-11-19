import '../../../../core/models/money.dart';
import '../../../budgets/domain/models/savings_goal_item.dart';

/// Performance and velocity metrics for a savings goal milestone.
class GoalVelocityMetric {
  final SavingsGoalItem goal;
  final Money currentMonthlyPace;
  final Money? requiredMonthlyPace;
  final DateTime? projectedCompletionDate;
  final int? monthsDifferenceWithTarget; // Positive = early, negative = delayed
  final bool isAheadOfSchedule;
  final bool isBehindSchedule;
  final bool isOverdue;
  final bool isStalled;
  final bool isNearCompletion; // >= 90%

  const GoalVelocityMetric({
    required this.goal,
    required this.currentMonthlyPace,
    this.requiredMonthlyPace,
    this.projectedCompletionDate,
    this.monthsDifferenceWithTarget,
    required this.isAheadOfSchedule,
    required this.isBehindSchedule,
    required this.isOverdue,
    required this.isStalled,
    required this.isNearCompletion,
  });
}
