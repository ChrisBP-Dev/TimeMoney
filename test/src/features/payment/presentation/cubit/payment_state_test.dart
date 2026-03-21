/// Equality and hashCode tests for [PaymentState] sealed hierarchy.
///
/// Exercises the `operator ==` and `hashCode` implementations with
/// non-identical instances to cover branches bypassed when BLoC tests
/// use canonicalized `const` values.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

void main() {
  group('PaymentState equality', () {
    test('PaymentInitial supports equality and hashCode', () {
      // Non-const to avoid Dart const canonicalization (identical bypass).
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = PaymentInitial();
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = PaymentInitial();

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('PaymentReady supports equality and hashCode', () {
      const times = [TimeEntry(id: 1, hour: 2, minutes: 30)];
      // ignore: prefer_const_constructors, non-const to test equality body.
      final a = PaymentReady(times: times, wageHourly: 15);
      // ignore: prefer_const_constructors, non-const to test equality body.
      final b = PaymentReady(times: times, wageHourly: 15);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });
}
