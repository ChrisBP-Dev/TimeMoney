import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.dart';

class ResultPaymentCubits {
  static List<BlocProvider> list() => [
        BlocProvider<ResultPaymentCubit>(
          create: (context) => ResultPaymentCubit(),
        ),
      ];
}
