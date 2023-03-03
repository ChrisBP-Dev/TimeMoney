import 'package:flutter/material.dart';
import 'package:time_money/app/view/app_bloc.dart';
import 'package:time_money/bootstrap.dart';
import 'package:time_money/src/core/services/objectbox.dart';
import 'package:time_money/src/features/times/infraestructure/i_times_objectbox_repository.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

late final ObjectBox objectbox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create('prod-1');

  await bootstrap(
    () => AppBloc(
      injection: InjectionRepositories(
        timesRepository: ITimesObjectboxRepository(objectbox),
        wageHourlyRepository: IWageHourlyObjectboxRepository(objectbox),
      ),
    ),
  );
}
