import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_state.dart';

export 'create_time_event.dart';
export 'create_time_state.dart';

/// BLoC responsible for creating a new time entry.
///
/// Manages form field changes for hour and minutes, validates input,
/// delegates persistence to [CreateTimeUseCase], and auto-resets
/// the form after a successful creation.
class CreateTimeBloc extends Bloc<CreateTimeEvent, CreateTimeState> {
  /// Creates a [CreateTimeBloc] with the given [useCase].
  CreateTimeBloc(CreateTimeUseCase useCase)
    : _createTimeUseCase = useCase,
      super(const CreateTimeInitial()) {
    on<CreateTimeHourChanged>(_onHourChanged);
    on<CreateTimeMinutesChanged>(_onMinutesChanged);
    on<CreateTimeSubmitted>(_onSubmitted);
    on<CreateTimeReset>(_onReset);
  }

  final CreateTimeUseCase _createTimeUseCase;

  FutureOr<void> _onHourChanged(
    CreateTimeHourChanged event,
    Emitter<CreateTimeState> emit,
  ) {
    final hour = int.tryParse(event.value);
    if (hour == null) return _emitError(emit);
    emit(CreateTimeInitial(hour: hour, minutes: state.minutes));
  }

  FutureOr<void> _onMinutesChanged(
    CreateTimeMinutesChanged event,
    Emitter<CreateTimeState> emit,
  ) {
    final minutes = int.tryParse(event.value);
    if (minutes == null) return _emitError(emit);
    emit(CreateTimeInitial(hour: state.hour, minutes: minutes));
  }

  Future<void> _onSubmitted(
    CreateTimeSubmitted event,
    Emitter<CreateTimeState> emit,
  ) async {
    final hour = state.hour;
    final minutes = state.minutes;

    emit(CreateTimeLoading(hour: hour, minutes: minutes));
    await Future<void>.delayed(AppDurations.actionFeedback);

    if (minutes == 0 && hour == 0) return _emitError(emit);

    final time = TimeEntry(hour: hour, minutes: minutes);
    final result = await _createTimeUseCase.call(time);

    result.fold(
      (failure) => emit(CreateTimeError(failure, hour: hour, minutes: minutes)),
      (timeEntry) =>
          emit(CreateTimeSuccess(timeEntry, hour: hour, minutes: minutes)),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);
    // Success: clear form. Use-case error: restore values so user can retry.
    emit(
      state is CreateTimeSuccess
          ? const CreateTimeInitial()
          : CreateTimeInitial(hour: hour, minutes: minutes),
    );
  }

  void _onReset(CreateTimeReset event, Emitter<CreateTimeState> emit) {
    emit(const CreateTimeInitial());
  }

  FutureOr<void> _emitError(Emitter<CreateTimeState> emit) async {
    final hour = state.hour;
    final minutes = state.minutes;
    emit(
      CreateTimeError(
        const InternalError('invalid number'),
        hour: hour,
        minutes: minutes,
      ),
    );
    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(CreateTimeInitial(hour: hour, minutes: minutes));
  }
}
