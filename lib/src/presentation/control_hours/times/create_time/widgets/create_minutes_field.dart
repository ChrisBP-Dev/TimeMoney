import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/bloc/create_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/widgets/widgets.dart';

class CreateMinutesField extends StatefulWidget {
  const CreateMinutesField({super.key});

  @override
  State<CreateMinutesField> createState() => _CreateMinutesFieldState();
}

class _CreateMinutesFieldState extends State<CreateMinutesField> {
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
    return BlocConsumer<CreateTimeBloc, CreateTimeState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return CustomCreateField(
          title: 'Minutes',
          controller: _controller,
          onChanged: (value) => context.read<CreateTimeBloc>().add(
                CreateTimeEvent.changeMinutes(value: value),
              ),
        );
      },
    );
  }
}
