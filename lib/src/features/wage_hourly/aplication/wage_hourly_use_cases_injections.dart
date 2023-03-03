import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage_hourly/aplication/fetch_wage_hourly_use_case.dart';
import 'package:time_money/src/features/wage_hourly/aplication/set_wage_hourly_use_case.dart';
import 'package:time_money/src/features/wage_hourly/aplication/update_wage_hourly_use_case.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

class WageHourlyUseCasesInjections {
  static List<RepositoryProvider<Object>> list(
    InjectionRepositories injection,
  ) =>
      [
        RepositoryProvider<FetchWageHourlyUseCase>(
          create: (context) => FetchWageHourlyUseCase(
            injection.wageHourlyRepository,
          ),
        ),
        RepositoryProvider<SetWageHourlyUseCase>(
          create: (context) => SetWageHourlyUseCase(
            injection.wageHourlyRepository,
          ),
        ),
        RepositoryProvider<UpdateWageHourlyUseCase>(
          create: (context) => UpdateWageHourlyUseCase(
            injection.wageHourlyRepository,
          ),
        ),
      ];
}
