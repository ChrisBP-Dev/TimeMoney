import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

@immutable
sealed class UpdateTimeState {
  const UpdateTimeState({this.hour = 0, this.minutes = 0, this.time});
  final int hour;
  final int minutes;
  final TimeEntry? time;
}

final class UpdateTimeInitial extends UpdateTimeState {
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

final class UpdateTimeLoading extends UpdateTimeState {
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

final class UpdateTimeSuccess extends UpdateTimeState {
  const UpdateTimeSuccess(
    this.timeEntry, {
    required super.hour,
    required super.minutes,
    super.time,
  });
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

final class UpdateTimeError extends UpdateTimeState {
  const UpdateTimeError(
    this.failure, {
    required super.hour,
    required super.minutes,
    super.time,
  });
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
