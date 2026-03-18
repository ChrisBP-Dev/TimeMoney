import 'package:flutter/material.dart';
import 'package:time_money/src/presentation/widgets/widgets.dart';

class ShimmerWageHourlyView extends StatelessWidget {
  const ShimmerWageHourlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
          // color: Colors.black,
          ),
    );
  }
}

class EmptyWageHourlyView extends StatelessWidget {
  const EmptyWageHourlyView({
    this.actionWidget,
    super.key,
  });
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ShowInfoSection(
      infoMessage: 'Empty List...\nThere is no times to calculate',
      infoImage: const IconText('🕰️'),
      actionWidget: actionWidget,
    );
  }
}
