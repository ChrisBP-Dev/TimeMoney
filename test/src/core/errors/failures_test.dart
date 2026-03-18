import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';

void main() {
  group('ValueFailure', () {
    test('CharacterLimitExceeded holds failedValue', () {
      const failure = CharacterLimitExceeded<String>(failedValue: 'too long');
      expect(failure, isA<CharacterLimitExceeded<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, 'too long');
    });

    test('ShortOrNullCharacters holds failedValue', () {
      const failure = ShortOrNullCharacters<String>(failedValue: '');
      expect(failure, isA<ShortOrNullCharacters<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, '');
    });

    test('InvalidFormat holds failedValue', () {
      const failure = InvalidFormat<String>(failedValue: 'abc');
      expect(failure, isA<InvalidFormat<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, 'abc');
    });
  });

  group('GlobalFailure', () {
    test('GlobalFailure is non-generic sealed class', () {
      const failure = NotConnection();
      expect(failure, isA<GlobalFailure>());
    });

    test('ServerError holds failure value', () {
      const failure = ServerError('500');
      expect(failure, isA<ServerError>());
      expect(failure, isA<GlobalFailure>());
      expect(failure.failure, '500');
    });

    test('NotConnection is correct type', () {
      const failure = NotConnection();
      expect(failure, isA<NotConnection>());
      expect(failure, isA<GlobalFailure>());
    });

    test('TimeOutExceeded is correct type', () {
      const failure = TimeOutExceeded();
      expect(failure, isA<TimeOutExceeded>());
      expect(failure, isA<GlobalFailure>());
    });

    test('InternalError holds error and optional stackTrace', () {
      final st = StackTrace.current;
      final failure = InternalError('err', st);
      expect(failure, isA<InternalError>());
      expect(failure, isA<GlobalFailure>());
      expect(failure.error, 'err');
      expect(failure.stackTrace, st);
    });

    test('InternalError with no stackTrace has null stackTrace', () {
      const failure = InternalError('err');
      expect(failure, isA<InternalError>());
      expect(failure.stackTrace, isNull);
    });

    test('exhaustive switch covers all variants', () {
      const GlobalFailure failure = NotConnection();
      final result = switch (failure) {
        ServerError() => 'server',
        NotConnection() => 'noConnection',
        TimeOutExceeded() => 'timeout',
        InternalError() => 'internal',
      };
      expect(result, 'noConnection');
    });

    group('fromException', () {
      test('SocketException maps to NotConnection', () {
        final failure = GlobalFailure.fromException(
          const SocketException('no network'),
        );
        expect(failure, isA<NotConnection>());
      });

      test('TimeoutException maps to TimeOutExceeded', () {
        final failure = GlobalFailure.fromException(
          TimeoutException('timed out'),
        );
        expect(failure, isA<TimeOutExceeded>());
      });

      test('generic Exception maps to InternalError', () {
        final failure = GlobalFailure.fromException(
          Exception('generic'),
        );
        expect(failure, isA<InternalError>());
        expect((failure as InternalError).error, isA<Exception>());
      });

      test('fromException forwards StackTrace to InternalError', () {
        final st = StackTrace.current;
        final failure = GlobalFailure.fromException(Exception('x'), st);
        expect(failure, isA<InternalError>());
        expect((failure as InternalError).stackTrace, st);
      });
    });
  });
}
