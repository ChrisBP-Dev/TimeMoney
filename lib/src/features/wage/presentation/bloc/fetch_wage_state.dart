import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

@immutable
sealed class FetchWageState {
  const FetchWageState();
}

final class FetchWageInitial extends FetchWageState {
  const FetchWageInitial();
}

final class FetchWageLoading extends FetchWageState {
  const FetchWageLoading();
}

final class FetchWageLoaded extends FetchWageState {
  const FetchWageLoaded(this.wage);
  final WageHourly wage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchWageLoaded && wage == other.wage;

  @override
  int get hashCode => wage.hashCode;
}

final class FetchWageError extends FetchWageState {
  const FetchWageError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchWageError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
