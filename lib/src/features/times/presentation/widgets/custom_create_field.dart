import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';

/// Reusable numeric text field for the create-time form.
///
/// Displays a labelled [TextField] configured for numeric input.
/// The [controller] manages the field's text state, and [onChanged]
/// is called whenever the user modifies the value.
class CustomCreateField extends StatelessWidget {
  /// Creates a [CustomCreateField] with the given [title] and [controller].
  const CustomCreateField({
    required this.title,
    required this.controller,
    super.key,
    this.onChanged,
  });

  /// The label displayed above the text field.
  final String title;

  /// Controller for the text field's current value.
  final TextEditingController? controller;

  /// Callback invoked when the text field value changes.
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.fieldLabel(title)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
