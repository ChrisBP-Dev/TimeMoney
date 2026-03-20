import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_table.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Drift-backed implementation of [WageRepository].
///
/// Each method delegates to [WageDriftDatasource], maps between
/// [WageHourlyTableData] rows and [WageHourly] domain entities, and wraps
/// results in [Either] to surface [GlobalFailure] on errors.
class DriftWageRepository implements WageRepository {
  /// Creates the repository with the given drift datasource.
  const DriftWageRepository(this._datasource);
  final WageDriftDatasource _datasource;

  @override
  FetchWageResultStream fetchWageHourly() {
    try {
      final stream = _datasource.watchAll().map(
            (rows) {
              final wages = rows.map((row) => row.toWageHourly).toList();
              return wages.isEmpty ? const WageHourly() : wages.last;
            },
          );
      return right(stream);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  SetWageResult setWageHourly(WageHourly wageHourly) async {
    try {
      await _datasource.insert(value: wageHourly.value);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateWageResult update(WageHourly wageHourly) async {
    try {
      await _datasource.update(wageHourly.id, value: wageHourly.value);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
