import 'dart:async';

class Consts {
  static Future<void> get delayed => Future<void>.delayed(
        const Duration(milliseconds: 500),
      );
}
