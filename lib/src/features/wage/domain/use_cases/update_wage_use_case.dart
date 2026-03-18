import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class UpdateWageUseCase {
  UpdateWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  UpdateWageResult call(WageHourly wageHourly) async {
    final result = await _repository.update(wageHourly);

    return result;
  }
}
