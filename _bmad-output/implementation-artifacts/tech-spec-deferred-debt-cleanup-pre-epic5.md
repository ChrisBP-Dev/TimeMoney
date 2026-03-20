---
title: 'Resolve all deferred technical debt before Epic 5'
type: 'refactor'
created: '2026-03-20'
status: 'done'
baseline_commit: '0c51eff'
context: ['_bmad-output/project-context.md', '_bmad-output/implementation-artifacts/epic-4-retro-2026-03-20.md']
---

# Resolve All Deferred Technical Debt Before Epic 5

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Epic 4 accumulated 8 deferred items across DB lifecycle, API correctness, error reporting, stream safety, and test infrastructure. These defects propagated from ObjectBox into drift — new code inherited old bugs. D-7 (pumpApp missing LocaleCubit) is a blocker for Epic 5 widget tests.

**Approach:** Fix all 8 items consistently in both ObjectBox and drift implementations: return DB-assigned IDs from create, report failures on non-existent targets, close DB resources on app lifecycle, guard DB initialization, add stream error handling, and provide LocaleCubit in the test helper.

## Boundaries & Constraints

**Always:**
- Fix in BOTH ObjectBox and drift — consistency is non-negotiable.
- Maintain all existing 165 tests green (update stubs/assertions as needed).
- Return `Either<GlobalFailure, T>` for all failure cases — no silent operations.
- Dartdoc on all new/modified public members. Zero lint warnings.
- New tests for every new behavior (ID return, failure on missing, stream errors, lifecycle close).

**Ask First:**
- If any datasource API change cascades to BLoC layer (it should NOT — repositories absorb changes).
- If Drift update() row-count approach requires schema or migration changes.

**Never:**
- Do NOT change repository interfaces (TimesRepository, WageRepository) — their return types are already correct.
- Do NOT touch BLoC, UI, or use case layers — changes stay in data + core + test helpers.
- Do NOT change Freezed entities or domain layer.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| create() happy path | TimeEntry(id: 0, hour: 1, minutes: 30) | Right(TimeEntry(id: DB_ASSIGNED, hour: 1, minutes: 30)) | N/A |
| setWageHourly() happy path | WageHourly(id: 0, value: 20.0) | Right(WageHourly(id: DB_ASSIGNED, value: 20.0)) | N/A |
| delete() non-existent ID | TimeEntry(id: 999) | Left(GlobalFailure) | NotFound failure |
| update() non-existent ID | TimeEntry(id: 999, ...) | Left(GlobalFailure) | NotFound failure |
| update() happy path (drift) | TimeEntry(id: 1, ...) | Right(TimeEntry(id: 1, ...)) with 1 row affected | N/A |
| stream runtime error | DB corruption mid-stream | Error transformed to GlobalFailure in stream | handleError on stream |
| DB close on lifecycle | AppLifecycleState.detached | Both ObjectBox and drift close cleanly | Log if close fails |
| DB init failure | Corrupt DB or missing WASM | Error caught inside runZonedGuarded | Logged, app shows error |
| pumpApp with locale | Any widget using context.l10n | LocaleCubit provided, no crash | N/A |

</frozen-after-approval>

## Code Map

- `lib/bootstrap.dart` -- App entry: move createRepositories inside runZonedGuarded, add lifecycle observer
- `lib/bootstrap_repositories_native.dart` -- Return close callback alongside repositories
- `lib/bootstrap_repositories_web.dart` -- Return close callback alongside repositories
- `lib/src/core/services/app_database.dart` -- Already has close() via GeneratedDatabase
- `lib/src/core/services/objectbox_service.dart` -- Already has close()
- `lib/src/features/times/data/datasources/times_drift_datasource.dart` -- Change update() return to Future<int>
- `lib/src/features/times/data/datasources/times_objectbox_datasource.dart` -- No changes needed (put returns int, remove returns bool)
- `lib/src/features/times/data/repositories/drift_times_repository.dart` -- Capture IDs, check affected rows, add handleError
- `lib/src/features/times/data/repositories/objectbox_times_repository.dart` -- Capture IDs, check remove result, add handleError
- `lib/src/features/wage/data/datasources/wage_drift_datasource.dart` -- Change update() return to Future<int>
- `lib/src/features/wage/data/repositories/drift_wage_repository.dart` -- Capture IDs, check affected rows, add handleError
- `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` -- Capture IDs, add handleError
- `test/helpers/pump_app.dart` -- Add BlocProvider<LocaleCubit>
- `test/src/features/times/data/repositories/drift_times_repository_test.dart` -- Update stubs, add ID/failure tests
- `test/src/features/times/data/repositories/objectbox_times_repository_test.dart` -- Update stubs, add ID/failure tests
- `test/src/features/times/data/datasources/times_drift_datasource_test.dart` -- Update for new return type
- `test/src/features/wage/data/repositories/drift_wage_repository_test.dart` -- Update stubs, add ID/failure tests
- `test/src/features/wage/data/repositories/objectbox_wage_repository_test.dart` -- Update stubs, add ID/failure tests
- `test/src/features/wage/data/datasources/wage_drift_datasource_test.dart` -- Update for new return type

