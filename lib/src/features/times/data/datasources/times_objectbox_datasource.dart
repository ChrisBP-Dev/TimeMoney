import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';

/// Raw ObjectBox operations for time entries.
/// Works with DB models only — no domain entity mapping here.
class TimesObjectboxDatasource {
  const TimesObjectboxDatasource(this._box);
  final Box<TimeBox> _box;

  Stream<List<TimeBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (query) => query.find(),
        );
  }

  int put(TimeBox timeBox) => _box.put(timeBox);

  bool remove(int id) => _box.remove(id);
}
