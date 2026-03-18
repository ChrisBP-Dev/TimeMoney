import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class InfoTime extends StatelessWidget {
  const InfoTime({
    required this.time,
    super.key,
  });

  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomInfo(
            category: 'Hour',
            value: '${time.hour}',
          ),
        ),
        Expanded(
          flex: 4,
          child: CustomInfo(
            category: 'Minutes',
            value: '${time.minutes}',
          ),
        ),
      ],
    );
  }
}
