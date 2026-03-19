import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';

class DeleteTimeButton extends StatelessWidget {
  const DeleteTimeButton({
    required this.time,
    super.key,
  });

  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteTimeBloc, DeleteTimeState>(
      listenWhen: (prev, curr) => curr is DeleteTimeSuccess,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      builder: (_, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 163, 70, 64),
          ),
          onPressed: state is DeleteTimeInitial
              ? () {
                  context.read<DeleteTimeBloc>().add(
                        DeleteTimeRequested(time: time),
                      );
                }
              : null,
          child: switch (state) {
            DeleteTimeInitial() => const Text('Delete'),
            DeleteTimeLoading() => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            DeleteTimeSuccess() => const Text('Success'),
            DeleteTimeError() => const Text('Error'),
          },
        );
      },
    );
  }
}
