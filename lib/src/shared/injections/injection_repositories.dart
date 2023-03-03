import 'package:time_money/src/features/times/domain/times_repository.dart';
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly_repository.dart';

class InjectionRepositories {
  InjectionRepositories({
    required this.timesRepository,
    required this.wageHourlyRepository,
  });
  final TimesRepository timesRepository;
  final WageHourlyRepository wageHourlyRepository;
}
