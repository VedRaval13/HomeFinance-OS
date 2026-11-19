import 'package:drift/drift.dart';

/// Device metadata table storing hardware installation instance info.
@DataClassName('DeviceInfoEntry')
class DeviceInfoTable extends Table {
  @override
  String get tableName => 'device_info';

  TextColumn get id => text()(); // UUID
  TextColumn get deviceModel => text().withLength(min: 1, max: 120)();
  TextColumn get osVersion => text().withLength(min: 1, max: 80)();
  TextColumn get appVersion => text().withLength(min: 1, max: 40)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
