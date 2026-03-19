import 'package:time_money/src/core/errors/failures.dart';

/// Generic state machine for asynchronous CRUD operations.
///
/// Embedded inside BLoC/Cubit states to track individual action lifecycles
/// (e.g. create, update, delete) independently from the main data list.
/// The sealed hierarchy enables exhaustive `switch` handling in the UI and
/// exposes boolean convenience getters for simpler checks.
sealed class ActionState<T> {
  /// Creates an [ActionState] instance.
  const ActionState();

  /// Whether the action has not yet been triggered.
  bool get isInitial => this is ActionInitial<T>;

  /// Whether the action is currently in progress.
  bool get isLoading => this is ActionLoading<T>;

  /// Whether the action completed successfully.
  bool get isSuccess => this is ActionSuccess<T>;

  /// Whether the action completed with a failure.
  bool get isError => this is ActionError<T>;
}

/// The action has not been triggered yet (idle / reset state).
final class ActionInitial<T> extends ActionState<T> {
  /// Creates an [ActionInitial] instance.
  const ActionInitial();
}

/// The action is currently in progress (e.g. awaiting a repository call).
final class ActionLoading<T> extends ActionState<T> {
  /// Creates an [ActionLoading] instance.
  const ActionLoading();
}

/// The action completed successfully, carrying the resulting [data].
final class ActionSuccess<T> extends ActionState<T> {
  /// Creates an [ActionSuccess] with the operation result [data].
  const ActionSuccess(this.data);

  /// The payload returned by the successful operation.
  final T data;
}

/// The action completed with a [GlobalFailure].
///
/// The UI typically maps [failure] to a user-facing message and then
/// resets back to [ActionInitial] after `AppDurations.actionFeedback`.
final class ActionError<T> extends ActionState<T> {
  /// Creates an [ActionError] wrapping the [failure] that occurred.
  const ActionError(this.failure);

  /// The infrastructure or domain failure that caused the error.
  final GlobalFailure failure;
}
