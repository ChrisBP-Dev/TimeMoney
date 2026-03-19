/// Tests for [UpdateWageBloc].
///
/// Uses `bloc_test` to verify the full lifecycle of updating the hourly wage:
/// - Initial state holds a default [WageHourly].
/// - [UpdateWageHourlyChanged] updates the form value or emits a transient
///   error then auto-recovers on invalid input.
/// - [UpdateWageSubmitted] transitions through loading -> success -> reset on
///   success, or loading -> error -> reset on failure (preserving wageHourly
///   on error, resetting on the final initial state).
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late MockUpdateWageUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUpdateWageUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const WageHourly());
  });

  const testWage = WageHourly(id: 1, value: 25);

  // UpdateWageBloc handles form input, validation, and
  // submission. It preserves the wageHourly across error
  // states and auto-resets after success or failure.
  group('UpdateWageBloc', () {
    // Sanity check: bloc starts with an empty default
    // wage so the form fields can bind immediately
    // without requiring a prior fetch.
    test('initial state is UpdateWageInitial with default WageHourly', () {
      final bloc = UpdateWageBloc(mockUseCase);
      expect(bloc.state, const UpdateWageInitial());
      expect(bloc.state.wageHourly, const WageHourly());
    });

    // Valid input: user types a parseable number.
    // Bloc updates wageHourly in state so the form
    // reflects the new value before submission.
    blocTest<UpdateWageBloc, UpdateWageState>(
      'emits UpdateWageInitial with updated wageHourly '
      'on valid UpdateWageHourlyChanged',
      build: () => UpdateWageBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const UpdateWageHourlyChanged(value: '25.0'),
      ),
      expect: () => [
        const UpdateWageInitial(
          wageHourly: WageHourly(value: 25),
        ),
      ],
    );

    // Invalid input: non-numeric string like "abc".
    // Bloc emits a transient error then auto-recovers
    // to initial, keeping the previous wageHourly safe.
    blocTest<UpdateWageBloc, UpdateWageState>(
      'emits [error, initial] on invalid UpdateWageHourlyChanged '
      '(preserves wageHourly)',
      build: () => UpdateWageBloc(mockUseCase),
      act: (bloc) => bloc.add(
        const UpdateWageHourlyChanged(value: 'abc'),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateWageError(
          InternalError('invalid number'),
        ),
        const UpdateWageInitial(),
      ],
    );

    // Submit happy path: use case succeeds. Bloc goes
    // loading -> success -> reset to initial. The reset
    // lets the UI dismiss any success banner cleanly.
    blocTest<UpdateWageBloc, UpdateWageState>(
      'emits [loading, success, initial] on successful submit',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async => const Right<GlobalFailure, WageHourly>(testWage),
        );
        return UpdateWageBloc(mockUseCase);
      },
      seed: () => const UpdateWageInitial(
        wageHourly: WageHourly(value: 25),
      ),
      act: (bloc) => bloc.add(const UpdateWageSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateWageLoading(wageHourly: WageHourly(value: 25)),
        const UpdateWageSuccess(
          result: testWage,
          wageHourly: WageHourly(value: 25),
        ),
        const UpdateWageInitial(),
      ],
    );

    // Submit failure path: use case returns Left.
    // wageHourly is preserved in the error state so the
    // user does not lose typed input, then auto-resets.
    blocTest<UpdateWageBloc, UpdateWageState>(
      'emits [loading, error, initial] on failed submit '
      '(preserves wageHourly on error, resets on initial)',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async => const Left<GlobalFailure, WageHourly>(
            NotConnection(),
          ),
        );
        return UpdateWageBloc(mockUseCase);
      },
      seed: () => const UpdateWageInitial(
        wageHourly: WageHourly(value: 25),
      ),
      act: (bloc) => bloc.add(const UpdateWageSubmitted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const UpdateWageLoading(wageHourly: WageHourly(value: 25)),
        const UpdateWageError(
          NotConnection(),
          wageHourly: WageHourly(value: 25),
        ),
        const UpdateWageInitial(),
      ],
    );
  });
}
