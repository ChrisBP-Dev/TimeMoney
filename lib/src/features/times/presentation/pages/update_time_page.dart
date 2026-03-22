import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Dialog page for updating an existing time entry.
///
/// Presents an [AlertDialog] containing the [UpdateTimeCard] form
/// pre-populated with the current values of [time]. The
/// [UpdateTimeButton] action submits changes.
class UpdateTimePage extends StatelessWidget {
  /// Creates an [UpdateTimePage] for the given [time] entry.
  const UpdateTimePage({
    required this.time,
    super.key,
  });

  /// The time entry to update.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.updateTimeTitle),
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
          UpdateTimeCard(),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: const [
        UpdateTimeButton(),
      ],
    );
  }
}
