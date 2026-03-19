import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';

class UpdateTimeButton extends StatelessWidget {
  const UpdateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateTimeBloc, UpdateTimeState>(
      listenWhen: (prev, curr) => curr is UpdateTimeSuccess,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 137, 86),
          ),
          onPressed: state is UpdateTimeLoading
              ? null
              : () {
                  context.read<UpdateTimeBloc>().add(
                        const UpdateTimeSubmitted(),
                      );
                },
          child: switch (state) {
            UpdateTimeInitial() => const Text('Update'),
            UpdateTimeLoading() => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            UpdateTimeSuccess() => const Text('Success'),
            UpdateTimeError() => const Text('Error'),
          },
        );
      },
    );
  }
}
