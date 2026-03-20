/// Tests for the [ValueFailure] and [GlobalFailure] sealed class hierarchies.
///
/// Covers type identity, payload retention, the [GlobalFailure.fromException]
/// factory mapping, exhaustive switch dispatch, and structural equality
/// (including `==` and `hashCode`) for every variant.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';

void main() {
  // ValueFailure variants represent domain validation errors
  // for user input — each must carry the rejected value.
  group('ValueFailure', () {
    // Exceeding a character limit is a common input error;
    // the failed value is needed for user-facing messages.
    test('CharacterLimitExceeded holds failedValue', () {
      const failure = CharacterLimitExceeded<String>(failedValue: 'too long');
      expect(failure, isA<CharacterLimitExceeded<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, 'too long');
    });

    // Empty or too-short input must be caught before it
    // reaches the domain layer; payload aids error display.
    test('ShortOrNullCharacters holds failedValue', () {
      const failure = ShortOrNullCharacters<String>(failedValue: '');
      expect(failure, isA<ShortOrNullCharacters<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, '');
    });

    // Format validation (e.g. wage format) rejects
    // malformed input; the raw value helps debug.
    test('InvalidFormat holds failedValue', () {
      const failure = InvalidFormat<String>(failedValue: 'abc');
      expect(failure, isA<InvalidFormat<String>>());
      expect(failure, isA<ValueFailure<String>>());
      expect(failure.failedValue, 'abc');
    });
  });

  // GlobalFailure variants represent infrastructure-level
  // errors (network, server, timeout) shared across features.
  group('GlobalFailure', () {
    // Non-generic sealed base ensures all global errors
    // can be handled uniformly regardless of feature.
    test('GlobalFailure is non-generic sealed class', () {
      const failure = NotConnection();
      expect(failure, isA<GlobalFailure>());
    });

    // ServerError carries the HTTP status or message so
    // the UI can show a server-specific error to the user.
    test('ServerError holds failure value', () {
      const failure = ServerError('500');
      expect(failure, isA<ServerError>());
      expect(failure, isA<GlobalFailure>());
      expect(failure.failure, '500');
    });

    // No-connection is a common mobile scenario; must be
    // a distinct type so the UI can suggest retrying.
    test('NotConnection is correct type', () {
      const failure = NotConnection();
      expect(failure, isA<NotConnection>());
      expect(failure, isA<GlobalFailure>());
    });

    // Timeout is distinct from no-connection: the server
    // was reachable but too slow — different UX guidance.
    test('TimeOutExceeded is correct type', () {
      const failure = TimeOutExceeded();
      expect(failure, isA<TimeOutExceeded>());
      expect(failure, isA<GlobalFailure>());
    });

    // InternalError is the catch-all for unexpected bugs;
    // carrying both error and stackTrace enables crash logs.
    test('InternalError holds error and optional stackTrace', () {
      final st = StackTrace.current;
      final failure = InternalError('err', st);
      expect(failure, isA<InternalError>());
      expect(failure, isA<GlobalFailure>());
      expect(failure.error, 'err');
      expect(failure.stackTrace, st);
    });

    // StackTrace is optional because some callers (e.g.
    // const constructors) cannot provide one at compile time.
    test('InternalError with no stackTrace has null stackTrace', () {
      const failure = InternalError('err');
      expect(failure, isA<InternalError>());
      expect(failure.stackTrace, isNull);
    });

    // Exhaustive switch proves all four variants are
    // handled — adding a new one forces a compiler error.
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

    // fromException is the single conversion point from
    // raw platform exceptions to typed domain failures.
    group('fromException', () {
      // SocketException is a dart:io type — in the domain layer it maps
      // to InternalError (the catch-all) rather than NotConnection,
      // keeping the core free of platform imports.
      test('SocketException maps to InternalError', () {
        final failure = GlobalFailure.fromException(
          const SocketException('no network'),
        );
        expect(failure, isA<InternalError>());
      });

      // TimeoutException must map to its own variant so
      // users see "slow connection" instead of generic error.
      test('TimeoutException maps to TimeOutExceeded', () {
        final failure = GlobalFailure.fromException(
          TimeoutException('timed out'),
        );
        expect(failure, isA<TimeOutExceeded>());
      });

      // Any unrecognized exception falls back to
      // InternalError — the safe catch-all for logging.
      test('generic Exception maps to InternalError', () {
        final failure = GlobalFailure.fromException(
          Exception('generic'),
        );
        expect(failure, isA<InternalError>());
        expect((failure as InternalError).error, isA<Exception>());
      });

      // StackTrace forwarding is critical for crash
      // diagnostics — losing it makes debugging impossible.
      test('fromException forwards StackTrace to InternalError', () {
        final st = StackTrace.current;
        final failure = GlobalFailure.fromException(Exception('x'), st);
        expect(failure, isA<InternalError>());
        expect((failure as InternalError).stackTrace, st);
      });
    });
  });

  // Structural equality lets bloc/cubit skip duplicate
  // emissions — two failures with the same data are equal.
  group('GlobalFailure structural equality', () {
    // StackTrace is excluded from equality because the same
    // logical error can occur at different call sites.
    test('InternalError equal when error is same (ignores stackTrace)', () {
      // InternalError(error, st) is genuinely non-const — st is runtime
      final st = StackTrace.current;
      expect(InternalError('msg', st), const InternalError('msg'));
    });

    // Different error messages must produce distinct
    // failures so the UI can differentiate problems.
    test('InternalError not equal when error differs', () {
      expect(const InternalError('a'), isNot(const InternalError('b')));
    });

    // hashCode consistency is required for correct Set/Map
    // behavior when failures are used as keys or members.
    test('InternalError hashCode stable across instances', () {
      expect(
        const InternalError('msg').hashCode,
        const InternalError('msg').hashCode,
      );
    });

    // Runtime vs const instances must still be equal when
    // payload matches — verifies the == override works.
    test('ServerError equal when failure is same', () {
      // StringBuffer().toString() is a runtime value — prevents const
      final code = StringBuffer('500').toString();
      expect(ServerError(code), const ServerError('500'));
    });

    // Const singletons must be equal so bloc dedup works.
    test('NotConnection instances are equal', () {
      // Two const NotConnection instances must be identical
      const a = NotConnection();
      expect(a, const NotConnection());
    });

    // Same as NotConnection — runtime fromException result
    // must equal the const singleton for bloc dedup.
    test('TimeOutExceeded instances are equal', () {
      // fromException returns a runtime TimeOutExceeded — tests == override
      final a = GlobalFailure.fromException(TimeoutException(''));
      expect(a, const TimeOutExceeded());
    });
  });

  // ValueFailure equality matters for form validation UX:
  // same input error should not trigger duplicate rebuilds.
  group('ValueFailure structural equality', () {
    // Runtime string vs const string must be equal when
    // content matches — validates the == override.
    test('CharacterLimitExceeded equal when failedValue same', () {
      // StringBuffer().toString() produces a runtime value — prevents const
      final value = StringBuffer('x').toString();
      expect(
        CharacterLimitExceeded<String>(failedValue: value),
        const CharacterLimitExceeded<String>(failedValue: 'x'),
      );
    });

    // Different rejected values must be distinguishable so
    // the UI updates when the user corrects their input.
    test('CharacterLimitExceeded not equal when failedValue differs', () {
      expect(
        const CharacterLimitExceeded<String>(failedValue: 'a'),
        isNot(const CharacterLimitExceeded<String>(failedValue: 'b')),
      );
    });

    // Empty-string edge case: runtime empty vs const empty
    // must be equal for consistent form validation behavior.
    test('ShortOrNullCharacters equal when failedValue same', () {
      final value = StringBuffer().toString(); // runtime empty string
      expect(
        ShortOrNullCharacters<String>(failedValue: value),
        const ShortOrNullCharacters<String>(failedValue: ''),
      );
    });

    // Completes coverage of all ValueFailure variants to
    // ensure structural equality is consistent across types.
    test('InvalidFormat equal when failedValue same', () {
      final value = StringBuffer('bad').toString(); // runtime value
      expect(
        InvalidFormat<String>(failedValue: value),
        const InvalidFormat<String>(failedValue: 'bad'),
      );
    });
  });
}
