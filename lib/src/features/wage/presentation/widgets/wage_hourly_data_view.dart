import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/widgets/widgets.dart';
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
          context.read<PaymentCubit>().setWage(wage.value);
          return WageHourlyCard(wageHourly: wage);
        },
      ),
    );
  }
}
