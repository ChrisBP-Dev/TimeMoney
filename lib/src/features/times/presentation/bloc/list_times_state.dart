import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Represents the state of the list times operation.
@immutable
sealed class ListTimesState {
  /// Creates a [ListTimesState].
  const ListTimesState();
}

/// Initial state before any load operation has been requested.
final class ListTimesInitial extends ListTimesState {
  /// Creates a [ListTimesInitial] state.
  const ListTimesInitial();
}

/// Loading state while the time entries stream is being established.
final class ListTimesLoading extends ListTimesState {
  /// Creates a [ListTimesLoading] state.
  const ListTimesLoading();
}

/// Success state containing a non-empty list of [TimeEntry] items.
final class ListTimesLoaded extends ListTimesState {
  /// Creates a [ListTimesLoaded] state with the given [times].
  const ListTimesLoaded(this.times);

  /// The loaded list of time entries.
  final List<TimeEntry> times;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesLoaded && listEquals(times, other.times);

  @override
  int get hashCode => Object.hashAll(times);
}

/// Success state indicating the stream returned an empty list.
final class ListTimesEmpty extends ListTimesState {
  /// Creates a [ListTimesEmpty] state.
  const ListTimesEmpty();
}

/// Error state containing the [GlobalFailure] that caused the operation
/// to fail.
final class ListTimesError extends ListTimesState {
  /// Creates a [ListTimesError] state with the given [failure].
  const ListTimesError(this.failure);

  /// The failure that caused the error.
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
