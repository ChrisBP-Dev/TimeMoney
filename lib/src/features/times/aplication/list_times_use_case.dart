import 'package:time_money/src/features/times/domain/times_repository.dart';

class ListTimesUseCase {
  ListTimesUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  FetchTimesResultStream call() {
    final result = _repository.fetchTimesStream();

    return result;
  }
}
