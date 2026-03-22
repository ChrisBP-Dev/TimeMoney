import 'package:flutter/material.dart';

/// Centered informational section with an optional image, message, and action.
///
/// Used throughout the app for empty states, error states, and other
/// feedback screens that follow the image-message-action layout pattern.
class ShowInfoSection extends StatelessWidget {
  /// Creates a [ShowInfoSection] with the required [infoMessage].
  const ShowInfoSection({
    required this.infoMessage,
    super.key,
    this.infoImage,
    this.actionWidget,
  });

  /// The informational text displayed to the user.
  final String infoMessage;

  /// Optional action widget (e.g., a retry button) rendered at the bottom.
  final Widget? actionWidget;

  /// Optional image or icon widget rendered above the message.
  final Widget? infoImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          ),
          const Spacer(),
          if (actionWidget != null) ...[
            SizedBox(height: 60, child: Center(child: actionWidget)),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}
