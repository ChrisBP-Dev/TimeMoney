part of 'update_time_bloc.dart';

@freezed
abstract class UpdateTimeState with _$UpdateTimeState {
  const factory UpdateTimeState({
    @Default(
      ActionInitial<TimeEntry>(),
    )
        ActionState<TimeEntry> currentState,
    @Default(null)
        TimeEntry? time,
  }) = _UpdateTimeState;

  factory UpdateTimeState.initial() => const UpdateTimeState();
}
