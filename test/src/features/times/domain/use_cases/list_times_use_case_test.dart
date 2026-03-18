import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockTimesRepository mockRepository;
  late ListTimesUseCase useCase;

  setUp(() {
    mockRepository = MockTimesRepository();
    useCase = ListTimesUseCase(mockRepository);
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  group('ListTimesUseCase', () {
    test('returns Right with Stream on success', () {
      final stream = Stream.value([testTime]);
      when(() => mockRepository.fetchTimesStream()).thenReturn(
        Right<GlobalFailure, Stream<List<TimeEntry>>>(stream),
      );

      final result = useCase.call();

      expect(result.isRight(), true);
      verify(() => mockRepository.fetchTimesStream()).called(1);
    });

    test('returns Left with GlobalFailure on error', () {
      when(() => mockRepository.fetchTimesStream()).thenReturn(
        const Left<GlobalFailure, Stream<List<TimeEntry>>>(
          NotConnection(),
        ),
      );

      final result = useCase.call();

      expect(result.isLeft(), true);
      verify(() => mockRepository.fetchTimesStream()).called(1);
    });
  });
}
