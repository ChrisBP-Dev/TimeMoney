import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Removes an existing [TimeEntry] from the persistence store.
///
/// Returns `Unit` on success or a `GlobalFailure` on error.
class DeleteTimeUseCase {
  /// Creates the use case backed by the given [repository].
  DeleteTimeUseCase(TimesRepository repository) : _repository = repository;

  final TimesRepository _repository;

  /// Executes the use case, deleting the provided [time] entry.
  DeleteTimeResult call(TimeEntry time) async {
    final result = await _repository.delete(time);

    return result;
  }
}
