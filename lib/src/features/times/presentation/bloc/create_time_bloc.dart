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

class CreateTimeBloc extends Bloc<CreateTimeEvent, CreateTimeState> {
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
    emit(CreateTimeLoading(hour: state.hour, minutes: state.minutes));
    await Future<void>.delayed(AppDurations.actionFeedback);

    if (state.minutes == 0 && state.hour == 0) return _emitError(emit);

    final time = TimeEntry(hour: state.hour, minutes: state.minutes);
    final result = await _createTimeUseCase.call(time);

    result.fold(
      (failure) => emit(
        CreateTimeError(failure, hour: state.hour, minutes: state.minutes),
      ),
      (timeEntry) => emit(
        CreateTimeSuccess(timeEntry, hour: state.hour, minutes: state.minutes),
      ),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(const CreateTimeInitial());
  }

  void _onReset(CreateTimeReset event, Emitter<CreateTimeState> emit) {
    emit(const CreateTimeInitial());
  }

  FutureOr<void> _emitError(Emitter<CreateTimeState> emit) async {
    emit(
      CreateTimeError(
        const InternalError('invalid number'),
        hour: state.hour,
        minutes: state.minutes,
      ),
    );
    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(CreateTimeInitial(hour: state.hour, minutes: state.minutes));
  }
}
