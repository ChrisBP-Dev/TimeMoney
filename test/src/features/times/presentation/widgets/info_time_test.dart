/// Tests for [InfoTime] widget.
///
/// Verifies that hour and minutes values from a [TimeEntry] are rendered
/// via [CustomInfo] widgets using localized labels.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_info.dart';
import 'package:time_money/src/features/times/presentation/widgets/info_time.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('InfoTime', () {
    const testTime = TimeEntry(hour: 2, minutes: 30);

    testWidgets('renders two CustomInfo widgets for hour and minutes',
        (tester) async {
      await tester.pumpApp(
        const InfoTime(time: testTime),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomInfo), findsNWidgets(2));
    });

    testWidgets('displays hour value as text', (tester) async {
      await tester.pumpApp(
        const InfoTime(time: testTime),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == '${testTime.hour}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays minutes value as text', (tester) async {
      await tester.pumpApp(
        const InfoTime(time: testTime),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == '${testTime.minutes}',
        ),
        findsOneWidget,
      );
    });
  });
}
