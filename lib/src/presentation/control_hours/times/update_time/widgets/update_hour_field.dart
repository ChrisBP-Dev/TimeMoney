import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/bloc/update_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/widgets/widgets.dart';

class UpdateHourField extends HookWidget {
  const UpdateHourField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.watch<UpdateTimeBloc>().state.time?.hour.toString(),
    );
    return BlocConsumer<UpdateTimeBloc, UpdateTimeState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return CustomUpdateField(
          title: 'Hour',
          controller: controller,
          onChanged: (value) => context.read<UpdateTimeBloc>().add(
                UpdateTimeEvent.changeHour(value: value),
              ),
        );
      },
    );
  }
}
