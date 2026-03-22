/// Tests for [DeleteTimeConfirmationDialog] widget.
///
/// Verifies that the confirmation dialog renders localised title and
/// message, that the cancel button dismisses the dialog without
/// dispatching events, and that the confirm action delegates to
/// [DeleteTimeButton] / [DeleteTimeBloc].
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_confirmation_dialog.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('DeleteTimeConfirmationDialog', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockDeleteTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const DeleteTimeRequested(time: testTime));
    });

    setUp(() {
      mockBloc = MockDeleteTimeBloc();
      when(() => mockBloc.state).thenReturn(const DeleteTimeInitial());
    });

    Future<void> pumpDialog(WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider<DeleteTimeBloc>.value(
                  value: mockBloc,
                  child: const DeleteTimeConfirmationDialog(time: testTime),
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
    }

    testWidgets('renders localised title and message', (tester) async {
      await pumpDialog(tester);

      expect(find.text('Delete Time Entry?'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this entry?'),
        findsOneWidget,
      );
    });

    testWidgets('renders cancel and delete buttons', (tester) async {
      await pumpDialog(tester);

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(DeleteTimeButton), findsOneWidget);
    });

    testWidgets('cancel button pops dialog without dispatching events', (
      tester,
    ) async {
      await pumpDialog(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => mockBloc.add(any()));
    });

    testWidgets('confirm button dispatches DeleteTimeRequested', (
      tester,
    ) async {
      await pumpDialog(tester);

      await tester.tap(find.byType(DeleteTimeButton));

      final captured = verify(() => mockBloc.add(captureAny())).captured;
      final event = captured.last as DeleteTimeRequested;
      expect(event.time, testTime);
    });

    testWidgets('dialog closes on successful deletion', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const DeleteTimeSuccess()),
        initialState: const DeleteTimeInitial(),
      );

      await pumpDialog(tester);

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
