import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockFetchWageUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockFetchWageUseCase();
  });

  const testWage = WageHourly(id: 1, value: 25);

  group('FetchWageBloc', () {
    test('initial state is FetchWageInitial', () {
      expect(
        FetchWageBloc(mockUseCase).state,
        const FetchWageInitial(),
      );
    });

    blocTest<FetchWageBloc, FetchWageState>(
      'emits [loading, loaded] when stream emits data',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          Right<GlobalFailure, Stream<WageHourly>>(
            Stream.value(testWage),
          ),
        );
        return FetchWageBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchWageRequested()),
      expect: () => [
        const FetchWageLoading(),
        const FetchWageLoaded(testWage),
      ],
    );

    blocTest<FetchWageBloc, FetchWageState>(
      'emits [loading, error] when use case returns Left',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          const Left<GlobalFailure, Stream<WageHourly>>(
            NotConnection(),
          ),
        );
        return FetchWageBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchWageRequested()),
      expect: () => [
        const FetchWageLoading(),
        const FetchWageError(NotConnection()),
      ],
    );

    blocTest<FetchWageBloc, FetchWageState>(
      'emits [loading, error] when stream itself emits an error event '
      '(emit.forEach onError path)',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          Right<GlobalFailure, Stream<WageHourly>>(
            Stream<WageHourly>.error(Exception('db crash')),
          ),
        );
        return FetchWageBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchWageRequested()),
      expect: () => [
        const FetchWageLoading(),
        isA<FetchWageError>(),
      ],
    );
  });
}
