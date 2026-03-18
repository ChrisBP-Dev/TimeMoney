import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/set_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';

class WageUseCasesInjections {
  static List<RepositoryProvider<Object>> list() => [
        RepositoryProvider<FetchWageUseCase>(
          create: (context) =>
              FetchWageUseCase(context.read<WageRepository>()),
        ),
        RepositoryProvider<SetWageUseCase>(
          create: (context) =>
              SetWageUseCase(context.read<WageRepository>()),
        ),
        RepositoryProvider<UpdateWageUseCase>(
          create: (context) =>
              UpdateWageUseCase(context.read<WageRepository>()),
        ),
      ];
}
