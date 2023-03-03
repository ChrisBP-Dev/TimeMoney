import 'package:flutter/material.dart';
import 'package:time_money/src/core/extensions/screen_size.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/calculate_payment_button.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/widgets/widgets.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/list_times_screen.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/fetch_wage/fetch_wage_screen.dart';

class ControlHoursPage extends StatelessWidget {
  const ControlHoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    // print(FocusManager.instance.primaryFocus?.hasFocus);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Work Payment Controller',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          const FetchWageScreen(),
          const Expanded(child: ListTimesScreen()),
          SafeArea(
            child: Container(
              color: Theme.of(context).colorScheme.background.withOpacity(.2),
              height: context.getHeight * .13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CalculatePaymentButton(),
                  FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => const CreateTimeCard(),
                      );
                    },
                    label: const Text(
                      'Add Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
