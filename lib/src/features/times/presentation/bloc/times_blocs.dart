import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';

/// Provides all Times feature BLoC instances for dependency injection.
///
/// Used by the widget tree to register each CRUD BLoC via [BlocProvider].
class TimesBlocs {
  /// Returns a list of [BlocProvider]s for every Times feature BLoC.
  static List<BlocProvider> list() => [
        BlocProvider<ListTimesBloc>(
          create: (context) => ListTimesBloc(
            context.read<ListTimesUseCase>(),
          ),
        ),
        BlocProvider<CreateTimeBloc>(
          create: (context) => CreateTimeBloc(
            context.read<CreateTimeUseCase>(),
          ),
        ),
        BlocProvider<DeleteTimeBloc>(
          create: (context) => DeleteTimeBloc(
            context.read<DeleteTimeUseCase>(),
          ),
        ),
        BlocProvider<UpdateTimeBloc>(
          create: (context) => UpdateTimeBloc(
            context.read<UpdateTimeUseCase>(),
          ),
        ),
      ];
}
