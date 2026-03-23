import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// ObjectBox persistence model for a time entry.
///
/// Maps 1-to-1 with the [TimeEntry] domain entity. Conversion helpers
/// are provided via the [ConvertTimeEntry] and [ConvertTimeBox] extensions.
@Entity()
class TimeBox {
  /// Creates a [TimeBox] with the required [hour] and [minutes].
  ///
  /// [id] defaults to `0`, which tells ObjectBox to assign a new identifier.
  TimeBox({
    required this.hour,
    required this.minutes,
    this.id = 0,
  });

  /// ObjectBox-managed primary key.
  @Id()
  int id;

  /// Number of full hours tracked.
  int hour;

  /// Additional minutes beyond full hours.
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

/// Maps a [TimeBox] persistence model to a [TimeEntry] domain entity.
extension ConvertTimeEntry on TimeBox {
  /// Converts this [TimeBox] into a [TimeEntry].
  TimeEntry get toTimeEntry => TimeEntry(
    id: id,
    hour: hour,
    minutes: minutes,
  );
}

/// Maps a [TimeEntry] domain entity to a [TimeBox] persistence model.
extension ConvertTimeBox on TimeEntry {
  /// Converts this [TimeEntry] into a [TimeBox].
  TimeBox get toTimeBox => TimeBox(
    id: id,
    hour: hour,
    minutes: minutes,
  );
}
