import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:time_money/src/features/times/data/models/times_table.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_table.dart';

part 'app_database.g.dart';

/// Central drift database for the web platform.
///
/// Aggregates [TimesTable] and [WageHourlyTable] into a single SQLite
/// database. On web, uses WASM + OPFS for persistence. On native platforms,
/// uses the file system (though ObjectBox is the primary native datasource).
@DriftDatabase(tables: [TimesTable, WageHourlyTable])
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the provided [QueryExecutor].
  ///
  /// Use [AppDatabase.named] to obtain a platform-aware executor.
  AppDatabase(super.e);

  /// Creates an [AppDatabase] with a named, platform-aware connection.
  ///
  /// [dbName] is the environment-specific database name
  /// (`test-1`, `stg-1`, or `prod-1`).
  AppDatabase.named(String dbName) : super(_openConnection(dbName));

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection(String name) {
  return driftDatabase(
    name: name,
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
