/// Base event class for the create time BLoC.
sealed class CreateTimeEvent {
  /// Creates a [CreateTimeEvent].
  const CreateTimeEvent();
}

/// Event indicating the hour input field value has changed.
final class CreateTimeHourChanged extends CreateTimeEvent {
  /// Creates a [CreateTimeHourChanged] event with the raw [value] string.
  const CreateTimeHourChanged({required this.value});

  /// The raw string value from the hour input field.
  final String value;
}

/// Event indicating the minutes input field value has changed.
final class CreateTimeMinutesChanged extends CreateTimeEvent {
  /// Creates a [CreateTimeMinutesChanged] event with the raw [value] string.
  const CreateTimeMinutesChanged({required this.value});

  /// The raw string value from the minutes input field.
  final String value;
}

/// Event requesting submission of the current form values to create
/// a new time entry.
final class CreateTimeSubmitted extends CreateTimeEvent {
  /// Creates a [CreateTimeSubmitted] event.
  const CreateTimeSubmitted();
}

/// Event requesting the form to reset to its initial state.
final class CreateTimeReset extends CreateTimeEvent {
  /// Creates a [CreateTimeReset] event.
  const CreateTimeReset();
}
