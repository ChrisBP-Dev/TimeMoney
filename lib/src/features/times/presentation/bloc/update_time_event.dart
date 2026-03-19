import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Base event class for the update time BLoC.
sealed class UpdateTimeEvent {
  /// Creates an [UpdateTimeEvent].
  const UpdateTimeEvent();
}

/// Event that seeds the BLoC with the [TimeEntry] to be edited.
final class UpdateTimeInit extends UpdateTimeEvent {
  /// Creates an [UpdateTimeInit] event with the [time] entry to edit.
  const UpdateTimeInit({required this.time});

  /// The time entry whose values populate the edit form.
  final TimeEntry time;
}

/// Event indicating the hour input field value has changed.
final class UpdateTimeHourChanged extends UpdateTimeEvent {
  /// Creates an [UpdateTimeHourChanged] event with the raw [value] string.
  const UpdateTimeHourChanged({required this.value});

  /// The raw string value from the hour input field.
  final String value;
}

/// Event indicating the minutes input field value has changed.
final class UpdateTimeMinutesChanged extends UpdateTimeEvent {
  /// Creates an [UpdateTimeMinutesChanged] event with the raw [value] string.
  const UpdateTimeMinutesChanged({required this.value});

  /// The raw string value from the minutes input field.
  final String value;
}

/// Event requesting submission of the edited time entry for persistence.
final class UpdateTimeSubmitted extends UpdateTimeEvent {
  /// Creates an [UpdateTimeSubmitted] event.
  const UpdateTimeSubmitted();
}
