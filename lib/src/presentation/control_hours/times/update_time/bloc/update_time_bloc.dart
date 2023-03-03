import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/core/unions/action_state.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/shared/consts/consts.dart';

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
      emit(state.copyWith(currentState: const ActionState.loading()));

      await Consts.delayed;

      if (state.time == null) return _emitError(emit);

      final result = await _updateTimeUseCase.call(state.time!);

      emit(
        state.copyWith(
          currentState: result.fold(ActionState.error, ActionState.success),
        ),
      );

      await Consts.delayed;

      emit(state.copyWith(currentState: const ActionState.initial()));
    });
  }

  final UpdateTimeUseCase _updateTimeUseCase;

  FutureOr<void> _emitError(Emitter<UpdateTimeState> emit) async {
    emit(
      state.copyWith(
        currentState: const ActionState.error(
          GlobalFailure.internalError('invalid number'),
        ),
      ),
    );

    await Consts.delayed;

    emit(
      state.copyWith(
        currentState: const ActionState.initial(),
      ),
    );
  }
}
