import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

sealed class DeleteTimeEvent {
  const DeleteTimeEvent();
}

final class DeleteTimeRequested extends DeleteTimeEvent {
  const DeleteTimeRequested({required this.time});
  final TimeEntry time;
}
