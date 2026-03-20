/// Tests for [UpdateTimePage] widget.
///
/// Verifies that [UpdateTimePage] renders an [AlertDialog] with
/// [UpdateTimeCard], [DeleteTimeButton], and [UpdateTimeButton].
/// Needs [MockUpdateTimeBloc] and [MockDeleteTimeBloc].
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/update_time_page.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateTimePage', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockUpdateBloc;
    late MockDeleteTimeBloc mockDeleteBloc;

    setUp(() {
      mockUpdateBloc = MockUpdateTimeBloc();
      mockDeleteBloc = MockDeleteTimeBloc();
      when(() => mockUpdateBloc.state).thenReturn(
        const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
      );
      when(() => mockDeleteBloc.state).thenReturn(const DeleteTimeInitial());
    });

    testWidgets('renders AlertDialog with UpdateTimeCard, DeleteTimeButton, '
        'and UpdateTimeButton', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<UpdateTimeBloc>.value(
                        value: mockUpdateBloc,
                      ),
                      BlocProvider<DeleteTimeBloc>.value(
                        value: mockDeleteBloc,
                      ),
                    ],
                    child: const UpdateTimePage(time: testTime),
                  ),
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(UpdateTimeCard), findsOneWidget);
      expect(find.byType(DeleteTimeButton), findsOneWidget);
      expect(find.byType(UpdateTimeButton), findsOneWidget);
    });

    testWidgets('close button pops dialog', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<UpdateTimeBloc>.value(
                        value: mockUpdateBloc,
                      ),
                      BlocProvider<DeleteTimeBloc>.value(
                        value: mockDeleteBloc,
                      ),
                    ],
                    child: const UpdateTimePage(time: testTime),
                  ),
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
