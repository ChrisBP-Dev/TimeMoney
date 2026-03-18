import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class FetchWageUseCase {
  FetchWageUseCase(
    WageRepository repository,
  ) : _repository = repository;

  final WageRepository _repository;

  FetchWageResultStream call() => _repository.fetchWageHourly();
}
