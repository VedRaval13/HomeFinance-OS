import 'package:drift/drift.dart';

import '../../models/money.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/goal_contributions_table.dart';
import '../tables/savings_goals_table.dart';

part 'savings_goals_dao.g.dart';

@DriftAccessor(
  tables: [SavingsGoalsTable, GoalContributionsTable, AccountsTable],
)
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  Stream<List<SavingsGoalEntry>> watchGoals({
    required String scope,
    String? memberId,
  }) {
    return (select(savingsGoalsTable)
          ..where((tbl) {
            final scopeMatch = tbl.scope.equals(scope);
            if (scope == 'personal' && memberId != null) {
              return scopeMatch & tbl.memberId.equals(memberId);
            }
            return scopeMatch;
          })
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.targetDate)]))
        .watch();
  }

  Future<int> insertGoal(SavingsGoalsTableCompanion entry) {
    return into(savingsGoalsTable).insert(entry);
  }

  /// Contributes funds from an account to a savings goal atomically.
  Future<void> contributeToGoal({
    required String contributionId,
    required String goalId,
    required String accountId,
    required String memberId,
    required Money amount,
    required DateTime contributionDate,
    String? notes,
  }) {
    return transaction(() async {
      final goal = await (select(
        savingsGoalsTable,
      )..where((tbl) => tbl.id.equals(goalId))).getSingleOrNull();
      if (goal == null) throw StateError('Goal $goalId not found');

      final account = await (select(
        accountsTable,
      )..where((tbl) => tbl.id.equals(accountId))).getSingleOrNull();
      if (account == null) throw StateError('Account $accountId not found');

      // Deduct from account
      final newAccountBalance = account.currentBalance - amount;
      await (update(
        accountsTable,
      )..where((tbl) => tbl.id.equals(accountId))).write(
        AccountsTableCompanion(
          currentBalance: Value(newAccountBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Add to goal progress
      final newGoalAmount = goal.currentAmount + amount;
      final isAchieved = newGoalAmount >= goal.targetAmount;
      await (update(
        savingsGoalsTable,
      )..where((tbl) => tbl.id.equals(goalId))).write(
        SavingsGoalsTableCompanion(
          currentAmount: Value(newGoalAmount),
          status: Value(isAchieved ? 'achieved' : goal.status),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Insert contribution audit
      await into(goalContributionsTable).insert(
        GoalContributionsTableCompanion.insert(
          id: contributionId,
          goalId: goalId,
          accountId: accountId,
          memberId: memberId,
          amount: amount,
          contributionDate: contributionDate,
          notes: Value(notes),
        ),
      );
    });
  }
}
