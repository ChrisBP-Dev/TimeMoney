/// Golden tests for [CreateTimePage] visual regression verification.
///
/// Captures a snapshot of the create-time dialog in its initial state
/// to detect unintended layout or styling changes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/create_time_page.dart';

import '../helpers/helpers.dart';

void main() {
  group('CreateTimePage Golden', () {
    late MockCreateTimeBloc mockCreateTimeBloc;

    setUp(() {
      mockCreateTimeBloc = MockCreateTimeBloc();
      when(() => mockCreateTimeBloc.state).thenReturn(
        const CreateTimeInitial(),
      );
    });

    testWidgets('renders correctly in initial state', (tester) async {
      await tester.pumpGoldenApp(
        BlocProvider<CreateTimeBloc>.value(
          value: mockCreateTimeBloc,
          child: const CreateTimePage(),
        ),
        size: const Size(800, 1200),
      );

      await expectLater(
        find.byType(CreateTimePage),
        matchesGoldenFile('create_time_dialog.png'),
      );
    });
  });
}
