import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Contract for wage persistence operations.
///
/// Implementations must handle fetching, creating, and updating
/// [WageHourly] records, returning [Either] results for error safety.
abstract class WageRepository {
  /// Returns a reactive stream of the current [WageHourly], or a failure.
  FetchWageResultStream fetchWageHourly();

  /// Persists a new [WageHourly] record and returns the saved entity.
  SetWageResult setWageHourly(WageHourly wageHourly);

  /// Updates an existing [WageHourly] record and returns the updated entity.
  UpdateWageResult update(WageHourly wageHourly);
}

/// Result type for [WageRepository.fetchWageHourly]: a synchronous [Either]
/// holding either a [GlobalFailure] or a reactive [Stream] of [WageHourly].
typedef FetchWageResultStream
    = Either<GlobalFailure, Stream<WageHourly>>;

/// Result type for [WageRepository.setWageHourly]: an async [Either]
/// holding either a [GlobalFailure] or the persisted [WageHourly].
typedef SetWageResult = Future<Either<GlobalFailure, WageHourly>>;

/// Result type for [WageRepository.update]: an async [Either]
/// holding either a [GlobalFailure] or the updated [WageHourly].
typedef UpdateWageResult = Future<Either<GlobalFailure, WageHourly>>;
