/// Base event class for the list times BLoC.
sealed class ListTimesEvent {
  /// Creates a [ListTimesEvent].
  const ListTimesEvent();
}

/// Event requesting the BLoC to start streaming time entries.
final class ListTimesRequested extends ListTimesEvent {
  /// Creates a [ListTimesRequested] event.
  const ListTimesRequested();
}
