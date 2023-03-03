import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/times/delete_time/bloc/delete_time_bloc.dart';
import 'package:time_money/src/shared/consts/consts.dart';

class DeleteTimeButton extends StatelessWidget {
  const DeleteTimeButton({
    required this.time,
    super.key,
  });

  final ModelTime time;

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
            await Consts.delayed.then(
              (value) => Navigator.of(context).pop(),
            );
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
