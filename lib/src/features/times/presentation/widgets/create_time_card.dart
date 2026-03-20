import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Card containing the form fields for creating a new time entry.
///
/// Lays out `CreateHourField`, `CreateMinutesField`, and
/// `CreateTimeButton` in a row within a sized card. Used inside
/// `CreateTimePage` as the main form content.
class CreateTimeCard extends StatelessWidget {
  /// Creates a [CreateTimeCard].
  const CreateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .24,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                context.l10n.createTimeTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 3, child: CreateHourField()),
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: CreateMinutesField(),
                  ),
                  Spacer(),
                  CreateTimeButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
