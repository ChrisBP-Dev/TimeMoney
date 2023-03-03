import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/fetch_wage/widgets/widgets.dart';
import 'package:time_money/src/presentation/widgets/widgets.dart';

class WageHourlyDataView extends StatelessWidget {
  const WageHourlyDataView({
    required this.wageHourly,
    super.key,
  });

  final Stream<WageHourly> wageHourly;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WageHourly>(
      stream: wageHourly,
      builder: (context, snapshot) => CatchErrorBuilder<WageHourly>(
        snapshot: snapshot,
        builder: (wage) {
          context.read<ResultPaymentCubit>().setWage(wage.value);
          return WageHourlyCard(wageHourly: wage);
        },
      ),
    );
  }
}
