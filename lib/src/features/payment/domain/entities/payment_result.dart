import 'package:meta/meta.dart';

/// Immutable domain entity representing the result of a payment calculation.
///
/// Encapsulates the computed totals derived from a set of `TimeEntry` records
/// and an hourly wage rate.
@immutable
class PaymentResult {
  /// Creates a [PaymentResult] with all required computed fields.
  const PaymentResult({
    required this.totalHours,
    required this.totalMinutes,
    required this.wageHourly,
    required this.totalPayment,
    required this.workedDays,
  });

  /// Total whole hours worked across all time entries.
  final int totalHours;

  /// Remaining minutes beyond [totalHours].
  final int totalMinutes;

  /// Hourly wage rate used for the calculation.
  final double wageHourly;

  /// Computed total payment amount (wage * time worked).
  final double totalPayment;

  /// Number of distinct days worked.
  final int workedDays;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResult &&
          totalHours == other.totalHours &&
          totalMinutes == other.totalMinutes &&
          wageHourly == other.wageHourly &&
          totalPayment == other.totalPayment &&
          workedDays == other.workedDays;

  @override
  int get hashCode => Object.hash(
        totalHours,
        totalMinutes,
        wageHourly,
        totalPayment,
        workedDays,
      );
}
