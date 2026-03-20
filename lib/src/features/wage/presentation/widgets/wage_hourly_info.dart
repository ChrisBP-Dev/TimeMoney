import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Displays the hourly wage label and numeric value in a column.
class WageHourlyInfo extends StatelessWidget {
  /// Creates a [WageHourlyInfo] for the given [wageHourly].
  const WageHourlyInfo({
    required this.wageHourly,
    super.key,
  });

  /// The hourly wage entity whose value is rendered.
  final WageHourly wageHourly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.hourlyLabel,
          style: const TextStyle(
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
