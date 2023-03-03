import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage_hourly/aplication/fetch_wage_hourly_use_case.dart';
import 'package:time_money/src/features/wage_hourly/aplication/update_wage_hourly_use_case.dart';

import 'package:time_money/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart';

import 'package:time_money/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart';

class WageHourlyBlocs {
  static List<BlocProvider> list() => [
        BlocProvider<FetchWageHourlyBloc>(
          create: (context) => FetchWageHourlyBloc(
            context.read<FetchWageHourlyUseCase>(),
          ),
        ),
        BlocProvider<UpdateWageHourlyBloc>(
          create: (context) => UpdateWageHourlyBloc(
            context.read<UpdateWageHourlyUseCase>(),
          ),
        ),
      ];
}
