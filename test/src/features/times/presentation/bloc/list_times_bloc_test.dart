/// Tests for [ListTimesBloc].
///
/// Uses `bloc_test` to verify the state transitions when listing time entries:
/// - Initial state is [ListTimesInitial].
/// - On [ListTimesRequested], transitions through [ListTimesLoading] to
///   [ListTimesLoaded], [ListTimesEmpty], or [ListTimesError] depending on
///   the use-case result and stream content.
/// - Covers the `emit.forEach` onError path when the stream itself errors.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockListTimesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockListTimesUseCase();
  });

  const testTime = TimeEntry(hour: 1, minutes: 30, id: 1);

  // All state transitions for the list-times BLoC,
  // covering happy path, empty data, and error scenarios.
  group('ListTimesBloc', () {
    // Sanity check: BLoC must start in initial state so
    // the UI shows a neutral screen before any fetch.
    test('initial state is ListTimesInitial', () {
      expect(
        ListTimesBloc(mockUseCase).state,
        const ListTimesInitial(),
      );
    });

    // Happy path: use case returns a stream with entries.
    // Ensures loading indicator shows, then data renders.
    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, loaded] when stream emits data',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          Right<GlobalFailure, Stream<List<TimeEntry>>>(
            Stream.value([testTime]),
          ),
        );
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        const ListTimesLoaded([testTime]),
      ],
    );

    // Edge case: database has no entries yet. The UI must
    // show an empty-state placeholder, not a stale list.
    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, empty] when stream emits empty list',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          Right<GlobalFailure, Stream<List<TimeEntry>>>(
            Stream.value(<TimeEntry>[]),
          ),
        );
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        const ListTimesEmpty(),
      ],
    );

    // Use-case failure (e.g. no network). Left branch
    // of Either must surface a typed error to the UI.
    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, error] when use case returns Left',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          const Left<GlobalFailure, Stream<List<TimeEntry>>>(
            NotConnection(),
          ),
        );
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        const ListTimesError(NotConnection()),
      ],
    );

    // Covers the emit.forEach onError callback: the
    // stream itself throws (e.g. DB crash mid-read).
    // Without this, an unhandled stream error would
    // leave the BLoC stuck in loading forever.
    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, error] when stream itself emits an error event '
      '(emit.forEach onError path)',
      build: () {
        when(() => mockUseCase.call()).thenReturn(
          Right<GlobalFailure, Stream<List<TimeEntry>>>(
            Stream<List<TimeEntry>>.error(Exception('db crash')),
          ),
        );
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        isA<ListTimesError>(),
      ],
    );
  });
}
