import 'package:drift/drift.dart';

/// Fallback stub for platforms without SQLite support.
LazyDatabase openDatabaseConnection({
  bool inMemory = false,
  String dbName = 'home_finance_os.sqlite',
}) {
  throw UnsupportedError(
    'Cannot open database connection: Platform not supported.',
  );
}
