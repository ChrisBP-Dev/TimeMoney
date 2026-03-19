import 'package:flutter/material.dart';

/// Reusable label-value pair widget for displaying time entry data.
///
/// Renders a [category] label followed by its [value] in a horizontal
/// [Row]. Used by `InfoTime` to show hour and minutes values.
class CustomInfo extends StatelessWidget {
  /// Creates a [CustomInfo] with the given [category] label and [value].
  const CustomInfo({
    required this.category,
    required this.value,
    super.key,
  });

  /// The label describing the value (e.g. "Hour", "Minutes").
  final String category;

  /// The displayed value for this category.
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
