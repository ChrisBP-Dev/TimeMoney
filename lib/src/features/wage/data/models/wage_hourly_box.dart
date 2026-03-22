import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// ObjectBox entity representing a persisted hourly wage record.
@Entity()
class WageHourlyBox {
  /// Creates a [WageHourlyBox] with the given hourly [value] and optional
  /// [id].
  WageHourlyBox({
    required this.value,
    this.id = 0,
  });

  /// ObjectBox-assigned primary key. A value of `0` indicates a new record.
  @Id()
  int id;

  /// Hourly wage amount stored in the database.
  double value;

  @override
  String toString() {
    return '''
WageHourlyBox(id: $id,
value: $value,
),
        ''';
  }
}

/// Converts a [WageHourlyBox] data model to a [WageHourly] domain entity.
extension ConvertWageHourly on WageHourlyBox {
  /// Maps this box model to its domain-layer [WageHourly] equivalent.
  WageHourly get toWageHourly => WageHourly(
    id: id,
    value: value,
  );
}

/// Converts a [WageHourly] domain entity to a [WageHourlyBox] data model.
extension ConvertWageHourlyBox on WageHourly {
  /// Maps this domain entity to its persistence-layer [WageHourlyBox]
  /// equivalent.
  WageHourlyBox get toWageHourlyBox => WageHourlyBox(
    id: id,
    value: value,
  );
}
