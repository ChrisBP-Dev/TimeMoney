import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';

/// Raw ObjectBox operations for wage entries.
///
/// Works with [WageHourlyBox] DB models only -- no domain entity mapping here.
class WageObjectboxDatasource {
  /// Creates the datasource with the given ObjectBox [Box] for
  /// [WageHourlyBox].
  const WageObjectboxDatasource(this._box);
  final Box<WageHourlyBox> _box;

  /// Returns a reactive stream emitting every stored [WageHourlyBox]
  /// whenever the underlying box changes, triggering immediately on
  /// subscription.
  Stream<List<WageHourlyBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (query) => query.find(),
        );
  }

  /// Returns `true` if a [WageHourlyBox] with the given [id] exists.
  bool contains(int id) => _box.contains(id);

  /// Inserts or updates the given [wageBox] and returns the assigned id.
  int put(WageHourlyBox wageBox) => _box.put(wageBox);
}
