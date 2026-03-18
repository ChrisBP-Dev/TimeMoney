import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

abstract class TimesRepository {
  FetchTimesResultStream fetchTimesStream();
  CreateTimeResult create(TimeEntry time);
  DeleteTimeResult delete(TimeEntry time);
  UpdateTimeResult update(TimeEntry time);
}

typedef FetchTimesResultStream
    = Either<GlobalFailure, Stream<List<TimeEntry>>>;
typedef CreateTimeResult = Future<Either<GlobalFailure, TimeEntry>>;
typedef DeleteTimeResult = Future<Either<GlobalFailure, Unit>>;
typedef UpdateTimeResult = Future<Either<GlobalFailure, TimeEntry>>;
