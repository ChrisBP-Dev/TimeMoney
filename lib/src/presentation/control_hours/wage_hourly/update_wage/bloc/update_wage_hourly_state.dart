part of 'update_wage_hourly_bloc.dart';

@freezed
class UpdateWageHourlyState with _$UpdateWageHourlyState {
  const factory UpdateWageHourlyState({
    @Default(WageHourly())
        WageHourly wageHourly,
    @Default(
      ActionState<WageHourly>.initial(),
    )
        ActionState<WageHourly> currentState,
  }) = _UpdateWageHourlyState;

  factory UpdateWageHourlyState.initial() => const UpdateWageHourlyState();
}
