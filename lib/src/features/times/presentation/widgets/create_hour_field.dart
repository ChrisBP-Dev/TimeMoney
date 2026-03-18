import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class CreateHourField extends StatefulWidget {
  const CreateHourField({super.key});

  @override
  State<CreateHourField> createState() => _CreateHourFieldState();
}

class _CreateHourFieldState extends State<CreateHourField> {
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
    return BlocListener<CreateTimeBloc, CreateTimeState>(
      listenWhen: (previous, current) =>
          current is CreateTimeInitial &&
          current.hour == 0 &&
          current.minutes == 0 &&
          previous is! CreateTimeInitial,
      listener: (context, state) => _controller.clear(),
      child: CustomCreateField(
        title: 'Hour',
        controller: _controller,
        onChanged: (value) => context.read<CreateTimeBloc>().add(
              CreateTimeHourChanged(value: value),
            ),
      ),
    );
  }
}
