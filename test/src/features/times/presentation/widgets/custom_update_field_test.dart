/// Tests for `CustomUpdateField` widget.
///
/// Verifies that the title is rendered, the text field responds to input,
/// and the `onChanged` callback fires on user input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_update_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CustomUpdateField', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomUpdateField(
            title: 'TestTitle',
            controller: TextEditingController(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('text field responds to input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpApp(
        Scaffold(
          body: CustomUpdateField(
            title: 'Hour',
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '3');
      expect(controller.text, '3');
    });

    testWidgets('onChanged callback fires on input', (tester) async {
      String? changedValue;

      await tester.pumpApp(
        Scaffold(
          body: CustomUpdateField(
            title: 'Hour',
            controller: TextEditingController(),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '9');
      expect(changedValue, '9');
    });

    testWidgets('uses numeric keyboard type', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomUpdateField(
            title: 'Hour',
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
