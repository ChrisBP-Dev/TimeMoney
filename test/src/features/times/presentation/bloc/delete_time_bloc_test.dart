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

  group('DeleteTimeBloc', () {
    test('initial state is DeleteTimeInitial', () {
      final bloc = DeleteTimeBloc(mockUseCase);
      expect(bloc.state, const DeleteTimeInitial());
    });

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
