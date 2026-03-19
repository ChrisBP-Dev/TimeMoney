import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/set_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';

class MockTimesRepository extends Mock implements TimesRepository {}

class MockWageRepository extends Mock implements WageRepository {}

class MockCreateTimeUseCase extends Mock implements CreateTimeUseCase {}

class MockDeleteTimeUseCase extends Mock implements DeleteTimeUseCase {}

class MockListTimesUseCase extends Mock implements ListTimesUseCase {}

class MockUpdateTimeUseCase extends Mock implements UpdateTimeUseCase {}

class MockFetchWageUseCase extends Mock implements FetchWageUseCase {}

class MockSetWageUseCase extends Mock implements SetWageUseCase {}

class MockUpdateWageUseCase extends Mock implements UpdateWageUseCase {}

class MockCalculatePaymentUseCase extends Mock
    implements CalculatePaymentUseCase {}
