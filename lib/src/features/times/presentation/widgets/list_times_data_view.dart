import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class ListTimesDataView extends StatelessWidget {
  const ListTimesDataView({required this.times, super.key});
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
