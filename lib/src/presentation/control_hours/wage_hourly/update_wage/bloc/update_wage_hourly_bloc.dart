// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/core/unions/action_state.dart';
import 'package:time_money/src/features/wage_hourly/aplication/update_wage_hourly_use_case.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/shared/consts/consts.dart';

part 'update_wage_hourly_event.dart';
part 'update_wage_hourly_state.dart';
part 'update_wage_hourly_bloc.freezed.dart';

class UpdateWageHourlyBloc extends Bloc<UpdateWageHourlyEvent, UpdateWageHourlyState> {
  UpdateWageHourlyBloc(UpdateWageHourlyUseCase useCase)
      : _updateWageHourlyUseCase = useCase,
        super(UpdateWageHourlyState.initial()) {
    on<_ChangeHourly>((event, emit) {
      final hourly = double.tryParse(event.value);

      if (hourly == null) return _emitError(emit);

      emit(
        state.copyWith(wageHourly: state.wageHourly.copyWith(value: hourly)),
      );
    });
    on<_Update>((event, emit) async {
      emit(state.copyWith(currentState: const ActionState.loading()));

      final result = await _updateWageHourlyUseCase.call(state.wageHourly);

      await Consts.delayed;

      result.fold(
        (l) => _emitError(emit),
        (wage) => emit(state.copyWith(wageHourly: wage)),
      );

      await Consts.delayed;

      emit(UpdateWageHourlyState.initial());
    });
  }

  final UpdateWageHourlyUseCase _updateWageHourlyUseCase;

  FutureOr<void> _emitError(Emitter<UpdateWageHourlyState> emit) async {
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
