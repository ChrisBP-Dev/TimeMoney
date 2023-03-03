import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/core/failures/failures.dart';

part 'action_state.freezed.dart';

@freezed
class ActionState<T> with _$ActionState<T> {
  const factory ActionState.initial() = _Initial<T>;
  const factory ActionState.loading() = _Loading<T>;
  const factory ActionState.error(GlobalDefaultFailure err) = _Error<T>;
  const factory ActionState.success(T value) = _Success<T>;
}

extension ActionInfo<T> on ActionState<T> {
  bool get isInitial => when(
        initial: () => true,
        loading: () => false,
        error: (_) => false,
        success: (_) => false,
      );
  bool get isLoading => when(
        initial: () => false,
        loading: () => true,
        error: (_) => false,
        success: (_) => false,
      );
  bool get isSuccess => when(
        initial: () => false,
        loading: () => false,
        error: (_) => false,
        success: (_) => true,
      );
  bool get isError => when(
        initial: () => false,
        loading: () => false,
        error: (_) => true,
        success: (_) => false,
      );
}
