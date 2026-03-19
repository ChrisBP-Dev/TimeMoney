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

  group('UpdateWageBloc', () {
    test('initial state is UpdateWageInitial with default WageHourly', () {
      final bloc = UpdateWageBloc(mockUseCase);
      expect(bloc.state, const UpdateWageInitial());
      expect(bloc.state.wageHourly, const WageHourly());
    });

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
