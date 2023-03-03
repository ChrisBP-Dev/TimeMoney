import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';

class WageHourlyInfo extends StatelessWidget {
  const WageHourlyInfo({
    required this.wageHourly,
    super.key,
  });

  final WageHourly wageHourly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'hourly:',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          wageHourly.value.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
