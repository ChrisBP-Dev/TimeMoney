import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Replaces an existing [TimeEntry] with updated values.
///
/// Returns the updated entity or a `GlobalFailure` on error.
class UpdateTimeUseCase {
  /// Creates the use case backed by the given [repository].
  UpdateTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  /// Executes the use case, updating the provided [time] entry in the store.
  UpdateTimeResult call(TimeEntry time) async {
    final result = await _repository.update(time);

    return result;
  }
}
