part of 'delete_time_bloc.dart';

@freezed
class DeleteTimeEvent with _$DeleteTimeEvent {
  const factory DeleteTimeEvent.delete({required ModelTime time}) = _Delete;
}
