import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText(this.iconText, {super.key, this.fontSize = 60});
  final String iconText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fontSize,
      width: fontSize,
      child: FittedBox(
        child: Text(
          iconText,
          textAlign: TextAlign.center,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
