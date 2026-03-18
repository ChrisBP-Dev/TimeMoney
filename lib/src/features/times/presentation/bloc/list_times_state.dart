import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

@immutable
sealed class ListTimesState {
  const ListTimesState();
}

final class ListTimesInitial extends ListTimesState {
  const ListTimesInitial();
}

final class ListTimesLoading extends ListTimesState {
  const ListTimesLoading();
}

final class ListTimesLoaded extends ListTimesState {
  const ListTimesLoaded(this.times);
  final List<TimeEntry> times;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesLoaded && listEquals(times, other.times);

  @override
  int get hashCode => Object.hashAll(times);
}

final class ListTimesEmpty extends ListTimesState {
  const ListTimesEmpty();
}

final class ListTimesError extends ListTimesState {
  const ListTimesError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
