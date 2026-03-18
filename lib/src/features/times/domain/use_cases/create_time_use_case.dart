import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

class CreateTimeUseCase {
  CreateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  CreateTimeResult call(TimeEntry time) async {
    final result = await _repository.create(time);

    return result;
  }
}
