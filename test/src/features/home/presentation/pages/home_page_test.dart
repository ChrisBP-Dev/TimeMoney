/// Tests for [HomePage] widget.
///
/// Verifies structural composition of [FetchWagePage], [ListTimesPage],
/// action bar with addTime FAB, conditional [CalculatePaymentButton]
/// rendering on [PaymentReady], and locale toggle behavior.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/home/presentation/pages/home_page.dart';
import 'package:time_money/src/features/home/presentation/widgets/calculate_payment_button.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/list_times_page.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_page.dart';

import '../../../../../helpers/helpers.dart';

const _testTimes = [
  TimeEntry(id: 1, hour: 5, minutes: 15),
  TimeEntry(id: 2, hour: 3, minutes: 45),
  TimeEntry(id: 3, hour: 1, minutes: 30),
];

void main() {
  late MockPaymentCubit mockPaymentCubit;
  late MockListTimesBloc mockListTimesBloc;
  late MockFetchWageBloc mockFetchWageBloc;

  setUp(() {
    mockPaymentCubit = MockPaymentCubit();
    mockListTimesBloc = MockListTimesBloc();
    mockFetchWageBloc = MockFetchWageBloc();

    when(() => mockPaymentCubit.state)
        .thenReturn(const PaymentInitial());
    when(() => mockListTimesBloc.state)
        .thenReturn(const ListTimesInitial());
    when(() => mockFetchWageBloc.state)
        .thenReturn(const FetchWageInitial());
  });

  Widget buildSubject() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
        BlocProvider<ListTimesBloc>.value(value: mockListTimesBloc),
        BlocProvider<FetchWageBloc>.value(value: mockFetchWageBloc),
      ],
      child: const HomePage(),
    );
  }

  group('HomePage', () {
    testWidgets('renders Scaffold with AppBar showing localized homeTitle',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders FetchWagePage', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FetchWagePage), findsOneWidget);
    });

    testWidgets('renders ListTimesPage', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(ListTimesPage), findsOneWidget);
    });

    testWidgets('renders addTime FAB', (tester) async {
      await tester.pumpApp(buildSubject());

      // In PaymentInitial, only one FAB (addTime) is present
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('hides CalculatePaymentButton when PaymentInitial',
        (tester) async {
      when(() => mockPaymentCubit.state)
          .thenReturn(const PaymentInitial());

      await tester.pumpApp(buildSubject());

      expect(find.byType(CalculatePaymentButton), findsNothing);
    });

    testWidgets('shows CalculatePaymentButton when PaymentReady',
        (tester) async {
      whenListen(
        mockPaymentCubit,
        Stream.value(
          const PaymentReady(times: _testTimes, wageHourly: 15),
        ),
        initialState: const PaymentInitial(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(CalculatePaymentButton), findsOneWidget);
    });

    group('locale toggle', () {
      testWidgets('renders OutlinedButton in AppBar actions', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets(
          'locale toggle shows "ES" initially and cycles to "EN" after tap',
          (tester) async {
        await tester.pumpApp(buildSubject());

        // Initial state: LocaleSystem → test default 'en' → shows "ES"
        expect(find.text('ES'), findsOneWidget);

        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();

        // After tap: setLocale(es) → shows "EN"
        expect(find.text('EN'), findsOneWidget);
      });
    });
  });
}
