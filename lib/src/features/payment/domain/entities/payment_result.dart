import 'package:flutter/foundation.dart';

@immutable
class PaymentResult {
  const PaymentResult({
    required this.totalHours,
    required this.totalMinutes,
    required this.wageHourly,
    required this.totalPayment,
    required this.workedDays,
  });

  final int totalHours;
  final int totalMinutes;
  final double wageHourly;
  final double totalPayment;
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
