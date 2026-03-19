/// Tests for [FetchWageUseCase].
///
/// Validates that the use case transparently forwards the reactive wage
/// stream from `WageRepository.fetchWageHourly` on success, and propagates
/// the exact [GlobalFailure] on error without modification.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockWageRepository mockRepository;
  late FetchWageUseCase useCase;

  setUp(() {
    mockRepository = MockWageRepository();
    useCase = FetchWageUseCase(mockRepository);
  });

  const testWage = WageHourly(id: 1, value: 25);

  // Use case is a thin pass-through: it must forward
  // the reactive wage stream or the failure from the
  // repository without any transformation.
  group('FetchWageUseCase', () {
    // Happy path: repo provides a valid stream.
    // Confirms the use case delegates once and the
    // stream content reaches the caller intact.
    test('returns Right with stream on success', () async {
      final stream = Stream.value(testWage);
      when(() => mockRepository.fetchWageHourly()).thenReturn(
        Right<GlobalFailure, Stream<WageHourly>>(stream),
      );

      final result = useCase.call();

      expect(result.isRight(), true);
      final returnedStream = result.getOrElse((_) => throw Exception());
      expect(await returnedStream.first, testWage);
      verify(() => mockRepository.fetchWageHourly()).called(1);
    });

    // Failure path: repo returns Left(NotConnection).
    // The use case must not swallow or remap the failure
    // so the presentation layer can show the right error.
    test('returns Left with the exact GlobalFailure on error', () {
      when(() => mockRepository.fetchWageHourly()).thenReturn(
        const Left<GlobalFailure, Stream<WageHourly>>(
          NotConnection(),
        ),
      );

      final result = useCase.call();

      expect(
        result,
        const Left<GlobalFailure, Stream<WageHourly>>(NotConnection()),
      );
      verify(() => mockRepository.fetchWageHourly()).called(1);
    });
  });
}
