import 'package:flutter/material.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';

/// Dialog page that displays a [PaymentResult] summary.
///
/// Shows total hours, minutes, hourly rate, worked days, and the
/// computed total payment in a scrollable [AlertDialog].
class PaymentResultPage extends StatelessWidget {
  /// Creates a [PaymentResultPage] for the given [result].
  const PaymentResultPage({required this.result, super.key});

  /// The payment result to display.
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
