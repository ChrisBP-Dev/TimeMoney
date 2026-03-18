import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';

part 'delete_time_event.dart';
part 'delete_time_state.dart';
part 'delete_time_bloc.freezed.dart';

class DeleteTimeBloc extends Bloc<DeleteTimeEvent, DeleteTimeState> {
  DeleteTimeBloc(DeleteTimeUseCase useCase)
      : _deleteTimeUseCase = useCase,
        super(const _Initial()) {
    on<_Delete>((event, emit) async {
      emit(const DeleteTimeState.loading());

      await Future<void>.delayed(AppDurations.actionFeedback);

      final result = await _deleteTimeUseCase.call(event.time);

      result.fold(DeleteTimeState.error, (r) => const _Success());

      await Future<void>.delayed(AppDurations.actionFeedback);

      emit(const DeleteTimeState.initial());
    });
  }

  final DeleteTimeUseCase _deleteTimeUseCase;
}
