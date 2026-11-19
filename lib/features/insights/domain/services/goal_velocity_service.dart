import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../budgets/domain/models/savings_goal_item.dart';
import '../models/financial_insight.dart';
import '../models/goal_velocity_metric.dart';

/// Statistical intelligence service that projects savings goal completion dates and detects pacing bottlenecks.
class GoalVelocityService {
  const GoalVelocityService();

  /// Analyzes active savings goals to produce actionable completion and velocity insights.
  List<FinancialInsight> analyzeGoalVelocities({
    required List<SavingsGoalItem> goals,
    DateTime? referenceDate,
  }) {
    if (goals.isEmpty) return [];

    final now = referenceDate ?? DateTime.now();
    final activeGoals = goals
        .where((g) =>
            g.status != GoalStatus.achieved &&
            g.status != GoalStatus.cancelled &&
            !g.isAchieved &&
            g.targetAmount > const Money.zero())
        .toList();

    if (activeGoals.isEmpty) return [];

    final insights = <FinancialInsight>[];

    for (final goal in activeGoals) {
      final metric = _computeMetric(goal, now);
      final insight = _generateInsight(metric, now);
      if (insight != null) {
        insights.add(insight);
      }
    }

    // Sort insights: Critical (overdue) first, then Warnings (behind pace), then Success (ahead/near finish)
    insights.sort((a, b) {
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

    // Return top 2 most impactful goal insights to avoid card clutter
    return insights.take(2).toList();
  }

  GoalVelocityMetric _computeMetric(SavingsGoalItem goal, DateTime now) {
    // 1. Time elapsed since goal creation
    final daysElapsed = now.difference(goal.createdAt).inDays.clamp(1, 3650);
    final monthsElapsed = daysElapsed / 30.4375;

    // 2. Current monthly velocity in integer paise
    final accumulatedPaise = goal.currentAmount.paise;
    final monthlyPacePaise =
        monthsElapsed >= 0.5 ? (accumulatedPaise ~/ monthsElapsed).clamp(0, 999999999) : 0;
    final currentMonthlyPace = Money.fromPaise(monthlyPacePaise);

    // 3. Projected completion ETA based on current velocity
    final remainingPaise = goal.remaining.paise;
    DateTime? projectedDate;
    if (monthlyPacePaise > 0) {
      final monthsToTarget = remainingPaise / monthlyPacePaise;
      final daysToTarget = (monthsToTarget * 30.4375).toInt().clamp(1, 36500);
      projectedDate = now.add(Duration(days: daysToTarget));
    }

    // 4. Required monthly pace (if target date exists)
    Money? requiredPace;
    int? monthsDiff;
    bool isOverdue = false;
    bool isBehind = false;
    bool isAhead = false;

    if (goal.targetDate != null) {
      final daysUntilTarget = goal.targetDate!.difference(now).inDays;

      if (daysUntilTarget <= 0) {
        isOverdue = true;
      } else {
        final monthsRemaining = (daysUntilTarget / 30.4375).clamp(0.2, 120.0);
        final reqPaise = (remainingPaise / monthsRemaining).toInt();
        requiredPace = Money.fromPaise(reqPaise);

        if (projectedDate != null) {
          final diffDays = goal.targetDate!.difference(projectedDate).inDays;
          monthsDiff = diffDays ~/ 30; // positive = early, negative = delayed

          if (monthsDiff >= 1) {
            isAhead = true;
          } else if (monthsDiff <= -1 || currentMonthlyPace.paise < reqPaise * 0.75) {
            isBehind = true;
          }
        } else {
          // Zero pace but deadline is approaching
          isBehind = true;
        }
      }
    }

    // 5. Stalled status: no contributions in last 45+ days and still 0 progress
    final daysSinceUpdate = now.difference(goal.updatedAt).inDays;
    final isStalled = daysSinceUpdate >= 45 &&
        goal.currentAmount.isZero &&
        daysElapsed >= 45;

    // 6. Near completion (>= 90%)
    final isNearCompletion = goal.progressPercent >= 90;

    return GoalVelocityMetric(
      goal: goal,
      currentMonthlyPace: currentMonthlyPace,
      requiredMonthlyPace: requiredPace,
      projectedCompletionDate: projectedDate,
      monthsDifferenceWithTarget: monthsDiff,
      isAheadOfSchedule: isAhead,
      isBehindSchedule: isBehind,
      isOverdue: isOverdue,
      isStalled: isStalled,
      isNearCompletion: isNearCompletion,
    );
  }

  FinancialInsight? _generateInsight(GoalVelocityMetric m, DateTime now) {
    final goal = m.goal;

    // 1. Almost Complete Milestone (>= 90%)
    if (m.isNearCompletion) {
      return FinancialInsight(
        id: 'goal_near_finish_${goal.id}',
        type: InsightType.goalVelocity,
        severity: InsightSeverity.success,
        title: '${goal.name} Almost Complete!',
        message:
            'You are at ${goal.progressPercent}% of your goal! Only ${goal.remaining.formatted} remaining to fully reach your milestone.',
        metricBadge: '${goal.remaining.formatted} to finish',
        actionLabel: 'Complete Goal',
        actionRoute: '/budgets',
        createdAt: now,
      );
    }

    // 2. Overdue Target Date
    if (m.isOverdue && goal.targetDate != null) {
      return FinancialInsight(
        id: 'goal_overdue_${goal.id}',
        type: InsightType.goalVelocity,
        severity: InsightSeverity.critical,
        title: '${goal.name} Target Overdue',
        message:
            'The target date was ${DateFormatters.formatMonthYear(goal.targetDate!)}. Still needs ${goal.remaining.formatted} to achieve completion.',
        metricBadge: '${goal.remaining.formatted} remaining',
        actionLabel: 'Contribute Now',
        actionRoute: '/budgets',
        createdAt: now,
      );
    }

    // 3. Behind Pace Alert
    if (m.isBehindSchedule && m.requiredMonthlyPace != null && goal.targetDate != null) {
      final currentPaceStr = m.currentMonthlyPace.isZero
          ? '₹0/mo'
          : '${m.currentMonthlyPace.formatted}/mo';

      return FinancialInsight(
        id: 'goal_behind_${goal.id}',
        type: InsightType.goalVelocity,
        severity: InsightSeverity.warning,
        title: '${goal.name} Behind Schedule',
        message:
            'To achieve ${goal.name} by ${DateFormatters.formatMonthYear(goal.targetDate!)}, increase monthly savings to ${m.requiredMonthlyPace!.formatted}/mo (currently $currentPaceStr).',
        metricBadge: '${m.requiredMonthlyPace!.formatted}/mo needed',
        actionLabel: 'Boost Savings',
        actionRoute: '/budgets',
        createdAt: now,
      );
    }

    // 4. Ahead of Schedule Milestone
    if (m.isAheadOfSchedule && m.projectedCompletionDate != null) {
      final monthsAhead = m.monthsDifferenceWithTarget ?? 1;
      return FinancialInsight(
        id: 'goal_ahead_${goal.id}',
        type: InsightType.goalVelocity,
        severity: InsightSeverity.success,
        title: '${goal.name} Ahead of Schedule',
        message:
            'At your current pace of ${m.currentMonthlyPace.formatted}/mo, you are on track to achieve ${goal.name} ~$monthsAhead month(s) ahead of your target date!',
        metricBadge: 'ETA: ${DateFormatters.formatMonthYear(m.projectedCompletionDate!)}',
        actionLabel: 'View Goal',
        actionRoute: '/budgets',
        createdAt: now,
      );
    }

    // 5. Stalled Goal Alert
    if (m.isStalled) {
      return FinancialInsight(
        id: 'goal_stalled_${goal.id}',
        type: InsightType.goalVelocity,
        severity: InsightSeverity.info,
        title: 'Restart ${goal.name}',
        message:
            'No contributions have been logged for ${goal.name} in over 45 days. Depositing a small amount today will get your momentum back.',
        metricBadge: 'Zero activity 45+ days',
        actionLabel: 'Contribute',
        actionRoute: '/budgets',
        createdAt: now,
      );
    }

    return null;
  }
}
