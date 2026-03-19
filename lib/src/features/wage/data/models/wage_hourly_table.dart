import 'package:drift/drift.dart';

/// Drift table definition for hourly wage records.
///
/// Maps to the `WageHourly` domain entity. Columns match the ObjectBox
/// `WageHourlyBox` model fields for data consistency across datasources.
class WageHourlyTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Hourly wage amount stored as a real (double) value.
  RealColumn get value => real()();
}
