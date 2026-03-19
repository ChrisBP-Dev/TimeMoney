import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';

class FetchWageScreen extends StatelessWidget {
  const FetchWageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchWageBloc, FetchWageState>(
      listenWhen: (prev, curr) => curr is FetchWageLoaded,
      listener: (context, state) {
        if (state is FetchWageLoaded) {
          context.read<PaymentCubit>().setWage(state.wage.value);
        }
      },
      bloc: context.read<FetchWageBloc>()
        ..add(const FetchWageRequested()),
      builder: (context, state) => switch (state) {
        FetchWageInitial() => const ShimmerWageHourlyView(),
        FetchWageLoading() => const ShimmerWageHourlyView(),
        FetchWageLoaded(:final wage) => WageHourlyCard(wageHourly: wage),
        FetchWageError(:final failure) => ErrorFetchWageHourlyView(
            failure,
            actionWidget: const _ActionWidget(),
          ),
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
