import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_money/objectbox.g.dart';

/// Singleton-style wrapper around the ObjectBox [Store].
///
/// Encapsulates store creation and teardown so the rest of the app
/// interacts with ObjectBox through a single, well-defined entry point.
/// Instantiated once at startup via [create] and shared through
/// dependency injection.
class ObjectBox {
  ObjectBox._create(this.store);

  /// The underlying ObjectBox [Store] used to obtain entity boxes.
  late final Store store;

  /// Opens (or creates) an ObjectBox database at the given [path] inside
  /// the application documents directory.
  ///
  /// Returns a fully initialised [ObjectBox] instance ready for use.
  static Future<ObjectBox> create(String path) async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store = await openStore(
      directory: p.join(docsDir.path, path),
    );

    return ObjectBox._create(store);
  }

  /// Closes the underlying [Store], releasing all native resources.
  ///
  /// Should be called during app shutdown or when the database is no
  /// longer needed.
  Future<void> close() async {
    store.close();
  }
}
