import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Dialog page for creating a new time entry.
///
/// Presents an [AlertDialog] containing the [CreateTimeCard] form
/// with hour and minutes input fields and a [CreateTimeButton] action.
/// The dialog can be dismissed via the close icon button.
class CreateTimePage extends StatelessWidget {
  /// Creates a [CreateTimePage].
  const CreateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.createTimeTitle),
      iconPadding: const EdgeInsets.all(7),
      icon: Align(
        alignment: Alignment.topRight,
        child: Card(
          child: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CreateTimeCard(),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: const [
        CreateTimeButton(),
      ],
    );
  }
}
