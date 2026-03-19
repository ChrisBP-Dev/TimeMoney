import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Persists a new [TimeEntry] through the repository layer.
///
/// Returns an `Either` with the saved entity or a `GlobalFailure`.
class CreateTimeUseCase {
  /// Creates the use case backed by the given [repository].
  CreateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  /// Executes the use case, persisting the provided [time] entry.
  CreateTimeResult call(TimeEntry time) async {
    final result = await _repository.create(time);

    return result;
  }
}
