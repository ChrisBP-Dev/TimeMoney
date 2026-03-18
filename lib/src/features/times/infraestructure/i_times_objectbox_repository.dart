import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/features/times/domain/times_repository.dart';
import 'package:time_money/src/features/times/infraestructure/timebox.dart';

class ITimesObjectboxRepository implements TimesRepository {
  ITimesObjectboxRepository(ObjectBox objectbox) : _objectbox = objectbox;

  final ObjectBox _objectbox;

  @override
  CreateTimeResult create(ModelTime time) async {
    try {
      _objectbox.time.put(time.toTimeBox);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  DeleteTimeResult delete(ModelTime time) async {
    try {
      _objectbox.time.remove(time.id);
      return right(unit);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateTimeResult update(ModelTime time) async {
    try {
      _objectbox.time.put(time.toTimeBox);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  FetchTimesResultStream fetchTimesStream() {
    try {
      return right(_objectbox.getTimesStream());
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
