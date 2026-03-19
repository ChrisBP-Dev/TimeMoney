import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';

sealed class ValueFailure<T> {
  const ValueFailure();
}

@immutable
final class CharacterLimitExceeded<T> extends ValueFailure<T> {
  const CharacterLimitExceeded({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterLimitExceeded<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

@immutable
final class ShortOrNullCharacters<T> extends ValueFailure<T> {
  const ShortOrNullCharacters({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortOrNullCharacters<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

@immutable
final class InvalidFormat<T> extends ValueFailure<T> {
  const InvalidFormat({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvalidFormat<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

sealed class GlobalFailure {
  const GlobalFailure();

  factory GlobalFailure.fromException(Object err, [StackTrace? st]) {
    if (err is SocketException) return const NotConnection();
    if (err is TimeoutException) return const TimeOutExceeded();
    if (kDebugMode) {
      developer.log('Exception Failure', error: err, stackTrace: st);
    }
    return InternalError(err, st);
  }
}

@immutable
final class ServerError extends GlobalFailure {
  const ServerError(this.failure);
  final Object failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

@immutable
final class NotConnection extends GlobalFailure {
  const NotConnection();

  @override
  bool operator ==(Object other) => other is NotConnection;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
final class TimeOutExceeded extends GlobalFailure {
  const TimeOutExceeded();

  @override
  bool operator ==(Object other) => other is TimeOutExceeded;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
final class InternalError extends GlobalFailure {
  const InternalError(this.error, [this.stackTrace]);
  final dynamic error;
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternalError && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
