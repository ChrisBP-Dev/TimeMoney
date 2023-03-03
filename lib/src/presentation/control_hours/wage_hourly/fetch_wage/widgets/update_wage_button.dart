import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/update_wage/wage_hourly_view.dart';

class UpdateWageButton extends StatelessWidget {
  const UpdateWageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog<void>(
          context: context,
          builder: (context) => const WageHourlyView(),
        );
      },
      child: const Text('change'),
    );
  }
}
