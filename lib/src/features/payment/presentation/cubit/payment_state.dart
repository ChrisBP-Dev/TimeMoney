import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

@immutable
sealed class PaymentState {
  const PaymentState();
}

@immutable
final class PaymentInitial extends PaymentState {
  const PaymentInitial();

  @override
  bool operator ==(Object other) => other is PaymentInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
final class PaymentReady extends PaymentState {
  const PaymentReady({required this.times, required this.wageHourly});

  final List<TimeEntry> times;
  final double wageHourly;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReady &&
          const ListEquality<TimeEntry>().equals(times, other.times) &&
          wageHourly == other.wageHourly;

  @override
  int get hashCode =>
      Object.hash(const ListEquality<TimeEntry>().hash(times), wageHourly);
}
