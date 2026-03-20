/// Tests for [ErrorFetchWageHourlyView] widget.
///
/// Verifies that [ErrorView] is rendered with the given [GlobalFailure]
/// and that the optional actionWidget is displayed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart';
import 'package:time_money/src/shared/widgets/error_view.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('ErrorFetchWageHourlyView', () {
    const testFailure = InternalError('test error');

    testWidgets('renders ErrorView with failure', (tester) async {
      await tester.pumpApp(
        const ErrorFetchWageHourlyView(
          testFailure,
          actionWidget: null,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('displays optional actionWidget when provided',
        (tester) async {
      await tester.pumpApp(
        const ErrorFetchWageHourlyView(
          testFailure,
          actionWidget: Text('retry'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is Text && w.data == 'retry'),
        findsOneWidget,
      );
    });
  });
}
