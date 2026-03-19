/// Tests for [UpdateTimeUseCase].
///
/// Validates that the use case delegates to `TimesRepository.update` and
/// returns either a `Right` containing the updated [TimeEntry] on success,
/// or a `Left` with the exact [GlobalFailure] on error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/update_time_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockTimesRepository mockRepository;
  late UpdateTimeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const TimeEntry(hour: 0, minutes: 0));
  });

  setUp(() {
    mockRepository = MockTimesRepository();
    useCase = UpdateTimeUseCase(mockRepository);
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  // Thin use case: delegates update to the repository.
  // Must return the updated entity or the exact failure.
  group('UpdateTimeUseCase', () {
    // Happy path: user edits an existing time entry. The
    // returned TimeEntry confirms the update was persisted,
    // letting the Bloc trust the data is current.
    test('returns Right with TimeEntry on success', () async {
      when(() => mockRepository.update(testTime)).thenAnswer(
        (_) async => const Right<GlobalFailure, TimeEntry>(testTime),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Right<GlobalFailure, TimeEntry>(testTime),
      );
      verify(() => mockRepository.update(testTime)).called(1);
    });

    // Failure path: update fails (e.g., stale record or DB
    // error). The exact GlobalFailure must propagate so the
    // presentation layer can show a meaningful error message.
    test('returns Left with the exact GlobalFailure on error', () async {
      when(() => mockRepository.update(testTime)).thenAnswer(
        (_) async => const Left<GlobalFailure, TimeEntry>(
          NotConnection(),
        ),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Left<GlobalFailure, TimeEntry>(NotConnection()),
      );
      verify(() => mockRepository.update(testTime)).called(1);
    });
  });
}
