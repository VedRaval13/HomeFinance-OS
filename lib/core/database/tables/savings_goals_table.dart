import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'family_members_table.dart';

/// Savings goals table (Household emergency funds, vacation funds, personal targets).
@DataClassName('SavingsGoalEntry')
class SavingsGoalsTable extends Table {
  @override
  String get tableName => 'savings_goals';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get scope =>
      text().withLength(min: 1, max: 20)(); // 'household' or 'personal'
  TextColumn get memberId => text().nullable().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.cascade,
  )();

  // Stored strictly in integer paise
  IntColumn get targetAmount => integer().map(const MoneyConverter())();
  IntColumn get currentAmount => integer().map(const MoneyConverter())();

  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get iconName => text()
      .withLength(min: 1, max: 80)
      .withDefault(const Constant('savings'))();
  TextColumn get colorHex => text()
      .withLength(min: 7, max: 9)
      .withDefault(const Constant('#16A34A'))();
  TextColumn get status => text()
      .withLength(min: 1, max: 30)
      .withDefault(
        const Constant('inProgress'),
      )(); // inProgress, achieved, paused, cancelled
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
