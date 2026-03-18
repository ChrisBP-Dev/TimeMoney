import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';

sealed class ValueFailure<T> {
  const ValueFailure();
}

final class CharacterLimitExceeded<T> extends ValueFailure<T> {
  const CharacterLimitExceeded({required this.failedValue});
  final T failedValue;
}

final class ShortOrNullCharacters<T> extends ValueFailure<T> {
  const ShortOrNullCharacters({required this.failedValue});
  final T failedValue;
}

final class InvalidFormat<T> extends ValueFailure<T> {
  const InvalidFormat({required this.failedValue});
  final T failedValue;
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

final class ServerError extends GlobalFailure {
  const ServerError(this.failure);
  final Object failure;
}

final class NotConnection extends GlobalFailure {
  const NotConnection();
}

final class TimeOutExceeded extends GlobalFailure {
  const TimeOutExceeded();
}

final class InternalError extends GlobalFailure {
  const InternalError(this.error, [this.stackTrace]);
  final dynamic error;
  final StackTrace? stackTrace;
}
