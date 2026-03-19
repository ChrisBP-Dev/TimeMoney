/// Tests for [SetWageUseCase].
///
/// Validates that the use case delegates to `WageRepository.setWageHourly`
/// with a default [WageHourly] and returns either a `Right` containing the
/// persisted wage on success, or a `Left` with the exact [GlobalFailure] on
/// error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/set_wage_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockWageRepository mockRepository;
  late SetWageUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const WageHourly());
  });

  setUp(() {
    mockRepository = MockWageRepository();
    useCase = SetWageUseCase(mockRepository);
  });

  const testWage = WageHourly();

  // Set use case creates the initial wage record with
  // a default WageHourly. Called once during onboarding
  // or first app launch.
  group('SetWageUseCase', () {
    // Happy path: repo persists the default wage.
    // Confirms delegation and that the persisted entity
    // is returned to the caller for immediate use.
    test('returns Right with WageHourly on success', () async {
      when(() => mockRepository.setWageHourly(any())).thenAnswer(
        (_) async => const Right<GlobalFailure, WageHourly>(testWage),
      );

      final result = await useCase.call();

      expect(
        result,
        const Right<GlobalFailure, WageHourly>(testWage),
      );
      verify(() => mockRepository.setWageHourly(any())).called(1);
    });

    // Failure path: repo cannot persist (e.g. DB locked).
    // The exact GlobalFailure must propagate unchanged
    // so the BLoC can react with the correct error state.
    test('returns Left with the exact GlobalFailure on error', () async {
      when(() => mockRepository.setWageHourly(any())).thenAnswer(
        (_) async => const Left<GlobalFailure, WageHourly>(
          NotConnection(),
        ),
      );

      final result = await useCase.call();

      expect(
        result,
        const Left<GlobalFailure, WageHourly>(NotConnection()),
      );
      verify(() => mockRepository.setWageHourly(any())).called(1);
    });
  });
}
