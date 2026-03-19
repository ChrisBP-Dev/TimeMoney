/// Tests for [CreateTimeBloc].
///
/// Uses `bloc_test` to verify the full lifecycle of creating a time entry:
/// - Initial state holds default hour/minutes of zero.
/// - [CreateTimeHourChanged] / [CreateTimeMinutesChanged] update form values
///   or emit a transient error then auto-recover on invalid input.
/// - [CreateTimeSubmitted] transitions through loading -> success -> reset on
///   success, or loading -> error -> initial-with-preserved-values on failure.
/// - Validation rejects submission when both hour and minutes are zero.
/// - [CreateTimeReset] clears the form back to defaults (D-5 fix).
library;

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

  // Full lifecycle of the create-time form BLoC:
  // input changes, validation, submission, and reset.
  group('CreateTimeBloc', () {
    // Verifies default form state. hour/minutes must be
    // zero so the form starts blank for new entries.
    test('initial state is CreateTimeInitial(hour: 0, minutes: 0)',
        () {
      final bloc = CreateTimeBloc(mockUseCase);
      expect(bloc.state, const CreateTimeInitial());
      expect(bloc.state.hour, 0);
      expect(bloc.state.minutes, 0);
    });

    // Happy path for hour input: a valid numeric string
    // updates the form state so it is ready for submit.
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

    // Non-numeric hour input (e.g. "abc") must show a
    // transient error then auto-recover to initial so
    // the user can correct without manual dismissal.
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

    // Happy path for minutes input: mirrors the hour
    // test to cover the second form field independently.
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

    // Non-numeric minutes input triggers the same
    // transient-error-then-recover pattern as hours.
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

    // Successful creation: loading -> success -> auto-
    // reset to blank form. The reset lets the user
    // immediately create another entry without friction.
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

    // Critical UX: on failure the form must keep the
    // user's hour/minutes so they can retry without
    // re-typing. Losing input here would be frustrating.
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

    // Zero-time guard: submitting 0h 0m is meaningless
    // and must be rejected before calling the use case.
    // Ensures no empty entries pollute the database.
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

    // D-5 regression fix: explicit reset clears stale
    // form data. Before this fix, navigating away and
    // back could show leftover values from a prior entry.
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
