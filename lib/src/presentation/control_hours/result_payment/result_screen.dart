import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';

class ResultPaymentScreen extends StatelessWidget {
  const ResultPaymentScreen({
    required this.times,
    required this.wageHourly,
    super.key,
  });

  final List<ModelTime> times;
  final double wageHourly;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Result Info:'),
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
        children: [
          ListTile(
            title: const Text('Hours:'),
            subtitle: Text('${times.totalHours}'),
          ),
          ListTile(
            title: const Text('Minutes:'),
            subtitle: Text('${times.totalMinutes}'),
          ),
          ListTile(
            title: const Text('Hourly:'),
            subtitle: Text('$wageHourly Dolars'),
          ),
          ListTile(
            title: const Text('Worked days:'),
            subtitle: Text('${times.length}'),
          ),
          const Divider(),
          Card(
            child: Center(
              child: Text(
                '\$/. ${times.calculatePayment(wageHourly).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
