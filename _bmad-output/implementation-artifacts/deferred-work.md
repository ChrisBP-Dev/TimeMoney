# Deferred Work

Items surfaced during adversarial review that are pre-existing and not caused by the current change.

## From: tech-spec-deferred-debt-cleanup-pre-epic5 (2026-03-20)

- **TOCTOU race in ObjectBox update()**: `contains()` then `put()` is not atomic. Between the check and the write, a concurrent operation could delete the entity. ObjectBox API does not offer a conditional-put. App is single-isolate today, so risk is theoretical. Would require ObjectBox API extension or transaction-level locking to fix.

- **GlobalFailure is neither Exception nor Error**: `handleError` re-throws `GlobalFailure` via `Error.throwWithStackTrace`, but `GlobalFailure` doesn't extend `Exception` or `Error`. Downstream `catch (Exception)` blocks won't match. BLoC `emit.forEach(onError: (Object))` handles it, but the type hierarchy is architecturally imprecise. Fixing requires making `GlobalFailure` implement `Exception` — a cross-cutting change.

- **iOS paused→killed without detached**: iOS may kill an app from `paused` state without ever reaching `detached`. The lifecycle observer only triggers on `detached`. Known Flutter platform limitation with no reliable workaround.

- **GlobalFailure.fromException imports dart:io**: `failures.dart` references `SocketException` from `dart:io`, which is unavailable on web. Currently works because conditional imports isolate ObjectBox code from the web compiler, but if `failures.dart` is ever imported directly in web-compiled code, it will fail.

- **ObjectBox create() with non-zero ID upserts**: `put()` with a non-zero ID performs an update instead of insert. The domain layer currently never passes non-zero IDs to `create()`, but the API permits it silently. Drift's `insert()` is safe (auto-increments, ignores provided ID).

- **createRepositories failure shows blank screen**: If DB initialization throws inside `runZonedGuarded`, the error is logged but `runApp()` is never called. The user sees a blank screen. A fallback error UI would require significant bootstrap restructuring.
