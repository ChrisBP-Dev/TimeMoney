import 'package:drift/drift.dart';

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
