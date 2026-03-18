import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

@immutable
sealed class CreateTimeState {
  const CreateTimeState({this.hour = 0, this.minutes = 0});
  final int hour;
  final int minutes;
}

final class CreateTimeInitial extends CreateTimeState {
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

final class CreateTimeLoading extends CreateTimeState {
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

final class CreateTimeSuccess extends CreateTimeState {
  const CreateTimeSuccess(
    this.timeEntry, {
    required super.hour,
    required super.minutes,
  });
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

final class CreateTimeError extends CreateTimeState {
  const CreateTimeError(
    this.failure, {
    required super.hour,
    required super.minutes,
  });
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
