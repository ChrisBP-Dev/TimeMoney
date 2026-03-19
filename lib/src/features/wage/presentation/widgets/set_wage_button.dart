import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

class SetWageButton extends StatelessWidget {
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
          onPressed: () => context.read<UpdateWageBloc>().add(
                const UpdateWageSubmitted(),
              ),
          child: switch (state) {
            UpdateWageInitial() => const Text('Update'),
            UpdateWageLoading() => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            UpdateWageSuccess() => const Text('Success'),
            UpdateWageError() => const Text('Error'),
          },
        );
      },
    );
  }
}
