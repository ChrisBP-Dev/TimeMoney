/// Tests for [UpdateTimeCard] widget.
///
/// Verifies that [UpdateTimeCard] renders [UpdateHourField] and
/// [UpdateMinutesField] within a [Card].
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_hour_field.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_minutes_field.dart';
import 'package:time_money/src/features/times/presentation/widgets/update_time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateTimeCard', () {
    late MockUpdateTimeBloc mockBloc;

    setUp(() {
      mockBloc = MockUpdateTimeBloc();
      // Pre-populate state so initState in fields can read hour/minutes
      when(() => mockBloc.state).thenReturn(
        const UpdateTimeInitial(
          hour: 2,
          minutes: 30,
          time: TimeEntry(id: 1, hour: 2, minutes: 30),
        ),
      );
    });

    testWidgets('renders UpdateHourField and UpdateMinutesField',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateTimeCard()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UpdateHourField), findsOneWidget);
      expect(find.byType(UpdateMinutesField), findsOneWidget);
    });

    testWidgets('renders inside a Card', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: UpdateTimeCard()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
