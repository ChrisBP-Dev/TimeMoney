import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

class TimesUseCasesInjections {
  static List<RepositoryProvider<Object>> list(
    InjectionRepositories injection,
  ) =>
      [
        RepositoryProvider<ListTimesUseCase>(
          create: (context) => ListTimesUseCase(injection.timesRepository),
        ),
        RepositoryProvider<CreateTimeUseCase>(
          create: (context) => CreateTimeUseCase(injection.timesRepository),
        ),
        RepositoryProvider<DeleteTimeUseCase>(
          create: (context) => DeleteTimeUseCase(injection.timesRepository),
        ),
        RepositoryProvider<UpdateTimeUseCase>(
          create: (context) => UpdateTimeUseCase(injection.timesRepository),
        ),
      ];
}
