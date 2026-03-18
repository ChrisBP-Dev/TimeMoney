import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockCreateTimeUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCreateTimeUseCase();
  });

  setUpAll(() {
    registerFallbackValue(
      const TimeEntry(hour: 0, minutes: 0),
    );
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  group('CreateTimeBloc', () {
    test('initial state is CreateTimeInitial(hour: 0, minutes: 0)',
        () {
      final bloc = CreateTimeBloc(mockUseCase);
      expect(bloc.state, const CreateTimeInitial());
      expect(bloc.state.hour, 0);
      expect(bloc.state.minutes, 0);
    });

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits CreateTimeInitial with updated hour '
      'on valid CreateTimeHourChanged',
      build: () => CreateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const CreateTimeHourChanged(value: '5'),
      ),
      expect: () => [
        const CreateTimeInitial(hour: 5),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits error then recovers '
      'on invalid CreateTimeHourChanged',
      build: () => CreateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const CreateTimeHourChanged(value: 'abc'),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CreateTimeError(
          InternalError('invalid number'),
          hour: 0,
          minutes: 0,
        ),
        const CreateTimeInitial(),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits CreateTimeInitial with updated minutes '
      'on valid CreateTimeMinutesChanged',
      build: () => CreateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const CreateTimeMinutesChanged(value: '45'),
      ),
      expect: () => [
        const CreateTimeInitial(minutes: 45),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits error then recovers '
      'on invalid CreateTimeMinutesChanged',
      build: () => CreateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const CreateTimeMinutesChanged(value: 'xyz'),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CreateTimeError(
          InternalError('invalid number'),
          hour: 0,
          minutes: 0,
        ),
        const CreateTimeInitial(),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits [loading, success, initial] on successful submit',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async =>
              const Right<GlobalFailure, TimeEntry>(testTime),
        );
        return CreateTimeBloc(mockUseCase);
      },
      seed: () => const CreateTimeInitial(hour: 1, minutes: 30),
      act: (bloc) => bloc.add(const CreateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CreateTimeLoading(hour: 1, minutes: 30),
        const CreateTimeSuccess(
          testTime,
          hour: 1,
          minutes: 30,
        ),
        const CreateTimeInitial(),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits [loading, error, initial-with-values] on failed submit '
      '(preserves user input for retry)',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async => const Left<GlobalFailure, TimeEntry>(
            NotConnection(),
          ),
        );
        return CreateTimeBloc(mockUseCase);
      },
      seed: () => const CreateTimeInitial(hour: 1, minutes: 30),
      act: (bloc) => bloc.add(const CreateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CreateTimeLoading(hour: 1, minutes: 30),
        const CreateTimeError(
          NotConnection(),
          hour: 1,
          minutes: 30,
        ),
        const CreateTimeInitial(hour: 1, minutes: 30),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits [loading, validation error, initial] '
      'when hour=0 and minutes=0',
      build: () => CreateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(const CreateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CreateTimeLoading(hour: 0, minutes: 0),
        const CreateTimeError(
          InternalError('invalid number'),
          hour: 0,
          minutes: 0,
        ),
        const CreateTimeInitial(),
      ],
    );

    blocTest<CreateTimeBloc, CreateTimeState>(
      'emits CreateTimeInitial on CreateTimeReset (D-5 fix)',
      build: () => CreateTimeBloc(mockUseCase),
      seed: () => const CreateTimeInitial(hour: 5, minutes: 30),
      act: (bloc) => bloc.add(const CreateTimeReset()),
      expect: () => [
        const CreateTimeInitial(),
      ],
    );
  });
}
