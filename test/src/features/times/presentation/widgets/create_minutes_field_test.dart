/// Tests for [CreateMinutesField] widget.
///
/// Verifies that [CreateMinutesField] dispatches [CreateTimeMinutesChanged]
/// events on input and auto-clears when the BLoC resets.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_minutes_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CreateMinutesField', () {
    late MockCreateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const CreateTimeMinutesChanged(value: '0'));
    });

    setUp(() {
      mockBloc = MockCreateTimeBloc();
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());
    });

    testWidgets('dispatches CreateTimeMinutesChanged on input', (tester) async {
      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: CreateMinutesField()),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), '30');

      final captured = verify(() => mockBloc.add(captureAny())).captured;
      expect(captured.last, isA<CreateTimeMinutesChanged>());
    });

    testWidgets('auto-clears on BLoC reset', (tester) async {
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
          child: const Scaffold(body: CreateMinutesField()),
        ),
      );

      await tester.pump();
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    // -- BS2: listenWhen negative path --

    testWidgets(
      'does NOT auto-clear when previous state is also CreateTimeInitial',
      (tester) async {
        when(() => mockBloc.state).thenReturn(const CreateTimeInitial());

        await tester.pumpApp(
          BlocProvider<CreateTimeBloc>.value(
            value: mockBloc,
            child: const Scaffold(body: CreateMinutesField()),
          ),
        );
        await tester.pump();

        // Enter text in field
        await tester.enterText(find.byType(TextField), '30');

        // Simulate transition from Initial to Initial with zero values
        // listenWhen: previous is! CreateTimeInitial → false, so no clear
        whenListen(
          mockBloc,
          Stream.value(const CreateTimeInitial()),
          initialState: const CreateTimeInitial(minutes: 30),
        );

        await tester.pump();
        await tester.pump();

        // Field should retain its text because listenWhen blocked the listener
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, '30');
      },
    );
  });
}
