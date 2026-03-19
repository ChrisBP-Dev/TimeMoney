/// Base event type for `FetchWageBloc`.
sealed class FetchWageEvent {
  /// Creates a [FetchWageEvent].
  const FetchWageEvent();
}

/// Signals that the UI wants to start fetching the current wage.
final class FetchWageRequested extends FetchWageEvent {
  /// Creates a [FetchWageRequested] event.
  const FetchWageRequested();
}
