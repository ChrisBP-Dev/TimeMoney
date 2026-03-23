import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';

/// Factory class that provides the list of payment-related [BlocProvider]s.
///
/// Used by `BlocInjections` to register payment cubits in the widget tree.
class PaymentCubits {
  /// Returns a list containing the [PaymentCubit] provider.
  static List<BlocProvider> list() => [
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(
        const CalculatePaymentUseCase(),
      ),
    ),
  ];
}
