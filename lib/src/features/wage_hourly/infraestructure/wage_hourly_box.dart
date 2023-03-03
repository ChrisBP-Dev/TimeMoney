import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';

@Entity()
class WageHourlyBox {
  WageHourlyBox({
    required this.value,
    this.id = 0,
  });
  @Id()
  int id;

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

extension ConvertWageHourly on WageHourlyBox {
  WageHourly get toFreezedWageHourly => WageHourly(
        id: id,
        value: value,
      );
}

extension ConvertWageHourlyBox on WageHourly {
  WageHourlyBox get toWageHourlyBox => WageHourlyBox(
        id: id,
        value: value,
      );
}
