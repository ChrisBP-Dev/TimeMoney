import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/features/times/domain/times_repository.dart';

class UpdateTimeUseCase {
  UpdateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  UpdateTimeResult call(ModelTime time) async {
    final result = await _repository.update(time);

    return result;
  }
}
