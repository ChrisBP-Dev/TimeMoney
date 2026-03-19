import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_event.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_state.dart';

export 'update_wage_event.dart';
export 'update_wage_state.dart';

class UpdateWageBloc extends Bloc<UpdateWageEvent, UpdateWageState> {
  UpdateWageBloc(UpdateWageUseCase useCase)
      : _updateWageUseCase = useCase,
        super(const UpdateWageInitial()) {
    on<UpdateWageHourlyChanged>(_onHourlyChanged);
    on<UpdateWageSubmitted>(_onSubmitted);
  }

  final UpdateWageUseCase _updateWageUseCase;

  Future<void> _onHourlyChanged(
    UpdateWageHourlyChanged event,
    Emitter<UpdateWageState> emit,
  ) async {
    final hourly = double.tryParse(event.value);

    if (hourly == null) return _emitError(emit);

    final currentWage = state.wageHourly;
    emit(UpdateWageInitial(
      wageHourly: currentWage.copyWith(value: hourly),
    ));
  }

  Future<void> _onSubmitted(
    UpdateWageSubmitted event,
    Emitter<UpdateWageState> emit,
  ) async {
    final currentWage = state.wageHourly;

    emit(UpdateWageLoading(wageHourly: currentWage));

    final result = await _updateWageUseCase.call(currentWage);

    result.fold(
      (failure) => emit(UpdateWageError(failure, wageHourly: currentWage)),
      (wage) => emit(UpdateWageSuccess(result: wage, wageHourly: currentWage)),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);

    emit(const UpdateWageInitial());
  }

  Future<void> _emitError(Emitter<UpdateWageState> emit) async {
    final currentWage = state.wageHourly;

    emit(UpdateWageError(
      const InternalError('invalid number'),
      wageHourly: currentWage,
    ));

    await Future<void>.delayed(AppDurations.actionFeedback);

    emit(UpdateWageInitial(wageHourly: currentWage));
  }
}
