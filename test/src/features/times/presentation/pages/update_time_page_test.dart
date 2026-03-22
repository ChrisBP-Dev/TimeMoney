/// Tests for [UpdateTimePage] widget.
///
/// Verifies that [UpdateTimePage] renders an [AlertDialog] with
/// [UpdateTimeCard] and [UpdateTimeButton], and that the close button
/// pops the dialog.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/update_time_page.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateTimePage', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockUpdateBloc;

    setUp(() {
      mockUpdateBloc = MockUpdateTimeBloc();
      when(() => mockUpdateBloc.state).thenReturn(
        const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
      );
    });

    testWidgets(
      'renders AlertDialog with UpdateTimeCard and UpdateTimeButton',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => BlocProvider<UpdateTimeBloc>.value(
                      value: mockUpdateBloc,
                      child: const UpdateTimePage(time: testTime),
                    ),
                  ),
                  child: const Text('open'),
                );
              },
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('open'));
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(UpdateTimeCard), findsOneWidget);
        expect(find.byType(UpdateTimeButton), findsOneWidget);
      },
    );

    testWidgets('close button pops dialog', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider<UpdateTimeBloc>.value(
                    value: mockUpdateBloc,
                    child: const UpdateTimePage(time: testTime),
                  ),
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('open'));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
