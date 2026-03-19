/// Declarative pattern-matching helpers for [bool] values.
///
/// Replaces verbose ternary expressions with a readable, callback-based API
/// inspired by sealed-class `when`/`whenOrNull` patterns. Useful in widget
/// builds where branching on a flag should remain expressive.
extension DeclarativeBool on bool {
  /// Executes [isTrue] when `true`, [isFalse] when `false`, and returns
  /// the result.
  ///
  /// Both callbacks are required, guaranteeing exhaustive handling.
  W when<W>({
    required W Function() isTrue,
    required W Function() isFalse,
  }) =>
      this ? isTrue() : isFalse();

  /// Like [when], but both callbacks are optional and may return `null`.
  ///
  /// Returns `null` when the matching callback is not provided.
  W? whenOrNull<W>({
    W? Function()? isTrue,
    W? Function()? isFalse,
  }) =>
      this ? isTrue?.call() : isFalse?.call();
}
