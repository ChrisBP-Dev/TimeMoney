import 'package:flutter/material.dart';
import 'package:time_money/app/app.dart';
import 'package:time_money/bootstrap.dart';
import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';

late final ObjectBox objectbox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create('stg-1');

  await bootstrap(
    () => AppBloc(
      timesRepository: ObjectboxTimesRepository(
        TimesObjectboxDatasource(objectbox.store.box<TimeBox>()),
      ),
      wageHourlyRepository: ObjectboxWageRepository(
        WageObjectboxDatasource(objectbox.store.box<WageHourlyBox>()),
      ),
    ),
  );
}
