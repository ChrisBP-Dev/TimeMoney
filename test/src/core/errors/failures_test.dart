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

  group('GlobalFailure structural equality', () {
    test('InternalError equal when error is same (ignores stackTrace)', () {
      // InternalError(error, st) is genuinely non-const — st is runtime
      final st = StackTrace.current;
      expect(InternalError('msg', st), const InternalError('msg'));
    });

    test('InternalError not equal when error differs', () {
      expect(const InternalError('a'), isNot(const InternalError('b')));
    });

    test('InternalError hashCode stable across instances', () {
      expect(
        const InternalError('msg').hashCode,
        const InternalError('msg').hashCode,
      );
    });

    test('ServerError equal when failure is same', () {
      // StringBuffer().toString() is a runtime value — prevents const
      final code = StringBuffer('500').toString();
      expect(ServerError(code), const ServerError('500'));
    });

    test('NotConnection instances are equal', () {
      // fromException returns a runtime NotConnection — tests == override
      final a = GlobalFailure.fromException(const SocketException(''));
      expect(a, const NotConnection());
    });

    test('TimeOutExceeded instances are equal', () {
      // fromException returns a runtime TimeOutExceeded — tests == override
      final a = GlobalFailure.fromException(TimeoutException(''));
      expect(a, const TimeOutExceeded());
    });
  });

  group('ValueFailure structural equality', () {
    test('CharacterLimitExceeded equal when failedValue same', () {
      // StringBuffer().toString() produces a runtime value — prevents const
      final value = StringBuffer('x').toString();
      expect(
        CharacterLimitExceeded<String>(failedValue: value),
        const CharacterLimitExceeded<String>(failedValue: 'x'),
      );
    });

    test('CharacterLimitExceeded not equal when failedValue differs', () {
      expect(
        const CharacterLimitExceeded<String>(failedValue: 'a'),
        isNot(const CharacterLimitExceeded<String>(failedValue: 'b')),
      );
    });

    test('ShortOrNullCharacters equal when failedValue same', () {
      final value = StringBuffer().toString(); // runtime empty string
      expect(
        ShortOrNullCharacters<String>(failedValue: value),
        const ShortOrNullCharacters<String>(failedValue: ''),
      );
    });

    test('InvalidFormat equal when failedValue same', () {
      final value = StringBuffer('bad').toString(); // runtime value
      expect(
        InvalidFormat<String>(failedValue: value),
        const InvalidFormat<String>(failedValue: 'bad'),
      );
    });
  });
}
