import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

class CalculatePaymentUseCase {
  const CalculatePaymentUseCase();

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
