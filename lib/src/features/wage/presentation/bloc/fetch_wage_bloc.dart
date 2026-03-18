import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';

part 'fetch_wage_event.dart';
part 'fetch_wage_state.dart';
part 'fetch_wage_bloc.freezed.dart';

class FetchWageBloc extends Bloc<FetchWageEvent, FetchWageState> {
  FetchWageBloc(FetchWageUseCase useCase)
      : _fetchWageUseCase = useCase,
        super(const _Initial()) {
    on<_GetWage>((event, emit) async {
      // emit(const FetchWageState.loading());

      // await Consts.delayed;

      final result = _fetchWageUseCase.call();

      emit(
        result.fold(
          FetchWageState.error,
          FetchWageState.hasDataStream,
        ),
      );
    });
  }
  final FetchWageUseCase _fetchWageUseCase;
}
