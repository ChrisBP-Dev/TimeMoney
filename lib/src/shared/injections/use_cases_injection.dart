import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/features/wage_hourly/aplication/wage_hourly_use_cases_injections.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

class UseCasesInjection {
  static List<RepositoryProvider<Object>> list(
    InjectionRepositories injection,
  ) =>
      [
        ...TimesUseCasesInjections.list(injection),
        ...WageHourlyUseCasesInjections.list(injection),
      ];
}
