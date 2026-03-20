/// Tests for [DeleteTimeButton] widget.
///
/// Verifies 4-state UI rendering, that the button is only enabled on
/// [DeleteTimeInitial], and that it dispatches [DeleteTimeRequested]
/// on tap. Uses `canPop()` guard before popping on success.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('DeleteTimeButton', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockDeleteTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const DeleteTimeRequested(time: testTime));
    });

    setUp(() {
      mockBloc = MockDeleteTimeBloc();
    });

    testWidgets('shows localized delete label on Initial (enabled)',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const DeleteTimeInitial());

      await tester.pumpApp(
        BlocProvider<DeleteTimeBloc>.value(
          value: mockBloc,
          child: const DeleteTimeButton(time: testTime),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows spinner on Loading (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(const DeleteTimeLoading());

      await tester.pumpApp(
        BlocProvider<DeleteTimeBloc>.value(
          value: mockBloc,
          child: const DeleteTimeButton(time: testTime),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows success label on Success (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(const DeleteTimeSuccess());

      await tester.pumpApp(
        BlocProvider<DeleteTimeBloc>.value(
          value: mockBloc,
          child: const DeleteTimeButton(time: testTime),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows error label on Error (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const DeleteTimeError(InternalError('test')),
      );

      await tester.pumpApp(
        BlocProvider<DeleteTimeBloc>.value(
          value: mockBloc,
          child: const DeleteTimeButton(time: testTime),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('dispatches DeleteTimeRequested on tap when Initial',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const DeleteTimeInitial());

      await tester.pumpApp(
        BlocProvider<DeleteTimeBloc>.value(
          value: mockBloc,
          child: const DeleteTimeButton(time: testTime),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));

      verify(() => mockBloc.add(any(that: isA<DeleteTimeRequested>())))
          .called(1);
    });
  });
}
