import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';

/// Raw ObjectBox operations for wage entries.
/// Works with DB models only — no domain entity mapping here.
class WageObjectboxDatasource {
  const WageObjectboxDatasource(this._box);
  final Box<WageHourlyBox> _box;

  Stream<List<WageHourlyBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (query) => query.find(),
        );
  }

  int put(WageHourlyBox wageBox) => _box.put(wageBox);
}
