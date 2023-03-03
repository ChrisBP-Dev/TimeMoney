import 'package:flutter/material.dart';

class CustomUpdateField extends StatelessWidget {
  const CustomUpdateField({
    required this.title,
    required this.controller,
    super.key,
    this.onChanged,
  });

  final String title;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title:'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          ),
        ),
      ],
    );
  }
}
