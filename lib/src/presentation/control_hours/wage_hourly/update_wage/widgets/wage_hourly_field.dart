import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart';

class WageHourlyField extends HookWidget {
  const WageHourlyField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Row(
      children: [
        const Text('hourly:'),
        const SizedBox(width: 25),
        BlocConsumer<UpdateWageHourlyBloc, UpdateWageHourlyState>(
          listener: (_, state) => state,
          builder: (context, state) {
            return SizedBox(
              width: 70,
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) => context.read<UpdateWageHourlyBloc>().add(
                      UpdateWageHourlyEvent.changeHourly(value: value),
                    ),
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
