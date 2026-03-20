import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Drift table definition for time entries.
///
/// Maps to the `TimeEntry` domain entity. Columns match the ObjectBox
/// `TimeBox` model fields for data consistency across datasources.
class TimesTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Number of full hours tracked.
  IntColumn get hour => integer()();

  /// Additional minutes beyond full hours.
  IntColumn get minutes => integer()();
}

/// Maps a [TimesTableData] drift row to a [TimeEntry] domain entity.
extension ConvertTimesTableData on TimesTableData {
  /// Converts this drift row into a [TimeEntry].
  TimeEntry get toTimeEntry => TimeEntry(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}
