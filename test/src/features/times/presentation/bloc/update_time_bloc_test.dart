/// Tests for [UpdateTimeBloc].
///
/// Uses `bloc_test` to verify the full lifecycle of updating a time entry:
/// - Initial state holds default hour/minutes of zero and a null time.
/// - [UpdateTimeInit] seeds the bloc with the existing [TimeEntry] to edit.
/// - [UpdateTimeHourChanged] / [UpdateTimeMinutesChanged] update form values
///   or emit a transient error then auto-recover on invalid input.
/// - [UpdateTimeSubmitted] transitions through loading -> success -> reset on
///   success, or loading -> error -> reset on failure (preserving form values).
/// - Submitting without a loaded time emits a validation error and never
///   calls the use case.
library;

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

  // Full lifecycle of the update-time form BLoC:
  // init with existing entry, field edits, validation,
  // submission, and null-time guard.
  group('UpdateTimeBloc', () {
    // Default state must carry null time and zero fields
    // so the edit screen knows no entry is loaded yet.
    test('initial state is UpdateTimeInitial(hour: 0, minutes: 0, time: null)',
        () {
      final bloc = UpdateTimeBloc(mockUseCase);
      expect(bloc.state, const UpdateTimeInitial());
      expect(bloc.state.hour, 0);
      expect(bloc.state.minutes, 0);
      expect(bloc.state.time, isNull);
    });

    // Seeds the BLoC with an existing entry for editing.
    // The form fields must reflect the entry's current
    // values so the user sees what they are modifying.
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

    // Valid hour change: both the form field and the
    // underlying TimeEntry.hour must update together
    // so the copyWith stays in sync for submission.
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

    // Non-numeric hour input: transient error then
    // auto-recover. Existing form values (hour, minutes,
    // time) must be preserved through the cycle.
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

    // Valid minutes change: same copyWith-sync pattern
    // as the hour test, covering the other form field.
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

    // Non-numeric minutes input: mirrors the invalid
    // hour test for symmetry across both form fields.
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

    // Successful update: loading -> success -> auto-
    // reset. Form values stay in the reset state so
    // the UI can navigate back or show confirmation.
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

    // Critical UX: on failure the form must preserve
    // hour, minutes, and the loaded TimeEntry so the
    // user can retry without losing their edits.
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

    // Null-time guard: if no entry was loaded before
    // submit (e.g. race condition), the BLoC must
    // reject and never call the use case. Verified by
    // verifyNever in the verify callback.
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
