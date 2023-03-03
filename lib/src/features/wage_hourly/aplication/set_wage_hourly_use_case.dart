import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly_repository.dart';

class SetWageHourlyUseCase {
  SetWageHourlyUseCase(
    WageHourlyRepository repository,
  ) : _repository = repository;

  final WageHourlyRepository _repository;

  SetWageHourlyResult call() async {
    const defaultWageHourly = WageHourly(value: 15);
    final result = await _repository.setWageHourly(defaultWageHourly);

    return result;
  }
}
