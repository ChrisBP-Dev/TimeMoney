import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class SetWageUseCase {
  SetWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  SetWageResult call() async {
    const defaultWageHourly = WageHourly();
    final result = await _repository.setWageHourly(defaultWageHourly);

    return result;
  }
}
