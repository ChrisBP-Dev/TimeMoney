import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';

/// Page that fetches and displays the current hourly wage.
///
/// Dispatches [FetchWageRequested] on build and reacts to
/// [FetchWageState] changes, rendering the appropriate loading,
/// loaded, or error view. On a successful load it also pushes
/// the wage value into [PaymentCubit].
class FetchWagePage extends StatelessWidget {
  /// Creates a [FetchWagePage].
  const FetchWagePage({super.key});

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
            actionWidget: Builder(
              builder: (context) => FilledButton.icon(
                onPressed: () => context
                    .read<FetchWageBloc>()
                    .add(const FetchWageRequested()),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.retry),
              ),
            ),
          ),
      },
    );
  }
}
