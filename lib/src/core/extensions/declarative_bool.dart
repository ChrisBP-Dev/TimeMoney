extension DeclarativeBool on bool {
  W when<W>({
    required W Function() isTrue,
    required W Function() isFalse,
  }) =>
      this ? isTrue() : isFalse();

  W? whenOrNull<W>({
    W? Function()? isTrue,
    W? Function()? isFalse,
  }) =>
      this ? isTrue?.call() : isFalse?.call();
}
