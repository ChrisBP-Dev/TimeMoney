/// Centralised mocktail mocks shared across all test files.
///
/// Each mock class uses [Mock] from `package:mocktail` to create a
/// test-double that can be stubbed and verified without code-generation.
library;

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

/// Mock for [TimesRepository], the domain contract for time-entry persistence.
class MockTimesRepository extends Mock implements TimesRepository {}

/// Mock for [WageRepository], the domain contract for wage persistence.
class MockWageRepository extends Mock implements WageRepository {}

/// Mock for [CreateTimeUseCase], used to stub time-entry creation logic.
class MockCreateTimeUseCase extends Mock implements CreateTimeUseCase {}

/// Mock for [DeleteTimeUseCase], used to stub time-entry deletion logic.
class MockDeleteTimeUseCase extends Mock implements DeleteTimeUseCase {}

/// Mock for [ListTimesUseCase], used to stub the reactive time-entry listing.
class MockListTimesUseCase extends Mock implements ListTimesUseCase {}

/// Mock for [UpdateTimeUseCase], used to stub time-entry update logic.
class MockUpdateTimeUseCase extends Mock implements UpdateTimeUseCase {}

/// Mock for [FetchWageUseCase], used to stub the reactive wage fetch stream.
class MockFetchWageUseCase extends Mock implements FetchWageUseCase {}

/// Mock for [SetWageUseCase], used to stub initial wage creation logic.
class MockSetWageUseCase extends Mock implements SetWageUseCase {}

/// Mock for [UpdateWageUseCase], used to stub wage update logic.
class MockUpdateWageUseCase extends Mock implements UpdateWageUseCase {}

/// Mock for [CalculatePaymentUseCase], used to stub payment calculation logic.
class MockCalculatePaymentUseCase extends Mock
    implements CalculatePaymentUseCase {}
