/// Tests for [IconText] widget.
///
/// Verifies text content rendering inside [FittedBox], default and custom
/// fontSize creating matching [SizedBox] dimensions, and
/// [TextScaler.noScaling].
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/shared/widgets/icon_text.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('IconText', () {
    testWidgets('renders text content inside FittedBox', (tester) async {
      await tester.pumpApp(const IconText('⚠️'));

      expect(find.text('⚠️'), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('⚠️'),
          matching: find.byType(FittedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('default fontSize creates 60x60 SizedBox', (tester) async {
      await tester.pumpApp(const IconText('⚠️'));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 60);
      expect(sizedBox.height, 60);
    });

    testWidgets('custom fontSize creates matching SizedBox', (tester) async {
      await tester.pumpApp(const IconText('⚠️', fontSize: 100));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 100);
      expect(sizedBox.height, 100);
    });

    testWidgets('uses TextScaler.noScaling', (tester) async {
      await tester.pumpApp(const IconText('⚠️'));

      final text = tester.widget<Text>(find.text('⚠️'));
      expect(text.textScaler, TextScaler.noScaling);
    });
  });
}
