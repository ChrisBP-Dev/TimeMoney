import 'package:flutter/widgets.dart';
import 'package:time_money/l10n/gen/app_localizations.dart';

export 'package:time_money/l10n/gen/app_localizations.dart';

/// Convenience extension on [BuildContext] for accessing localized strings.
extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
