import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class CreateTimePage extends StatelessWidget {
  const CreateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Time:'),
      iconPadding: const EdgeInsets.all(7),
      icon: Align(
        alignment: Alignment.topRight,
        child: Card(
          child: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CreateTimeCard(),
        ],
      ),
    );
  }
}
