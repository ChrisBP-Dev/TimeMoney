import 'package:flutter/material.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

class ShimmerListTimesView extends StatelessWidget {
  const ShimmerListTimesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class EmptyListTimesView extends StatelessWidget {
  const EmptyListTimesView({
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
