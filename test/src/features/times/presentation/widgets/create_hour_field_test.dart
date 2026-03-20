/// Tests for [CreateHourField] widget.
///
/// Verifies that [CreateHourField] dispatches [CreateTimeHourChanged]
/// events on input and auto-clears when the BLoC emits a reset state.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_hour_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CreateHourField', () {
    late MockCreateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const CreateTimeHourChanged(value: '0'));
    });

    setUp(() {
      mockBloc = MockCreateTimeBloc();
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());
    });

    testWidgets('dispatches CreateTimeHourChanged on input', (tester) async {
      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: CreateHourField()),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), '5');

      final captured =
          verify(() => mockBloc.add(captureAny())).captured;
      expect(captured.last, isA<CreateTimeHourChanged>());
    });

    testWidgets('auto-clears when BLoC resets to initial with zero values',
        (tester) async {
      whenListen(
        mockBloc,
        Stream<CreateTimeState>.fromIterable([
          const CreateTimeSuccess(
            TimeEntry(hour: 1, minutes: 30),
            hour: 1,
            minutes: 30,
          ),
          const CreateTimeInitial(),
        ]),
        initialState: const CreateTimeLoading(hour: 1, minutes: 30),
      );

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: CreateHourField()),
        ),
      );

      // Process stream events
      await tester.pump();
      await tester.pump();

      // Controller should be cleared after reset
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });
}
