import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Sealed base class for all `PaymentCubit` states.
@immutable
sealed class PaymentState {
  /// Creates a [PaymentState] base instance.
  const PaymentState();
}

/// Initial state indicating that time entries or wage data is missing.
@immutable
final class PaymentInitial extends PaymentState {
  /// Creates a [PaymentInitial] state.
  const PaymentInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaymentInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// State indicating that both time entries and wage are available for
/// payment calculation.
@immutable
final class PaymentReady extends PaymentState {
  /// Creates a [PaymentReady] state with the given [times] and [wageHourly].
  const PaymentReady({required this.times, required this.wageHourly});

  /// The list of time entries to compute payment from.
  final List<TimeEntry> times;

  /// The hourly wage rate for the calculation.
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
