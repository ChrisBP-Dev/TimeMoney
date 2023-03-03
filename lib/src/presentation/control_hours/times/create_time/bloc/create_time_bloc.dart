import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/core/unions/action_state.dart';
import 'package:time_money/src/features/times/aplication/create_time_use_case.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/shared/consts/consts.dart';

part 'create_time_event.dart';
part 'create_time_state.dart';
part 'create_time_bloc.freezed.dart';

class CreateTimeBloc extends Bloc<CreateTimeEvent, CreateTimeState> {
  CreateTimeBloc(CreateTimeUseCase useCase)
      : _createTimeUseCase = useCase,
        super(CreateTimeState.initial()) {
    // hourController = TextEditingController();
    // minutesController = TextEditingController();

    on<_ChangeHour>((event, emit) {
      final hour = int.tryParse(event.value);
      if (hour == null) return _emitError(emit);
      emit(state.copyWith(hour: hour));
    });
    on<_ChangeMinutes>((event, emit) {
      final minutes = int.tryParse(event.value);
      if (minutes == null) return _emitError(emit);
      emit(state.copyWith(minutes: minutes));
    });

    on<_Create>((event, emit) async {
      emit(state.copyWith(currentState: const ActionState.loading()));

      await Consts.delayed;

      if (state.minutes == 0 && state.hour == 0) return _emitError(emit);

      final time = ModelTime(hour: state.hour, minutes: state.minutes);

      final result = await _createTimeUseCase.call(time);

      emit(
        state.copyWith(
          currentState: result.fold(ActionState.error, ActionState.success),
        ),
      );

      await Consts.delayed;

      emit(CreateTimeState.initial());
    });
  }

  FutureOr<void> _emitError(Emitter<CreateTimeState> emit) async {
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

  final CreateTimeUseCase _createTimeUseCase;
}
