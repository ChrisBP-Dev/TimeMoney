import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';

class CreateTimeButton extends StatelessWidget {
  const CreateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTimeBloc, CreateTimeState>(
      builder: (context, state) => FilledButton(
        onPressed: () async {
          context.read<CreateTimeBloc>().add(const CreateTimeSubmitted());
          await Future<void>.delayed(AppDurations.actionFeedback);
          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
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
