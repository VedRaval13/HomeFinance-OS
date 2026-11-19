import 'package:drift/drift.dart';

import 'family_members_table.dart';

/// Financial spaces table (Household space vs Personal member spaces).
@DataClassName('FinancialSpaceEntry')
class FinancialSpacesTable extends Table {
  @override
  String get tableName => 'financial_spaces';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get scope =>
      text().withLength(min: 1, max: 20)(); // 'household' or 'personal'
  TextColumn get memberId => text().nullable().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
