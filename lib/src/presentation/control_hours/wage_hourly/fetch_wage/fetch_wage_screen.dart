import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/fetch_wage/views/views.dart';

class FetchWageScreen extends StatelessWidget {
  const FetchWageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchWageHourlyBloc, FetchWageHourlyState>(
      listener: (context, state) => state,
      bloc: context.read<FetchWageHourlyBloc>()
        ..add(
          const FetchWageHourlyEvent.getWage(),
        ),
      builder: (context, state) {
        return state.when(
          initial: ShimmerWageHourlyView.new,
          loading: ShimmerWageHourlyView.new,
          empty: () => const EmptyWageHourlyView(
            actionWidget: _ActionWidget(),
          ),
          error: (err) => ErrorFetchWageHourlyView(
            err,
            actionWidget: const _ActionWidget(),
          ),
          hasDataStream: (goals) => WageHourlyDataView(wageHourly: goals),
        );
      },
    );
  }
}

class _ActionWidget extends StatelessWidget {
  const _ActionWidget();

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<DoubtBloc,DoubtState>(
    //   listener: (context, state) => state.listData,
    //   builder: (context) {
    //     return ActionButton(
    //         textButton: 'Refrescar',
    //         state: controller.actionState,
    //         onPressed: controller.getDoubtList,
    //       );
    //   }
    // );
    return ElevatedButton(onPressed: () {}, child: const Text('error'));
  }
}
