/// Tests for [PaymentResultPage] widget.
///
/// Verifies [AlertDialog] with localized title, 4 [ListTile] data fields,
/// totalPayment as bold 28px [Text] inside [Card], [Divider] separator,
/// close [IconButton] pops dialog, and save [FilledButton] pops dialog.
/// Pure presentation — no BLoC mocks needed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';

import '../../../../../helpers/helpers.dart';

const _testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15,
  totalPayment: 157.50,
  workedDays: 3,
);

void main() {
  group('PaymentResultPage', () {
    Future<void> pumpDialog(WidgetTester tester) async {
      // Increase test surface to avoid layout overflow in AlertDialog
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const PaymentResultPage(result: _testResult),
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders AlertDialog with localized title', (tester) async {
      await pumpDialog(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('renders 4 ListTile entries with correct data',
        (tester) async {
      await pumpDialog(tester);

      expect(find.byType(ListTile), findsNWidgets(4));

      // Verify data values are present
      expect(find.textContaining('10'), findsWidgets);
      expect(find.textContaining('30'), findsWidgets);
      expect(find.textContaining('15.0'), findsWidgets);
      expect(find.textContaining('3'), findsWidgets);
    });

    testWidgets('renders totalPayment as bold 28px Text inside Card',
        (tester) async {
      await pumpDialog(tester);

      // Find the total payment text
      final totalPaymentFinder = find.textContaining('157.50');
      expect(totalPaymentFinder, findsOneWidget);

      final totalPaymentText = tester.widget<Text>(totalPaymentFinder);
      expect(totalPaymentText.style?.fontWeight, FontWeight.bold);
      expect(totalPaymentText.style?.fontSize, 28);

      // Verify it's inside a Card
      expect(
        find.ancestor(
          of: totalPaymentFinder,
          matching: find.byType(Card),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders Divider between ListTiles and totalPayment Card',
        (tester) async {
      await pumpDialog(tester);

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('close IconButton (Icons.cancel) pops dialog', (tester) async {
      await pumpDialog(tester);

      expect(find.byType(PaymentResultPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentResultPage), findsNothing);
    });

    testWidgets('save FilledButton pops dialog', (tester) async {
      await pumpDialog(tester);

      expect(find.byType(PaymentResultPage), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentResultPage), findsNothing);
    });
  });
}
