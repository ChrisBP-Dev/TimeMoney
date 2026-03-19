import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/l10n/l10n.dart';

/// Convenience extension on [WidgetTester] for pumping widgets with the full
/// app scaffold (MaterialApp + localizations).
///
/// Usage:
/// ```dart
/// await tester.pumpApp(MyWidget());
/// ```
extension PumpApp on WidgetTester {
  /// Wraps [widget] inside a [MaterialApp] configured with the project's
  /// localisation delegates and supported locales, then pumps it.
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
