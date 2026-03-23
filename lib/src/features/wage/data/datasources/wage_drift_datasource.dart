import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';

/// Raw drift operations for wage entries.
///
/// Works exclusively with [WageHourlyTableData] and
/// [WageHourlyTableCompanion] DB models -- domain entity mapping is the
/// responsibility of the repository layer.
class WageDriftDatasource {
  /// Creates a datasource backed by the given [AppDatabase].
  const WageDriftDatasource(this._db);
  final AppDatabase _db;

  /// Watches all wage rows, emitting immediately and on every change.
  Stream<List<WageHourlyTableData>> watchAll() {
    return _db.select(_db.wageHourlyTable).watch();
  }

  /// Inserts a new wage record and returns its assigned id.
  Future<int> insert({required double value}) {
    return _db
        .into(_db.wageHourlyTable)
        .insert(
          WageHourlyTableCompanion.insert(value: value),
        );
  }

  /// Updates the wage record identified by [id] and returns the number of
  /// affected rows.
  Future<int> update(int id, {required double value}) {
    return (_db.update(
      _db.wageHourlyTable,
    )..where((t) => t.id.equals(id))).write(
      WageHourlyTableCompanion(value: Value(value)),
    );
  }
}
