import 'package:time_money/src/core/screen_type.dart';

class BreakPoints {
  static const maxMobile = 767.0;
  static const maxTablet = 1024.0;
  static const maxExtenseScreen = 1196.0;

  static ScreenType screenType(double value) {
    if (value <= maxMobile) return ScreenType.mobile;
    if (value <= maxTablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }
}
