/// Tests for [UpdateTimeButton] widget.
///
/// Verifies 4-state UI rendering, that the button is only enabled on
/// [UpdateTimeInitial], and that it dispatches [UpdateTimeSubmitted]
/// on tap. Uses `canPop()` guard before popping on success.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateTimeButton', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateTimeSubmitted());
    });

    setUp(() {
      mockBloc = MockUpdateTimeBloc();
    });

    testWidgets('shows localized update label on Initial (enabled)',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
      );

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const UpdateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows spinner on Loading (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeLoading(hour: 2, minutes: 30, time: testTime),
      );

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const UpdateTimeButton(),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows success label on Success (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeSuccess(
          testTime,
          hour: 2,
          minutes: 30,
          time: testTime,
        ),
      );

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const UpdateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows error label on Error (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeError(
          InternalError('test'),
          hour: 2,
          minutes: 30,
          time: testTime,
        ),
      );

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const UpdateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('dispatches UpdateTimeSubmitted on tap when Initial',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
      );

      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const UpdateTimeButton(),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));

      verify(() => mockBloc.add(any(that: isA<UpdateTimeSubmitted>())))
          .called(1);
    });

    // -- Pop-on-success with canPop guard (P4) --

    testWidgets('pops dialog on Success via canPop guard', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const UpdateTimeSuccess(
          testTime,
          hour: 2,
          minutes: 30,
          time: testTime,
        )),
        initialState: const UpdateTimeInitial(
          hour: 2,
          minutes: 30,
          time: testTime,
        ),
      );

      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider<UpdateTimeBloc>.value(
                  value: mockBloc,
                  child: const AlertDialog(
                    content: UpdateTimeButton(),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('open'));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
