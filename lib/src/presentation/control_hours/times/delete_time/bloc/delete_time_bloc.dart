import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/shared/consts/consts.dart';

part 'delete_time_event.dart';
part 'delete_time_state.dart';
part 'delete_time_bloc.freezed.dart';

class DeleteTimeBloc extends Bloc<DeleteTimeEvent, DeleteTimeState> {
  DeleteTimeBloc(DeleteTimeUseCase useCase)
      : _deleteTimeUseCase = useCase,
        super(const _Initial()) {
    on<_Delete>((event, emit) async {
      emit(const DeleteTimeState.loading());

      await Consts.delayed;

      final result = await _deleteTimeUseCase.call(event.time);

      result.fold(DeleteTimeState.error, (r) => const _Success());

      await Consts.delayed;

      emit(const DeleteTimeState.initial());
    });
  }

  final DeleteTimeUseCase _deleteTimeUseCase;
}
