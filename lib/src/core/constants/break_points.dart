import 'package:time_money/src/core/extensions/screen_type.dart';

/// Responsive design breakpoint thresholds for the application.
///
/// Defines pixel-width boundaries that classify screens into
/// [ScreenType.mobile], [ScreenType.tablet], or [ScreenType.desktop].
/// Used by the `ScreenSize` extension to expose responsive helpers on
/// `BuildContext`.
class BreakPoints {
  /// Maximum width (inclusive) for mobile devices, in logical pixels.
  static const maxMobile = 767.0;

  /// Maximum width (inclusive) for tablet devices, in logical pixels.
  static const maxTablet = 1024.0;

  /// Maximum width for extended/wide screens, in logical pixels.
  static const maxExtenseScreen = 1196.0;

  /// Resolves the [ScreenType] for a given screen [value] width.
  ///
  /// Returns [ScreenType.mobile] when [value] <= [maxMobile],
  /// [ScreenType.tablet] when [value] <= [maxTablet], and
  /// [ScreenType.desktop] otherwise.
  static ScreenType screenType(double value) {
    if (value <= maxMobile) return ScreenType.mobile;
    if (value <= maxTablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }
}
