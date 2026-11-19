import 'package:drift/drift.dart';

/// Key-Value application settings and preferences table.
@DataClassName('AppSettingEntry')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text().withLength(min: 1, max: 80)();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
