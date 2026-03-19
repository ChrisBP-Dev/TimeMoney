import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// ObjectBox-backed implementation of [TimesRepository].
///
/// Each method delegates to [TimesObjectboxDatasource], maps between
/// [TimeBox] models and [TimeEntry] domain entities, and wraps results
/// in [Either] to surface [GlobalFailure] on errors.
class ObjectboxTimesRepository implements TimesRepository {
  /// Creates the repository with the given ObjectBox datasource.
  const ObjectboxTimesRepository(this._datasource);
  final TimesObjectboxDatasource _datasource;

  @override
  FetchTimesResultStream fetchTimesStream() {
    try {
      final stream = _datasource.watchAll().map(
            (boxes) => boxes.map((box) => box.toTimeEntry).toList(),
          );
      return right(stream);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  CreateTimeResult create(TimeEntry time) async {
    try {
      _datasource.put(time.toTimeBox);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  DeleteTimeResult delete(TimeEntry time) async {
    try {
      _datasource.remove(time.id);
      return right(unit);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateTimeResult update(TimeEntry time) async {
    try {
      _datasource.put(time.toTimeBox);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
