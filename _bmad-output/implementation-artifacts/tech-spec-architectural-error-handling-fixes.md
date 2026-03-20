---
title: 'Fix architectural error handling impurities'
type: 'refactor'
created: '2026-03-20'
status: 'done'
baseline_commit: 'fc209bc'
context: ['_bmad-output/project-context.md']
---

# Fix Architectural Error Handling Impurities

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Three architectural impurities in error handling: (1) Repository `.handleError` double-wraps stream errors that `emit.forEach(onError:)` already handles — we introduced this in the previous cleanup. (2) `failures.dart` imports `dart:io` for `SocketException` mapping — domain layer has platform dependency, violating Dependency Inversion. (3) Bootstrap shows blank screen when DB init fails — no fallback UI.

**Approach:** Remove redundant `.handleError` from 4 repositories (BLoC already covers stream errors). Remove `dart:io` import and `SocketException` mapping from domain — this is a local DB app with no network calls. Add try/catch with `_BootstrapErrorApp` fallback widget in bootstrap for DB init failures.

## Boundaries & Constraints

**Always:**
- Stream errors must still be handled — verified via existing BLoC tests with `emit.forEach(onError:)`.
- `NotConnection` and `ServerError` types remain in GlobalFailure (they're valid domain abstractions). Only the platform-specific mapping inside `fromException` is removed.
- Zero lint warnings. All 177 tests pass (remove handleError tests, verify BLoC-level coverage exists).
- Dartdoc updated on all modified members.

**Ask First:**
- If removing `SocketException` mapping breaks any existing test (it shouldn't — but verify).

**Never:**
- Do NOT change GlobalFailure's public API (sealed class, subclasses, fromException signature).
- Do NOT change BLoC or use case layers.
- Do NOT add new dependencies.

</frozen-after-approval>

## Code Map

- `lib/src/core/errors/failures.dart` -- Remove `dart:io` import and SocketException case from fromException
- `lib/src/features/times/data/repositories/drift_times_repository.dart` -- Remove .handleError chain
- `lib/src/features/times/data/repositories/objectbox_times_repository.dart` -- Remove .handleError chain
- `lib/src/features/wage/data/repositories/drift_wage_repository.dart` -- Remove .handleError chain
- `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` -- Remove .handleError chain
- `lib/bootstrap.dart` -- Add try/catch around createRepositories with _BootstrapErrorApp fallback
- `test/src/core/errors/failures_test.dart` -- Remove SocketException→NotConnection test if exists
- `test/src/features/*/data/repositories/*_test.dart` -- Remove 4 handleError stream tests

## Tasks & Acceptance

**Execution:**
- [ ] `lib/src/core/errors/failures.dart` -- Remove `import 'dart:io';` and the `if (err is SocketException) return const NotConnection();` line from `fromException`. Update dartdoc to remove SocketException reference.
- [ ] `lib/src/features/times/data/repositories/drift_times_repository.dart` -- Remove `.handleError(...)` chain from `fetchTimesStream()`. Keep the stream as `_datasource.watchAll().map(...)` without handleError.
- [ ] `lib/src/features/times/data/repositories/objectbox_times_repository.dart` -- Same: remove `.handleError(...)` from `fetchTimesStream()`.
- [ ] `lib/src/features/wage/data/repositories/drift_wage_repository.dart` -- Remove `.handleError(...)` from `fetchWageHourly()`.
- [ ] `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` -- Remove `.handleError(...)` from `fetchWageHourly()`.
- [ ] `lib/bootstrap.dart` -- Wrap `createRepositories` + `runApp` in try/catch inside `runZonedGuarded`. On failure, call `runApp(_BootstrapErrorApp(error: error))`. Create `_BootstrapErrorApp` as a private minimal MaterialApp showing error message with localization delegates.
- [ ] `test/src/core/errors/failures_test.dart` -- Remove SocketException mapping test if present. Add test verifying SocketException now maps to InternalError.
- [ ] Remove 4 handleError stream tests from repository test files. Verify BLoC-level onError tests exist (they do — ListTimesBlocTest and FetchWageBlocTest).
- [ ] Run `flutter analyze` and `flutter test` -- zero issues, all tests pass.

**Acceptance Criteria:**
- Given a stream error in `fetchTimesStream()`/`fetchWageHourly()`, when consumed by `emit.forEach`, then the BLoC's `onError` handler converts it to `GlobalFailure` — single wrapping, no double-wrap.
- Given `failures.dart`, when inspected, then no `dart:io` import exists. Domain layer is platform-agnostic.
- Given a `SocketException` passed to `GlobalFailure.fromException()`, when processed, then it maps to `InternalError` (not `NotConnection`) — platform-specific mapping removed from domain.
- Given `createRepositories()` throws during bootstrap, when the error is caught, then a `_BootstrapErrorApp` widget is displayed with the error message instead of a blank screen.
- Given all changes, when `flutter test` runs, then all tests pass. When `flutter analyze` runs, then zero issues.

## Spec Change Log


## Design Notes

**Why remove handleError instead of fixing double-wrap at BLoC level:**
The repository's responsibility in Clean Architecture is to provide the stream via `Either<GlobalFailure, Stream<T>>`. Synchronous subscription errors are caught by the existing try/catch. Async stream errors are the **consumer's** responsibility — the BLoC already handles them via `emit.forEach(onError:)`. Adding `.handleError` in the repository layer violates the single-responsibility boundary and creates the double-wrapping problem.

**Why remove SocketException mapping instead of conditional import:**
This app is a local database app with zero network calls. `SocketException` would never occur. The `NotConnection` type remains available for future use — but the mapping belongs in the data layer (a future network datasource), not in the domain factory. This follows Dependency Inversion: domain defines the abstraction, data layer provides the mapping.

## Verification

**Commands:**
- `flutter analyze` -- expected: zero issues
- `flutter test` -- expected: all tests pass
