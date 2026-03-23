import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Base state type for `FetchWageBloc`.
@immutable
sealed class FetchWageState {
  /// Creates a [FetchWageState].
  const FetchWageState();
}

/// The initial state before any fetch has been requested.
final class FetchWageInitial extends FetchWageState {
  /// Creates a [FetchWageInitial] state.
  const FetchWageInitial();
}

/// Indicates the wage fetch is in progress.
final class FetchWageLoading extends FetchWageState {
  /// Creates a [FetchWageLoading] state.
  const FetchWageLoading();
}

/// Holds the successfully loaded [WageHourly].
final class FetchWageLoaded extends FetchWageState {
  /// Creates a [FetchWageLoaded] state with the retrieved [wage].
  const FetchWageLoaded(this.wage);

  /// The fetched hourly wage entity.
  final WageHourly wage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FetchWageLoaded && wage == other.wage;

  @override
  int get hashCode => wage.hashCode;
}

/// Indicates the wage fetch failed with a [GlobalFailure].
final class FetchWageError extends FetchWageState {
  /// Creates a [FetchWageError] state with the given [failure].
  const FetchWageError(this.failure);

  /// The failure that caused the fetch to fail.
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchWageError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
