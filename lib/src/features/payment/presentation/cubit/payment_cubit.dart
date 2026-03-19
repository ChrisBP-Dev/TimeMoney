import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_state.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

export 'payment_state.dart';

/// Cubit managing payment readiness and calculation.
///
/// Tracks time entries and wage rate independently, emitting
/// [PaymentReady] only when both inputs are valid. Delegates the
/// actual computation to [CalculatePaymentUseCase].
class PaymentCubit extends Cubit<PaymentState> {
  /// Creates a [PaymentCubit] with the given [CalculatePaymentUseCase].
  PaymentCubit(this._calculatePaymentUseCase)
      : super(const PaymentInitial());

  final CalculatePaymentUseCase _calculatePaymentUseCase;

  List<TimeEntry> _times = const [];
  double _wageHourly = 0;

  /// Updates the list of time entries and re-evaluates readiness.
  void setTimes(List<TimeEntry> times) {
    _times = times;
    _tryEmitReady();
  }

  /// Updates the hourly wage rate and re-evaluates readiness.
  void setWage(double wageHourly) {
    _wageHourly = wageHourly;
    _tryEmitReady();
  }

  /// Calculates the payment based on current state.
  ///
  /// Returns a [Left] failure if the cubit is not in [PaymentReady] state,
  /// otherwise delegates to [CalculatePaymentUseCase].
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
