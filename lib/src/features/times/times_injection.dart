import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';

/// Dependency-injection helper that registers all Times-feature use cases.
///
/// Call [list] to obtain [RepositoryProvider]s wired to the current
/// [TimesRepository] from the widget tree.
class TimesUseCasesInjections {
  /// Returns a list of [RepositoryProvider]s for every Times use case.
  static List<RepositoryProvider<Object>> list() => [
    RepositoryProvider<ListTimesUseCase>(
      create: (context) => ListTimesUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<CreateTimeUseCase>(
      create: (context) => CreateTimeUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<DeleteTimeUseCase>(
      create: (context) => DeleteTimeUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<UpdateTimeUseCase>(
      create: (context) => UpdateTimeUseCase(context.read<TimesRepository>()),
    ),
  ];
}
