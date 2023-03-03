import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/widgets/widgets.dart';

class InfoTime extends StatelessWidget {
  const InfoTime({
    required this.time,
    super.key,
  });

  final ModelTime time;

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
