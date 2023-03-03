import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/views/views.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/widgets/widgets.dart';
import 'package:time_money/src/presentation/widgets/widgets.dart';

class ListTimesDataView extends StatelessWidget {
  const ListTimesDataView({
    required this.goalsStream,
    super.key,
  });

  final Stream<List<ModelTime>> goalsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ModelTime>>(
      stream: goalsStream,
      builder: (context, snapshot) => CatchErrorBuilder<List<ModelTime>>(
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
