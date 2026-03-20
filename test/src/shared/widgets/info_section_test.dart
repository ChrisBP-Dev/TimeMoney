/// Tests for [ShowInfoSection] widget.
///
/// Verifies centered message rendering, optional image with bottom padding,
/// optional action widget inside [SizedBox], null-safe optional parameters,
/// and [Spacer] count differences based on actionWidget presence.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/shared/widgets/info_section.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ShowInfoSection', () {
    testWidgets('renders infoMessage text centered', (tester) async {
      await tester.pumpApp(
        const ShowInfoSection(infoMessage: 'Test message'),
      );

      expect(find.text('Test message'), findsOneWidget);

      final text = tester.widget<Text>(find.text('Test message'));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('renders infoImage when provided with bottom 32px padding',
        (tester) async {
      await tester.pumpApp(
        const ShowInfoSection(
          infoMessage: 'Test',
          infoImage: Icon(Icons.error),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);

      // Verify 32px bottom padding on image wrapper
      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byIcon(Icons.error),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, const EdgeInsets.only(bottom: 32));
    });

    testWidgets('hides image area when infoImage is null', (tester) async {
      await tester.pumpApp(
        const ShowInfoSection(infoMessage: 'Test'),
      );

      // Only the horizontal padding around the text should exist
      final paddingWidgets =
          tester.widgetList<Padding>(find.byType(Padding)).toList();
      // None should have bottom: 32 (image padding)
      final imagePaddings = paddingWidgets.where(
        (p) => p.padding == const EdgeInsets.only(bottom: 32),
      );
      expect(imagePaddings, isEmpty);
    });

    testWidgets('renders actionWidget when provided inside 60-height SizedBox',
        (tester) async {
      await tester.pumpApp(
        const ShowInfoSection(
          infoMessage: 'Test',
          actionWidget: ElevatedButton(
            onPressed: null,
            child: Text('Retry'),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);

      // Verify the SizedBox wrapper with height 60
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Retry'),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 60);
    });

    testWidgets('hides action area when actionWidget is null', (tester) async {
      await tester.pumpApp(
        const ShowInfoSection(infoMessage: 'Test'),
      );

      // No SizedBox with height 60 should exist
      final sizedBoxes =
          tester.widgetList<SizedBox>(find.byType(SizedBox)).toList();
      final actionSizedBoxes = sizedBoxes.where((s) => s.height == 60);
      expect(actionSizedBoxes, isEmpty);
    });

    testWidgets(
        'renders 2 Spacers when actionWidget is null, '
        '3 Spacers when actionWidget is provided', (tester) async {
      // Without action widget — expect 2 Spacers
      await tester.pumpApp(
        const ShowInfoSection(infoMessage: 'Test without action'),
      );

      expect(find.byType(Spacer), findsNWidgets(2));

      // With action widget — expect 3 Spacers
      await tester.pumpApp(
        const ShowInfoSection(
          infoMessage: 'Test with action',
          actionWidget: ElevatedButton(
            onPressed: null,
            child: Text('Action'),
          ),
        ),
      );

      expect(find.byType(Spacer), findsNWidgets(3));
    });
  });
}
