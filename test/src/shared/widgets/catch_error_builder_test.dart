/// Tests for [CatchErrorBuilder] widget.
///
/// Verifies all [AsyncSnapshot] state branches: error, waiting, hasData,
/// and the fallback (no data / not waiting / no error), with both custom
/// and default widgets for error and loading parameters.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/shared/widgets/catch_error_builder.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CatchErrorBuilder', () {
    group('error state', () {
      testWidgets('renders custom error widget when snapshot.hasError', (
        tester,
      ) async {
        const snapshot = AsyncSnapshot<String>.withError(
          ConnectionState.done,
          'test error',
        );

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            error: Text('Custom error'),
            builder: Text.new,
          ),
        );

        expect(find.text('Custom error'), findsOneWidget);
      });

      testWidgets('renders default "Something went wrong" text '
          'when snapshot.hasError and no custom error', (tester) async {
        const snapshot = AsyncSnapshot<String>.withError(
          ConnectionState.done,
          'test error',
        );

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            builder: Text.new,
          ),
        );

        expect(find.text('Something went wrong'), findsOneWidget);
      });
    });

    group('waiting state', () {
      testWidgets('renders custom loading widget when snapshot is waiting', (
        tester,
      ) async {
        const snapshot = AsyncSnapshot<String>.waiting();

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            loading: Text('Custom loading'),
            builder: Text.new,
          ),
        );

        expect(find.text('Custom loading'), findsOneWidget);
      });

      testWidgets('renders default CircularProgressIndicator.adaptive '
          'when snapshot is waiting and no custom loading', (tester) async {
        const snapshot = AsyncSnapshot<String>.waiting();

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            builder: Text.new,
          ),
        );

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );
      });
    });

    group('data state', () {
      testWidgets('calls builder with data when snapshot.hasData', (
        tester,
      ) async {
        const snapshot = AsyncSnapshot<String>.withData(
          ConnectionState.done,
          'test data',
        );

        await tester.pumpApp(
          CatchErrorBuilder<String>(
            snapshot: snapshot,
            builder: (data) => Text('Built: $data'),
          ),
        );

        expect(find.text('Built: test data'), findsOneWidget);
      });
    });

    group('fallback state (no data, not waiting, no error)', () {
      testWidgets('renders custom loading widget wrapped in Center '
          'when snapshot is nothing and loading is provided', (tester) async {
        const snapshot = AsyncSnapshot<String>.nothing();

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            loading: Text('Fallback loading'),
            builder: Text.new,
          ),
        );

        expect(find.text('Fallback loading'), findsOneWidget);
        // Verify custom loading is wrapped in Center in fallback
        expect(
          find.ancestor(
            of: find.text('Fallback loading'),
            matching: find.byType(Center),
          ),
          findsWidgets,
        );
      });

      testWidgets('renders default "error" text '
          'when snapshot is nothing and no custom loading', (tester) async {
        const snapshot = AsyncSnapshot<String>.nothing();

        await tester.pumpApp(
          const CatchErrorBuilder<String>(
            snapshot: snapshot,
            builder: Text.new,
          ),
        );

        expect(find.text('error'), findsOneWidget);
      });
    });
  });
}
