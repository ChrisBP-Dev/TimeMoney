import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.dart';
import 'package:time_money/src/presentation/widgets/widgets.dart';

class ListTimesDataView extends StatelessWidget {
  const ListTimesDataView({
    required this.goalsStream,
    super.key,
  });

  final Stream<List<TimeEntry>> goalsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TimeEntry>>(
      stream: goalsStream,
      builder: (context, snapshot) => CatchErrorBuilder<List<TimeEntry>>(
        snapshot: snapshot,
        builder: (times) {
          context.read<ResultPaymentCubit>().setList(times);
          if (times.isEmpty) return const EmptyListTimesView();
          return Scrollbar(
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(4),
            child: ListView.builder(
              itemCount: times.length,
              itemBuilder: (_, i) {
                return TimeCard(time: times[i]);
              },
            ),
          );
        },
      ),
    );
  }
}
