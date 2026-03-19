import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Card widget representing a single time entry in the list.
///
/// Displays the time entry's hour and minutes via [InfoTime] and
/// provides an [EditButton] to navigate to the update/delete dialog.
class TimeCard extends StatelessWidget {
  /// Creates a [TimeCard] for the given [time] entry.
  const TimeCard({
    required this.time,
    super.key,
  });

  /// The time entry to display in this card.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(child: InfoTime(time: time)),
            EditButton(time: time),
          ],
        ),
      ),
    );
  }
}
