/// Tests for [CalculatePaymentUseCase].
///
/// This use case is a pure, synchronous computation with no repository
/// dependency. Tests validate correct aggregation of hours, minutes, payment
/// totals, worked-day counts, edge cases (zero entries, zero wage), and a
/// non-functional performance requirement (NFR4: < 50 ms for 100 entries).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// A fake [List] that throws on iteration, used to trigger the
/// defensive catch block in [CalculatePaymentUseCase].
class _ThrowingTimesList extends Fake implements List<TimeEntry> {
  @override
  Iterator<TimeEntry> get iterator => throw StateError('intentional');
}

void main() {
  // ignore: prefer_const_constructors, non-const to cover constructor line.
  final useCase = CalculatePaymentUseCase();

  // Core business logic: aggregate time entries + hourly
  // wage into a payment summary. Pure function, no I/O.
  group('CalculatePaymentUseCase', () {
    // Happy path with multiple entries verifying hours
    // roll over from minutes, payment = rate * total hours,
    // and workedDays counts distinct entries.
    test('standard input returns correct PaymentResult', () {
      final times = [
        const TimeEntry(hour: 3, minutes: 30, id: 1),
        const TimeEntry(hour: 1, minutes: 45, id: 2),
      ];

      final result = useCase(times, 20);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentResult) {
          expect(paymentResult.totalHours, 5);
          expect(paymentResult.totalMinutes, 15);
          expect(paymentResult.wageHourly, 20);
          expect(paymentResult.totalPayment, 105.0);
          expect(paymentResult.workedDays, 2);
        },
      );
    });

    // Edge case: no time entries logged yet. Must still
    // succeed (Right) with all-zero totals, not error out.
    test('zero entries returns Right with zeroed PaymentResult', () {
      final result = useCase([], 20);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentResult) {
          expect(
            paymentResult,
            const PaymentResult(
              totalHours: 0,
              totalMinutes: 0,
              wageHourly: 20,
              totalPayment: 0,
              workedDays: 0,
            ),
          );
        },
      );
    });

    // Edge case: user set wage to 0 (volunteer/unpaid).
    // Hours/days are still tracked; only payment is zero.
    test('zero wage returns Right with zero totalPayment', () {
      final times = [const TimeEntry(hour: 1, minutes: 0, id: 1)];

      final result = useCase(times, 0);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentResult) {
          expect(
            paymentResult,
            const PaymentResult(
              totalHours: 1,
              totalMinutes: 0,
              wageHourly: 0,
              totalPayment: 0,
              workedDays: 1,
            ),
          );
        },
      );
    });

    // Simplest happy path: one entry, no leftover minutes.
    // Validates the basic multiplication: 2h * $15 = $30.
    test('single entry exact hours returns correct totalPayment', () {
      final times = [const TimeEntry(hour: 2, minutes: 0, id: 1)];

      final result = useCase(times, 15);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentResult) {
          expect(paymentResult.totalPayment, 30.0);
        },
      );
    });

    // Defensive catch block: when the list throws during
    // computation, the use case wraps it in a Left(InternalError).
    test('returns Left(InternalError) when computation throws', () {
      final result = useCase(_ThrowingTimesList(), 10);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InternalError>()),
        (_) => fail('Expected Left'),
      );
    });

    // NFR4 performance gate: 100 entries must compute in
    // <50ms to keep the UI responsive on low-end devices.
    test('large data set completes under 50ms (NFR4)', () {
      final times = List.generate(
        100,
        (i) => TimeEntry(hour: i % 12, minutes: i % 60, id: i),
      );

      final stopwatch = Stopwatch()..start();
      final result = useCase(times, 25);
      stopwatch.stop();

      expect(result.isRight(), true);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
  });
}
