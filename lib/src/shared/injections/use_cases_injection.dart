import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/times_injection.dart';
import 'package:time_money/src/features/wage/wage_injection.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

class UseCasesInjection {
  static List<RepositoryProvider<Object>> list(
    InjectionRepositories injection,
  ) =>
      [
        ...TimesUseCasesInjections.list(injection),
        ...WageUseCasesInjections.list(injection),
      ];
}
