import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Retrieves a reactive stream of all tracked time entries.
///
/// Delegates to [TimesRepository.fetchTimesStream] and returns
/// an `Either` containing the stream or a `GlobalFailure`.
class ListTimesUseCase {
  /// Creates the use case backed by the given [repository].
  ListTimesUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  /// Executes the use case, returning a stream of time-entry lists.
  FetchTimesResultStream call() {
    final result = _repository.fetchTimesStream();

    return result;
  }
}
