import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';

class CalculatePaymentButton extends StatelessWidget {
  const CalculatePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state.times.isEmpty
              ? null
              : () {
                  unawaited(showDialog<void>(
                    context: context,
                    builder: (_) => PaymentResultPage(
                      times: state.times,
                      wageHourly: state.wageHourly,
                    ),
                  ));
                },
          label: const Text(
            'Calculate Payment',
          ),
        );
      },
    );
  }
}
