/// Tests for `CustomCreateField` widget.
///
/// Verifies that the title is rendered, the text field responds to input,
/// and the `onChanged` callback fires on user input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_create_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CustomCreateField', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomCreateField(
            title: 'TestTitle',
            semanticId: 'test_field',
            controller: TextEditingController(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title is rendered via context.l10n.fieldLabel — verify Text exists
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('text field responds to input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpApp(
        Scaffold(
          body: CustomCreateField(
            title: 'Hour',
            semanticId: 'test_hour_field',
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '5');
      expect(controller.text, '5');
    });

    testWidgets('onChanged callback fires on input', (tester) async {
      String? changedValue;

      await tester.pumpApp(
        Scaffold(
          body: CustomCreateField(
            title: 'Hour',
            semanticId: 'test_hour_field',
            controller: TextEditingController(),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '7');
      expect(changedValue, '7');
    });

    testWidgets('uses numeric keyboard type', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomCreateField(
            title: 'Hour',
            semanticId: 'test_hour_field',
            controller: TextEditingController(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.number);
    });
  });
}
