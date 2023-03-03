import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/result_screen.dart';

class CalculatePaymentButton extends StatelessWidget {
  const CalculatePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResultPaymentCubit, ResultPaymentState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state.times.isEmpty
              ? null
              : () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => ResultPaymentScreen(
                      times: state.times,
                      wageHourly: state.wageHourly,
                    ),
                  );
                },
          label: const Text(
            'Calculate Payment',
          ),
        );
      },
    );
  }
}
