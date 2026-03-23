import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Page that displays the list of time entries.
///
/// Uses [BlocConsumer] to reactively render different views based on
/// [ListTimesBloc] state: loading shimmer, empty state, error state,
/// or a scrollable data list. Also synchronises loaded times with
/// the [PaymentCubit] so payment calculations stay up-to-date.
class ListTimesPage extends StatelessWidget {
  /// Creates a [ListTimesPage].
  const ListTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListTimesBloc, ListTimesState>(
      listener: (context, state) {
        switch (state) {
          case ListTimesLoaded(:final times):
            context.read<PaymentCubit>().setTimes(times);
          case ListTimesEmpty():
          case ListTimesError():
            context.read<PaymentCubit>().setTimes(const []);
          default:
            break;
        }
      },
      bloc: context.read<ListTimesBloc>()..add(const ListTimesRequested()),
      builder: (context, state) => switch (state) {
        ListTimesInitial() => const ShimmerListTimesView(),
        ListTimesLoading() => const ShimmerListTimesView(),
        ListTimesEmpty() => const EmptyListTimesView(),
        ListTimesError(:final failure) => ErrorListTimesView(
          failure,
          actionWidget: Builder(
            builder: (context) => FilledButton.icon(
              onPressed: () =>
                  context.read<ListTimesBloc>().add(const ListTimesRequested()),
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ),
        ),
        ListTimesLoaded(:final times) => ListTimesDataView(times: times),
      },
    );
  }
}
