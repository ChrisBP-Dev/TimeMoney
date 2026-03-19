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

  group('DeleteTimeUseCase', () {
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
