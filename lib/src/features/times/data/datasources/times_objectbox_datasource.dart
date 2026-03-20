import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';

/// Raw ObjectBox operations for time entries.
///
/// Works exclusively with [TimeBox] DB models -- domain entity mapping
/// is the responsibility of the repository layer.
class TimesObjectboxDatasource {
  /// Creates a datasource backed by the given ObjectBox [Box].
  const TimesObjectboxDatasource(this._box);
  final Box<TimeBox> _box;

  /// Watches all [TimeBox] rows, emitting immediately and on every change.
  Stream<List<TimeBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (query) => query.find(),
        );
  }

  /// Inserts or updates the given [timeBox] and returns its assigned id.
  int put(TimeBox timeBox) => _box.put(timeBox);

  /// Removes the row identified by [id]; returns `true` if it existed.
  bool remove(int id) => _box.remove(id);

  /// Returns `true` if a [TimeBox] with the given [id] exists in the store.
  bool contains(int id) => _box.contains(id);
}
