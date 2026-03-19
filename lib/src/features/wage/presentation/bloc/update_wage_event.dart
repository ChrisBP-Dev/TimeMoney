sealed class UpdateWageEvent {
  const UpdateWageEvent();
}

final class UpdateWageHourlyChanged extends UpdateWageEvent {
  const UpdateWageHourlyChanged({required this.value});
  final String value;
}

final class UpdateWageSubmitted extends UpdateWageEvent {
  const UpdateWageSubmitted();
}
