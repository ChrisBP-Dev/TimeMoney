import 'package:dartz/dartz.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/core/services/objectbox.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly_repository.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/wage_hourly_box.dart';

class IWageHourlyObjectboxRepository extends WageHourlyRepository {
  IWageHourlyObjectboxRepository(ObjectBox objectbox) : _objectbox = objectbox;

  final ObjectBox _objectbox;
  @override
  FetchTimesResultStream fetchWageHourly() {
    try {
      return right(_objectbox.getWageHourlyStream());
    } catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  SetWageHourlyResult setWageHourly(WageHourly wageHourly) async {
    try {
      _objectbox.wageHourly.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateWageHourlyResult update(WageHourly wageHourly) async {
    try {
      _objectbox.wageHourly.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
