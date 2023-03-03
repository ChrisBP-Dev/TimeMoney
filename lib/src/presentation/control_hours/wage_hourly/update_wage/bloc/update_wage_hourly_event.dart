part of 'update_wage_hourly_bloc.dart';

@freezed
class UpdateWageHourlyEvent with _$UpdateWageHourlyEvent {
  const factory UpdateWageHourlyEvent.changeHourly({
    required String value,
  }) = _ChangeHourly;
  const factory UpdateWageHourlyEvent.update() = _Update;
}
