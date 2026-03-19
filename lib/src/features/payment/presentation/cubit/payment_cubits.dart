import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';

class PaymentCubits {
  static List<BlocProvider> list() => [
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(
            const CalculatePaymentUseCase(),
          ),
        ),
      ];
}
