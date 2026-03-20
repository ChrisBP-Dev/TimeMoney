import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Widget that displays the hour and minutes of a [TimeEntry].
///
/// Renders two [CustomInfo] labels side by side -- one for the hour
/// value and one for the minutes value -- using an [Expanded] layout.
class InfoTime extends StatelessWidget {
  /// Creates an [InfoTime] display for the given [time] entry.
  const InfoTime({
    required this.time,
    super.key,
  });

  /// The time entry whose hour and minutes are shown.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomInfo(
            category: context.l10n.hourTitle,
            value: '${time.hour}',
          ),
        ),
        Expanded(
          flex: 4,
          child: CustomInfo(
            category: context.l10n.minutesTitle,
            value: '${time.minutes}',
          ),
        ),
      ],
    );
  }
}
