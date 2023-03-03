import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';

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
          // final dataList = await times.toList();
          // if (dataList.isEmpty) {
          //   emit(const ListTimesState.empty());
          // } else {
          // final length = dataList.last.isEmpty;
          // if (length) {
          //   emit(const ListTimesState.empty());
          // } else {
          emit(ListTimesState.hasDataStream(times));
          // }
          // }
        },
      );
    });
  }
  final ListTimesUseCase _timesListUseCase;
}
