import 'package:flutter/material.dart';

class ShowInfoSection extends StatelessWidget {
  const ShowInfoSection({
    required this.infoMessage,
    super.key,
    this.infoImage,
    this.actionWidget,
  });
  final String infoMessage;
  final Widget? actionWidget;
  final Widget? infoImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          if (infoImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: infoImage,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              infoMessage,
              textAlign: TextAlign.center,
              // style: context.normalFont,
            ),
          ),
          const Spacer(),
          if (actionWidget != null) ...[
            SizedBox(height: 60, child: Center(child: actionWidget)),
            const Spacer(),
          ]
        ],
      ),
    );
  }
}

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
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