## Tasks & Acceptance

**Execution:**
- [ ] `lib/bootstrap_repositories_native.dart` + `lib/bootstrap_repositories_web.dart` -- Change return type to include `Future<void> Function() close` callback that closes ObjectBox Store / Drift AppDatabase respectively
- [ ] `lib/bootstrap.dart` -- Move `createRepositories()` inside `runZonedGuarded`. Register `WidgetsBindingObserver` that calls `close()` on `AppLifecycleState.detached`. Wrap binding init in try/catch within the guarded zone.
- [ ] `lib/src/features/times/data/datasources/times_drift_datasource.dart` -- Change `update()` return type from `Future<void>` to `Future<int>` (rows affected)
- [ ] `lib/src/features/wage/data/datasources/wage_drift_datasource.dart` -- Change `update()` return type from `Future<void>` to `Future<int>` (rows affected)
- [ ] `lib/src/features/times/data/repositories/drift_times_repository.dart` -- create(): capture ID, return `time.copyWith(id: id)`. delete(): check rows==0 → Left(GlobalFailure). update(): check rows==0 → Left(GlobalFailure). fetchTimesStream(): add `.handleError` wrapping to GlobalFailure.
- [ ] `lib/src/features/times/data/repositories/objectbox_times_repository.dart` -- create(): capture ID from put(), return `time.copyWith(id: id)`. delete(): check `remove()` bool → false means Left(GlobalFailure). update(): verify entity exists via datasource before put(). fetchTimesStream(): add `.handleError`.
- [ ] `lib/src/features/wage/data/repositories/drift_wage_repository.dart` -- setWageHourly(): capture ID, return `wageHourly.copyWith(id: id)`. update(): check rows==0 → Left(GlobalFailure) (for non-zero IDs). fetchWageHourly(): add `.handleError`.
- [ ] `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` -- setWageHourly(): capture ID from put(), return `wageHourly.copyWith(id: id)`. update(): capture ID from put(), return entity with ID. fetchWageHourly(): add `.handleError`.
- [ ] `test/helpers/pump_app.dart` -- Wrap MaterialApp with `BlocProvider<LocaleCubit>(create: (_) => LocaleCubit(), child: ...)`.
- [ ] Update ALL 6 existing repository/datasource test files -- Adjust stubs for new return types and signatures. Add tests: create returns entity with DB-assigned ID, delete/update on non-existent ID returns Left(GlobalFailure), stream handleError coverage.
- [ ] Run `flutter test` -- all tests pass (165 existing + new tests). Run `flutter analyze` -- zero issues.

**Acceptance Criteria:**
- Given a `create()` call on any repository (Times or Wage, ObjectBox or drift), when the datasource assigns an ID, then the returned entity contains the DB-assigned ID (not 0).
- Given a `delete()` call with a non-existent ID, when the datasource reports 0 affected rows (drift) or false (ObjectBox), then the repository returns `Left(GlobalFailure)`.
- Given an `update()` call with a non-existent ID, when the datasource reports 0 affected rows, then the repository returns `Left(GlobalFailure)`.
- Given a stream from `fetchTimesStream()` or `fetchWageHourly()`, when a runtime error occurs, then the error is transformed to `GlobalFailure` via `.handleError`.
- Given the app lifecycle reaches `detached`, when the observer fires, then both ObjectBox Store and drift AppDatabase are closed.
- Given `createRepositories()` throws during startup, when `bootstrap()` runs, then the error is caught inside `runZonedGuarded` and logged.
- Given a widget test using `tester.pumpApp(widget)`, when the widget accesses `context.l10n` or `LocaleCubit`, then no crash occurs.
- Given all changes applied, when `flutter test` runs, then all tests pass with zero regressions. When `flutter analyze` runs, then zero issues.

## Spec Change Log


## Verification

**Commands:**
- `flutter analyze` -- expected: zero issues
- `flutter test` -- expected: all tests pass (165+ existing, all new tests green)
