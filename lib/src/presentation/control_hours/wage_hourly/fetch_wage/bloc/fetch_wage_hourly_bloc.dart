// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/features/wage_hourly/aplication/fetch_wage_hourly_use_case.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';

part 'fetch_wage_hourly_event.dart';
part 'fetch_wage_hourly_state.dart';
part 'fetch_wage_hourly_bloc.freezed.dart';

class FetchWageHourlyBloc extends Bloc<FetchWageHourlyEvent, FetchWageHourlyState> {
  FetchWageHourlyBloc(FetchWageHourlyUseCase useCase)
      : _fetchWageUseCase = useCase,
        super(const _Initial()) {
    on<_GetWage>((event, emit) async {
      // emit(const FetchWageHourlyState.loading());

      // await Consts.delayed;

      final result = _fetchWageUseCase.call();

      emit(
        result.fold(
          FetchWageHourlyState.error,
          FetchWageHourlyState.hasDataStream,
        ),
      );
    });
  }
  final FetchWageHourlyUseCase _fetchWageUseCase;
}
