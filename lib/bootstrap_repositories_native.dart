import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Creates ObjectBox-backed repositories for native platforms
/// (iOS, Android, Windows, macOS, Linux).
///
/// ObjectBox provides a high-performance native binary store with reactive
/// streaming via `watch()`. This factory is selected at compile time through
/// conditional imports — the web compiler never sees this file.
///
/// The [dbName] parameter isolates databases per environment
/// (`test-1`, `stg-1`, `prod-1`).
Future<({TimesRepository timesRepository, WageRepository wageRepository})>
    createRepositories(String dbName) async {
  final objectbox = await ObjectBox.create(dbName);

  final timesDatasource = TimesObjectboxDatasource(
    objectbox.store.box<TimeBox>(),
  );
  final wageDatasource = WageObjectboxDatasource(
    objectbox.store.box<WageHourlyBox>(),
  );

  return (
    timesRepository: ObjectboxTimesRepository(timesDatasource),
    wageRepository: ObjectboxWageRepository(wageDatasource),
  );
}
