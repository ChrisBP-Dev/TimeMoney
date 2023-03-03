part of 'fetch_wage_hourly_bloc.dart';

@freezed
class FetchWageHourlyEvent with _$FetchWageHourlyEvent {
  const factory FetchWageHourlyEvent.getWage() = _GetWage;
}
