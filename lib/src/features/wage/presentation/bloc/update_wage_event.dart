part of 'update_wage_bloc.dart';

@freezed
abstract class UpdateWageEvent with _$UpdateWageEvent {
  const factory UpdateWageEvent.changeHourly({
    required String value,
  }) = _ChangeHourly;
  const factory UpdateWageEvent.update() = _Update;
}
