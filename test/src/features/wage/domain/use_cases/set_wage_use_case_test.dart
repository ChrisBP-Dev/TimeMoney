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

  group('SetWageUseCase', () {
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
