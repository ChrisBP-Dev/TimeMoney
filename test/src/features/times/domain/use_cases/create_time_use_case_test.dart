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

  group('CreateTimeUseCase', () {
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

    test('returns Left with GlobalFailure on error', () async {
      when(() => mockRepository.create(testTime)).thenAnswer(
        (_) async => const Left<GlobalFailure, TimeEntry>(
          NotConnection(),
        ),
      );

      final result = await useCase.call(testTime);

      expect(result.isLeft(), true);
      verify(() => mockRepository.create(testTime)).called(1);
    });
  });
}
