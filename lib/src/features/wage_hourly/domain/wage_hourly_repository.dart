// ignore_for_file: lines_longer_than_80_chars

import 'package:dartz/dartz.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';

abstract class WageHourlyRepository {
  FetchTimesResultStream fetchWageHourly();
  SetWageHourlyResult setWageHourly(WageHourly wageHourly);
  UpdateWageHourlyResult update(WageHourly wageHourly);
}

typedef FetchTimesResultStream
    = Either<GlobalDefaultFailure, Stream<WageHourly>>;
typedef SetWageHourlyResult = Future<Either<GlobalDefaultFailure, WageHourly>>;
typedef UpdateWageHourlyResult
    = Future<Either<GlobalDefaultFailure, WageHourly>>;
