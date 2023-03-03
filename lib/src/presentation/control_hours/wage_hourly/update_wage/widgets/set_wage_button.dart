import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart';
import 'package:time_money/src/shared/consts/consts.dart';

class SetWageButton extends StatelessWidget {
  const SetWageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateWageHourlyBloc, UpdateWageHourlyState>(
      listener: (context, state) => state,
      builder: (_, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 137, 86),
          ),
          onPressed: () async {
            context.read<UpdateWageHourlyBloc>().add(
                  const UpdateWageHourlyEvent.update(),
                );

            await Consts.delayed.then(
              (value) => Navigator.of(context).pop(),
            );
          },
          child: state.currentState.when(
            initial: () => const Text('Update'),
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            success: (_) => const Text('Success'),
            error: (_) => const Text('Error'),
          ),
        );
      },
    );
  }
}
