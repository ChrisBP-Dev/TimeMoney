import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

class WageHourlyField extends StatefulWidget {
  const WageHourlyField({super.key});

  @override
  State<WageHourlyField> createState() => _WageHourlyFieldState();
}

class _WageHourlyFieldState extends State<WageHourlyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('hourly:'),
        const SizedBox(width: 25),
        BlocConsumer<UpdateWageBloc, UpdateWageState>(
          listener: (_, state) => state,
          builder: (context, state) {
            return SizedBox(
              width: 70,
              child: TextFormField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) =>
                    context.read<UpdateWageBloc>().add(
                          UpdateWageEvent.changeHourly(value: value),
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
