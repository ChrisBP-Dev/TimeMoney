import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// ObjectBox-backed implementation of [WageRepository].
///
/// Translates between [WageHourly] domain entities and
/// [WageHourlyBox] data models via [WageObjectboxDatasource].
class ObjectboxWageRepository implements WageRepository {
  /// Creates the repository with the given ObjectBox [_datasource].
  const ObjectboxWageRepository(this._datasource);
  final WageObjectboxDatasource _datasource;

  @override
  FetchWageResultStream fetchWageHourly() {
    try {
      final stream = _datasource.watchAll().map(
            (boxes) {
              final wages = boxes.map((box) => box.toWageHourly).toList();
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
      _datasource.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateWageResult update(WageHourly wageHourly) async {
    try {
      _datasource.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
