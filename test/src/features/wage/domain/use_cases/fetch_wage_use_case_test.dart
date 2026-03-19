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

  group('FetchWageUseCase', () {
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
