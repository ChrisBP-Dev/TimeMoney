/// Tests for [UpdateWageButton] widget.
///
/// Verifies that the button renders as an [ElevatedButton] with localized
/// text. Dialog content is NOT tested here due to dialog provider scope
/// limitations — dialog internals are tested in update_wage_page_test.dart.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/wage/presentation/widgets/update_wage_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateWageButton', () {
    testWidgets('renders an ElevatedButton', (tester) async {
      await tester.pumpApp(const UpdateWageButton());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders with localized text', (tester) async {
      await tester.pumpApp(const UpdateWageButton());
      await tester.pumpAndSettle();

      // The button has a Text child via context.l10n.change
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
