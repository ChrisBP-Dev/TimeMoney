import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';

part 'update_time_event.dart';
part 'update_time_state.dart';
part 'update_time_bloc.freezed.dart';

class UpdateTimeBloc extends Bloc<UpdateTimeEvent, UpdateTimeState> {
  UpdateTimeBloc(UpdateTimeUseCase useCase)
      : _updateTimeUseCase = useCase,
        super(UpdateTimeState.initial()) {
    on<_Init>((event, emit) => emit(UpdateTimeState(time: event.time)));
    on<_ChangeHour>((event, emit) {
      final hour = int.tryParse(event.value);
      if (hour == null) return _emitError(emit);
      emit(state.copyWith(time: state.time?.copyWith(hour: hour)));
    });
    on<_ChangeMinutes>((event, emit) {
      final minutes = int.tryParse(event.value);
      if (minutes == null) return _emitError(emit);
      emit(state.copyWith(time: state.time?.copyWith(minutes: minutes)));
    });
    on<_Update>((event, emit) async {
      emit(state.copyWith(currentState: const ActionLoading()));

      await Future<void>.delayed(AppDurations.actionFeedback);

      if (state.time == null) return _emitError(emit);

      final result = await _updateTimeUseCase.call(state.time!);

      emit(
        state.copyWith(
          currentState: result.fold(ActionError.new, ActionSuccess.new),
        ),
      );

      await Future<void>.delayed(AppDurations.actionFeedback);

      emit(state.copyWith(currentState: const ActionInitial()));
    });
  }

  final UpdateTimeUseCase _updateTimeUseCase;

  FutureOr<void> _emitError(Emitter<UpdateTimeState> emit) async {
    emit(
      state.copyWith(
        currentState: const ActionError(
          InternalError('invalid number'),
        ),
      ),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);

    emit(
      state.copyWith(
        currentState: const ActionInitial(),
      ),
    );
  }
}
