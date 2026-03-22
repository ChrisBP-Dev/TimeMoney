/// Tests for [UpdateMinutesField] widget.
///
/// Verifies that [UpdateMinutesField] pre-populates from BLoC state
/// and dispatches [UpdateTimeMinutesChanged] events on input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_minutes_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateMinutesField', () {
    late MockUpdateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateTimeMinutesChanged(value: '0'));
    });

    setUp(() {
      mockBloc = MockUpdateTimeBloc();
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeInitial(
          hour: 2,
          minutes: 30,
          time: TimeEntry(id: 1, hour: 2, minutes: 30),
        ),
      );
    });

    testWidgets('pre-populates with minutes from BLoC state', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateMinutesField()),
        ),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '30');
    });

    testWidgets('dispatches UpdateTimeMinutesChanged on input', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateMinutesField()),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), '45');

      verify(
        () => mockBloc.add(any(that: isA<UpdateTimeMinutesChanged>())),
      ).called(1);
    });

    // -- BS1: null time pre-population edge case --

    testWidgets('field is empty when BLoC state has null time', (tester) async {
      when(() => mockBloc.state).thenReturn(const UpdateTimeInitial());

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateMinutesField()),
        ),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });
}
