import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/drift_times_repository.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// BLoC observer that logs state changes and errors for debugging.
class AppBlocObserver extends BlocObserver {
  /// Creates a const [AppBlocObserver].
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstraps the app with platform-aware DI and environment-specific database.
///
/// Uses [kIsWeb] compile-time constant for platform detection:
/// - Web → drift ([AppDatabase]) with SQLite via WASM + OPFS
/// - Native → ObjectBox ([ObjectBox]) with native binary store
///
/// The [dbName] parameter isolates databases per environment
/// (`test-1`, `stg-1`, `prod-1`).
Future<void> bootstrap({required String dbName}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Platform-aware datasource and repository resolution.
  // kIsWeb is a compile-time constant — dead branches are tree-shaken.
  final TimesRepository timesRepository;
  final WageRepository wageRepository;

  if (kIsWeb) {
    // drift stack — synchronous creation.
    final db = AppDatabase.named(dbName);
    final timesDatasource = TimesDriftDatasource(db);
    final wageDatasource = WageDriftDatasource(db);
    timesRepository = DriftTimesRepository(timesDatasource);
    wageRepository = DriftWageRepository(wageDatasource);
  } else {
    // ObjectBox stack — asynchronous creation.
    final objectbox = await ObjectBox.create(dbName);
    final timesDatasource = TimesObjectboxDatasource(
      objectbox.store.box<TimeBox>(),
    );
    final wageDatasource = WageObjectboxDatasource(
      objectbox.store.box<WageHourlyBox>(),
    );
    timesRepository = ObjectboxTimesRepository(timesDatasource);
    wageRepository = ObjectboxWageRepository(wageDatasource);
  }

  await runZonedGuarded(
    () async => runApp(
      AppBloc(
        timesRepository: timesRepository,
        wageHourlyRepository: wageRepository,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
