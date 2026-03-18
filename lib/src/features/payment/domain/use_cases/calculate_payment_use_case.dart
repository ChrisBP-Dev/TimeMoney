import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Calculates total payment from time entries and hourly wage.
/// Uses the CalculatePay extension on `List<TimeEntry>`.
/// No repository dependencies — pure domain calculation.
class CalculatePaymentUseCase {
  const CalculatePaymentUseCase();

  double call(List<TimeEntry> times, double wageHourly) {
    return times.calculatePayment(wageHourly);
  }
}
