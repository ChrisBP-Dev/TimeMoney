import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

class ListTimesScreen extends StatelessWidget {
  const ListTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListTimesBloc, ListTimesState>(
      listener: (context, state) {
        if (state case ListTimesLoaded(:final times)) {
          context.read<PaymentCubit>().setTimes(times);
        }
      },
      bloc: context.read<ListTimesBloc>()..add(const ListTimesRequested()),
      builder: (context, state) => switch (state) {
        ListTimesInitial() => const ShimmerListTimesView(),
        ListTimesLoading() => const ShimmerListTimesView(),
        ListTimesEmpty() =>
          const EmptyListTimesView(actionWidget: _ActionWidget()),
        ListTimesError(:final failure) => ErrorListTimesView(
            failure,
            actionWidget: const _ActionWidget(),
          ),
        ListTimesLoaded(:final times) => ListTimesDataView(times: times),
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
