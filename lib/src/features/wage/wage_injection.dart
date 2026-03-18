import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/set_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

class WageUseCasesInjections {
  static List<RepositoryProvider<Object>> list(
    InjectionRepositories injection,
  ) =>
      [
        RepositoryProvider<FetchWageUseCase>(
          create: (context) => FetchWageUseCase(
            injection.wageHourlyRepository,
          ),
        ),
        RepositoryProvider<SetWageUseCase>(
          create: (context) => SetWageUseCase(
            injection.wageHourlyRepository,
          ),
        ),
        RepositoryProvider<UpdateWageUseCase>(
          create: (context) => UpdateWageUseCase(
            injection.wageHourlyRepository,
          ),
        ),
      ];
}
