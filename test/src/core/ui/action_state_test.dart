/// Tests for the [ActionState] sealed class hierarchy.
///
/// Verifies that each variant (Initial, Loading, Error, Success) is correctly
/// typed, holds its payload, exposes accurate convenience getters, and supports
/// exhaustive `switch` dispatch -- the foundation for all bloc/cubit state
/// machines in the application.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';

void main() {
  // Verify each sealed variant is a proper subtype of
  // ActionState — foundational for type-safe state machines.
  group('ActionState sealed class variants', () {
    // Confirm the default/idle state is recognized as both
    // its concrete type and the sealed supertype.
    test('ActionInitial is correct type', () {
      const state = ActionInitial<int>();
      expect(state, isA<ActionInitial<int>>());
      expect(state, isA<ActionState<int>>());
    });

    // Loading variant must be typed correctly so the UI
    // can show spinners/progress for any async operation.
    test('ActionLoading is correct type', () {
      const state = ActionLoading<int>();
      expect(state, isA<ActionLoading<int>>());
      expect(state, isA<ActionState<int>>());
    });

    // Error variant must carry a Failure payload so the
    // UI can display a meaningful error message to the user.
    test('ActionError holds failure', () {
      const failure = NotConnection();
      const state = ActionError<int>(failure);
      expect(state, isA<ActionError<int>>());
      expect(state, isA<ActionState<int>>());
      expect(state.failure, failure);
    });

    // Success variant must hold the result data so
    // downstream widgets can render the computed value.
    test('ActionSuccess holds data', () {
      const state = ActionSuccess<int>(42);
      expect(state, isA<ActionSuccess<int>>());
      expect(state, isA<ActionState<int>>());
      expect(state.data, 42);
    });
  });

  // Convenience getters let widgets check state without
  // casting; each must be exclusive to its own variant.
  group('ActionState convenience getters', () {
    // isInitial must be true only for the idle state so
    // the UI can distinguish "not started" from other states.
    test('isInitial returns true only for ActionInitial', () {
      expect(const ActionInitial<int>().isInitial, isTrue);
      expect(const ActionLoading<int>().isInitial, isFalse);
      expect(const ActionSuccess<int>(1).isInitial, isFalse);
      expect(
        const ActionError<int>(NotConnection()).isInitial,
        isFalse,
      );
    });

    // isLoading exclusivity prevents showing a spinner
    // when the operation already succeeded or failed.
    test('isLoading returns true only for ActionLoading', () {
      expect(const ActionInitial<int>().isLoading, isFalse);
      expect(const ActionLoading<int>().isLoading, isTrue);
      expect(const ActionSuccess<int>(1).isLoading, isFalse);
      expect(
        const ActionError<int>(NotConnection()).isLoading,
        isFalse,
      );
    });

    // isSuccess exclusivity ensures result data is only
    // accessed when the operation truly completed.
    test('isSuccess returns true only for ActionSuccess', () {
      expect(const ActionInitial<int>().isSuccess, isFalse);
      expect(const ActionLoading<int>().isSuccess, isFalse);
      expect(const ActionSuccess<int>(1).isSuccess, isTrue);
      expect(
        const ActionError<int>(NotConnection()).isSuccess,
        isFalse,
      );
    });

    // isError exclusivity prevents showing error UI when
    // the state is actually loading or successful.
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

  // Exhaustive switch guarantees compile-time safety: if a
  // new variant is added, all switch sites must be updated.
  group('ActionState exhaustive switch', () {
    // Ensures the switch arm for ActionInitial fires when
    // the state machine is in its default idle position.
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

    // Ensures the switch arm for ActionLoading fires when
    // an async operation is in progress.
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

    // Ensures the switch arm for ActionError fires when
    // the operation encountered a failure.
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

    // Ensures the Success arm provides destructured data
    // so the UI can render the result inline.
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
