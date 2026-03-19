import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Base state type for `UpdateWageBloc`.
///
/// Every substate carries the current [wageHourly] so the UI can always
/// display the latest in-progress value.
@immutable
sealed class UpdateWageState {
  /// Creates an [UpdateWageState] with an optional [wageHourly].
  const UpdateWageState({this.wageHourly = const WageHourly()});

  /// The current in-progress hourly wage value.
  final WageHourly wageHourly;
}

/// The initial idle state, ready for user input.
final class UpdateWageInitial extends UpdateWageState {
  /// Creates an [UpdateWageInitial] state with an optional [wageHourly].
  const UpdateWageInitial({super.wageHourly});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageInitial && wageHourly == other.wageHourly;

  @override
  int get hashCode => wageHourly.hashCode;
}

/// Indicates the wage update is being persisted.
final class UpdateWageLoading extends UpdateWageState {
  /// Creates an [UpdateWageLoading] state with an optional [wageHourly].
  const UpdateWageLoading({super.wageHourly});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWageLoading && wageHourly == other.wageHourly;

  @override
  int get hashCode => wageHourly.hashCode;
}

/// Indicates the wage was updated successfully.
final class UpdateWageSuccess extends UpdateWageState {
  /// Creates an [UpdateWageSuccess] state with the persisted [result].
  const UpdateWageSuccess({required this.result, super.wageHourly});

  /// The [WageHourly] entity returned by the repository after persisting.
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

/// Indicates the wage update failed with a [GlobalFailure].
final class UpdateWageError extends UpdateWageState {
  /// Creates an [UpdateWageError] state with the given [failure].
  const UpdateWageError(this.failure, {super.wageHourly});

  /// The failure that caused the update to fail.
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
