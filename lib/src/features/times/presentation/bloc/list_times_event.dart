part of 'list_times_bloc.dart';

@freezed
abstract class ListTimesEvent with _$ListTimesEvent {
  const factory ListTimesEvent.getTimes() = _GetTimes;
}
