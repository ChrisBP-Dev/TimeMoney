import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/core/locale/locale_cubit.dart';

/// Convenience extension on [WidgetTester] for pumping widgets with the full
/// app scaffold (MaterialApp + localizations + LocaleCubit).
///
/// Usage:
/// ```dart
/// await tester.pumpApp(MyWidget());
/// ```
extension PumpApp on WidgetTester {
  /// Wraps [widget] inside a [BlocProvider] for [LocaleCubit] and a
  /// [MaterialApp] configured with the project's localisation delegates
  /// and supported locales, then pumps it.
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      BlocProvider<LocaleCubit>(
        create: (_) => LocaleCubit(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
