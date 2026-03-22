/// Tests for [UpdateHourField] widget.
///
/// Verifies that [UpdateHourField] pre-populates from BLoC state and
/// dispatches [UpdateTimeHourChanged] events on input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_hour_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateHourField', () {
    late MockUpdateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateTimeHourChanged(value: '0'));
    });

    setUp(() {
      mockBloc = MockUpdateTimeBloc();
      // Stub state BEFORE pumping — initState reads it
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeInitial(
          hour: 2,
          minutes: 30,
          time: TimeEntry(id: 1, hour: 2, minutes: 30),
        ),
      );
    });

    testWidgets('pre-populates with hour from BLoC state', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateHourField()),
        ),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '2');
    });

    testWidgets('dispatches UpdateTimeHourChanged on input', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateHourField()),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), '5');

      verify(
        () => mockBloc.add(any(that: isA<UpdateTimeHourChanged>())),
      ).called(1);
    });

    // -- BS1: null time pre-population edge case --

    testWidgets('field is empty when BLoC state has null time', (tester) async {
      when(() => mockBloc.state).thenReturn(const UpdateTimeInitial());

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateHourField()),
        ),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });
}
