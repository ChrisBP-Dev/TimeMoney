import 'package:flutter/material.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

/// Error view displayed when fetching the hourly wage fails.
///
/// Wraps the shared [ErrorView] and forwards the [failure] and an
/// optional [actionWidget] for retry or navigation.
class ErrorFetchWageHourlyView extends StatelessWidget {
  /// Creates an [ErrorFetchWageHourlyView] with the given [failure]
  /// and optional [actionWidget].
  const ErrorFetchWageHourlyView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });

  /// The failure to present to the user.
  final GlobalFailure failure;

  /// Optional action widget (e.g. retry button) shown below the error.
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ErrorView(failure, actionWidget: actionWidget);
  }
}
