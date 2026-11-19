// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goals_dao.dart';

// ignore_for_file: type=lint
mixin _$SavingsGoalsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  $SavingsGoalsTableTable get savingsGoalsTable =>
      attachedDatabase.savingsGoalsTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  $GoalContributionsTableTable get goalContributionsTable =>
      attachedDatabase.goalContributionsTable;
  SavingsGoalsDaoManager get managers => SavingsGoalsDaoManager(this);
}

class SavingsGoalsDaoManager {
  final _$SavingsGoalsDaoMixin _db;
  SavingsGoalsDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
  $$SavingsGoalsTableTableTableManager get savingsGoalsTable =>
      $$SavingsGoalsTableTableTableManager(
        _db.attachedDatabase,
        _db.savingsGoalsTable,
      );
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
  $$GoalContributionsTableTableTableManager get goalContributionsTable =>
      $$GoalContributionsTableTableTableManager(
        _db.attachedDatabase,
        _db.goalContributionsTable,
      );
}
