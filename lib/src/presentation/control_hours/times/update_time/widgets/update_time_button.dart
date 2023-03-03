import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/bloc/update_time_bloc.dart';
import 'package:time_money/src/shared/consts/consts.dart';

class UpdateTimeButton extends StatelessWidget {
  const UpdateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateTimeBloc, UpdateTimeState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 137, 86),
          ),
          onPressed: () async {
            context.read<UpdateTimeBloc>().add(
                  const UpdateTimeEvent.update(),
                );

            await Consts.delayed.whenComplete(
              () => Navigator.of(context).pop(),
            );
          },
          child: state.currentState.when(
            initial: () => const Text('Update'),
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            success: (_) => const Text('Success'),
            error: (_) => const Text('Error'),
          ),
        );
      },
    );
  }
}
