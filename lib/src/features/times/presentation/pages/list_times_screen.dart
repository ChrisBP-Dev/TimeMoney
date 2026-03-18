import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class ListTimesScreen extends StatelessWidget {
  const ListTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListTimesBloc, ListTimesState>(
      listener: (context, state) => state,
      bloc: context.read<ListTimesBloc>()..add(const ListTimesEvent.getTimes()),
      builder: (context, state) {
        return state.when(
          initial: ShimmerListTimesView.new,
          loading: ShimmerListTimesView.new,
          empty: () => const EmptyListTimesView(
            actionWidget: _ActionWidget(),
          ),
          error: (err) => ErrorListTimesView(
            err,
            actionWidget: const _ActionWidget(),
          ),
          hasDataStream: (goals) => ListTimesDataView(goalsStream: goals),
        );
      },
    );
  }
}

class _ActionWidget extends StatelessWidget {
  const _ActionWidget();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: const Text('error'));
  }
}
