import 'package:time_money/bootstrap.dart';

/// Development entry point.
///
/// Bootstraps the app with the `test-1` database environment.
Future<void> main() => bootstrap(dbName: 'test-1');
