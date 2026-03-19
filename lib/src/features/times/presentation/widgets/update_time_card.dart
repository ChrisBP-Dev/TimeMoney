import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Card containing the form fields for updating an existing time entry.
///
/// Lays out `UpdateHourField` and `UpdateMinutesField` in a row
/// within a card. Used inside `UpdateTimePage` as the main form content.
class UpdateTimeCard extends StatelessWidget {
  /// Creates an [UpdateTimeCard].
  const UpdateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 3, child: UpdateHourField()),
            Spacer(),
            Expanded(
              flex: 4,
              child: UpdateMinutesField(),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
