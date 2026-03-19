/// Tests for [DeleteTimeUseCase].
///
/// Validates that the use case delegates to `TimesRepository.delete` and
/// returns either a `Right` containing `Unit` on successful deletion, or a
/// `Left` with the exact [GlobalFailure] on error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/delete_time_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockTimesRepository mockRepository;
  late DeleteTimeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const TimeEntry(hour: 0, minutes: 0));
  });

  setUp(() {
    mockRepository = MockTimesRepository();
    useCase = DeleteTimeUseCase(mockRepository);
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  // Thin use case: delegates deletion to the repository.
  // Returns Unit on success since no data needs to come back.
  group('DeleteTimeUseCase', () {
    // Happy path: entry is removed from persistence. Right(unit)
    // tells the Bloc the operation succeeded so the reactive
    // stream will reflect the deletion automatically.
    test('returns Right with Unit on success', () async {
      when(() => mockRepository.delete(testTime)).thenAnswer(
        (_) async => const Right<GlobalFailure, Unit>(unit),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Right<GlobalFailure, Unit>(unit),
      );
      verify(() => mockRepository.delete(testTime)).called(1);
    });

    // Failure path: deletion fails (e.g., connectivity loss).
    // The exact failure type must propagate so the Bloc can
    // distinguish between error scenarios for UI feedback.
    test('returns Left with the exact GlobalFailure on error', () async {
      when(() => mockRepository.delete(testTime)).thenAnswer(
        (_) async => const Left<GlobalFailure, Unit>(
          NotConnection(),
        ),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Left<GlobalFailure, Unit>(NotConnection()),
      );
      verify(() => mockRepository.delete(testTime)).called(1);
    });
  });
}
