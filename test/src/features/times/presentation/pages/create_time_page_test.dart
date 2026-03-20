/// Tests for [CreateTimePage] widget.
///
/// Verifies that [CreateTimePage] renders an [AlertDialog] containing
/// [CreateTimeCard] and a close button that pops the dialog.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/create_time_page.dart';
import 'package:time_money/src/features/times/presentation/widgets/create_time_card.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('CreateTimePage', () {
    late MockCreateTimeBloc mockBloc;

    setUp(() {
      mockBloc = MockCreateTimeBloc();
      when(() => mockBloc.state).thenReturn(const CreateTimeInitial());
    });

    testWidgets('renders AlertDialog with CreateTimeCard', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider<CreateTimeBloc>.value(
                    value: mockBloc,
                    child: const CreateTimePage(),
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
      expect(find.byType(CreateTimeCard), findsOneWidget);
    });

    testWidgets('close button pops dialog', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider<CreateTimeBloc>.value(
                    value: mockBloc,
                    child: const CreateTimePage(),
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

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
