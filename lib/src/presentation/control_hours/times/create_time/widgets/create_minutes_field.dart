import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/bloc/create_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/widgets/widgets.dart';

class CreateMinutesField extends HookWidget {
  const CreateMinutesField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return BlocConsumer<CreateTimeBloc, CreateTimeState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return CustomCreateField(
          title: 'Minutes',
          controller: controller,
          onChanged: (value) => context.read<CreateTimeBloc>().add(
                CreateTimeEvent.changeMinutes(value: value),
              ),
        );
      },
    );
  }
}
