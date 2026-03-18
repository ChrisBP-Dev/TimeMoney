import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({
    required this.time,
    super.key,
  });

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
