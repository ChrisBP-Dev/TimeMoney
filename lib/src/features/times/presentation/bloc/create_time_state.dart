import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Represents the state of the create time entry operation.
///
/// All states carry the current [hour] and [minutes] form values so the
/// UI can preserve user input across state transitions.
@immutable
sealed class CreateTimeState {
  /// Creates a [CreateTimeState] with the current form values.
  const CreateTimeState({this.hour = 0, this.minutes = 0});

  /// The current hour value entered by the user.
  final int hour;

  /// The current minutes value entered by the user.
  final int minutes;
}

/// Initial idle state of the create time form.
final class CreateTimeInitial extends CreateTimeState {
  /// Creates a [CreateTimeInitial] state with optional form values.
  const CreateTimeInitial({super.hour, super.minutes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeInitial &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(hour, minutes);
}

/// Loading state while the time entry is being persisted.
final class CreateTimeLoading extends CreateTimeState {
  /// Creates a [CreateTimeLoading] state preserving the form values.
  const CreateTimeLoading({required super.hour, required super.minutes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeLoading &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(hour, minutes);
}

/// Success state after the time entry has been created.
final class CreateTimeSuccess extends CreateTimeState {
  /// Creates a [CreateTimeSuccess] state with the persisted [timeEntry].
  const CreateTimeSuccess(
    this.timeEntry, {
    required super.hour,
    required super.minutes,
  });

  /// The newly created time entry returned by the use case.
  final TimeEntry timeEntry;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeSuccess &&
          timeEntry == other.timeEntry &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(timeEntry, hour, minutes);
}

/// Error state containing the [GlobalFailure] that prevented creation.
final class CreateTimeError extends CreateTimeState {
  /// Creates a [CreateTimeError] state with the given [failure].
  const CreateTimeError(
    this.failure, {
    required super.hour,
    required super.minutes,
  });

  /// The failure that caused the error.
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeError &&
          failure == other.failure &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(failure, hour, minutes);
}
