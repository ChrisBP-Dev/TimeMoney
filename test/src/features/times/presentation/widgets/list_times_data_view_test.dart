/// Tests for [ListTimesDataView] widget.
///
/// Verifies that a [ListView] is rendered with the correct count of
/// [TimeCard] widgets matching the provided time entries list.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/list_times_data_view.dart';
import 'package:time_money/src/features/times/presentation/widgets/time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('ListTimesDataView', () {
    const testTimes = [
      TimeEntry(id: 1, hour: 1, minutes: 0),
      TimeEntry(id: 2, hour: 2, minutes: 30),
    ];

    late MockUpdateTimeBloc mockUpdateTimeBloc;

    setUp(() {
      mockUpdateTimeBloc = MockUpdateTimeBloc();
    });

    testWidgets('renders ListView with correct count of TimeCard widgets',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateTimeBloc,
          child: const ListTimesDataView(times: testTimes),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TimeCard), findsNWidgets(testTimes.length));
    });

    testWidgets('renders Scrollbar', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockUpdateTimeBloc,
          child: const ListTimesDataView(times: testTimes),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scrollbar), findsOneWidget);
    });
  });
}
