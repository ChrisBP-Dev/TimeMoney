import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

/// Button that submits the wage update and shows feedback state.
///
/// Listens to [UpdateWageBloc] state changes: disables during loading,
/// shows success/error labels, and pops the dialog on success.
class SetWageButton extends StatelessWidget {
  /// Creates a [SetWageButton].
  const SetWageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateWageBloc, UpdateWageState>(
      listenWhen: (prev, curr) => curr is UpdateWageSuccess,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (_, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 137, 86),
          ),
          onPressed: state is UpdateWageLoading
              ? null
              : () => context.read<UpdateWageBloc>().add(
                  const UpdateWageSubmitted(),
                ),
          child: switch (state) {
            UpdateWageInitial() => Text(context.l10n.update),
            UpdateWageLoading() => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
            UpdateWageSuccess() => Text(context.l10n.success),
            UpdateWageError() => Text(context.l10n.error),
          },
        );
      },
    );
  }
}
