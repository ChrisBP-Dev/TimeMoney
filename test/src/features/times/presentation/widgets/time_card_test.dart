/// Tests for [TimeCard] widget.
///
/// Verifies that [TimeCard] renders [InfoTime] and [EditButton] with the
/// correct [TimeEntry] data. Provides [MockUpdateTimeBloc] because
/// [EditButton] requires it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/edit_button.dart';
import 'package:time_money/src/features/times/presentation/widgets/info_time.dart';
import 'package:time_money/src/features/times/presentation/widgets/time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('TimeCard', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockUpdateTimeBloc;

    setUp(() {
      mockUpdateTimeBloc = MockUpdateTimeBloc();
      when(() => mockUpdateTimeBloc.state)
          .thenReturn(const UpdateTimeInitial());
    });

    testWidgets('renders InfoTime with correct TimeEntry data',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateTimeBloc,
          child: const TimeCard(time: testTime),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InfoTime), findsOneWidget);
      final infoTime = tester.widget<InfoTime>(find.byType(InfoTime));
      expect(infoTime.time, testTime);
    });

    testWidgets('renders EditButton with correct TimeEntry data',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateTimeBloc,
          child: const TimeCard(time: testTime),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditButton), findsOneWidget);
      final editButton = tester.widget<EditButton>(find.byType(EditButton));
      expect(editButton.time, testTime);
    });

    testWidgets('renders inside a Card widget', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateTimeBloc,
          child: const TimeCard(time: testTime),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
