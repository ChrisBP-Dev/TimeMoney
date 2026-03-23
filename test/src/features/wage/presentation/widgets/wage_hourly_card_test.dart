/// Tests for [WageHourlyCard] widget.
///
/// Verifies that [WageHourlyInfo] and [UpdateWageButton] are rendered
/// inside a [Card] with primary color.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/widgets/update_wage_button.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_card.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_info.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('WageHourlyCard', () {
    const testWage = WageHourly(id: 1, value: 15.5);

    testWidgets('renders WageHourlyInfo with correct wage', (tester) async {
      await tester.pumpApp(
        const WageHourlyCard(wageHourly: testWage),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WageHourlyInfo), findsOneWidget);
      final info = tester.widget<WageHourlyInfo>(find.byType(WageHourlyInfo));
      expect(info.wageHourly, testWage);
    });

    testWidgets('renders UpdateWageButton', (tester) async {
      await tester.pumpApp(
        const WageHourlyCard(wageHourly: testWage),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UpdateWageButton), findsOneWidget);
    });

    testWidgets('renders inside a Card with primary color', (tester) async {
      await tester.pumpApp(
        const WageHourlyCard(wageHourly: testWage),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      final card = tester.widget<Card>(find.byType(Card));
      final context = tester.element(find.byType(Card));
      expect(card.color, Theme.of(context).colorScheme.primary);
    });
  });
}
