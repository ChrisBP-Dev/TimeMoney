import 'package:flutter/material.dart';

class CustomCreateField extends StatelessWidget {
  const CustomCreateField({
    required this.title,
    required this.controller,
    // required this.focus,
    super.key,
    this.onChanged,
  });

  final String title;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  // final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title:'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          // focusNode: focus,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
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
