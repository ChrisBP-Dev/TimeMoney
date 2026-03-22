import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

/// Dependency-injection helper that registers all Wage BLoCs
/// as [BlocProvider]s in the widget tree.
class WageBlocs {
  /// Returns the list of [BlocProvider]s for every Wage BLoC.
  static List<BlocProvider> list() => [
    BlocProvider<FetchWageBloc>(
      create: (context) => FetchWageBloc(
        context.read<FetchWageUseCase>(),
      ),
    ),
    BlocProvider<UpdateWageBloc>(
      create: (context) => UpdateWageBloc(
        context.read<UpdateWageUseCase>(),
      ),
    ),
  ];
}
