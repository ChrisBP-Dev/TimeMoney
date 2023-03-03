import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/features/times/domain/times_repository.dart';

class DeleteTimeUseCase {
  DeleteTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  DeleteTimeResult call(ModelTime time) async {
    final result = await _repository.delete(time);

    return result;
  }
}
