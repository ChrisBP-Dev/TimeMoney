import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

sealed class UpdateTimeEvent {
  const UpdateTimeEvent();
}

final class UpdateTimeInit extends UpdateTimeEvent {
  const UpdateTimeInit({required this.time});
  final TimeEntry time;
}

final class UpdateTimeHourChanged extends UpdateTimeEvent {
  const UpdateTimeHourChanged({required this.value});
  final String value;
}

final class UpdateTimeMinutesChanged extends UpdateTimeEvent {
  const UpdateTimeMinutesChanged({required this.value});
  final String value;
}

final class UpdateTimeSubmitted extends UpdateTimeEvent {
  const UpdateTimeSubmitted();
}
