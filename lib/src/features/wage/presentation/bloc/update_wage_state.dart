part of 'update_wage_bloc.dart';

@freezed
abstract class UpdateWageState with _$UpdateWageState {
  const factory UpdateWageState({
    @Default(WageHourly())
        WageHourly wageHourly,
    @Default(
      ActionInitial<WageHourly>(),
    )
        ActionState<WageHourly> currentState,
  }) = _UpdateWageState;

  factory UpdateWageState.initial() => const UpdateWageState();
}
