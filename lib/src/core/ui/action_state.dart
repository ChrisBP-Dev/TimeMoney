import 'package:time_money/src/core/errors/failures.dart';

sealed class ActionState<T> {
  const ActionState();

  bool get isInitial => this is ActionInitial<T>;
  bool get isLoading => this is ActionLoading<T>;
  bool get isSuccess => this is ActionSuccess<T>;
  bool get isError => this is ActionError<T>;
}

final class ActionInitial<T> extends ActionState<T> {
  const ActionInitial();
}

final class ActionLoading<T> extends ActionState<T> {
  const ActionLoading();
}

final class ActionSuccess<T> extends ActionState<T> {
  const ActionSuccess(this.data);
  final T data;
}

final class ActionError<T> extends ActionState<T> {
  const ActionError(this.failure);
  final GlobalFailure failure;
}
