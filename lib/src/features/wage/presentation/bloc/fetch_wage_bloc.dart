import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_event.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_state.dart';

export 'fetch_wage_event.dart';
export 'fetch_wage_state.dart';

class FetchWageBloc extends Bloc<FetchWageEvent, FetchWageState> {
  FetchWageBloc(FetchWageUseCase useCase)
      : _fetchWageUseCase = useCase,
        super(const FetchWageInitial()) {
    on<FetchWageRequested>(_onFetchWageRequested);
  }

  final FetchWageUseCase _fetchWageUseCase;

  Future<void> _onFetchWageRequested(
    FetchWageRequested event,
    Emitter<FetchWageState> emit,
  ) async {
    emit(const FetchWageLoading());

    final result = _fetchWageUseCase.call();

    await result.fold(
      (failure) async => emit(FetchWageError(failure)),
      (stream) => emit.forEach<WageHourly>(
        stream,
        onData: FetchWageLoaded.new,
        onError: (error, _) => FetchWageError(
          GlobalFailure.fromException(error),
        ),
      ),
    );
  }
}
