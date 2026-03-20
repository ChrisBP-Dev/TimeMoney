import 'package:time_money/bootstrap.dart';

/// Staging entry point.
///
/// Bootstraps the app with the `stg-1` database environment.
Future<void> main() => bootstrap(dbName: 'stg-1');
