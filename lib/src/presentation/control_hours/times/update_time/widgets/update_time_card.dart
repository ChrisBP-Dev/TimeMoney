import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/widgets/widgets.dart';

class UpdateTimeCard extends StatelessWidget {
  const UpdateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
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
