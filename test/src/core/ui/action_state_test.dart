import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';

void main() {
  group('ActionState sealed class variants', () {
    test('ActionInitial is correct type', () {
      const state = ActionInitial<int>();
      expect(state, isA<ActionInitial<int>>());
      expect(state, isA<ActionState<int>>());
    });

    test('ActionLoading is correct type', () {
      const state = ActionLoading<int>();
      expect(state, isA<ActionLoading<int>>());
      expect(state, isA<ActionState<int>>());
    });

    test('ActionError holds failure', () {
      const failure = NotConnection();
      const state = ActionError<int>(failure);
      expect(state, isA<ActionError<int>>());
      expect(state, isA<ActionState<int>>());
      expect(state.failure, failure);
    });

    test('ActionSuccess holds data', () {
      const state = ActionSuccess<int>(42);
      expect(state, isA<ActionSuccess<int>>());
      expect(state, isA<ActionState<int>>());
      expect(state.data, 42);
    });
  });

  group('ActionState convenience getters', () {
    test('isInitial returns true only for ActionInitial', () {
      expect(const ActionInitial<int>().isInitial, isTrue);
      expect(const ActionLoading<int>().isInitial, isFalse);
      expect(const ActionSuccess<int>(1).isInitial, isFalse);
      expect(
        const ActionError<int>(NotConnection()).isInitial,
        isFalse,
      );
    });

    test('isLoading returns true only for ActionLoading', () {
      expect(const ActionInitial<int>().isLoading, isFalse);
      expect(const ActionLoading<int>().isLoading, isTrue);
      expect(const ActionSuccess<int>(1).isLoading, isFalse);
      expect(
        const ActionError<int>(NotConnection()).isLoading,
        isFalse,
      );
    });

    test('isSuccess returns true only for ActionSuccess', () {
      expect(const ActionInitial<int>().isSuccess, isFalse);
      expect(const ActionLoading<int>().isSuccess, isFalse);
      expect(const ActionSuccess<int>(1).isSuccess, isTrue);
      expect(
        const ActionError<int>(NotConnection()).isSuccess,
        isFalse,
      );
    });

    test('isError returns true only for ActionError', () {
      expect(const ActionInitial<int>().isError, isFalse);
      expect(const ActionLoading<int>().isError, isFalse);
      expect(const ActionSuccess<int>(1).isError, isFalse);
      expect(
        const ActionError<int>(NotConnection()).isError,
        isTrue,
      );
    });
  });

  group('ActionState exhaustive switch', () {
    test('switch dispatches ActionInitial', () {
      const ActionState<int> state = ActionInitial<int>();
      final result = switch (state) {
        ActionInitial() => 'initial',
        ActionLoading() => 'loading',
        ActionError() => 'error',
        ActionSuccess() => 'success',
      };
      expect(result, 'initial');
    });

    test('switch dispatches ActionLoading', () {
      const ActionState<int> state = ActionLoading<int>();
      final result = switch (state) {
        ActionInitial() => 'initial',
        ActionLoading() => 'loading',
        ActionError() => 'error',
        ActionSuccess() => 'success',
      };
      expect(result, 'loading');
    });

    test('switch dispatches ActionError', () {
      const ActionState<int> state = ActionError<int>(NotConnection());
      final result = switch (state) {
        ActionInitial() => 'initial',
        ActionLoading() => 'loading',
        ActionError() => 'error',
        ActionSuccess() => 'success',
      };
      expect(result, 'error');
    });

    test('switch dispatches ActionSuccess with data', () {
      const ActionState<int> state = ActionSuccess<int>(42);
      final result = switch (state) {
        ActionInitial() => 'initial',
        ActionLoading() => 'loading',
        ActionError() => 'error',
        ActionSuccess(:final data) => 'success:$data',
      };
      expect(result, 'success:42');
    });
  });
}
