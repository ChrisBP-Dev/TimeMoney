import 'package:flutter/material.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/bootstrap.dart';
import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart';
import 'package:time_money/src/shared/injections/injection_repositories.dart';

late final ObjectBox objectbox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create('test-1');

  await bootstrap(
    () => AppBloc(
      injection: InjectionRepositories(
        timesRepository: ObjectboxTimesRepository(
          TimesObjectboxDatasource(objectbox.store.box<TimeBox>()),
        ),
        wageHourlyRepository: IWageHourlyObjectboxRepository(objectbox),
      ),
    ),
  );
}
