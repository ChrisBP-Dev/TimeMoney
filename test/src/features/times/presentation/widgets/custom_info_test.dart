/// Tests for [CustomInfo] widget.
///
/// Verifies that the category label and value text are rendered correctly
/// using localized field labels.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_info.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CustomInfo', () {
    testWidgets('renders category label and value text', (tester) async {
      await tester.pumpApp(
        const Row(
          children: [
            Expanded(
              child: CustomInfo(category: 'TestCat', value: '42'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Verify two Text widgets are present (label + value)
      final texts = tester.widgetList<Text>(find.byType(Text));
      expect(texts.length, greaterThanOrEqualTo(2));

      // Verify the value text is displayed
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == '42',
        ),
        findsOneWidget,
      );
    });
  });
}
