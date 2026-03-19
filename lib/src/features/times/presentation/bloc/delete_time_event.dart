import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Base event class for the delete time BLoC.
sealed class DeleteTimeEvent {
  /// Creates a [DeleteTimeEvent].
  const DeleteTimeEvent();
}

/// Event requesting deletion of a specific [TimeEntry].
final class DeleteTimeRequested extends DeleteTimeEvent {
  /// Creates a [DeleteTimeRequested] event for the given [time] entry.
  const DeleteTimeRequested({required this.time});

  /// The time entry to delete.
  final TimeEntry time;
}
