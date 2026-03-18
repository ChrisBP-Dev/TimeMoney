import 'package:flutter/material.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

class ErrorFetchWageHourlyView extends StatelessWidget {
  const ErrorFetchWageHourlyView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });
  final GlobalFailure failure;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ErrorView(failure, actionWidget: actionWidget);
  }
}
