import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/features/times/domain/times_repository.dart';

class CreateTimeUseCase {
  CreateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  CreateTimeResult call(ModelTime time) async {
    final result = await _repository.create(time);

    return result;
  }
}
