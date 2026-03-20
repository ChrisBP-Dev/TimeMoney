import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/bootstrap_repositories_web.dart'
    if (dart.library.io) 'package:time_money/bootstrap_repositories_native.dart';

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
/// Repository creation is resolved at **compile time** via
/// conditional imports:
/// - **Web** → [createRepositories] from
///   `bootstrap_repositories_web.dart` uses Drift with SQLite
///   via WASM + OPFS.
/// - **Native** → [createRepositories] from
///   `bootstrap_repositories_native.dart` uses ObjectBox with a
///   native binary store.
///
/// This compile-time isolation ensures `dart:ffi` (required by ObjectBox) is
/// never seen by the web compiler, while the web-only Drift stack is excluded
/// from native builds.
///
/// The [dbName] parameter isolates databases per environment
/// (`test-1`, `stg-1`, `prod-1`).
Future<void> bootstrap({required String dbName}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final (:timesRepository, :wageRepository) =
      await createRepositories(dbName);

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
