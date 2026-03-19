import 'package:flutter/material.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

/// View displayed when loading time entries fails.
///
/// Wraps [ErrorView] to present the [failure] details along with
/// an optional [actionWidget] (e.g. a retry button).
class ErrorListTimesView extends StatelessWidget {
  /// Creates an [ErrorListTimesView] for the given [failure].
  const ErrorListTimesView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });

  /// The failure that caused the error state.
  final GlobalFailure failure;

  /// Optional action widget shown alongside the error message.
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ErrorView(failure, actionWidget: actionWidget);
  }
}
