/// Tests for [ListTimesUseCase].
///
/// Validates that the use case transparently forwards the reactive stream
/// from `TimesRepository.fetchTimesStream` on success, and propagates the
/// exact [GlobalFailure] on error without modification.
library;

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

  // Thin use case: must act as a pass-through to the repository.
  // Any transformation or swallowed error here is a bug.
  group('ListTimesUseCase', () {
    // Happy path: the reactive stream from the repository must
    // reach the presentation layer with identical data, ensuring
    // the UI reflects live database changes in real time.
    test('forwards the repository stream unchanged on success', () async {
      final stream = Stream.value([testTime]);
      when(() => mockRepository.fetchTimesStream()).thenReturn(
        Right<GlobalFailure, Stream<List<TimeEntry>>>(stream),
      );

      final result = useCase.call();

      expect(result.isRight(), true);
      final returnedStream = result.getOrElse((_) => throw Exception());
      expect(await returnedStream.first, [testTime]);
      verify(() => mockRepository.fetchTimesStream()).called(1);
    });

    // Failure path: the use case must not swallow or remap the
    // failure. NotConnection must arrive intact so the Bloc can
    // show the correct offline/error state to the user.
    test('returns Left with the exact GlobalFailure on error', () {
      when(() => mockRepository.fetchTimesStream()).thenReturn(
        const Left<GlobalFailure, Stream<List<TimeEntry>>>(
          NotConnection(),
        ),
      );

      final result = useCase.call();

      expect(
        result,
        const Left<GlobalFailure, Stream<List<TimeEntry>>>(NotConnection()),
      );
      verify(() => mockRepository.fetchTimesStream()).called(1);
    });
  });
}
