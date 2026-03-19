import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Persists the default [WageHourly] when no wage record exists yet.
///
/// Creates a [WageHourly] with default values and delegates persistence
/// to [WageRepository.setWageHourly].
class SetWageUseCase {
  /// Creates a [SetWageUseCase] backed by the given [repository].
  SetWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  /// Executes the use case, persisting a default wage and returning the result.
  SetWageResult call() async {
    const defaultWageHourly = WageHourly();
    final result = await _repository.setWageHourly(defaultWageHourly);

    return result;
  }
}
