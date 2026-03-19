import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

@immutable
sealed class UpdateWageState {
  const UpdateWageState({this.wageHourly = const WageHourly()});
  final WageHourly wageHourly;
}

final class UpdateWageInitial extends UpdateWageState {
  const UpdateWageInitial({super.wageHourly});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageInitial && wageHourly == other.wageHourly;

  @override
  int get hashCode => wageHourly.hashCode;
}

final class UpdateWageLoading extends UpdateWageState {
  const UpdateWageLoading({super.wageHourly});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageLoading && wageHourly == other.wageHourly;

  @override
  int get hashCode => wageHourly.hashCode;
}

final class UpdateWageSuccess extends UpdateWageState {
  const UpdateWageSuccess({required this.result, super.wageHourly});
  final WageHourly result;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageSuccess &&
          result == other.result &&
          wageHourly == other.wageHourly;

  @override
  int get hashCode => Object.hash(result, wageHourly);
}

final class UpdateWageError extends UpdateWageState {
  const UpdateWageError(this.failure, {super.wageHourly});
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageError &&
          failure == other.failure &&
          wageHourly == other.wageHourly;

  @override
  int get hashCode => Object.hash(failure, wageHourly);
}
