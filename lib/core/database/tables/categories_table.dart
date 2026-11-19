import 'package:drift/drift.dart';

/// Categories and subcategories table.
@DataClassName('CategoryEntry')
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get iconName => text().withLength(min: 1, max: 80)();
  TextColumn get colorHex => text().withLength(min: 7, max: 9)();
  TextColumn get type =>
      text().withLength(min: 1, max: 20)(); // 'income' or 'expense'
  TextColumn get scope => text().withLength(
    min: 1,
    max: 20,
  )(); // 'household', 'personal', or 'both'
  TextColumn get parentId => text().nullable().references(
    CategoriesTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
