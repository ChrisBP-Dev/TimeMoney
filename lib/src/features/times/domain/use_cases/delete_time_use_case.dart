import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

class DeleteTimeUseCase {
  DeleteTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  DeleteTimeResult call(TimeEntry time) async {
    final result = await _repository.delete(time);

    return result;
  }
}
