import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class UpdateTimePage extends StatelessWidget {
  const UpdateTimePage({
    required this.time,
    super.key,
  });

  final TimeEntry time;

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
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
