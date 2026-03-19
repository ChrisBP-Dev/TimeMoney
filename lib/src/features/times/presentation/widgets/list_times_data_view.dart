import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// View that renders a scrollable list of [TimeCard] widgets.
///
/// Displayed when `ListTimesBloc` emits a loaded state with data.
/// Each [TimeEntry] is rendered as a [TimeCard] inside a [ListView]
/// wrapped with a visible [Scrollbar].
class ListTimesDataView extends StatelessWidget {
  /// Creates a [ListTimesDataView] with the given list of [times].
  const ListTimesDataView({required this.times, super.key});

  /// The time entries to display in the list.
  final List<TimeEntry> times;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: ListView.builder(
        itemCount: times.length,
        itemBuilder: (_, i) => TimeCard(time: times[i]),
      ),
    );
  }
}
