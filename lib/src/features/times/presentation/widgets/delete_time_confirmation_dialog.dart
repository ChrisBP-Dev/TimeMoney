import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/delete_time_button.dart';

/// Confirmation dialog displayed before deleting a time entry.
///
/// Presents a localised title and message asking the user to confirm
/// deletion. The [DeleteTimeButton] handles state-driven feedback
/// (loading, success, error) via `DeleteTimeBloc`.
class DeleteTimeConfirmationDialog extends StatelessWidget {
  /// Creates a [DeleteTimeConfirmationDialog] for the given [time].
  const DeleteTimeConfirmationDialog({
    required this.time,
    super.key,
  });

  /// The time entry to delete upon confirmation.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.deleteConfirmTitle),
      content: Text(context.l10n.deleteConfirmMessage),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        DeleteTimeButton(time: time),
      ],
    );
  }
}
