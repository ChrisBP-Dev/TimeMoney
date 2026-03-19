/// Base event type for `UpdateWageBloc`.
sealed class UpdateWageEvent {
  /// Creates an [UpdateWageEvent].
  const UpdateWageEvent();
}

/// Signals that the hourly wage text input has changed.
final class UpdateWageHourlyChanged extends UpdateWageEvent {
  /// Creates an [UpdateWageHourlyChanged] event with the raw [value] string.
  const UpdateWageHourlyChanged({required this.value});

  /// The raw text value entered by the user.
  final String value;
}

/// Signals that the user has submitted the wage update form.
final class UpdateWageSubmitted extends UpdateWageEvent {
  /// Creates an [UpdateWageSubmitted] event.
  const UpdateWageSubmitted();
}
