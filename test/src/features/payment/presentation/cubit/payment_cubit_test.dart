import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

void main() {
  const useCase = CalculatePaymentUseCase();
  const testEntry = TimeEntry(hour: 2, minutes: 30, id: 1);
  const testEntry2 = TimeEntry(hour: 1, minutes: 0, id: 2);

  group('PaymentCubit', () {
    test('initial state is PaymentInitial', () async {
      final cubit = PaymentCubit(useCase);
      expect(cubit.state, const PaymentInitial());
      await cubit.close();
    });

    blocTest<PaymentCubit, PaymentState>(
      'setWage alone re-emits PaymentInitial (no dedup in bloc 8.x)',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setWage(15),
      expect: () => [const PaymentInitial()],
    );

    blocTest<PaymentCubit, PaymentState>(
      'setTimes alone (non-empty, no wage) re-emits PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setTimes([testEntry]),
      expect: () => [const PaymentInitial()],
    );

    blocTest<PaymentCubit, PaymentState>(
      'setTimes with empty list alone re-emits PaymentInitial',
      build: () => PaymentCubit(useCase),
      act: (c) => c.setTimes([]),
      expect: () => [const PaymentInitial()],
    );

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

    test('calculate() when PaymentInitial returns Left', () async {
      final cubit = PaymentCubit(useCase);

      final result = cubit.calculate();

      expect(result.isLeft(), true);
      await cubit.close();
    });
  });
}
