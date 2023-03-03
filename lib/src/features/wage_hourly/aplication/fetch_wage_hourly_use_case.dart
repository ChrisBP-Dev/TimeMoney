import 'package:time_money/src/features/wage_hourly/domain/wage_hourly_repository.dart';

class FetchWageHourlyUseCase {
  FetchWageHourlyUseCase(
    WageHourlyRepository repository,
  ) : _repository = repository;

  final WageHourlyRepository _repository;

  FetchTimesResultStream call() => _repository.fetchWageHourly();
}
