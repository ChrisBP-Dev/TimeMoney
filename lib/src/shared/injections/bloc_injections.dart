import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/times_blocs.dart';
import 'package:time_money/src/features/wage/presentation/bloc/wage_blocs.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/result_payment_cubits.dart';

class BlocInjections {
  static List<BlocProvider> list() => [
        ...TimesBlocs.list(),
        ...WageBlocs.list(),
        ...ResultPaymentCubits.list(),
      ];
}
