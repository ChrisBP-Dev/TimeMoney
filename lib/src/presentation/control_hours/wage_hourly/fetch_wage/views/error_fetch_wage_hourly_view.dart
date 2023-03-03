import 'package:flutter/material.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/presentation/widgets/widgets.dart';

class ErrorFetchWageHourlyView extends StatelessWidget {
  const ErrorFetchWageHourlyView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });
  final GlobalDefaultFailure failure;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ErrorView(failure, actionWidget: actionWidget);
  }
}
