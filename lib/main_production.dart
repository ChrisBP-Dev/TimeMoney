import 'package:time_money/bootstrap.dart';

/// Production entry point.
///
/// Bootstraps the app with the `prod-1` database environment.
Future<void> main() => bootstrap(dbName: 'prod-1');
