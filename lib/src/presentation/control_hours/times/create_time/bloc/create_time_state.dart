part of 'create_time_bloc.dart';

@freezed
abstract class CreateTimeState with _$CreateTimeState {
  const factory CreateTimeState({
    required ActionState<ModelTime> currentState,
    @Default(0) int hour,
    @Default(0) int minutes,
  }) = _CreateTimeState;

  factory CreateTimeState.initial() => const CreateTimeState(
        currentState: ActionState<ModelTime>.initial(),
      );
}
