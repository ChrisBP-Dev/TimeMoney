import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';

/// Represents the state of the delete time entry operation.
@immutable
sealed class DeleteTimeState {
  /// Creates a [DeleteTimeState].
  const DeleteTimeState();
}

/// Initial idle state before any delete operation.
final class DeleteTimeInitial extends DeleteTimeState {
  /// Creates a [DeleteTimeInitial] state.
  const DeleteTimeInitial();
}

/// Loading state while the time entry is being deleted.
final class DeleteTimeLoading extends DeleteTimeState {
  /// Creates a [DeleteTimeLoading] state.
  const DeleteTimeLoading();
}

/// Success state after the time entry has been deleted.
final class DeleteTimeSuccess extends DeleteTimeState {
  /// Creates a [DeleteTimeSuccess] state.
  const DeleteTimeSuccess();
}

/// Error state containing the [GlobalFailure] that prevented deletion.
final class DeleteTimeError extends DeleteTimeState {
  /// Creates a [DeleteTimeError] state with the given [failure].
  const DeleteTimeError(this.failure);

  /// The failure that caused the error.
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTimeError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
