/// Equality and hashCode tests for all times-feature BLoC state and event
/// sealed hierarchies.
///
/// Exercises the `operator ==` and `hashCode` implementations with
/// non-identical instances to cover branches bypassed when BLoC tests
/// use canonicalized `const` values.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';

void main() {
  // Non-const instantiation avoids Dart const canonicalization, ensuring
  // the full operator == body is reached (not short-circuited by identical).

  group('CreateTimeState equality', () {
    test('CreateTimeInitial supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeInitial();
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeInitial();

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('CreateTimeInitial supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeInitial(hour: 1);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeInitial(hour: 2);

      expect(a, isNot(equals(b)));
    });

    test('CreateTimeLoading supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeLoading(hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeLoading(hour: 1, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('CreateTimeLoading supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeLoading(hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeLoading(hour: 2, minutes: 0);

      expect(a, isNot(equals(b)));
    });

    test('CreateTimeSuccess supports equality and hashCode', () {
      const entry = TimeEntry(id: 1, hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeSuccess(entry, hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeSuccess(entry, hour: 1, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('CreateTimeSuccess supports inequality for different fields', () {
      const entry1 = TimeEntry(id: 1, hour: 1, minutes: 30);
      const entry2 = TimeEntry(id: 2, hour: 3, minutes: 0);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeSuccess(entry1, hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeSuccess(entry2, hour: 3, minutes: 0);

      expect(a, isNot(equals(b)));
    });

    test('CreateTimeError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeError(failure, hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeError(failure, hour: 1, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('CreateTimeError supports inequality for different fields', () {
      const failure1 = InternalError('a');
      const failure2 = InternalError('b');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = CreateTimeError(failure1, hour: 1, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = CreateTimeError(failure2, hour: 1, minutes: 30);

      expect(a, isNot(equals(b)));
    });
  });

  group('CreateTimeEvent coverage', () {
    test('CreateTimeReset can be instantiated', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final event = CreateTimeReset();

      expect(event, isA<CreateTimeEvent>());
    });
  });

  group('ListTimesState equality', () {
    test('ListTimesLoaded supports equality and hashCode', () {
      // Non-identical list instances to exercise deep equality comparison.
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = ListTimesLoaded(
        // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors, non-const.
        [TimeEntry(id: 1, hour: 2, minutes: 15)],
      );
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = ListTimesLoaded(
        // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors, non-const.
        [TimeEntry(id: 1, hour: 2, minutes: 15)],
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('ListTimesLoaded supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = ListTimesLoaded(
        // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors, non-const.
        [TimeEntry(id: 1, hour: 2, minutes: 15)],
      );
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = ListTimesLoaded(
        // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors, non-const.
        [TimeEntry(id: 2, hour: 5, minutes: 30)],
      );

      expect(a, isNot(equals(b)));
    });

    test('ListTimesError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = ListTimesError(failure);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = ListTimesError(failure);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('ListTimesError supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = ListTimesError(InternalError('a'));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = ListTimesError(InternalError('b'));

      expect(a, isNot(equals(b)));
    });
  });

  group('UpdateTimeState equality', () {
    test('UpdateTimeInitial supports equality and hashCode', () {
      const time = TimeEntry(id: 1, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeInitial(hour: 2, minutes: 30, time: time);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeInitial(hour: 2, minutes: 30, time: time);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateTimeInitial supports inequality for different fields', () {
      const time = TimeEntry(id: 1, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeInitial(hour: 2, minutes: 30, time: time);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeInitial(hour: 5, minutes: 15, time: time);

      expect(a, isNot(equals(b)));
    });

    test('UpdateTimeLoading supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeLoading(hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeLoading(hour: 2, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateTimeLoading supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeLoading(hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeLoading(hour: 4, minutes: 0);

      expect(a, isNot(equals(b)));
    });

    test('UpdateTimeSuccess supports equality and hashCode', () {
      const entry = TimeEntry(id: 1, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeSuccess(entry, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeSuccess(entry, hour: 2, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateTimeSuccess supports inequality for different fields', () {
      const entry1 = TimeEntry(id: 1, hour: 2, minutes: 30);
      const entry2 = TimeEntry(id: 2, hour: 5, minutes: 0);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeSuccess(entry1, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeSuccess(entry2, hour: 5, minutes: 0);

      expect(a, isNot(equals(b)));
    });

    test('UpdateTimeError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeError(failure, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeError(failure, hour: 2, minutes: 30);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateTimeError supports inequality for different fields', () {
      const failure1 = InternalError('a');
      const failure2 = InternalError('b');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateTimeError(failure1, hour: 2, minutes: 30);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateTimeError(failure2, hour: 2, minutes: 30);

      expect(a, isNot(equals(b)));
    });
  });

  group('DeleteTimeState equality', () {
    test('DeleteTimeError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = DeleteTimeError(failure);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = DeleteTimeError(failure);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('DeleteTimeError supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = DeleteTimeError(InternalError('a'));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = DeleteTimeError(InternalError('b'));

      expect(a, isNot(equals(b)));
    });
  });
}
