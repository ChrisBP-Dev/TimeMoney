import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/update_wage/widgets/widgets.dart';

class WageHourlyView extends StatelessWidget {
  const WageHourlyView({
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [WageHourlyField()],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: const [
        SetWageButton(),
      ],
    );
  }
}
