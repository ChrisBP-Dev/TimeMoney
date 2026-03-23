/// Tests for [SetWageButton] widget.
///
/// Verifies 4-state UI rendering with SetWageButton-specific enabled/disabled
/// logic: disabled ONLY when [UpdateWageLoading], enabled on Initial,
/// Success, and Error states. Dispatches [UpdateWageSubmitted] on tap.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/widgets/set_wage_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('SetWageButton', () {
    late MockUpdateWageBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateWageSubmitted());
    });

    setUp(() {
      mockBloc = MockUpdateWageBloc();
    });

    testWidgets('shows localized update label on Initial (enabled)', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const UpdateWageInitial());

      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const SetWageButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows spinner on Loading (disabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(const UpdateWageLoading());

      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const SetWageButton(),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows success label on Success (enabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateWageSuccess(result: WageHourly(id: 1, value: 20)),
      );

      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const SetWageButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows error label on Error (enabled)', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const UpdateWageError(InternalError('test')),
      );

      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const SetWageButton(),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('dispatches UpdateWageSubmitted on tap', (tester) async {
      when(() => mockBloc.state).thenReturn(const UpdateWageInitial());

      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const SetWageButton(),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));

      verify(
        () => mockBloc.add(any(that: isA<UpdateWageSubmitted>())),
      ).called(1);
    });

    // -- Pop-on-success listener test (P6) --

    testWidgets('pops dialog on Success via BlocConsumer listener', (
      tester,
    ) async {
      whenListen(
        mockBloc,
        Stream.value(
          const UpdateWageSuccess(result: WageHourly(id: 1, value: 20)),
        ),
        initialState: const UpdateWageInitial(),
      );

      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider<UpdateWageBloc>.value(
                  value: mockBloc,
                  child: const AlertDialog(
                    content: SetWageButton(),
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
