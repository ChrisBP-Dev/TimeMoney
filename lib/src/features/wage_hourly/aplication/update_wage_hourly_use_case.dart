import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly_repository.dart';

class UpdateWageHourlyUseCase {
  UpdateWageHourlyUseCase(
    WageHourlyRepository repository,
  ) : _repository = repository;

  final WageHourlyRepository _repository;

  UpdateWageHourlyResult call(WageHourly wageHourly) async {
    final result = await _repository.update(wageHourly);

    return result;
  }
}
