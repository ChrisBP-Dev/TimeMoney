import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_state.dart';

export 'delete_time_event.dart';
export 'delete_time_state.dart';

/// BLoC responsible for deleting an existing time entry.
///
/// Delegates removal to [DeleteTimeUseCase] and auto-resets to the
/// initial state after a brief feedback delay.
class DeleteTimeBloc extends Bloc<DeleteTimeEvent, DeleteTimeState> {
  /// Creates a [DeleteTimeBloc] with the given [useCase].
  DeleteTimeBloc(DeleteTimeUseCase useCase)
    : _deleteTimeUseCase = useCase,
      super(const DeleteTimeInitial()) {
    on<DeleteTimeRequested>(_onDelete);
  }

  final DeleteTimeUseCase _deleteTimeUseCase;

  Future<void> _onDelete(
    DeleteTimeRequested event,
    Emitter<DeleteTimeState> emit,
  ) async {
    emit(const DeleteTimeLoading());

    final result = await _deleteTimeUseCase.call(event.time);

    result.fold(
      (failure) => emit(DeleteTimeError(failure)),
      (_) => emit(const DeleteTimeSuccess()),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(const DeleteTimeInitial());
  }
}
