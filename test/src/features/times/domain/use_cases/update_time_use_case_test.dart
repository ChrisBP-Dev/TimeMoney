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

  group('UpdateTimeUseCase', () {
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
