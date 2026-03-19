import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';

/// Card widget that displays the current hourly wage alongside an
/// [UpdateWageButton] for editing.
class WageHourlyCard extends StatelessWidget {
  /// Creates a [WageHourlyCard] showing the given [wageHourly].
  const WageHourlyCard({
    required this.wageHourly,
    super.key,
  });

  /// The hourly wage entity to display.
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
