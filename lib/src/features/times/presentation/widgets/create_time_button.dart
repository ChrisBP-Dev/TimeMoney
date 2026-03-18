import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/ui/action_state.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';

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

          await Future<void>.delayed(AppDurations.actionFeedback);
          if (!context.mounted) return;
          Navigator.of(context).pop();
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
