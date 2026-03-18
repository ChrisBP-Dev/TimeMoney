part of 'fetch_wage_bloc.dart';

@freezed
abstract class FetchWageEvent with _$FetchWageEvent {
  const factory FetchWageEvent.getWage() = _GetWage;
}
