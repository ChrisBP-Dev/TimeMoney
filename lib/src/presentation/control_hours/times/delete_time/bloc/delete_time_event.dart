part of 'delete_time_bloc.dart';

@freezed
abstract class DeleteTimeEvent with _$DeleteTimeEvent {
  const factory DeleteTimeEvent.delete({required ModelTime time}) = _Delete;
}
