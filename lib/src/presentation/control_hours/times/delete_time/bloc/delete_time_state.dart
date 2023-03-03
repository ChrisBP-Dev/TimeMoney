part of 'delete_time_bloc.dart';

@freezed
abstract class DeleteTimeState with _$DeleteTimeState {
  const factory DeleteTimeState.initial() = _Initial;
  const factory DeleteTimeState.loading() = _Loading;
  const factory DeleteTimeState.success() = _Success;
  const factory DeleteTimeState.error(GlobalFailure<dynamic> err) = _Error;
}
