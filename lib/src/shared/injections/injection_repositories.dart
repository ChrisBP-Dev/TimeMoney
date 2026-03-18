import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class InjectionRepositories {
  InjectionRepositories({
    required this.timesRepository,
    required this.wageHourlyRepository,
  });
  final TimesRepository timesRepository;
  final WageRepository wageHourlyRepository;
}
