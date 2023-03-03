part of 'update_time_bloc.dart';

@freezed
class UpdateTimeEvent with _$UpdateTimeEvent {
  const factory UpdateTimeEvent.init({required ModelTime time}) = _Init;

  const factory UpdateTimeEvent.changeHour({
    required String value,
  }) = _ChangeHour;

  const factory UpdateTimeEvent.changeMinutes({
    required String value,
  }) = _ChangeMinutes;

  const factory UpdateTimeEvent.update() = _Update;
}
