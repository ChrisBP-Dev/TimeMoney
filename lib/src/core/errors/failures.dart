import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Base sealed class for domain-level validation failures.
///
/// Used as the Left side of `Either<ValueFailure, T>` to represent
/// invalid input detected during value-object construction. Each subclass
/// carries the `failedValue` that violated the validation rule.
sealed class ValueFailure<T> {
  /// Creates a [ValueFailure] instance.
  const ValueFailure();
}

/// Indicates a value exceeded the maximum allowed character length.
///
/// Wraps the offending [failedValue] so callers can display or log it.
@immutable
final class CharacterLimitExceeded<T> extends ValueFailure<T> {
  /// Creates a [CharacterLimitExceeded] with the value that was too long.
  const CharacterLimitExceeded({required this.failedValue});

  /// The input value that exceeded the character limit.
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterLimitExceeded<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

/// Indicates a value was too short or effectively null/empty.
///
/// Wraps the offending [failedValue] so callers can display or log it.
@immutable
final class ShortOrNullCharacters<T> extends ValueFailure<T> {
  /// Creates a [ShortOrNullCharacters] with the value that was too short.
  const ShortOrNullCharacters({required this.failedValue});

  /// The input value that was too short or null.
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortOrNullCharacters<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

/// Indicates a value did not match the expected format (e.g. regex pattern).
///
/// Wraps the offending [failedValue] so callers can display or log it.
@immutable
final class InvalidFormat<T> extends ValueFailure<T> {
  /// Creates an [InvalidFormat] with the value that failed format validation.
  const InvalidFormat({required this.failedValue});

  /// The input value that did not match the expected format.
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvalidFormat<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

/// Base sealed class for infrastructure and runtime failures.
///
/// Used as the Left side of `Either<GlobalFailure, T>` in use-cases and
/// repositories. The `fromException` factory maps raw exceptions into the
/// appropriate typed subclass, keeping error handling consistent across the
/// entire data layer.
sealed class GlobalFailure {
  /// Creates a [GlobalFailure] instance.
  const GlobalFailure();

  /// Maps a raw [err] (and optional [st]) to a typed [GlobalFailure].
  ///
  /// - [TimeoutException] -> [TimeOutExceeded]
  /// - Everything else -> [InternalError] (logged in debug mode)
  ///
  /// Platform-specific exception mapping (e.g. `SocketException` ->
  /// [NotConnection]) belongs in the data layer, not here. The domain
  /// factory only handles platform-agnostic types.
  factory GlobalFailure.fromException(Object err, [StackTrace? st]) {
    if (err is TimeoutException) return const TimeOutExceeded();
    if (kDebugMode) {
      developer.log('Exception Failure', error: err, stackTrace: st);
    }
    return InternalError(err, st);
  }
}

/// Represents an error response from a remote server or API.
@immutable
final class ServerError extends GlobalFailure {
  /// Creates a [ServerError] carrying the raw server [failure] payload.
  const ServerError(this.failure);

  /// The raw error object returned by the server.
  final Object failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

/// Indicates the device has no network connectivity.
///
/// Available for use by data-layer code that catches platform-specific
/// network exceptions (e.g. `SocketException`). Not produced directly
/// by [GlobalFailure.fromException] — platform mapping belongs in the
/// data layer per Dependency Inversion.
@immutable
final class NotConnection extends GlobalFailure {
  /// Creates a [NotConnection] instance.
  const NotConnection();

  @override
  bool operator ==(Object other) => other is NotConnection;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Indicates an operation timed out before completing.
///
/// Produced when a [TimeoutException] is caught by
/// [GlobalFailure.fromException].
@immutable
final class TimeOutExceeded extends GlobalFailure {
  /// Creates a [TimeOutExceeded] instance.
  const TimeOutExceeded();

  @override
  bool operator ==(Object other) => other is TimeOutExceeded;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Catch-all for unexpected or unclassified exceptions.
///
/// Carries the original [error] and optional [stackTrace] for debugging.
/// In debug mode the error is logged via `dart:developer` before wrapping.
@immutable
final class InternalError extends GlobalFailure {
  /// Creates an [InternalError] from the raw [error] and optional [stackTrace].
  const InternalError(this.error, [this.stackTrace]);

  /// The original exception or error object.
  final dynamic error;

  /// The stack trace captured at the point of failure, if available.
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is InternalError && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
