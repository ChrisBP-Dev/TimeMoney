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

  group('ListTimesBloc', () {
    test('initial state is ListTimesInitial', () {
      expect(
        ListTimesBloc(mockUseCase).state,
        const ListTimesInitial(),
      );
    });

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
