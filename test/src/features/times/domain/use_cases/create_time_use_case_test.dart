/// Tests for [CreateTimeUseCase].
///
/// Validates that the use case delegates to `TimesRepository.create` and
/// returns either a `Right` containing the persisted [TimeEntry] on success,
/// or a `Left` with the exact [GlobalFailure] on error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockTimesRepository mockRepository;
  late CreateTimeUseCase useCase;

  setUp(() {
    mockRepository = MockTimesRepository();
    useCase = CreateTimeUseCase(mockRepository);
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  // Thin use case: delegates creation to the repository.
  // Must not add logic; just forward the call and result.
  group('CreateTimeUseCase', () {
    // Happy path: user submits a new time entry. The use case
    // returns the persisted entity so the Bloc can confirm
    // the entry was saved and update the UI accordingly.
    test('returns Right with TimeEntry on success', () async {
      when(() => mockRepository.create(testTime)).thenAnswer(
        (_) async => const Right<GlobalFailure, TimeEntry>(testTime),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Right<GlobalFailure, TimeEntry>(testTime),
      );
      verify(() => mockRepository.create(testTime)).called(1);
    });

    // Failure path: repository signals a failure (e.g., no
    // connection). The exact GlobalFailure type must propagate
    // unchanged so the UI can display the right error message.
    test('returns Left with the exact GlobalFailure on error', () async {
      when(() => mockRepository.create(testTime)).thenAnswer(
        (_) async => const Left<GlobalFailure, TimeEntry>(
          NotConnection(),
        ),
      );

      final result = await useCase.call(testTime);

      expect(
        result,
        const Left<GlobalFailure, TimeEntry>(NotConnection()),
      );
      verify(() => mockRepository.create(testTime)).called(1);
    });
  });
}
