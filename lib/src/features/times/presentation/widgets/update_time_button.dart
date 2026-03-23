import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';

/// Submit button for updating an existing time entry.
///
/// Uses [BlocConsumer] to react to [UpdateTimeBloc] state changes.
/// Shows contextual labels (Update, loading spinner, Success, Error),
/// disables itself during non-initial states, and pops the dialog
/// on successful update.
class UpdateTimeButton extends StatelessWidget {
  /// Creates an [UpdateTimeButton].
  const UpdateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateTimeBloc, UpdateTimeState>(
      listenWhen: (prev, curr) => curr is UpdateTimeSuccess,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 137, 86),
          ),
          onPressed: state is UpdateTimeInitial
              ? () {
                  context.read<UpdateTimeBloc>().add(
                    const UpdateTimeSubmitted(),
                  );
                }
              : null,
          child: switch (state) {
            UpdateTimeInitial() => Text(context.l10n.update),
            UpdateTimeLoading() => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            UpdateTimeSuccess() => Text(context.l10n.success),
            UpdateTimeError() => Text(context.l10n.error),
          },
        );
      },
    );
  }
}
