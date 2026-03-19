/// Tests for [DeleteTimeBloc].
///
/// Uses `bloc_test` to verify the state transitions when deleting a time entry:
/// - Initial state is [DeleteTimeInitial].
/// - On [DeleteTimeRequested], transitions through loading -> success -> reset
///   on success, or loading -> error -> reset on failure.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockDeleteTimeUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockDeleteTimeUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const TimeEntry(hour: 0, minutes: 0));
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  // State transitions for deleting a time entry:
  // success path and network-failure path.
  group('DeleteTimeBloc', () {
    // BLoC must start idle so no delete confirmation
    // or spinner is shown before the user acts.
    test('initial state is DeleteTimeInitial', () {
      final bloc = DeleteTimeBloc(mockUseCase);
      expect(bloc.state, const DeleteTimeInitial());
    });

    // Happy path: entry removed from backend. The auto-
    // reset to initial lets the UI dismiss any success
    // feedback and return to a neutral state.
    blocTest<DeleteTimeBloc, DeleteTimeState>(
      'emits [loading, success, initial] on successful delete',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async => const Right<GlobalFailure, Unit>(unit),
        );
        return DeleteTimeBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const DeleteTimeRequested(time: testTime)),
      wait: const Duration(seconds: 2),
      expect: () => [
        const DeleteTimeLoading(),
        const DeleteTimeSuccess(),
        const DeleteTimeInitial(),
      ],
    );

    // Network failure during delete. Error auto-resets
    // to initial so the UI can recover and the user
    // can retry the deletion without a stuck spinner.
    blocTest<DeleteTimeBloc, DeleteTimeState>(
      'emits [loading, error, initial] on failed delete',
      build: () {
        when(() => mockUseCase.call(any<TimeEntry>())).thenAnswer(
          (_) async => const Left<GlobalFailure, Unit>(
            NotConnection(),
          ),
        );
        return DeleteTimeBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const DeleteTimeRequested(time: testTime)),
      wait: const Duration(seconds: 2),
      expect: () => [
        const DeleteTimeLoading(),
        const DeleteTimeError(NotConnection()),
        const DeleteTimeInitial(),
      ],
    );
  });
}
