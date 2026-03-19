import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

void main() {
  const useCase = CalculatePaymentUseCase();

  group('CalculatePaymentUseCase', () {
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
