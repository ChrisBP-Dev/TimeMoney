import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';
import 'package:time_money/src/shared/injections/bloc_injections.dart';
import 'package:time_money/src/shared/injections/use_cases_injection.dart';

class AppBloc extends StatelessWidget {
  const AppBloc({
    required this.timesRepository,
    required this.wageHourlyRepository,
    super.key,
  });

  final TimesRepository timesRepository;
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
