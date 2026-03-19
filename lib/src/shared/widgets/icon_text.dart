import 'package:flutter/material.dart';

/// Widget that renders a text-based icon (e.g., an emoji)
/// inside a fixed-size box.
///
/// Uses [FittedBox] to scale the text to fill the available space defined
/// by [fontSize].
class IconText extends StatelessWidget {
  /// Creates an [IconText] displaying [iconText] at the given [fontSize].
  const IconText(this.iconText, {super.key, this.fontSize = 60});

  /// The text content to display (typically an emoji or symbol).
  final String iconText;

  /// The width and height of the bounding box. Defaults to 60.
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
