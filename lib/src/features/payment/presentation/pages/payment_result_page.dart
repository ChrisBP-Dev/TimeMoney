import 'package:flutter/material.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({required this.result, super.key});

  final PaymentResult result;

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
            subtitle: Text('${result.totalHours}'),
          ),
          ListTile(
            title: const Text('Minutes:'),
            subtitle: Text('${result.totalMinutes}'),
          ),
          ListTile(
            title: const Text('Hourly:'),
            subtitle: Text('${result.wageHourly} Dolars'),
          ),
          ListTile(
            title: const Text('Worked days:'),
            subtitle: Text('${result.workedDays}'),
          ),
          const Divider(),
          Card(
            child: Center(
              child: Text(
                '\$/. ${result.totalPayment.toStringAsFixed(2)}',
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
