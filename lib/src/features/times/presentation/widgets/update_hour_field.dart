import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class UpdateHourField extends StatefulWidget {
  const UpdateHourField({super.key});

  @override
  State<UpdateHourField> createState() => _UpdateHourFieldState();
}

class _UpdateHourFieldState extends State<UpdateHourField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<UpdateTimeBloc>().state.time?.hour.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateTimeBloc, UpdateTimeState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return CustomUpdateField(
          title: 'Hour',
          controller: _controller,
          onChanged: (value) => context.read<UpdateTimeBloc>().add(
                UpdateTimeEvent.changeHour(value: value),
              ),
        );
      },
    );
  }
}
