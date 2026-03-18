import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';

class TimesUseCasesInjections {
  static List<RepositoryProvider<Object>> list() => [
        RepositoryProvider<ListTimesUseCase>(
          create: (context) =>
              ListTimesUseCase(context.read<TimesRepository>()),
        ),
        RepositoryProvider<CreateTimeUseCase>(
          create: (context) =>
              CreateTimeUseCase(context.read<TimesRepository>()),
        ),
        RepositoryProvider<DeleteTimeUseCase>(
          create: (context) =>
              DeleteTimeUseCase(context.read<TimesRepository>()),
        ),
        RepositoryProvider<UpdateTimeUseCase>(
          create: (context) =>
              UpdateTimeUseCase(context.read<TimesRepository>()),
        ),
      ];
}
