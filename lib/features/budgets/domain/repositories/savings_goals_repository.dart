import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../models/savings_goal_item.dart';

/// Abstract contract for Savings Goals operations.
abstract class SavingsGoalsRepository {
  /// Watches savings goals for the specified scope and optional member.
  Stream<List<SavingsGoalItem>> watchGoals({
    required FinancialScope scope,
    String? memberId,
  });

  /// Gets savings goals once.
  Future<List<SavingsGoalItem>> getGoals({
    required FinancialScope scope,
    String? memberId,
  });

  /// Gets a specific savings goal by ID.
  Future<SavingsGoalItem?> getGoalById(String id);

  /// Creates a new savings goal.
  Future<SavingsGoalItem> createGoal({
    required String name,
    required FinancialScope scope,
    String? memberId,
    required Money targetAmount,
    DateTime? targetDate,
    required String iconName,
    required String colorHex,
  });

  /// Updates an existing savings goal.
  Future<void> updateGoal(SavingsGoalItem goal);

  /// Contributes funds atomically from an account to a savings goal:
  /// Debits account balance, credits goal's current amount, and records audit entry.
  Future<void> contributeToGoal({
    required String goalId,
    required String accountId,
    required String memberId,
    required Money amount,
    DateTime? contributionDate,
    String? notes,
  });
}
