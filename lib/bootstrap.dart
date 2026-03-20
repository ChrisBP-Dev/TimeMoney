import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/bootstrap_repositories_web.dart'
    if (dart.library.io) 'package:time_money/bootstrap_repositories_native.dart';
import 'package:time_money/l10n/l10n.dart';

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

/// [WidgetsBindingObserver] that closes the database when the app is detached.
///
/// Registered after repository creation so that native resources (ObjectBox
/// Store or Drift AppDatabase) are released cleanly on app shutdown.
/// Includes an idempotency guard to prevent double-close errors on rapid
/// lifecycle transitions or hot-restart scenarios.
class _AppLifecycleObserver extends WidgetsBindingObserver {
  _AppLifecycleObserver(this._close);

  final Future<void> Function() _close;
  bool _closed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && !_closed) {
      _closed = true;
      unawaited(
        _close().catchError(
          (Object error, StackTrace stack) =>
              log('Database close error: $error', stackTrace: stack),
        ),
      );
    }
  }
}

/// Bootstraps the app with platform-aware DI and environment-specific database.
///
/// Repository creation is resolved at **compile time** via
/// conditional imports:
/// - **Web** -> [createRepositories] from
///   `bootstrap_repositories_web.dart` uses Drift with SQLite
///   via WASM + OPFS.
/// - **Native** -> [createRepositories] from
///   `bootstrap_repositories_native.dart` uses ObjectBox with a
///   native binary store.
///
/// This compile-time isolation ensures `dart:ffi` (required by ObjectBox) is
/// never seen by the web compiler, while the web-only Drift stack is excluded
/// from native builds.
///
/// Database creation happens inside [runZonedGuarded] so that init failures
/// are caught, logged, and presented to the user via [_BootstrapErrorApp]
/// instead of a blank screen. An [_AppLifecycleObserver] is registered to
/// close the database when the app lifecycle reaches
/// [AppLifecycleState.detached].
///
/// The [dbName] parameter isolates databases per environment
/// (`test-1`, `stg-1`, `prod-1`).
Future<void> bootstrap({required String dbName}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(
    () async {
      try {
        final (:timesRepository, :wageRepository, :close) =
            await createRepositories(dbName);

        WidgetsBinding.instance.addObserver(_AppLifecycleObserver(close));

        runApp(
          AppBloc(
            timesRepository: timesRepository,
            wageHourlyRepository: wageRepository,
          ),
        );
      } on Object catch (error, stackTrace) {
        log('Bootstrap failed: $error', stackTrace: stackTrace);
        runApp(_BootstrapErrorApp(error: error));
      }
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

/// Minimal fallback app displayed when database initialization fails.
///
/// Shows a localized error message so the user sees feedback instead of a
/// blank screen. Uses a [Builder] to obtain a [BuildContext] with access
/// to the localization delegates configured in the [MaterialApp].
class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Builder(
              builder: (context) => Text(
                context.l10n.bootstrapError(error.toString()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
