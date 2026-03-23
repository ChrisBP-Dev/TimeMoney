import 'package:flutter/material.dart';

/// Generic widget that handles [AsyncSnapshot] states (error, loading, data).
///
/// Provides sensible defaults for error and loading states while delegating
/// the data-ready state to the [builder] callback.
class CatchErrorBuilder<T> extends StatelessWidget {
  /// Creates a [CatchErrorBuilder] with the given [snapshot] and [builder].
  const CatchErrorBuilder({
    required this.builder,
    required this.snapshot,
    super.key,
    this.error,
    this.loading,
  });

  /// The async snapshot whose state drives the widget tree.
  final AsyncSnapshot<T> snapshot;

  /// Optional widget displayed while the snapshot is in a loading state.
  final Widget? loading;

  /// Optional widget displayed when the snapshot contains an error.
  final Widget? error;

  /// Builder invoked with the resolved data of type [T].
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return error ?? const Center(child: Text('Something went wrong'));
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return loading ?? const _Loading();
    }

    return snapshot.hasData
        ? builder.call(snapshot.data as T)
        : Center(
            child:
                loading ??
                const Text(
                  'error',
                ),
          );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
