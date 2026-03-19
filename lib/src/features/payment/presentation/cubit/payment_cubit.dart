import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_state.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

export 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this._calculatePaymentUseCase)
      : super(const PaymentInitial());

  final CalculatePaymentUseCase _calculatePaymentUseCase;

  List<TimeEntry> _times = const [];
  double _wageHourly = 0;

  void setTimes(List<TimeEntry> times) {
    _times = times;
    _tryEmitReady();
  }

  void setWage(double wageHourly) {
    _wageHourly = wageHourly;
    _tryEmitReady();
  }

  Either<GlobalFailure, PaymentResult> calculate() {
    return switch (state) {
      PaymentInitial() =>
        left(const InternalError('payment data not available')),
      PaymentReady(:final times, :final wageHourly) =>
        _calculatePaymentUseCase(times, wageHourly),
    };
  }

  void _tryEmitReady() {
    if (_times.isNotEmpty && _wageHourly > 0) {
      emit(PaymentReady(times: _times, wageHourly: _wageHourly));
    } else {
      emit(const PaymentInitial());
    }
  }
}
