import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

@Entity()
class TimeBox {
  TimeBox({
    required this.hour,
    required this.minutes,
    this.id = 0,
  });

  @Id()
  int id;

  int hour;
  int minutes;

  @override
  String toString() {
    return '''
TimeBox(id: $id,
hour: $hour,
minutes: $minutes,
),
        ''';
  }
}

extension ConvertTimeEntry on TimeBox {
  TimeEntry get toTimeEntry => TimeEntry(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}

extension ConvertTimeBox on TimeEntry {
  TimeBox get toTimeBox => TimeBox(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}
