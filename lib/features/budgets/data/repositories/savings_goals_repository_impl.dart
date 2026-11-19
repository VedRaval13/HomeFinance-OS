import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/savings_goal_item.dart';
import '../../domain/repositories/savings_goals_repository.dart';

/// Concrete Drift implementation of [SavingsGoalsRepository].
class SavingsGoalsRepositoryImpl implements SavingsGoalsRepository {
  final AppDatabase db;

  SavingsGoalsRepositoryImpl(this.db);

  @override
  Stream<List<SavingsGoalItem>> watchGoals({
    required FinancialScope scope,
    String? memberId,
  }) {
    return db.savingsGoalsDao
        .watchGoals(scope: scope.name, memberId: memberId)
        .map((entries) => entries.map(_mapToDomain).toList());
  }

  @override
  Future<List<SavingsGoalItem>> getGoals({
    required FinancialScope scope,
    String? memberId,
  }) async {
    final query = db.select(db.savingsGoalsTable)
      ..where((tbl) {
        final scopeMatch = tbl.scope.equals(scope.name);
        if (scope.isPersonal && memberId != null) {
          return scopeMatch & tbl.memberId.equals(memberId);
        }
        return scopeMatch;
      })
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.targetDate)]);

    final entries = await query.get();
    return entries.map(_mapToDomain).toList();
  }

  @override
  Future<SavingsGoalItem?> getGoalById(String id) async {
    final entry = await (db.select(
      db.savingsGoalsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return entry != null ? _mapToDomain(entry) : null;
  }

  @override
  Future<SavingsGoalItem> createGoal({
    required String name,
    required FinancialScope scope,
    String? memberId,
    required Money targetAmount,
    DateTime? targetDate,
    required String iconName,
    required String colorHex,
  }) async {
    final id = UuidUtil.generate();
    final now = DateTime.now();

    await db.savingsGoalsDao.insertGoal(
      SavingsGoalsTableCompanion.insert(
        id: id,
        name: name.trim(),
        scope: scope.name,
        memberId: Value(memberId),
        targetAmount: targetAmount,
        currentAmount: const Money.zero(),
        targetDate: Value(targetDate),
        iconName: Value(iconName),
        colorHex: Value(colorHex),
        status: const Value('inProgress'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return SavingsGoalItem(
      id: id,
      name: name.trim(),
      scope: scope,
      memberId: memberId,
      targetAmount: targetAmount,
      currentAmount: const Money.zero(),
      targetDate: targetDate,
      iconName: iconName,
      colorHex: colorHex,
      status: GoalStatus.inProgress,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> updateGoal(SavingsGoalItem goal) async {
    final now = DateTime.now();
    await (db.update(
      db.savingsGoalsTable,
    )..where((tbl) => tbl.id.equals(goal.id))).write(
      SavingsGoalsTableCompanion(
        name: Value(goal.name.trim()),
        targetAmount: Value(goal.targetAmount),
        targetDate: Value(goal.targetDate),
        iconName: Value(goal.iconName),
        colorHex: Value(goal.colorHex),
        status: Value(goal.status.name),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> contributeToGoal({
    required String goalId,
    required String accountId,
    required String memberId,
    required Money amount,
    DateTime? contributionDate,
    String? notes,
  }) async {
    final contributionId = UuidUtil.generate();

    await db.savingsGoalsDao.contributeToGoal(
      contributionId: contributionId,
      goalId: goalId,
      accountId: accountId,
      memberId: memberId,
      amount: amount,
      contributionDate: contributionDate ?? DateTime.now(),
      notes: notes,
    );
  }

  SavingsGoalItem _mapToDomain(SavingsGoalEntry entry) {
    return SavingsGoalItem(
      id: entry.id,
      name: entry.name,
      scope: entry.scope == 'household'
          ? FinancialScope.household
          : FinancialScope.personal,
      memberId: entry.memberId,
      targetAmount: entry.targetAmount,
      currentAmount: entry.currentAmount,
      targetDate: entry.targetDate,
      iconName: entry.iconName,
      colorHex: entry.colorHex,
      status: GoalStatus.fromString(entry.status),
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}
