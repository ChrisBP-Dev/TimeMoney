import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/widgets/widgets.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({
    required this.time,
    super.key,
  });

  final ModelTime time;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      // color: const Color.fromARGB(255, 212, 223, 223),
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
