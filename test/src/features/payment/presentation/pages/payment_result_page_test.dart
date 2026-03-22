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
      // P-2: verify localized title text content
      expect(find.text('Result Info:'), findsOneWidget);
    });

    testWidgets('renders 4 ListTile entries with correct data', (tester) async {
      await pumpDialog(tester);

      expect(find.byType(ListTile), findsNWidgets(4));

      // BS-1: inspect each ListTile subtitle individually instead of
      // loose textContaining assertions that match unintended widgets
      final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
      expect((tiles[0].subtitle! as Text).data, '10');
      expect((tiles[1].subtitle! as Text).data, '30');
      expect((tiles[2].subtitle! as Text).data, '15.0 Dollars');
      expect((tiles[3].subtitle! as Text).data, '3');
    });

    testWidgets('renders totalPayment as bold 28px Text inside Card', (
      tester,
    ) async {
      await pumpDialog(tester);

      // P-3: verify currency prefix is present
      final totalPaymentFinder = find.textContaining(r'$/. 157.50');
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

      // P-4: verify totalPayment is NOT inside a ListTile (per AC3)
      expect(
        find.ancestor(
          of: totalPaymentFinder,
          matching: find.byType(ListTile),
        ),
        findsNothing,
      );
    });

    testWidgets('renders Divider between ListTiles and totalPayment Card', (
      tester,
    ) async {
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
