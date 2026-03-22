/// Tests for [UpdateWagePage] widget.
///
/// Verifies that [UpdateWagePage] renders an [AlertDialog] with
/// [WageHourlyField] and [SetWageButton], and that the close button pops.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/pages/update_wage_page.dart';
import 'package:time_money/src/features/wage/presentation/widgets/set_wage_button.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('UpdateWagePage', () {
    late MockUpdateWageBloc mockBloc;

    setUp(() {
      mockBloc = MockUpdateWageBloc();
      when(() => mockBloc.state).thenReturn(const UpdateWageInitial());
    });

    testWidgets('renders AlertDialog with WageHourlyField and SetWageButton', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider<UpdateWageBloc>.value(
                    value: mockBloc,
                    child: const UpdateWagePage(),
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
      expect(find.byType(WageHourlyField), findsOneWidget);
      expect(find.byType(SetWageButton), findsOneWidget);
    });

    testWidgets('close button pops dialog', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider<UpdateWageBloc>.value(
                    value: mockBloc,
                    child: const UpdateWagePage(),
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
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
