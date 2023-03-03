import 'package:flutter/material.dart';
import 'package:time_money/src/core/break_points.dart';
import 'package:time_money/src/core/screen_type.dart';

extension ScreenSize on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get getHeight => _size.height;
  double get getWidth => _size.width;

  ScreenType get _screenType => BreakPoints.screenType(getWidth);
  bool get isMobile => _screenType.isMobile;
  bool get isDesktop => _screenType.isDesktop;
  bool get isTablet => _screenType.isTablet;
}
