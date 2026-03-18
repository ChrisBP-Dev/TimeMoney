import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

abstract class WageRepository {
  FetchWageResultStream fetchWageHourly();
  SetWageResult setWageHourly(WageHourly wageHourly);
  UpdateWageResult update(WageHourly wageHourly);
}

typedef FetchWageResultStream
    = Either<GlobalFailure, Stream<WageHourly>>;
typedef SetWageResult = Future<Either<GlobalFailure, WageHourly>>;
typedef UpdateWageResult = Future<Either<GlobalFailure, WageHourly>>;
