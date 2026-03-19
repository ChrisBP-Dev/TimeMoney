import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Retrieves the current hourly wage as a reactive stream.
///
/// Delegates to [WageRepository.fetchWageHourly] and returns a
/// [FetchWageResultStream] containing either a failure or the stream.
class FetchWageUseCase {
  /// Creates a [FetchWageUseCase] backed by the given [repository].
  FetchWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  /// Executes the use case, returning the wage stream or a failure.
  FetchWageResultStream call() => _repository.fetchWageHourly();
}
