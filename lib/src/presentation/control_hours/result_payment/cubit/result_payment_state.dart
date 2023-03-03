part of 'result_payment_cubit.dart';

@freezed
class ResultPaymentState with _$ResultPaymentState {
  const factory ResultPaymentState({
    @Default([]) List<ModelTime> times,
    @Default(0.0) double wageHourly,
  }) = _ResultPaymentState;

  factory ResultPaymentState.initial() => const ResultPaymentState();
}
