import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'family_members_table.dart';

/// Budgets table storing monthly allocations per scope and member.
@DataClassName('BudgetEntry')
class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get scope =>
      text().withLength(min: 1, max: 20)(); // 'household' or 'personal'
  TextColumn get memberId => text().nullable().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get month => integer()(); // 1 - 12
  IntColumn get year => integer()(); // e.g. 2026

  // Stored strictly in integer paise
  IntColumn get totalLimit => integer().map(const MoneyConverter())();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {scope, memberId, month, year},
  ];
}
