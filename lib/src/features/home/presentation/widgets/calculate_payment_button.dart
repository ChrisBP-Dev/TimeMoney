import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/payment/presentation/pages/pages.dart';

/// FAB that triggers payment calculation when the [PaymentCubit] is ready.
///
/// Disabled when the cubit is in [PaymentInitial] state. On tap, computes
/// the payment and shows the result in a [PaymentResultPage] dialog.
class CalculatePaymentButton extends StatelessWidget {
  /// Creates a [CalculatePaymentButton].
  const CalculatePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state is! PaymentReady
              ? null
              : () {
                  context.read<PaymentCubit>().calculate().fold(
                    (_) {},
                    (paymentResult) => unawaited(
                      showDialog<void>(
                        context: context,
                        builder: (_) =>
                            PaymentResultPage(result: paymentResult),
                      ),
                    ),
                  );
                },
          label: const Text('Calculate Payment'),
        );
      },
    );
  }
}
