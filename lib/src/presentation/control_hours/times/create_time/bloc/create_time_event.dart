part of 'create_time_bloc.dart';

@freezed
class CreateTimeEvent with _$CreateTimeEvent {
  const factory CreateTimeEvent.changeHour({
    required String value,
  }) = _ChangeHour;

  const factory CreateTimeEvent.changeMinutes({
    required String value,
  }) = _ChangeMinutes;

  const factory CreateTimeEvent.create() = _Create;
  const factory CreateTimeEvent.reset() = _Reset;
}
