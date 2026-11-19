import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens a WebAssembly-based SQLite connection for Flutter Web (Chrome, Edge, etc.).
LazyDatabase openDatabaseConnection({
  bool inMemory = false,
  String dbName = 'home_finance_os.sqlite',
}) {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: dbName,
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
