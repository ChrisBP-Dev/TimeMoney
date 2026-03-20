import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/models/times_table.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Drift-backed implementation of [TimesRepository].
///
/// Each method delegates to [TimesDriftDatasource], maps between
/// [TimesTableData] rows and [TimeEntry] domain entities, and wraps results
/// in [Either] to surface [GlobalFailure] on errors.
class DriftTimesRepository implements TimesRepository {
  /// Creates the repository with the given drift datasource.
  const DriftTimesRepository(this._datasource);
  final TimesDriftDatasource _datasource;

  @override
  FetchTimesResultStream fetchTimesStream() {
    try {
      final stream = _datasource
          .watchAll()
          .map(
            (rows) => rows.map((row) => row.toTimeEntry).toList(),
          )
          .handleError((Object error, StackTrace stack) {
        Error.throwWithStackTrace(
          GlobalFailure.fromException(error, stack),
          stack,
        );
      });
      return right(stream);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  CreateTimeResult create(TimeEntry time) async {
    try {
      final id =
          await _datasource.insert(hour: time.hour, minutes: time.minutes);
      return right(time.copyWith(id: id));
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  DeleteTimeResult delete(TimeEntry time) async {
    try {
      final deletedRows = await _datasource.remove(time.id);
      if (deletedRows == 0) {
        return left(
          GlobalFailure.fromException(Exception('Time entry not found')),
        );
      }
      return right(unit);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateTimeResult update(TimeEntry time) async {
    try {
      final affectedRows = await _datasource.update(
        time.id,
        hour: time.hour,
        minutes: time.minutes,
      );
      if (affectedRows == 0) {
        return left(
          GlobalFailure.fromException(Exception('Time entry not found')),
        );
      }
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
