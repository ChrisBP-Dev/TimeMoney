import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_update_field.dart';

class UpdateMinutesField extends StatefulWidget {
  const UpdateMinutesField({super.key});

  @override
  State<UpdateMinutesField> createState() => _UpdateMinutesFieldState();
}

class _UpdateMinutesFieldState extends State<UpdateMinutesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<UpdateTimeBloc>().state.time?.minutes.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateTimeBloc, UpdateTimeState>(
      builder: (context, state) {
        return CustomUpdateField(
          title: 'Minutes',
          controller: _controller,
          onChanged: (value) => context.read<UpdateTimeBloc>().add(
                UpdateTimeMinutesChanged(value: value),
              ),
        );
      },
    );
  }
}
