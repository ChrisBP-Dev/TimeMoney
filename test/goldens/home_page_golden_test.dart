/// Golden tests for [HomePage] visual regression verification.
///
/// Captures two snapshots — populated data and empty state — to detect
/// unintended layout or styling changes across the main landing page.
library;

import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/home/presentation/pages/home_page.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';

import '../helpers/helpers.dart';

void main() {
  group('HomePage Golden', () {
    late MockPaymentCubit mockPaymentCubit;
    late MockListTimesBloc mockListTimesBloc;
    late MockFetchWageBloc mockFetchWageBloc;

    setUp(() {
      mockPaymentCubit = MockPaymentCubit();
      mockListTimesBloc = MockListTimesBloc();
      mockFetchWageBloc = MockFetchWageBloc();
    });

    testWidgets('renders correctly with populated data', (tester) async {
      const testTimes = [
        TimeEntry(id: 1, hour: 5, minutes: 15),
        TimeEntry(id: 2, hour: 3, minutes: 45),
        TimeEntry(id: 3, hour: 1, minutes: 30),
      ];

      when(() => mockListTimesBloc.state).thenReturn(
        const ListTimesLoaded(testTimes),
      );
      when(() => mockFetchWageBloc.state).thenReturn(
        const FetchWageLoaded(WageHourly(id: 1)),
      );
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentReady(times: testTimes, wageHourly: 15),
      );

      // Wider viewport (480px) to accommodate both FABs — Ahem font renders
      // text as fixed-width blocks wider than production fonts.
      await tester.pumpGoldenApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
            BlocProvider<ListTimesBloc>.value(value: mockListTimesBloc),
            BlocProvider<FetchWageBloc>.value(value: mockFetchWageBloc),
          ],
          child: const HomePage(),
        ),
        size: const Size(480, 892),
      );

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('home_page_with_data.png'),
      );
    });

    testWidgets('renders correctly with empty state', (tester) async {
      when(() => mockListTimesBloc.state).thenReturn(
        const ListTimesEmpty(),
      );
      when(() => mockFetchWageBloc.state).thenReturn(
        const FetchWageInitial(),
      );
      when(() => mockPaymentCubit.state).thenReturn(
        const PaymentInitial(),
      );

      await tester.pumpGoldenApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
            BlocProvider<ListTimesBloc>.value(value: mockListTimesBloc),
            BlocProvider<FetchWageBloc>.value(value: mockFetchWageBloc),
          ],
          child: const HomePage(),
        ),
      );

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('home_page_empty.png'),
      );
    });
  });
}
