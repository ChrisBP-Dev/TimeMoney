/// Tests for [ShimmerWageHourlyView] widget.
///
/// Verifies that the shimmer loading view shows a [CircularProgressIndicator].
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_other_view.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('ShimmerWageHourlyView', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpApp(const ShimmerWageHourlyView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
