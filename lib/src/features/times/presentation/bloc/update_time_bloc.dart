import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_state.dart';

export 'update_time_event.dart';
export 'update_time_state.dart';

/// BLoC responsible for updating an existing time entry.
///
/// Initialized with a time entry to edit, manages form field changes,
/// validates input, and delegates persistence to the update use case.
class UpdateTimeBloc extends Bloc<UpdateTimeEvent, UpdateTimeState> {
  /// Creates an [UpdateTimeBloc] with the given [useCase].
  UpdateTimeBloc(UpdateTimeUseCase useCase)
    : _updateTimeUseCase = useCase,
      super(const UpdateTimeInitial()) {
    on<UpdateTimeInit>(_onInit);
    on<UpdateTimeHourChanged>(_onHourChanged);
    on<UpdateTimeMinutesChanged>(_onMinutesChanged);
    on<UpdateTimeSubmitted>(_onSubmitted);
  }

  final UpdateTimeUseCase _updateTimeUseCase;

  void _onInit(UpdateTimeInit event, Emitter<UpdateTimeState> emit) {
    emit(
      UpdateTimeInitial(
        time: event.time,
        hour: event.time.hour,
        minutes: event.time.minutes,
      ),
    );
  }

  Future<void> _onHourChanged(
    UpdateTimeHourChanged event,
    Emitter<UpdateTimeState> emit,
  ) async {
    final hour = int.tryParse(event.value);
    if (hour == null) return _emitError(emit);
    emit(
      UpdateTimeInitial(
        hour: hour,
        minutes: state.minutes,
        time: state.time?.copyWith(hour: hour),
      ),
    );
  }

  Future<void> _onMinutesChanged(
    UpdateTimeMinutesChanged event,
    Emitter<UpdateTimeState> emit,
  ) async {
    final minutes = int.tryParse(event.value);
    if (minutes == null) return _emitError(emit);
    emit(
      UpdateTimeInitial(
        hour: state.hour,
        minutes: minutes,
        time: state.time?.copyWith(minutes: minutes),
      ),
    );
  }

  Future<void> _onSubmitted(
    UpdateTimeSubmitted event,
    Emitter<UpdateTimeState> emit,
  ) async {
    final hour = state.hour;
    final minutes = state.minutes;
    final time = state.time;

    emit(UpdateTimeLoading(hour: hour, minutes: minutes, time: time));

    if (time == null) return _emitError(emit);

    final result = await _updateTimeUseCase.call(time);

    result.fold(
      (failure) => emit(
        UpdateTimeError(failure, hour: hour, minutes: minutes, time: time),
      ),
      (timeEntry) => emit(
        UpdateTimeSuccess(timeEntry, hour: hour, minutes: minutes, time: time),
      ),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(UpdateTimeInitial(hour: hour, minutes: minutes, time: time));
  }

  Future<void> _emitError(Emitter<UpdateTimeState> emit) async {
    final hour = state.hour;
    final minutes = state.minutes;
    final time = state.time;
    emit(
      UpdateTimeError(
        const InternalError('invalid number'),
        hour: hour,
        minutes: minutes,
        time: time,
      ),
    );
    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(UpdateTimeInitial(hour: hour, minutes: minutes, time: time));
  }
}
