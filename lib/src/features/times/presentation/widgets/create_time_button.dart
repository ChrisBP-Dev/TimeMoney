import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';

/// Submit button for creating a new time entry.
///
/// Uses [BlocConsumer] to react to [CreateTimeBloc] state changes.
/// Shows contextual labels (Create, loading spinner, Success, Error),
/// disables itself during non-initial states, and pops the dialog
/// on successful creation.
class CreateTimeButton extends StatelessWidget {
  /// Creates a [CreateTimeButton].
  const CreateTimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTimeBloc, CreateTimeState>(
      listenWhen: (previous, current) => current is CreateTimeSuccess,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      builder: (context, state) => FilledButton(
        onPressed: state is CreateTimeInitial
            ? () => context.read<CreateTimeBloc>().add(
                const CreateTimeSubmitted(),
              )
            : null,
        child: switch (state) {
          CreateTimeInitial() => Text(context.l10n.create),
          CreateTimeLoading() => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white),
          ),
          CreateTimeSuccess() => Text(context.l10n.success),
          CreateTimeError() => Text(context.l10n.error),
        },
      ),
    );
  }
}
