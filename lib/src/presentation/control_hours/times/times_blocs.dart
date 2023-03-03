import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/aplication/aplications.dart';
import 'package:time_money/src/presentation/control_hours/times/create_time/bloc/create_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/delete_time/bloc/delete_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/list_times/bloc/list_times_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/bloc/update_time_bloc.dart';

class TimesBlocs {
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
