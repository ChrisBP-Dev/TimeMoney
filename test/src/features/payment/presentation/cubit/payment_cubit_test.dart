/// Tests for [PaymentCubit].
///
/// The cubit combines a wage value and a list of [TimeEntry] objects to
/// determine readiness for payment calculation. Tests verify:
/// - initial state is [PaymentInitial],
/// - setting wage or times alone keeps the cubit in [PaymentInitial],
/// - providing both transitions to [PaymentReady],
/// - clearing times or zeroing wage resets back to [PaymentInitial],
/// - `calculate` returns a `Right` with a correct `PaymentResult` when ready,
///   and a `Left` when the cubit is not ready.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

void main() {
  const useCase = CalculatePaymentUseCase();
  const testEntry = TimeEntry(hour: 2, minutes: 30, id: 1);
  const testEntry2 = TimeEntry(hour: 1, minutes: 0, id: 2);

  // PaymentCubit orchestrates the "are we ready to
  // calculate?" logic by combining wage + time entries.
  group('PaymentCubit', () {
    // On creation the cubit must be in the idle state so
    // the UI shows "enter wage and times" guidance.
    test('initial state is PaymentInitial', () async {
      final cubit = PaymentCubit(useCase);
      expect(cubit.state, const PaymentInitial());
      await cubit.close();
    });

    // Wage alone is not enough — the cubit must stay in
    // PaymentInitial until time entries are also provided.
    blocTest<PaymentCubit, PaymentState>(
      'setWage alone re-emits PaymentInitial (no dedup in bloc 8.x)',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setWage(15),
      expect: () => [const PaymentInitial()],
    );

    // Time entries alone are not enough — without a wage
    // rate, payment cannot be calculated.
    blocTest<PaymentCubit, PaymentState>(
      'setTimes alone (non-empty, no wage) re-emits PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setTimes([testEntry]),
      expect: () => [const PaymentInitial()],
    );

    // An empty list is semantically "no entries" — cubit
    // must stay initial even if setTimes was called.
    blocTest<PaymentCubit, PaymentState>(
      'setTimes with empty list alone re-emits PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setTimes([]),
      expect: () => [const PaymentInitial()],
    );

    // Happy path order 1: user sets wage first, then adds
    // times. Both inputs present transitions to Ready.
    blocTest<PaymentCubit, PaymentState>(
      'wage then times emits PaymentInitial then PaymentReady',
      build: () => PaymentCubit(useCase),
      act: (c) {
        c
          ..setWage(15)
          ..setTimes([testEntry]);
      },
      expect: () => [
        const PaymentInitial(),
        const PaymentReady(times: [testEntry], wageHourly: 15),
      ],
    );

    // Happy path order 2: user adds times first, then
    // sets wage. Order must not matter for readiness.
    blocTest<PaymentCubit, PaymentState>(
      'times then wage emits PaymentInitial then PaymentReady',
      build: () => PaymentCubit(useCase),
      act: (c) {
        c
          ..setTimes([testEntry])
          ..setWage(15);
      },
      expect: () => [
        const PaymentInitial(),
        const PaymentReady(times: [testEntry], wageHourly: 15),
      ],
    );

    // When already ready, adding more entries must emit a
    // new PaymentReady with updated data for recalculation.
    blocTest<PaymentCubit, PaymentState>(
      'update times while PaymentReady emits new PaymentReady',
      build: () => PaymentCubit(useCase),
      act: (c) {
        c
          ..setWage(15)
          ..setTimes([testEntry])
          ..setTimes([testEntry, testEntry2]);
      },
      expect: () => [
        const PaymentInitial(),
        const PaymentReady(times: [testEntry], wageHourly: 15),
        const PaymentReady(
          times: [testEntry, testEntry2],
          wageHourly: 15,
        ),
      ],
    );

    // Clearing all entries invalidates readiness — the
    // cubit must revert so the calculate button disables.
    blocTest<PaymentCubit, PaymentState>(
      'setTimes empty resets from PaymentReady to PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) {
        c
          ..setWage(15)
          ..setTimes([testEntry])
          ..setTimes([]);
      },
      expect: () => [
        const PaymentInitial(),
        const PaymentReady(times: [testEntry], wageHourly: 15),
        const PaymentInitial(),
      ],
    );

    // Zero wage means "not configured" — even with entries,
    // the cubit must revert to prevent a $0 calculation.
    blocTest<PaymentCubit, PaymentState>(
      'setWage zero resets from PaymentReady to PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) {
        c
          ..setWage(15)
          ..setTimes([testEntry])
          ..setWage(0);
      },
      expect: () => [
        const PaymentInitial(),
        const PaymentReady(times: [testEntry], wageHourly: 15),
        const PaymentInitial(),
      ],
    );

    // When the cubit is ready, calculate() must delegate
    // to the use case and return a Right with all fields
    // populated (hours, minutes, payment, wage, days).
    test(
      'calculate() when PaymentReady returns Right with all fields',
      () async {
      final cubit = PaymentCubit(useCase)
        ..setTimes([testEntry])
        ..setWage(20);

      final result = cubit.calculate();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentResult) {
          expect(paymentResult.totalHours, 2);
          expect(paymentResult.totalMinutes, 30);
          expect(paymentResult.totalPayment, 50.0);
          expect(paymentResult.wageHourly, 20.0);
          expect(paymentResult.workedDays, 1);
        },
      );
      await cubit.close();
    });

    // Calling calculate() without both wage and entries
    // must return Left — protects against premature usage
    // if the UI button enable logic has a bug.
    test('calculate() when PaymentInitial returns Left', () async {
      final cubit = PaymentCubit(useCase);

      final result = cubit.calculate();

      expect(result.isLeft(), true);
      await cubit.close();
    });
  });
}
