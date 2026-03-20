/// Tests for [CreateTimeButton] widget.
///
/// Verifies 4-state UI rendering (Initial, Loading, Success, Error),
/// that the button is ALWAYS enabled, and that it dispatches
/// [CreateTimeSubmitted] on tap.
library;

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

    testWidgets('shows localized create label on Initial', (tester) async {
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());

      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const CreateTimeButton(),
        ),
      );
      await tester.pump();

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator on Loading', (tester) async {
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
    });

    testWidgets('shows success label on Success', (tester) async {
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

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('shows error label on Error', (tester) async {
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

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('button is ALWAYS enabled — dispatches on tap',
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

    testWidgets('button is enabled even on Loading state', (tester) async {
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

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });
  });
}
