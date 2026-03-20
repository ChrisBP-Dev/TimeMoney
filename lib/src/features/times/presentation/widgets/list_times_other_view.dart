import 'package:flutter/material.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

/// Loading placeholder view shown while time entries are being fetched.
///
/// Displays a centered [CircularProgressIndicator] to indicate that
/// data is loading. Used during initial and refresh loading states.
class ShimmerListTimesView extends StatelessWidget {
  /// Creates a [ShimmerListTimesView].
  const ShimmerListTimesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// View displayed when the time entries list is empty.
///
/// Shows a friendly informational section with an icon and a message
/// telling the user there are no time entries to calculate.
/// An optional [actionWidget] can be provided for a call-to-action.
class EmptyListTimesView extends StatelessWidget {
  /// Creates an [EmptyListTimesView] with an optional [actionWidget].
  const EmptyListTimesView({
    this.actionWidget,
    super.key,
  });

  /// Optional action widget shown below the empty state message.
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return ShowInfoSection(
      infoMessage: context.l10n.emptyTimesMessage,
      infoImage: const IconText('🕰️'),
      actionWidget: actionWidget,
    );
  }
}
