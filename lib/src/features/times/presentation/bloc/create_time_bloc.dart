import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';

part 'create_time_event.dart';
part 'create_time_state.dart';
part 'create_time_bloc.freezed.dart';

class CreateTimeBloc extends Bloc<CreateTimeEvent, CreateTimeState> {
  CreateTimeBloc(CreateTimeUseCase useCase)
      : _createTimeUseCase = useCase,
        super(CreateTimeState.initial()) {
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
      emit(state.copyWith(currentState: const ActionLoading()));

      await Future<void>.delayed(AppDurations.actionFeedback);

      if (state.minutes == 0 && state.hour == 0) return _emitError(emit);

      final time = TimeEntry(hour: state.hour, minutes: state.minutes);

      final result = await _createTimeUseCase.call(time);

      emit(
        state.copyWith(
          currentState: result.fold(ActionError.new, ActionSuccess.new),
        ),
      );

      await Future<void>.delayed(AppDurations.actionFeedback);

      emit(CreateTimeState.initial());
    });
  }

  FutureOr<void> _emitError(Emitter<CreateTimeState> emit) async {
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

  final CreateTimeUseCase _createTimeUseCase;
}
