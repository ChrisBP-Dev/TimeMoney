import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';

void main() {
  group('ValueFailure', () {
    test('characterLimitExceeded holds failedValue', () {
      const ValueFailure<String>.characterLimitExceeded(
        failedValue: 'too long',
      ).when(
        characterLimitExceeded: (value) => expect(value, 'too long'),
        shortOrNullCharacters: (_) => fail('wrong variant'),
        invalidFormat: (_) => fail('wrong variant'),
      );
    });

    test('shortOrNullCharacters holds failedValue', () {
      const ValueFailure<String>.shortOrNullCharacters(
        failedValue: '',
      ).when(
        characterLimitExceeded: (_) => fail('wrong variant'),
        shortOrNullCharacters: (value) => expect(value, ''),
        invalidFormat: (_) => fail('wrong variant'),
      );
    });

    test('invalidFormat holds failedValue', () {
      const ValueFailure<String>.invalidFormat(
        failedValue: 'abc',
      ).when(
        characterLimitExceeded: (_) => fail('wrong variant'),
        shortOrNullCharacters: (_) => fail('wrong variant'),
        invalidFormat: (value) => expect(value, 'abc'),
      );
    });
  });

  group('GlobalFailure', () {
    test('serverError holds failure value', () {
      const GlobalFailure<String>.serverError('500').when(
        serverError: (value) => expect(value, '500'),
        notConnection: () => fail('wrong variant'),
        timeOutExceeded: () => fail('wrong variant'),
        internalError: (_, _) => fail('wrong variant'),
      );
    });

    test('notConnection is constructable', () {
      const GlobalFailure<dynamic>.notConnection().when(
        serverError: (_) => fail('wrong variant'),
        notConnection: () => expect(true, isTrue),
        timeOutExceeded: () => fail('wrong variant'),
        internalError: (_, _) => fail('wrong variant'),
      );
    });

    test('timeOutExceeded is constructable', () {
      const GlobalFailure<dynamic>.timeOutExceeded().when(
        serverError: (_) => fail('wrong variant'),
        notConnection: () => fail('wrong variant'),
        timeOutExceeded: () => expect(true, isTrue),
        internalError: (_, _) => fail('wrong variant'),
      );
    });

    test('internalError holds error and optional stackTrace', () {
      final st = StackTrace.current;
      GlobalFailure<dynamic>.internalError('err', st).when(
        serverError: (_) => fail('wrong variant'),
        notConnection: () => fail('wrong variant'),
        timeOutExceeded: () => fail('wrong variant'),
        internalError: (err, stackTrace) {
          expect(err, 'err');
          expect(stackTrace, st);
        },
      );
    });

    group('fromException', () {
      test('SocketException maps to notConnection', () {
        GlobalFailure<dynamic>.fromException(
          const SocketException('no network'),
        ).when(
          serverError: (_) => fail('wrong variant'),
          notConnection: () => expect(true, isTrue),
          timeOutExceeded: () => fail('wrong variant'),
          internalError: (_, _) => fail('wrong variant'),
        );
      });

      test('TimeoutException maps to timeOutExceeded', () {
        GlobalFailure<dynamic>.fromException(
          TimeoutException('timed out'),
        ).when(
          serverError: (_) => fail('wrong variant'),
          notConnection: () => fail('wrong variant'),
          timeOutExceeded: () => expect(true, isTrue),
          internalError: (_, _) => fail('wrong variant'),
        );
      });

      test('generic Exception maps to internalError', () {
        GlobalFailure<dynamic>.fromException(
          Exception('generic'),
        ).when(
          serverError: (_) => fail('wrong variant'),
          notConnection: () => fail('wrong variant'),
          timeOutExceeded: () => fail('wrong variant'),
          internalError: (err, _) => expect(err, isA<Exception>()),
        );
      });
    });
  });

  group('GlobalDefaultFailure typedef', () {
    test('resolves to GlobalFailure<dynamic>', () {
      const failure = GlobalDefaultFailure.notConnection();

      expect(failure, isA<GlobalDefaultFailure>());
      expect(failure, isA<GlobalFailure<dynamic>>());
    });
  });
}
