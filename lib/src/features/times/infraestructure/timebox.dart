// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';

@Entity()
class TimeBox {
  @Id()
  int id;

  int hour;
  int minutes;

  TimeBox({
    required this.hour,
    required this.minutes,
    this.id = 0,
  });

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

extension ConvertModelTime on TimeBox {
  ModelTime get toFreezedModelTime => ModelTime(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}

extension ConvertModelTimeBox on ModelTime {
  TimeBox get toTimeBox => TimeBox(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}
