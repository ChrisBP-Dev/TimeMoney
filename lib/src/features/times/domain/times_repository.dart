import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';

abstract class TimesRepository {
  FetchTimesResultStream fetchTimesStream();
  CreateTimeResult create(ModelTime time);
  DeleteTimeResult delete(ModelTime time);
  UpdateTimeResult update(ModelTime time);
}

typedef FetchTimesResultStream
    = Either<GlobalFailure<dynamic>, Stream<List<ModelTime>>>;
typedef CreateTimeResult = Future<Either<GlobalFailure<dynamic>, ModelTime>>;
typedef DeleteTimeResult = Future<Either<GlobalFailure<dynamic>, Unit>>;
typedef UpdateTimeResult = Future<Either<GlobalFailure<dynamic>, ModelTime>>;
