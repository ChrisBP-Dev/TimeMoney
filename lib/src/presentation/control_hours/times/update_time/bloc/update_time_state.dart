part of 'update_time_bloc.dart';

@freezed
class UpdateTimeState with _$UpdateTimeState {
  const factory UpdateTimeState({
    @Default(
      ActionState<ModelTime>.initial(),
    )
        ActionState<ModelTime> currentState,
    @Default(null)
        ModelTime? time,
  }) = _UpdateTimeState;

  factory UpdateTimeState.initial() => const UpdateTimeState();
}
