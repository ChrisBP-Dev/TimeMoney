import 'package:flutter/material.dart';

class CustomInfo extends StatelessWidget {
  const CustomInfo({
    required this.category,
    required this.value,
    super.key,
  });

  final String category;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$category:',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }
}
