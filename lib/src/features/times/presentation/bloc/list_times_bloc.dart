import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';

part 'list_times_event.dart';
part 'list_times_state.dart';
part 'list_times_bloc.freezed.dart';

class ListTimesBloc extends Bloc<ListTimesEvent, ListTimesState> {
  ListTimesBloc(ListTimesUseCase useCase)
      : _timesListUseCase = useCase,
        super(const _Initial()) {
    on<_GetTimes>((event, emit) {
      emit(const ListTimesState.loading());

      _timesListUseCase.call().fold(
        (error) {
          emit(ListTimesState.error(error));
        },
        (times) {
          emit(ListTimesState.hasDataStream(times));
        },
      );
    });
  }
  final ListTimesUseCase _timesListUseCase;
}
