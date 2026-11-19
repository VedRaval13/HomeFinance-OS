import 'package:drift/drift.dart';

import 'open_connection_stub.dart'
    if (dart.library.ffi) 'open_connection_native.dart'
    if (dart.library.js_interop) 'open_connection_web.dart' as impl;

/// Opens a platform-appropriate database connection.
///
/// On Native (Android, iOS, Windows, macOS, Linux): Uses SQLite via FFI with WAL mode.
/// On Web (Chrome, Edge): Uses SQLite compiled to WebAssembly (WasmDatabase).
LazyDatabase openDatabaseConnection({
  bool inMemory = false,
  String dbName = 'home_finance_os.sqlite',
}) {
  return impl.openDatabaseConnection(
    inMemory: inMemory,
    dbName: dbName,
  );
}
