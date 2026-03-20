/// Tests for [ErrorView] widget.
///
/// Verifies that all four [GlobalFailure] subtypes map to the correct
/// [ShowInfoSection] with appropriate icon text and message, and that
/// the optional actionWidget is passed through correctly.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/shared/widgets/error_view.dart';
import 'package:time_money/src/shared/widgets/icon_text.dart';
import 'package:time_money/src/shared/widgets/info_section.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('ErrorView', () {
    group('InternalError', () {
      testWidgets('renders IconText with ⚠️ and message containing error',
          (tester) async {
        await tester.pumpApp(
          const ErrorView(
            InternalError('test error'),
            actionWidget: null,
          ),
        );

        // Verify icon
        final iconText = tester.widget<IconText>(find.byType(IconText));
        expect(iconText.iconText, '⚠️');

        // Verify message contains expected text
        final infoSection = tester.widget<ShowInfoSection>(
          find.byType(ShowInfoSection),
        );
        expect(
          infoSection.infoMessage,
          contains('Hubo un error interno'),
        );
        expect(infoSection.infoMessage, contains('test error'));
      });
    });

    group('TimeOutExceeded', () {
      testWidgets('renders IconText with ⏳ and timeout message',
          (tester) async {
        await tester.pumpApp(
          const ErrorView(
            TimeOutExceeded(),
            actionWidget: null,
          ),
        );

        final iconText = tester.widget<IconText>(find.byType(IconText));
        expect(iconText.iconText, '⏳');

        final infoSection = tester.widget<ShowInfoSection>(
          find.byType(ShowInfoSection),
        );
        expect(
          infoSection.infoMessage,
          contains('Se agotó el tiempo de espera'),
        );
      });
    });

    group('ServerError', () {
      testWidgets('renders IconText with 🚨 and server error message',
          (tester) async {
        await tester.pumpApp(
          const ErrorView(
            ServerError('500'),
            actionWidget: null,
          ),
        );

        final iconText = tester.widget<IconText>(find.byType(IconText));
        expect(iconText.iconText, '🚨');

        final infoSection = tester.widget<ShowInfoSection>(
          find.byType(ShowInfoSection),
        );
        expect(
          infoSection.infoMessage,
          contains('Hubo un error en el servidor'),
        );
      });
    });

    group('NotConnection', () {
      testWidgets('renders IconText with 📡 and connection message',
          (tester) async {
        await tester.pumpApp(
          const ErrorView(
            NotConnection(),
            actionWidget: null,
          ),
        );

        final iconText = tester.widget<IconText>(find.byType(IconText));
        expect(iconText.iconText, '📡');

        final infoSection = tester.widget<ShowInfoSection>(
          find.byType(ShowInfoSection),
        );
        expect(
          infoSection.infoMessage,
          contains('Hubo un problema de conexión.'),
        );
      });
    });

    group('actionWidget passthrough', () {
      testWidgets('renders actionWidget when non-null', (tester) async {
        await tester.pumpApp(
          const ErrorView(
            NotConnection(),
            actionWidget: ElevatedButton(
              onPressed: null,
              child: Text('Retry'),
            ),
          ),
        );

        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('actionWidget absent when null', (tester) async {
        await tester.pumpApp(
          const ErrorView(
            NotConnection(),
            actionWidget: null,
          ),
        );

        expect(find.byType(ElevatedButton), findsNothing);
      });
    });
  });
}
