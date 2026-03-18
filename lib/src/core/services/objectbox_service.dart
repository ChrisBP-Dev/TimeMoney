import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_money/objectbox.g.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/wage_hourly_box.dart';

class ObjectBox {
  ObjectBox._create(this.store) {
    wageHourly = Box<WageHourlyBox>(store);
  }
  late final Store store;

  late final Box<WageHourlyBox> wageHourly;

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
      directory: p.join(docsDir.path, path),
    );

    return ObjectBox._create(store);
  }

  Future<void> close() async {
    store.close();
  }
}
