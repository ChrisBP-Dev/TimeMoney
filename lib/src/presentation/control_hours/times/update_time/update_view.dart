import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/times/delete_time/widgets/delete_time_button.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/widgets/widgets.dart';

class UpdateTimeView extends StatelessWidget {
  const UpdateTimeView({
    required this.time,
    super.key,
  });

  final ModelTime time;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update or Delete:'),
      iconPadding: const EdgeInsets.all(7),
      icon: Align(
        alignment: Alignment.topRight,
        child: Card(
          child: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          UpdateTimeCard(),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        DeleteTimeButton(time: time),
        const UpdateTimeButton(),
      ],
    );
  }
}
