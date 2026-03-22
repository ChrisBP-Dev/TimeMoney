/// Device form-factor categories used by the responsive layout system.
///
/// Resolved from screen width via `BreakPoints.screenType` and consumed
/// by the `ScreenSize` extension on `BuildContext`.
enum ScreenType {
  /// Phone-sized screen (<= 767 logical pixels wide).
  mobile,

  /// Tablet-sized screen (<= 1024 logical pixels wide).
  tablet,

  /// Desktop or large screen (> 1024 logical pixels wide).
  desktop,
}

/// Convenience boolean getters for [ScreenType] comparison.
extension Screens on ScreenType {
  /// Returns `true` when this is [ScreenType.mobile].
  bool get isMobile => this == ScreenType.mobile;

  /// Returns `true` when this is [ScreenType.tablet].
  bool get isTablet => this == ScreenType.tablet;

  /// Returns `true` when this is [ScreenType.desktop].
  bool get isDesktop => this == ScreenType.desktop;
}
