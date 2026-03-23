/// Tests for [WageHourlyField] widget.
///
/// Verifies that [WageHourlyField] dispatches [UpdateWageHourlyChanged]
/// events on input and that [BlocBuilder] rebuilds correctly.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/widgets/wage_hourly_field.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('WageHourlyField', () {
    late MockUpdateWageBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateWageHourlyChanged(value: '0'));
    });

    setUp(() {
      mockBloc = MockUpdateWageBloc();
      when(() => mockBloc.state).thenReturn(const UpdateWageInitial());
    });

    testWidgets('dispatches UpdateWageHourlyChanged on input', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: WageHourlyField()),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextFormField), '25.5');

      verify(
        () => mockBloc.add(any(that: isA<UpdateWageHourlyChanged>())),
      ).called(1);
    });

    testWidgets('renders TextFormField with decimal numeric keyboard', (
      tester,
    ) async {
      await tester.pumpApp(
        BlocProvider<UpdateWageBloc>.value(
          value: mockBloc,
          child: const Scaffold(body: WageHourlyField()),
        ),
      );
      await tester.pump();

      expect(find.byType(TextFormField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.keyboardType,
        const TextInputType.numberWithOptions(decimal: true),
      );
    });
  });
}
