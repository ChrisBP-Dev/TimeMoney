import 'package:flutter/material.dart';

/// Placeholder loading view displayed while the wage is being fetched.
///
/// Shows a centered [CircularProgressIndicator] as a shimmer stand-in.
class ShimmerWageHourlyView extends StatelessWidget {
  /// Creates a [ShimmerWageHourlyView].
  const ShimmerWageHourlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
