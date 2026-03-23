import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_event.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_state.dart';

export 'fetch_wage_event.dart';
export 'fetch_wage_state.dart';

/// BLoC responsible for fetching the current hourly wage.
///
/// Listens for [FetchWageRequested] events and emits a reactive stream
/// of [FetchWageState] updates sourced from [FetchWageUseCase].
class FetchWageBloc extends Bloc<FetchWageEvent, FetchWageState> {
  /// Creates a [FetchWageBloc] with the given [useCase].
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
