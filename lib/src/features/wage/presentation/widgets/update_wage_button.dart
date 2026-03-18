import 'package:flutter/material.dart';
import 'package:time_money/src/features/wage/presentation/pages/update_wage_page.dart';

class UpdateWageButton extends StatelessWidget {
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
