import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockUpdateTimeUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUpdateTimeUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const TimeEntry(hour: 0, minutes: 0));
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  group('UpdateTimeBloc', () {
    test('initial state is UpdateTimeInitial(hour: 0, minutes: 0, time: null)',
        () {
      final bloc = UpdateTimeBloc(mockUseCase);
      expect(bloc.state, const UpdateTimeInitial());
      expect(bloc.state.hour, 0);
      expect(bloc.state.minutes, 0);
      expect(bloc.state.time, isNull);
    });

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits UpdateTimeInitial with time, hour, minutes on UpdateTimeInit',
      build: () => UpdateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(const UpdateTimeInit(time: testTime)),
      expect: () => [
        const UpdateTimeInitial(
          time: testTime,
          hour: 1,
          minutes: 30,
        ),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits UpdateTimeInitial with updated hour '
      'on valid UpdateTimeHourChanged',
      build: () => UpdateTimeBloc(mockUseCase),
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeHourChanged(value: '5')),
      expect: () => [
        UpdateTimeInitial(
          hour: 5,
          minutes: 30,
          time: testTime.copyWith(hour: 5),
        ),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits error then recovers on invalid UpdateTimeHourChanged',
      build: () => UpdateTimeBloc(mockUseCase),
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeHourChanged(value: 'abc')),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateTimeError(
          InternalError('invalid number'),
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
        const UpdateTimeInitial(
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits UpdateTimeInitial with updated minutes '
      'on valid UpdateTimeMinutesChanged',
      build: () => UpdateTimeBloc(mockUseCase),
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeMinutesChanged(value: '45')),
      expect: () => [
        UpdateTimeInitial(
          hour: 1,
          minutes: 45,
          time: testTime.copyWith(minutes: 45),
        ),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits error then recovers on invalid UpdateTimeMinutesChanged',
      build: () => UpdateTimeBloc(mockUseCase),
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeMinutesChanged(value: 'xyz')),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateTimeError(
          InternalError('invalid number'),
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
        const UpdateTimeInitial(
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits [loading, success, initial] on successful submit',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async => const Right<GlobalFailure, TimeEntry>(testTime),
        );
        return UpdateTimeBloc(mockUseCase);
      },
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateTimeLoading(hour: 1, minutes: 30, time: testTime),
        const UpdateTimeSuccess(
          testTime,
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
        const UpdateTimeInitial(hour: 1, minutes: 30, time: testTime),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits [loading, error, initial] on failed submit '
      '(preserves form values)',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async => const Left<GlobalFailure, TimeEntry>(
            NotConnection(),
          ),
        );
        return UpdateTimeBloc(mockUseCase);
      },
      seed: () => const UpdateTimeInitial(
        hour: 1,
        minutes: 30,
        time: testTime,
      ),
      act: (bloc) => bloc.add(const UpdateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateTimeLoading(hour: 1, minutes: 30, time: testTime),
        const UpdateTimeError(
          NotConnection(),
          hour: 1,
          minutes: 30,
          time: testTime,
        ),
        const UpdateTimeInitial(hour: 1, minutes: 30, time: testTime),
      ],
    );

    blocTest<UpdateTimeBloc, UpdateTimeState>(
      'emits [loading, error, initial] when time is null on submit',
      build: () => UpdateTimeBloc(mockUseCase),
      act: (bloc) => bloc.add(const UpdateTimeSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateTimeLoading(hour: 0, minutes: 0),
        const UpdateTimeError(
          InternalError('invalid number'),
          hour: 0,
          minutes: 0,
        ),
        const UpdateTimeInitial(),
      ],
      verify: (_) {
        verifyNever(() => mockUseCase.call(any<TimeEntry>()));
      },
    );
  });
}
