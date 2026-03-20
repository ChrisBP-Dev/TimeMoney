import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';

/// Raw drift operations for time entries.
///
/// Works exclusively with [TimesTableData] and [TimesTableCompanion]
/// DB models -- domain entity mapping is the responsibility of the
/// repository layer.
class TimesDriftDatasource {
  /// Creates a datasource backed by the given [AppDatabase].
  const TimesDriftDatasource(this._db);
  final AppDatabase _db;

  /// Watches all time entry rows, emitting immediately and on every change.
  Stream<List<TimesTableData>> watchAll() {
    return _db.select(_db.timesTable).watch();
  }

  /// Inserts a new time entry and returns its assigned id.
  Future<int> insert({required int hour, required int minutes}) {
    return _db.into(_db.timesTable).insert(
          TimesTableCompanion.insert(hour: hour, minutes: minutes),
        );
  }

  /// Updates the time entry identified by [id].
  Future<void> update(int id, {required int hour, required int minutes}) {
    return (_db.update(_db.timesTable)..where((t) => t.id.equals(id))).write(
          TimesTableCompanion(hour: Value(hour), minutes: Value(minutes)),
        );
  }

  /// Removes the row identified by [id]; returns the number of deleted rows.
  Future<int> remove(int id) {
    return (_db.delete(_db.timesTable)..where((t) => t.id.equals(id))).go();
  }
}
