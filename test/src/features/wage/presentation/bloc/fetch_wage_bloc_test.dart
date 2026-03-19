/// Tests for [FetchWageBloc].
///
/// Uses `bloc_test` to verify the state transitions when fetching the wage:
/// - Initial state is [FetchWageInitial].
/// - On [FetchWageRequested], transitions through [FetchWageLoading] to
///   [FetchWageLoaded] or [FetchWageError] depending on the use-case result.
/// - Covers the `emit.forEach` onError path when the stream itself errors.
library;

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

  // FetchWageBloc subscribes to a reactive wage stream.
  // It must transition through loading to loaded/error
  // and handle stream-level errors gracefully.
  group('FetchWageBloc', () {
    // Sanity check: bloc starts in the initial state
    // before any event is added, so the UI can show a
    // placeholder or trigger a fetch on build.
    test('initial state is FetchWageInitial', () {
      expect(
        FetchWageBloc(mockUseCase).state,
        const FetchWageInitial(),
      );
    });

    // Happy path: use case returns a stream with valid
    // data. Bloc must show loading then deliver the
    // WageHourly so the UI can render the wage value.
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

    // Failure path: use case returns Left immediately
    // (e.g. DB unavailable). Bloc transitions to error
    // so the UI can prompt the user to retry.
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

    // Edge case: use case returns Right but the stream
    // itself errors (e.g. mid-flight DB crash). Covers
    // the emit.forEach onError callback path in the bloc.
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
