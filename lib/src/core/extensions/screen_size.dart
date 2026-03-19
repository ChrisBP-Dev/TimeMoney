import 'package:flutter/material.dart';
import 'package:time_money/src/core/constants/break_points.dart';
import 'package:time_money/src/core/extensions/screen_type.dart';

/// Responsive layout helpers exposed directly on [BuildContext].
///
/// Wraps [MediaQuery] and [BreakPoints] so widgets can query screen
/// dimensions and device category without boilerplate.
extension ScreenSize on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  /// The current screen height in logical pixels.
  double get getHeight => _size.height;

  /// The current screen width in logical pixels.
  double get getWidth => _size.width;

  ScreenType get _screenType => BreakPoints.screenType(getWidth);

  /// Whether the current screen width classifies as mobile.
  bool get isMobile => _screenType.isMobile;

  /// Whether the current screen width classifies as desktop.
  bool get isDesktop => _screenType.isDesktop;

  /// Whether the current screen width classifies as tablet.
  bool get isTablet => _screenType.isTablet;
}
