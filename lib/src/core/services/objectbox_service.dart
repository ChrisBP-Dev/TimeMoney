import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_money/objectbox.g.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/features/times/infraestructure/timebox.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/wage_hourly_box.dart';

class ObjectBox {
  ObjectBox._create(this.store) {
    time = Box<TimeBox>(store);
    wageHourly = Box<WageHourlyBox>(store);
  }
  late final Store store;

  late final Box<TimeBox> time;
  late final Box<WageHourlyBox> wageHourly;

  Stream<List<ModelTime>> getTimesStream() {
    final times = time.query().watch(triggerImmediately: true).map(
          (event) => List<ModelTime>.from(
            event.find().map(
                  (e) => e.toFreezedModelTime,
                ),
          ),
        );

    return times;
  }

  Stream<WageHourly> getWageHourlyStream() {
    final wageHourlys = wageHourly.query().watch(triggerImmediately: true).map(
      (event) {
        final list = List<WageHourly>.from(
          event.find().map(
                (e) => e.toFreezedWageHourly,
              ),
        );

        return list.isEmpty ? const WageHourly() : list.last;
      },
    );

    return wageHourlys;
  }

  static Future<ObjectBox> create(String path) async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store = await openStore(
      // getObjectBoxModel(),
      directory: p.join(docsDir.path, path),
    );

    return ObjectBox._create(store);
  }

  Future<void> close() async {
    store.close();
  }
}
