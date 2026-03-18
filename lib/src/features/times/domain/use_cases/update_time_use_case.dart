import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

class UpdateTimeUseCase {
  UpdateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  UpdateTimeResult call(TimeEntry time) async {
    final result = await _repository.update(time);

    return result;
  }
}
