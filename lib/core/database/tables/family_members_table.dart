import 'package:drift/drift.dart';

/// Family member profiles table.
@DataClassName('FamilyMemberEntry')
class FamilyMembersTable extends Table {
  @override
  String get tableName => 'family_members';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get role => text().withLength(
    min: 1,
    max: 60,
  )(); // Admin, Partner, Child, Parent, etc.
  TextColumn get avatarPath => text().nullable()();
  TextColumn get colorHex => text()
      .withLength(min: 7, max: 9)
      .withDefault(const Constant('#00796B'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
