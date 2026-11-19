import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens a native platform SQLite connection with WAL mode and foreign key enforcement.
LazyDatabase openDatabaseConnection({
  bool inMemory = false,
  String dbName = 'home_finance_os.sqlite',
}) {
  return LazyDatabase(() async {
    if (inMemory) {
      return NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      );
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        // Enforce foreign key constraints
        rawDb.execute('PRAGMA foreign_keys = ON;');
        // Enable Write-Ahead Logging (WAL) for high concurrency & reliability
        rawDb.execute('PRAGMA journal_mode = WAL;');
        rawDb.execute('PRAGMA synchronous = NORMAL;');
      },
    );
  });
}
