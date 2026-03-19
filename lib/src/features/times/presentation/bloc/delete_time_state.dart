import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';

@immutable
sealed class DeleteTimeState {
  const DeleteTimeState();
}

final class DeleteTimeInitial extends DeleteTimeState {
  const DeleteTimeInitial();
}

final class DeleteTimeLoading extends DeleteTimeState {
  const DeleteTimeLoading();
}

final class DeleteTimeSuccess extends DeleteTimeState {
  const DeleteTimeSuccess();
}

final class DeleteTimeError extends DeleteTimeState {
  const DeleteTimeError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTimeError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
