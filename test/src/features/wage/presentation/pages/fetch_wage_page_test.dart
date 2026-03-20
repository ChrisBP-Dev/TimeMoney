/// Tests for [FetchWagePage] widget.
///
/// Verifies auto-dispatch of [FetchWageRequested] on build, state-driven
/// rendering for all [FetchWageState] subtypes, [PaymentCubit] listener
/// sync on [FetchWageLoaded] only, and retry button behavior.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_page.dart';
import 'package:time_money/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_card.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_other_view.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('FetchWagePage', () {
    late MockFetchWageBloc mockFetchBloc;
    late MockPaymentCubit mockPaymentCubit;

    setUpAll(() {
      registerFallbackValue(const FetchWageRequested());
    });

    setUp(() {
      mockFetchBloc = MockFetchWageBloc();
      mockPaymentCubit = MockPaymentCubit();
      when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<FetchWageBloc>.value(value: mockFetchBloc),
          BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
        ],
        child: const FetchWagePage(),
      );
    }

    testWidgets('dispatches FetchWageRequested on build', (tester) async {
      when(() => mockFetchBloc.state).thenReturn(const FetchWageInitial());

      await tester.pumpApp(buildSubject());

      verify(() => mockFetchBloc.add(const FetchWageRequested())).called(1);
    });

    testWidgets('renders ShimmerView on Initial state', (tester) async {
      when(() => mockFetchBloc.state).thenReturn(const FetchWageInitial());

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ShimmerWageHourlyView), findsOneWidget);
    });

    testWidgets('renders ShimmerView on Loading state', (tester) async {
      when(() => mockFetchBloc.state).thenReturn(const FetchWageLoading());

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ShimmerWageHourlyView), findsOneWidget);
    });

    testWidgets('renders WageHourlyCard on Loaded state', (tester) async {
      const testWage = WageHourly(id: 1, value: 15.5);
      when(() => mockFetchBloc.state).thenReturn(
        const FetchWageLoaded(testWage),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(WageHourlyCard), findsOneWidget);
    });

    testWidgets('renders ErrorView on Error state', (tester) async {
      when(() => mockFetchBloc.state).thenReturn(
        const FetchWageError(InternalError('test')),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(ErrorFetchWageHourlyView), findsOneWidget);
    });

    testWidgets('retry button dispatches FetchWageRequested', (tester) async {
      when(() => mockFetchBloc.state).thenReturn(
        const FetchWageError(InternalError('test')),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      clearInteractions(mockFetchBloc);

      await tester.tap(find.byType(FilledButton));

      verify(() => mockFetchBloc.add(const FetchWageRequested())).called(1);
    });

    // -- PaymentCubit listener sync tests (P2) --

    testWidgets('listener calls setWage on Loaded state', (tester) async {
      const testWage = WageHourly(id: 1, value: 15.5);
      whenListen(
        mockFetchBloc,
        Stream.value(const FetchWageLoaded(testWage)),
        initialState: const FetchWageInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verify(() => mockPaymentCubit.setWage(15.5)).called(1);
    });

    testWidgets('listener does not call setWage on Error state',
        (tester) async {
      whenListen(
        mockFetchBloc,
        Stream.value(const FetchWageError(InternalError('test'))),
        initialState: const FetchWageInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verifyNever(() => mockPaymentCubit.setWage(any()));
    });

    testWidgets('listener does not call setWage on Loading state',
        (tester) async {
      whenListen(
        mockFetchBloc,
        Stream.value(const FetchWageLoading()),
        initialState: const FetchWageInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      verifyNever(() => mockPaymentCubit.setWage(any()));
    });
  });
}
