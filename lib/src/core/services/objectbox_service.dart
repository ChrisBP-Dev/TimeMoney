import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_money/objectbox.g.dart';

class ObjectBox {
  ObjectBox._create(this.store);
  late final Store store;

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
