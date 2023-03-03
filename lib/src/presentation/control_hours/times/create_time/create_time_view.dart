import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/widgets/widgets.dart';

class CreateTimeView extends StatelessWidget {
  const CreateTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Time:'),
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
          CreateTimeCard(),
        ],
      ),
    );
  }
}
