import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';

class WageHourlyCard extends StatelessWidget {
  const WageHourlyCard({
    required this.wageHourly,
    super.key,
  });

  final WageHourly wageHourly;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            WageHourlyInfo(wageHourly: wageHourly),
            const Spacer(),
            const UpdateWageButton(),
          ],
        ),
      ),
    );
  }
}
