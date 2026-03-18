import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';

part 'update_wage_event.dart';
part 'update_wage_state.dart';
part 'update_wage_bloc.freezed.dart';

class UpdateWageBloc extends Bloc<UpdateWageEvent, UpdateWageState> {
  UpdateWageBloc(UpdateWageUseCase useCase)
      : _updateWageUseCase = useCase,
        super(UpdateWageState.initial()) {
    on<_ChangeHourly>((event, emit) {
      final hourly = double.tryParse(event.value);

      if (hourly == null) return _emitError(emit);

      emit(
        state.copyWith(wageHourly: state.wageHourly.copyWith(value: hourly)),
      );
    });
    on<_Update>((event, emit) async {
      emit(state.copyWith(currentState: const ActionLoading()));

      final result = await _updateWageUseCase.call(state.wageHourly);

      await Future<void>.delayed(AppDurations.actionFeedback);

      result.fold(
        (l) => _emitError(emit),
        (wage) => emit(state.copyWith(wageHourly: wage)),
      );

      await Future<void>.delayed(AppDurations.actionFeedback);

      emit(UpdateWageState.initial());
    });
  }

  final UpdateWageUseCase _updateWageUseCase;

  FutureOr<void> _emitError(Emitter<UpdateWageState> emit) async {
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
