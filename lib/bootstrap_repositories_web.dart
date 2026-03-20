import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/repositories/drift_times_repository.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Creates Drift-backed repositories for the web platform.
///
/// Drift provides SQLite persistence on web via WASM + OPFS, ensuring data
/// survives browser sessions. This factory is the default import — selected
/// at compile time when `dart:io` is unavailable (i.e., on web).
///
/// The [dbName] parameter isolates databases per environment
/// (`test-1`, `stg-1`, `prod-1`).
Future<({TimesRepository timesRepository, WageRepository wageRepository})>
    createRepositories(String dbName) async {
  final db = AppDatabase.named(dbName);

  final timesDatasource = TimesDriftDatasource(db);
  final wageDatasource = WageDriftDatasource(db);

  return (
    timesRepository: DriftTimesRepository(timesDatasource),
    wageRepository: DriftWageRepository(wageDatasource),
  );
}
