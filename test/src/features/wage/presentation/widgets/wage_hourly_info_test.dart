/// Tests for [WageHourlyInfo] widget.
///
/// Verifies that the localized hourly label and the wage value are rendered.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_info.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('WageHourlyInfo', () {
    const testWage = WageHourly(id: 1, value: 15.5);

    testWidgets('renders wage value as text', (tester) async {
      await tester.pumpApp(
        const WageHourlyInfo(wageHourly: testWage),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == '${testWage.value}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders two Text widgets for label and value',
        (tester) async {
      await tester.pumpApp(
        const WageHourlyInfo(wageHourly: testWage),
      );
      await tester.pumpAndSettle();

      // Label (hourlyLabel) + value text
      expect(find.byType(Text), findsNWidgets(2));
    });
  });
}
