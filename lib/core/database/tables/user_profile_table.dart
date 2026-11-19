import 'package:drift/drift.dart';

/// Primary user / administrator profile table.
@DataClassName('UserProfileEntry')
class UserProfileTable extends Table {
  @override
  String get tableName => 'user_profile';

  TextColumn get id => text()(); // UUID
  TextColumn get displayName => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().nullable().withLength(max: 120)();
  TextColumn get primaryCurrency =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('INR'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
