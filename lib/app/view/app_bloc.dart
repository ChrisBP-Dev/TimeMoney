import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/src/shared/injections/bloc_injections.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';
import 'package:time_money/src/shared/injections/use_cases_injection.dart';

class AppBloc extends StatelessWidget {
  const AppBloc({
    required this.injection,
    super.key,
  });

  final InjectionRepositories injection;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: UseCasesInjection.list(injection),
      child: MultiBlocProvider(
        providers: BlocInjections.list(),
        child: const App(),
      ),
    );
  }
}
