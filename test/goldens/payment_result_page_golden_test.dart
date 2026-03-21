/// Golden tests for [PaymentResultPage] visual regression verification.
///
/// Captures a snapshot of the payment result dialog with test data to
/// detect unintended layout or styling changes. Pure presentation — no
/// BLoC mocks needed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';

import '../helpers/helpers.dart';

void main() {
  group('PaymentResultPage Golden', () {
    testWidgets('renders correctly with payment data', (tester) async {
      const testResult = PaymentResult(
        totalHours: 10,
        totalMinutes: 30,
        wageHourly: 15,
        totalPayment: 157.50,
        workedDays: 3,
      );

      await tester.pumpGoldenApp(
        const PaymentResultPage(result: testResult),
        size: const Size(800, 1200),
      );

      await expectLater(
        find.byType(PaymentResultPage),
        matchesGoldenFile('payment_result_page.png'),
      );
    });
  });
}
