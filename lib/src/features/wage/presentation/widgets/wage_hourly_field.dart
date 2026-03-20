import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

/// Text input field for entering a new hourly wage value.
///
/// Dispatches [UpdateWageHourlyChanged] events to [UpdateWageBloc]
/// on each keystroke for real-time validation.
class WageHourlyField extends StatefulWidget {
  /// Creates a [WageHourlyField].
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
        Text(context.l10n.hourlyLabel),
        const SizedBox(width: 25),
        BlocBuilder<UpdateWageBloc, UpdateWageState>(
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
                          UpdateWageHourlyChanged(value: value),
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
