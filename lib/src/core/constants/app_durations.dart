/// Timing constants used across the application.
abstract final class AppDurations {
  /// Delay after CRUD action success/error before resetting to initial state.
  /// Provides visual feedback to the user (400ms).
  static const actionFeedback = Duration(milliseconds: 400);
}
