import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'accounts_table.dart';
import 'family_members_table.dart';
import 'savings_goals_table.dart';

/// Goal contributions table recording fund allocations towards savings goals.
@DataClassName('GoalContributionEntry')
class GoalContributionsTable extends Table {
  @override
  String get tableName => 'goal_contributions';

  TextColumn get id => text()(); // UUID
  TextColumn get goalId =>
      text().references(SavingsGoalsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get accountId =>
      text().references(AccountsTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get memberId => text().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.restrict,
  )();

  // Stored strictly in integer paise
  IntColumn get amount => integer().map(const MoneyConverter())();

  DateTimeColumn get contributionDate => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
