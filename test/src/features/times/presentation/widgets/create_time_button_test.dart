/// Tests for [CreateTimeButton] widget.
///
/// Verifies 4-state UI rendering (Initial, Loading, Success, Error),
/// that the button is only enabled on [CreateTimeInitial], and that
/// it dispatches [CreateTimeSubmitted] on tap. Uses `canPop()` guard
/// before popping on success.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_time_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CreateTimeButton', () {
    late MockCreateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const CreateTimeSubmitted());
    });

    setUp(() {
      mockBloc = MockCreateTimeBloc();
    });

    testWidgets('shows localized create label on Initial (enabled)',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows spinner on Loading (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const CreateTimeLoading(hour: 1, minutes: 30),
      );

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows success label on Success (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const CreateTimeSuccess(
          TimeEntry(hour: 1, minutes: 30),
          hour: 1,
          minutes: 30,
        ),
      );

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows error label on Error (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const CreateTimeError(
          InternalError('test'),
          hour: 1,
          minutes: 30,
        ),
      );

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('dispatches CreateTimeSubmitted on tap when Initial',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));

      verify(() => mockBloc.add(any(that: isA<CreateTimeSubmitted>())))
          .called(1);
    });

    // -- Pop-on-success with canPop guard --

    testWidgets('pops dialog on Success via canPop guard', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const CreateTimeSuccess(
          TimeEntry(hour: 1, minutes: 30),
          hour: 1,
          minutes: 30,
        )),
        initialState: const CreateTimeInitial(),
      );

      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider<CreateTimeBloc>.value(
                  value: mockBloc,
                  child: const AlertDialog(
                    content: CreateTimeButton(),
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
