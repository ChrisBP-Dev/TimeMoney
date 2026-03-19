import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage/presentation/pages/update_wage_page.dart';

/// Button that opens the [UpdateWagePage] dialog for editing the wage.
class UpdateWageButton extends StatelessWidget {
  /// Creates an [UpdateWageButton].
  const UpdateWageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog<void>(
          context: context,
          builder: (context) => const UpdateWagePage(),
        );
      },
      child: const Text('change'),
    );
  }
}
