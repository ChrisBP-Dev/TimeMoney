/// Tests for [ShimmerListTimesView] and [EmptyListTimesView] widgets.
///
/// Verifies that the shimmer view shows a progress indicator and the
/// empty view shows the informational section with icon and message.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/presentation/widgets/list_times_other_view.dart';
import 'package:time_money/src/shared/widgets/icon_text.dart';
import 'package:time_money/src/shared/widgets/info_section.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('ShimmerListTimesView', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpApp(const ShimmerListTimesView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('EmptyListTimesView', () {
    testWidgets('shows IconText and ShowInfoSection', (tester) async {
      await tester.pumpApp(const EmptyListTimesView());
      await tester.pumpAndSettle();

      expect(find.byType(ShowInfoSection), findsOneWidget);
      expect(find.byType(IconText), findsOneWidget);
    });

    testWidgets('displays optional actionWidget when provided', (tester) async {
      await tester.pumpApp(
        const EmptyListTimesView(
          actionWidget: Text('action'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is Text && w.data == 'action'),
        findsOneWidget,
      );
    });
  });
}
