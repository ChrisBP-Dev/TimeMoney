import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/bloc/create_time_bloc.dart';
import 'package:time_money/src/shared/consts/consts.dart';

class CreateTimeButton extends StatelessWidget {
  const CreateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTimeBloc, CreateTimeState>(
      listener: (context, state) => state,
      builder: (_, state) => FilledButton(
        onPressed: () async {
          context.read<CreateTimeBloc>().add(
                const CreateTimeEvent.create(),
              );

          await Consts.delayed.whenComplete(
            () => Navigator.of(context).pop(),
          );
          // FocusManager.instance.primaryFocus?.unfocus();
        },
        child: state.currentState.when(
          initial: () => const Text('Create'),
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white),
          ),
          success: (_) => const Text('Success'),
          error: (_) => const Text('Error'),
        ),
      ),
    );
  }
}
