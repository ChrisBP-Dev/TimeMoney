import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_state.dart';

export 'list_times_event.dart';
export 'list_times_state.dart';

/// BLoC responsible for listing time entries.
///
/// Subscribes to a reactive stream of [TimeEntry] lists returned by
/// [ListTimesUseCase] and maps the results into the appropriate state.
class ListTimesBloc extends Bloc<ListTimesEvent, ListTimesState> {
  /// Creates a [ListTimesBloc] with the given [useCase].
  ListTimesBloc(ListTimesUseCase useCase)
    : _listTimesUseCase = useCase,
      super(const ListTimesInitial()) {
    on<ListTimesRequested>(_onListTimesRequested);
  }

  final ListTimesUseCase _listTimesUseCase;

  Future<void> _onListTimesRequested(
    ListTimesRequested event,
    Emitter<ListTimesState> emit,
  ) async {
    emit(const ListTimesLoading());

    final result = _listTimesUseCase.call();

    await result.fold(
      (failure) async => emit(ListTimesError(failure)),
      (stream) => emit.forEach<List<TimeEntry>>(
        stream,
        onData: (times) =>
            times.isEmpty ? const ListTimesEmpty() : ListTimesLoaded(times),
        onError: (error, _) => ListTimesError(
          GlobalFailure.fromException(error),
        ),
      ),
    );
  }
}
