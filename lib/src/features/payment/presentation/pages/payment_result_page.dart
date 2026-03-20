import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
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
      title: Text(context.l10n.resultInfoTitle),
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
            title: Text(context.l10n.hoursLabel),
            subtitle: Text('${result.totalHours}'),
          ),
          ListTile(
            title: Text(context.l10n.minutesLabel),
            subtitle: Text('${result.totalMinutes}'),
          ),
          ListTile(
            title: Text(context.l10n.hourlyLabel),
            subtitle: Text(
              '${result.wageHourly} ${context.l10n.dollarsLabel}',
            ),
          ),
          ListTile(
            title: Text(context.l10n.workedDaysLabel),
            subtitle: Text('${result.workedDays}'),
          ),
          const Divider(),
          Card(
            child: Center(
              child: Text(
                '${context.l10n.currencyPrefix}'
                '${result.totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
