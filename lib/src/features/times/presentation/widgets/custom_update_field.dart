import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';

/// Reusable numeric text field for the update-time form.
///
/// Displays a labelled [TextField] configured for numeric input.
/// The [controller] manages the field's text state, and [onChanged]
/// is called whenever the user modifies the value.
///
/// Exposes a [Semantics] identifier via [semanticId] to support
/// accessibility services and E2E UI testing tools (e.g. Maestro).
class CustomUpdateField extends StatelessWidget {
  /// Creates a [CustomUpdateField] with the given [title] and [controller].
  const CustomUpdateField({
    required this.title,
    required this.semanticId,
    required this.controller,
    super.key,
    this.onChanged,
  });

  /// The label displayed above the text field.
  final String title;

  /// Locale-invariant identifier for accessibility and E2E testing.
  final String semanticId;

  /// Controller for the text field's current value.
  final TextEditingController? controller;

  /// Callback invoked when the text field value changes.
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.fieldLabel(title)),
        const SizedBox(height: 8),
        Semantics(
          identifier: semanticId,
          child: TextField(
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
        ),
      ],
    );
  }
}
