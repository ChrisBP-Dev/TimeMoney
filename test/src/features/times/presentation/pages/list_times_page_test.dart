/// Tests for [ListTimesPage] widget.
///
/// Verifies auto-dispatch of [ListTimesRequested] on build, state-driven
/// rendering for all [ListTimesState] subtypes, [PaymentCubit] sync via
/// listener, and retry button behavior.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/list_times_page.dart';
import 'package:time_money/src/features/times/presentation/widgets/error_list_times_view.dart';
import 'package:time_money/src/features/times/presentation/widgets/list_times_data_view.dart';
import 'package:time_money/src/features/times/presentation/widgets/list_times_other_view.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('ListTimesPage', () {
    late MockListTimesBloc mockListBloc;
    late MockPaymentCubit mockPaymentCubit;
    late MockUpdateTimeBloc mockUpdateBloc;
    late MockDeleteTimeBloc mockDeleteBloc;

    setUpAll(() {
      registerFallbackValue(const ListTimesRequested());
      registerFallbackValue(const <TimeEntry>[]);
    });

    setUp(() {
      mockListBloc = MockListTimesBloc();
      mockPaymentCubit = MockPaymentCubit();
      mockUpdateBloc = MockUpdateTimeBloc();
      mockDeleteBloc = MockDeleteTimeBloc();
      when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());
      when(() => mockUpdateBloc.state).thenReturn(const UpdateTimeInitial());
      when(() => mockDeleteBloc.state).thenReturn(const DeleteTimeInitial());
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ListTimesBloc>.value(value: mockListBloc),
          BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
          BlocProvider<UpdateTimeBloc>.value(value: mockUpdateBloc),
          BlocProvider<DeleteTimeBloc>.value(value: mockDeleteBloc),
        ],
        child: const ListTimesPage(),
      );
    }

    testWidgets('dispatches ListTimesRequested on build', (tester) async {
      when(() => mockListBloc.state).thenReturn(const ListTimesInitial());

      await tester.pumpApp(buildSubject());

      verify(() => mockListBloc.add(const ListTimesRequested())).called(1);
    });

    testWidgets('renders ShimmerView on Initial state', (tester) async {
      when(() => mockListBloc.state).thenReturn(const ListTimesInitial());

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ShimmerListTimesView), findsOneWidget);
    });

    testWidgets('renders ShimmerView on Loading state', (tester) async {
      when(() => mockListBloc.state).thenReturn(const ListTimesLoading());

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ShimmerListTimesView), findsOneWidget);
    });

    testWidgets('renders EmptyView on Empty state', (tester) async {
      when(() => mockListBloc.state).thenReturn(const ListTimesEmpty());

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(EmptyListTimesView), findsOneWidget);
    });

    testWidgets('renders ErrorView on Error state', (tester) async {
      when(() => mockListBloc.state).thenReturn(
        const ListTimesError(InternalError('test')),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ErrorListTimesView), findsOneWidget);
    });

    testWidgets('renders DataView on Loaded state', (tester) async {
      const testTimes = [
        TimeEntry(id: 1, hour: 1, minutes: 0),
        TimeEntry(id: 2, hour: 2, minutes: 30),
      ];
      when(() => mockListBloc.state).thenReturn(
        const ListTimesLoaded(testTimes),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ListTimesDataView), findsOneWidget);
    });

    testWidgets('retry button dispatches ListTimesRequested', (tester) async {
      when(() => mockListBloc.state).thenReturn(
        const ListTimesError(InternalError('test')),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      // Clear the initial add call
      clearInteractions(mockListBloc);

      await tester.tap(find.byType(FilledButton));

      verify(() => mockListBloc.add(const ListTimesRequested())).called(1);
    });

    // -- PaymentCubit listener sync tests (P1) --

    testWidgets('listener calls setTimes on Loaded state', (tester) async {
      const testTimes = [
        TimeEntry(id: 1, hour: 1, minutes: 0),
        TimeEntry(id: 2, hour: 2, minutes: 30),
      ];
      whenListen(
        mockListBloc,
        Stream.value(const ListTimesLoaded(testTimes)),
        initialState: const ListTimesInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verify(() => mockPaymentCubit.setTimes(testTimes)).called(1);
    });

    testWidgets('listener calls setTimes with empty list on Empty state',
        (tester) async {
      whenListen(
        mockListBloc,
        Stream.value(const ListTimesEmpty()),
        initialState: const ListTimesInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verify(() => mockPaymentCubit.setTimes(const <TimeEntry>[])).called(1);
    });

    testWidgets('listener calls setTimes with empty list on Error state',
        (tester) async {
      whenListen(
        mockListBloc,
        Stream.value(const ListTimesError(InternalError('test'))),
        initialState: const ListTimesInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verify(() => mockPaymentCubit.setTimes(const <TimeEntry>[])).called(1);
    });

    testWidgets('listener does not call setTimes on Loading state',
        (tester) async {
      whenListen(
        mockListBloc,
        Stream.value(const ListTimesLoading()),
        initialState: const ListTimesInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verifyNever(() => mockPaymentCubit.setTimes(any()));
    });
  });
}
