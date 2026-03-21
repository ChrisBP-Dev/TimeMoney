/// Equality and hashCode tests for all wage-feature BLoC state sealed
/// hierarchies.
///
/// Exercises the `operator ==` and `hashCode` implementations with
/// non-identical instances to cover branches bypassed when BLoC tests
/// use canonicalized `const` values.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

void main() {
  // Non-const instantiation avoids Dart const canonicalization, ensuring
  // the full operator == body is reached (not short-circuited by identical).

  group('FetchWageState equality', () {
    test('FetchWageLoaded supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = FetchWageLoaded(WageHourly(id: 1));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = FetchWageLoaded(WageHourly(id: 1));

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('FetchWageLoaded supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = FetchWageLoaded(WageHourly(id: 1, value: 10));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = FetchWageLoaded(WageHourly(id: 2, value: 20));

      expect(a, isNot(equals(b)));
    });

    test('FetchWageError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = FetchWageError(failure);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = FetchWageError(failure);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('FetchWageError supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = FetchWageError(InternalError('a'));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = FetchWageError(InternalError('b'));

      expect(a, isNot(equals(b)));
    });
  });

  group('UpdateWageState equality', () {
    test('UpdateWageInitial supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageInitial();
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageInitial();

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateWageInitial supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageInitial(wageHourly: WageHourly(id: 1, value: 10));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageInitial(wageHourly: WageHourly(id: 2, value: 25));

      expect(a, isNot(equals(b)));
    });

    test('UpdateWageLoading supports equality and hashCode', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageLoading();
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageLoading();

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateWageLoading supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageLoading(wageHourly: WageHourly(id: 1, value: 10));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageLoading(wageHourly: WageHourly(id: 2, value: 25));

      expect(a, isNot(equals(b)));
    });

    test('UpdateWageSuccess supports equality and hashCode', () {
      const wage = WageHourly(id: 1, value: 20);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageSuccess(result: wage);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageSuccess(result: wage);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateWageSuccess supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageSuccess(result: WageHourly(id: 1, value: 10));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageSuccess(result: WageHourly(id: 2, value: 20));

      expect(a, isNot(equals(b)));
    });

    test('UpdateWageError supports equality and hashCode', () {
      const failure = InternalError('test');
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageError(failure);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageError(failure);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('UpdateWageError supports inequality for different fields', () {
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = UpdateWageError(InternalError('a'));
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = UpdateWageError(InternalError('b'));

      expect(a, isNot(equals(b)));
    });
  });
}
