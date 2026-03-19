import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Use case that computes a [PaymentResult] from time entries
/// and an hourly wage.
///
/// Returns [Either] a [GlobalFailure] on error or a valid [PaymentResult]
/// on success.
class CalculatePaymentUseCase {
  /// Creates a const instance with no dependencies.
  const CalculatePaymentUseCase();

  /// Calculates the total payment for the given [times] at [wageHourly].
  ///
  /// Wraps computation in a try/catch, returning a [Left] failure when an
  /// unexpected exception occurs.
  Either<GlobalFailure, PaymentResult> call(
    List<TimeEntry> times,
    double wageHourly,
  ) {
    try {
      return right(
        PaymentResult(
          totalHours: times.totalHours,
          totalMinutes: times.totalMinutes,
          wageHourly: wageHourly,
          totalPayment: times.calculatePayment(wageHourly),
          workedDays: times.length,
        ),
      );
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
