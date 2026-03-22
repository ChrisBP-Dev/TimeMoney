import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Contract for time-entry persistence operations.
///
/// All methods return [Either] to signal success or [GlobalFailure].
abstract class TimesRepository {
  /// Returns a reactive stream of all persisted [TimeEntry] instances.
  FetchTimesResultStream fetchTimesStream();

  /// Persists a new [TimeEntry] and returns the stored entity.
  CreateTimeResult create(TimeEntry time);

  /// Removes the given [TimeEntry] from the store.
  DeleteTimeResult delete(TimeEntry time);

  /// Replaces the existing [TimeEntry] with the updated values.
  UpdateTimeResult update(TimeEntry time);
}

/// Result type for [TimesRepository.fetchTimesStream].
typedef FetchTimesResultStream = Either<GlobalFailure, Stream<List<TimeEntry>>>;

/// Result type for [TimesRepository.create].
typedef CreateTimeResult = Future<Either<GlobalFailure, TimeEntry>>;

/// Result type for [TimesRepository.delete].
typedef DeleteTimeResult = Future<Either<GlobalFailure, Unit>>;

/// Result type for [TimesRepository.update].
typedef UpdateTimeResult = Future<Either<GlobalFailure, TimeEntry>>;
