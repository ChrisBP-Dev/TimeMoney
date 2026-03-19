/// Tests for [UpdateWageUseCase].
///
/// Validates that the use case delegates to `WageRepository.update` and
/// returns either a `Right` containing the updated [WageHourly] on success,
/// or a `Left` with the exact [GlobalFailure] on error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockWageRepository mockRepository;
  late UpdateWageUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const WageHourly());
  });

  setUp(() {
    mockRepository = MockWageRepository();
    useCase = UpdateWageUseCase(mockRepository);
  });

  const testWage = WageHourly(id: 1, value: 25);

  // Update use case modifies an existing wage. Unlike
  // set, it receives a WageHourly with an assigned ID
  // so the datasource overwrites the correct row.
  group('UpdateWageUseCase', () {
    // Happy path: repo persists the new value.
    // Verifies the updated entity is returned and the
    // repo is called exactly once.
    test('returns Right with WageHourly on success', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Right<GlobalFailure, WageHourly>(testWage),
      );

      final result = await useCase.call(testWage);

      expect(
        result,
        const Right<GlobalFailure, WageHourly>(testWage),
      );
      verify(() => mockRepository.update(any())).called(1);
    });

    // Failure path: repo update fails. The exact failure
    // must arrive unchanged so the UI can show the
    // appropriate error message to the user.
    test('returns Left with the exact GlobalFailure on error', () async {
      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Left<GlobalFailure, WageHourly>(
          NotConnection(),
        ),
      );

      final result = await useCase.call(testWage);

      expect(
        result,
        const Left<GlobalFailure, WageHourly>(NotConnection()),
      );
      verify(() => mockRepository.update(any())).called(1);
    });
  });
}
