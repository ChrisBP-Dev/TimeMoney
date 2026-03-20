import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Base state for the locale cubit.
///
/// Determines whether the app follows the system locale or uses an
/// explicit user-selected override.
@immutable
sealed class LocaleState {
  /// Creates a [LocaleState].
  const LocaleState();
}

/// The app follows the device / browser locale (no user override).
final class LocaleSystem extends LocaleState {
  /// Creates a [LocaleSystem] state.
  const LocaleSystem();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LocaleSystem;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The user has explicitly selected a [locale].
final class LocaleSelected extends LocaleState {
  /// Creates a [LocaleSelected] state with the given [locale].
  const LocaleSelected(this.locale);

  /// The locale chosen by the user.
  final Locale locale;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleSelected && locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}
