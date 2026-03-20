import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/locale/locale_state.dart';

export 'locale_state.dart';

/// Cubit that manages the app-wide locale override.
///
/// Starts in the system-default state (follow device/browser locale).
/// When the user explicitly selects a language, emits a selected
/// state which the `MaterialApp` uses to force that locale.
class LocaleCubit extends Cubit<LocaleState> {
  /// Creates a [LocaleCubit] starting with the system default.
  LocaleCubit() : super(const LocaleSystem());

  /// Overrides the app locale to [locale].
  void setLocale(Locale locale) => emit(LocaleSelected(locale));

  /// Resets the locale to follow the system default.
  void resetToSystem() => emit(const LocaleSystem());
}
