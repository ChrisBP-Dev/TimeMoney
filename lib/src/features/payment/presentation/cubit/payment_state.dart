part of 'payment_cubit.dart';

@freezed
abstract class PaymentState with _$PaymentState {
  const factory PaymentState({
    @Default([]) List<TimeEntry> times,
    @Default(0.0) double wageHourly,
  }) = _PaymentState;

  factory PaymentState.initial() => const PaymentState();
}
