import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/ui/action_state.dart';

void main() {
  group('ActionState factory constructors', () {
    test('initial creates Initial state', () {
      const ActionState<int>.initial().when(
        initial: () => expect(true, isTrue),
        loading: () => fail('wrong variant'),
        error: (_) => fail('wrong variant'),
        success: (_) => fail('wrong variant'),
      );
    });

    test('loading creates Loading state', () {
      const ActionState<int>.loading().when(
        initial: () => fail('wrong variant'),
        loading: () => expect(true, isTrue),
        error: (_) => fail('wrong variant'),
        success: (_) => fail('wrong variant'),
      );
    });

    test('error creates Error state with failure', () {
      const failure = GlobalFailure<dynamic>.notConnection();
      const ActionState<int>.error(failure).when(
        initial: () => fail('wrong variant'),
        loading: () => fail('wrong variant'),
        error: (err) => expect(err, failure),
        success: (_) => fail('wrong variant'),
      );
    });

    test('success creates Success state with value', () {
      const ActionState<int>.success(42).when(
        initial: () => fail('wrong variant'),
        loading: () => fail('wrong variant'),
        error: (_) => fail('wrong variant'),
        success: (value) => expect(value, 42),
      );
    });
  });

  group('ActionInfo extension', () {
    test('isInitial returns true only for initial', () {
      expect(const ActionState<int>.initial().isInitial, isTrue);
      expect(const ActionState<int>.loading().isInitial, isFalse);
      expect(const ActionState<int>.success(1).isInitial, isFalse);
      expect(
        const ActionState<int>.error(
          GlobalFailure<dynamic>.notConnection(),
        ).isInitial,
        isFalse,
      );
    });

    test('isLoading returns true only for loading', () {
      expect(const ActionState<int>.initial().isLoading, isFalse);
      expect(const ActionState<int>.loading().isLoading, isTrue);
      expect(const ActionState<int>.success(1).isLoading, isFalse);
      expect(
        const ActionState<int>.error(
          GlobalFailure<dynamic>.notConnection(),
        ).isLoading,
        isFalse,
      );
    });

    test('isSuccess returns true only for success', () {
      expect(const ActionState<int>.initial().isSuccess, isFalse);
      expect(const ActionState<int>.loading().isSuccess, isFalse);
      expect(const ActionState<int>.success(1).isSuccess, isTrue);
      expect(
        const ActionState<int>.error(
          GlobalFailure<dynamic>.notConnection(),
        ).isSuccess,
        isFalse,
      );
    });

    test('isError returns true only for error', () {
      expect(const ActionState<int>.initial().isError, isFalse);
      expect(const ActionState<int>.loading().isError, isFalse);
      expect(const ActionState<int>.success(1).isError, isFalse);
      expect(
        const ActionState<int>.error(
          GlobalFailure<dynamic>.notConnection(),
        ).isError,
        isTrue,
      );
    });
  });

  group('when dispatches correctly', () {
    test('dispatches initial', () {
      final result = const ActionState<int>.initial().when(
        initial: () => 'initial',
        loading: () => 'loading',
        error: (_) => 'error',
        success: (_) => 'success',
      );
      expect(result, 'initial');
    });

    test('dispatches loading', () {
      final result = const ActionState<int>.loading().when(
        initial: () => 'initial',
        loading: () => 'loading',
        error: (_) => 'error',
        success: (_) => 'success',
      );
      expect(result, 'loading');
    });

    test('dispatches error', () {
      const failure = GlobalFailure<dynamic>.notConnection();
      final result = const ActionState<int>.error(failure).when(
        initial: () => 'initial',
        loading: () => 'loading',
        error: (_) => 'error',
        success: (_) => 'success',
      );
      expect(result, 'error');
    });

    test('dispatches success', () {
      final result = const ActionState<int>.success(42).when(
        initial: () => 'initial',
        loading: () => 'loading',
        error: (_) => 'error',
        success: (v) => 'success:$v',
      );
      expect(result, 'success:42');
    });
  });
}
