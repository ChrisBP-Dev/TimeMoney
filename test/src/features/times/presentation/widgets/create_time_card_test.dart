/// Tests for [CreateTimeCard] widget.
///
/// Verifies that [CreateTimeCard] renders [CreateHourField] and
/// [CreateMinutesField] within a [Card]. The submit button lives in
/// `CreateTimePage` actions, not inside the card.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_hour_field.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_minutes_field.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CreateTimeCard', () {
    late MockCreateTimeBloc mockBloc;

    setUp(() {
      mockBloc = MockCreateTimeBloc();
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());
    });

    testWidgets('renders CreateHourField and CreateMinutesField',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: CreateTimeCard()),
        ),
      );
      await tester.pump();

      expect(find.byType(CreateHourField), findsOneWidget);
      expect(find.byType(CreateMinutesField), findsOneWidget);
    });

    testWidgets('renders inside a Card', (tester) async {
      await tester.pumpApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: CreateTimeCard()),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
