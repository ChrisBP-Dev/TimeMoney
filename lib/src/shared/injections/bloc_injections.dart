import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/result_payment_cubits.dart';
import 'package:time_money/src/presentation/control_hours/times/times_blocs.dart';
import 'package:time_money/src/presentation/control_hours/wage_hourly/wage_hourly_blocs.dart';

class BlocInjections {
  static List<BlocProvider> list() => [
        ...TimesBlocs.list(),
        ...WageHourlyBlocs.list(),
        ...ResultPaymentCubits.list(),
      ];
}
