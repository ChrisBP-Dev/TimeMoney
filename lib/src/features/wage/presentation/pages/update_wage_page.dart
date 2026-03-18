import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';

class UpdateWagePage extends StatelessWidget {
  const UpdateWagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Horly pay:'),
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
        children: [WageHourlyField()],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: const [
        SetWageButton(),
      ],
    );
  }
}
