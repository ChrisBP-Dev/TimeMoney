/// Tests for [TimeCard] widget.
///
/// Verifies that [TimeCard] renders [InfoTime], [EditButton], and a
/// delete [IconButton] with the correct [TimeEntry] data. The delete
/// button opens a [DeleteTimeConfirmationDialog].
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_confirmation_dialog.dart';
import 'package:time_money/src/features/times/presentation/widgets/edit_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/info_time.dart';
import 'package:time_money/src/features/times/presentation/widgets/time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('TimeCard', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockUpdateTimeBloc;
    late MockDeleteTimeBloc mockDeleteTimeBloc;

    setUp(() {
      mockUpdateTimeBloc = MockUpdateTimeBloc();
      mockDeleteTimeBloc = MockDeleteTimeBloc();
      when(
        () => mockUpdateTimeBloc.state,
      ).thenReturn(const UpdateTimeInitial());
      when(
        () => mockDeleteTimeBloc.state,
      ).thenReturn(const DeleteTimeInitial());
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<UpdateTimeBloc>.value(value: mockUpdateTimeBloc),
          BlocProvider<DeleteTimeBloc>.value(value: mockDeleteTimeBloc),
        ],
        child: const TimeCard(time: testTime),
      );
    }

    testWidgets('renders InfoTime with correct TimeEntry data', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(InfoTime), findsOneWidget);
      final infoTime = tester.widget<InfoTime>(find.byType(InfoTime));
      expect(infoTime.time, testTime);
    });

    testWidgets('renders EditButton with correct TimeEntry data', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(EditButton), findsOneWidget);
      final editButton = tester.widget<EditButton>(find.byType(EditButton));
      expect(editButton.time, testTime);
    });

    testWidgets('renders delete IconButton with error color', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('delete button opens DeleteTimeConfirmationDialog', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.byType(DeleteTimeConfirmationDialog), findsOneWidget);
    });

    testWidgets('renders inside a Card widget', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
