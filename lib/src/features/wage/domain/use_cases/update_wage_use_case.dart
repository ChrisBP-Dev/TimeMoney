import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Updates an existing [WageHourly] record with new values.
///
/// Delegates to [WageRepository.update] and returns the updated entity
/// or a failure.
class UpdateWageUseCase {
  /// Creates an [UpdateWageUseCase] backed by the given [repository].
  UpdateWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  /// Executes the use case, updating the given [wageHourly] and returning
  /// the result.
  UpdateWageResult call(WageHourly wageHourly) async {
    final result = await _repository.update(wageHourly);

    return result;
  }
}
