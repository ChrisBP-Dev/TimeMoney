import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
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
      listener: (context, state) => state,
      builder: (_, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 163, 70, 64),
          ),
          onPressed: () async {
            context.read<DeleteTimeBloc>().add(
                  DeleteTimeEvent.delete(time: time),
                );
            await Future<void>.delayed(AppDurations.actionFeedback);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: state.when(
            initial: () => const Text('Delete'),
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            success: () => const Text('Success'),
            error: (_) => const Text('Error'),
          ),
        );
      },
    );
  }
}
