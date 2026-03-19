import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Represents the state of the update time entry operation.
///
/// All states carry the current [hour], [minutes], and optional [time]
/// entity so the UI can preserve user input and entity context across
/// state transitions.
@immutable
sealed class UpdateTimeState {
  /// Creates an [UpdateTimeState] with the current form values.
  const UpdateTimeState({this.hour = 0, this.minutes = 0, this.time});

  /// The current hour value entered by the user.
  final int hour;

  /// The current minutes value entered by the user.
  final int minutes;

  /// The [TimeEntry] being edited, or `null` before initialization.
  final TimeEntry? time;
}

/// Initial idle state of the update time form.
final class UpdateTimeInitial extends UpdateTimeState {
  /// Creates an [UpdateTimeInitial] state with optional form values.
  const UpdateTimeInitial({super.hour, super.minutes, super.time});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateTimeInitial &&
          hour == other.hour &&
          minutes == other.minutes &&
          time == other.time;

  @override
  int get hashCode => Object.hash(hour, minutes, time);
}

/// Loading state while the updated time entry is being persisted.
final class UpdateTimeLoading extends UpdateTimeState {
  /// Creates an [UpdateTimeLoading] state preserving the form values.
  const UpdateTimeLoading({
    required super.hour,
    required super.minutes,
    super.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateTimeLoading &&
          hour == other.hour &&
          minutes == other.minutes &&
          time == other.time;

  @override
  int get hashCode => Object.hash(hour, minutes, time);
}

/// Success state after the time entry has been updated.
final class UpdateTimeSuccess extends UpdateTimeState {
  /// Creates an [UpdateTimeSuccess] state with the persisted [timeEntry].
  const UpdateTimeSuccess(
    this.timeEntry, {
    required super.hour,
    required super.minutes,
    super.time,
  });

  /// The updated time entry returned by the use case.
  final TimeEntry timeEntry;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateTimeSuccess &&
          timeEntry == other.timeEntry &&
          hour == other.hour &&
          minutes == other.minutes &&
          time == other.time;

  @override
  int get hashCode => Object.hash(timeEntry, hour, minutes, time);
}

/// Error state containing the [GlobalFailure] that prevented the update.
final class UpdateTimeError extends UpdateTimeState {
  /// Creates an [UpdateTimeError] state with the given [failure].
  const UpdateTimeError(
    this.failure, {
    required super.hour,
    required super.minutes,
    super.time,
  });

  /// The failure that caused the error.
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateTimeError &&
          failure == other.failure &&
          hour == other.hour &&
          minutes == other.minutes &&
          time == other.time;

  @override
  int get hashCode => Object.hash(failure, hour, minutes, time);
}
