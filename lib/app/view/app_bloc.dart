import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';
import 'package:time_money/src/shared/injections/bloc_injections.dart';
import 'package:time_money/src/shared/injections/use_cases_injection.dart';

/// Top-level widget that wires repositories, use cases, and BLoCs.
///
/// Wraps the [App] in [MultiRepositoryProvider] and [MultiBlocProvider],
/// providing all feature-level dependencies to the widget tree.
class AppBloc extends StatelessWidget {
  /// Creates an [AppBloc] with the required repository implementations.
  const AppBloc({
    required this.timesRepository,
    required this.wageHourlyRepository,
    super.key,
  });

  /// Repository for managing time entry persistence.
  final TimesRepository timesRepository;

  /// Repository for managing hourly wage persistence.
  final WageRepository wageHourlyRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TimesRepository>.value(value: timesRepository),
        RepositoryProvider<WageRepository>.value(value: wageHourlyRepository),
        ...UseCasesInjection.list(),
      ],
      child: MultiBlocProvider(
        providers: BlocInjections.list(),
        child: const App(),
      ),
    );
  }
}
