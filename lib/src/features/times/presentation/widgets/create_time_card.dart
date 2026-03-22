import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Card containing the form fields for creating a new time entry.
///
/// Lays out [CreateHourField] and [CreateMinutesField] in a row
/// within a card. Used inside `CreateTimePage` as the main form
/// content — the submit button lives in the dialog actions.
class CreateTimeCard extends StatelessWidget {
  /// Creates a [CreateTimeCard].
  const CreateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 3, child: CreateHourField()),
            Spacer(),
            Expanded(
              flex: 4,
              child: CreateMinutesField(),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
