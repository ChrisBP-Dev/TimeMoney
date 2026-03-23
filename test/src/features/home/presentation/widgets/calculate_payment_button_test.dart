/// Tests for [CalculatePaymentButton] widget.
///
/// Verifies FAB rendering with localized label, disabled on [PaymentInitial],
/// enabled on [PaymentReady], tap calls calculate() on [PaymentCubit],
/// [Right] result opens [PaymentResultPage] dialog, and [Left] result
/// does not open dialog.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/home/presentation/widgets/calculate_payment_button.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

import '../../../../../helpers/helpers.dart';

const _testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15,
  totalPayment: 157.50,
  workedDays: 3,
);

const _testTimes = [
  TimeEntry(id: 1, hour: 5, minutes: 15),
  TimeEntry(id: 2, hour: 3, minutes: 45),
  TimeEntry(id: 3, hour: 1, minutes: 30),
];

void main() {
  late MockPaymentCubit mockPaymentCubit;

  setUp(() {
    mockPaymentCubit = MockPaymentCubit();
    when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());
  });

  Widget buildSubject() {
    return BlocProvider<PaymentCubit>.value(
      value: mockPaymentCubit,
      child: const CalculatePaymentButton(),
    );
  }

  group('CalculatePaymentButton', () {
    testWidgets('renders FloatingActionButton.extended with localized label', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FloatingActionButton), findsOneWidget);
      // Localized calculatePayment label is present
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.isExtended, isTrue);
    });

    testWidgets('onPressed is null when PaymentInitial (disabled)', (
      tester,
    ) async {
      when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());

      await tester.pumpApp(buildSubject());

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.onPressed, isNull);
    });

    testWidgets('onPressed is non-null when PaymentReady (enabled)', (
      tester,
    ) async {
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentReady(times: _testTimes, wageHourly: 15),
      );
      when(() => mockPaymentCubit.calculate()).thenReturn(right(_testResult));

      await tester.pumpApp(buildSubject());

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.onPressed, isNotNull);
    });

    testWidgets('tap calls mockPaymentCubit.calculate()', (tester) async {
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentReady(times: _testTimes, wageHourly: 15),
      );
      when(() => mockPaymentCubit.calculate()).thenReturn(right(_testResult));

      // Increase surface to avoid dialog overflow
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(buildSubject());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(() => mockPaymentCubit.calculate()).called(1);
    });

    testWidgets('on Right(PaymentResult) showDialog opens PaymentResultPage', (
      tester,
    ) async {
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentReady(times: _testTimes, wageHourly: 15),
      );
      when(() => mockPaymentCubit.calculate()).thenReturn(right(_testResult));

      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(buildSubject());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentResultPage), findsOneWidget);
    });

    testWidgets('on Left(GlobalFailure) no dialog opens', (tester) async {
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentReady(times: _testTimes, wageHourly: 15),
      );
      when(
        () => mockPaymentCubit.calculate(),
      ).thenReturn(left(const InternalError('test error')));

      await tester.pumpApp(buildSubject());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentResultPage), findsNothing);
      verify(() => mockPaymentCubit.calculate()).called(1);
    });
  });
}
