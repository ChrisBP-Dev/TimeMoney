/// Golden tests for [UpdateTimePage] visual regression verification.
///
/// Captures a snapshot of the update-time dialog pre-populated with
/// a test [TimeEntry] to detect unintended layout or styling changes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/update_time_page.dart';

import '../helpers/helpers.dart';

void main() {
  group('UpdateTimePage Golden', () {
    late MockUpdateTimeBloc mockUpdateBloc;

    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);

    setUp(() {
      mockUpdateBloc = MockUpdateTimeBloc();

      when(() => mockUpdateBloc.state).thenReturn(
        const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
      );
    });

    testWidgets('renders correctly with pre-populated data', (tester) async {
      await tester.pumpGoldenApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateBloc,
          child: const UpdateTimePage(time: testTime),
        ),
        size: const Size(800, 1200),
      );

      await expectLater(
        find.byType(UpdateTimePage),
        matchesGoldenFile('update_time_dialog.png'),
      );
    });
  });
}
