import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';

class CreateTimeButton extends StatelessWidget {
  const CreateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTimeBloc, CreateTimeState>(
      listenWhen: (previous, current) => current is CreateTimeSuccess,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) => FilledButton(
        onPressed: () =>
            context.read<CreateTimeBloc>().add(const CreateTimeSubmitted()),
        child: switch (state) {
          CreateTimeInitial() => const Text('Create'),
          CreateTimeLoading() => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          CreateTimeSuccess() => const Text('Success'),
          CreateTimeError() => const Text('Error'),
        },
      ),
    );
  }
}
