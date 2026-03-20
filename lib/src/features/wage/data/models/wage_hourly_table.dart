import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

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

/// Maps a [WageHourlyTableData] drift row to a [WageHourly] domain entity.
extension ConvertWageHourlyTableData on WageHourlyTableData {
  /// Converts this drift row into a [WageHourly].
  WageHourly get toWageHourly => WageHourly(
        id: id,
        value: value,
      );
}
