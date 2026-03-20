# Story 4.4: Platform-Aware DI & Multi-Environment Configuration

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want the app to automatically select the correct datasource based on the target platform,
so that native platforms use ObjectBox and web uses drift without manual configuration (FR24, FR28).

## Acceptance Criteria

1. **AC1 — Platform detection via kIsWeb**
   - **Given** `kIsWeb` from `package:flutter/foundation.dart` is a compile-time constant
   - **When** `bootstrap()` initializes the DI container
   - **Then** `kIsWeb == true` registers drift datasources and repositories
   - **And** `kIsWeb == false` registers ObjectBox datasources and repositories
   - **And** BLoCs receive repository interfaces (`TimesRepository`, `WageRepository`) — unaware of the underlying datasource

2. **AC2 — Platform-aware repository registration**
   - **Given** the platform-aware DI is configured in `bootstrap.dart`
   - **When** `AppBloc` wraps the widget tree with `MultiRepositoryProvider`
   - **Then** `RepositoryProvider<TimesRepository>` resolves to `DriftTimesRepository` (web) or `ObjectboxTimesRepository` (native)
   - **And** `RepositoryProvider<WageRepository>` resolves to `DriftWageRepository` (web) or `ObjectboxWageRepository` (native)
   - **And** use cases are created inline with `context.read<T>()` resolution (FR39)

3. **AC3 — Environment-specific database naming**
   - **Given** three entry points exist (`main_development.dart`, `main_staging.dart`, `main_production.dart`)
   - **When** each entry point calls `bootstrap(dbName: '<name>')`
   - **Then** `main_development.dart` passes `test-1`, `main_staging.dart` passes `stg-1`, `main_production.dart` passes `prod-1`
   - **And** both ObjectBox and drift respect the environment-specific naming (FR25, FR26, FR27)
   - **And** databases are isolated per environment — no cross-contamination

4. **AC4 — Tree-shaking via kIsWeb**
   - **Given** `kIsWeb` is a compile-time constant
   - **When** building for a native platform, drift-related code is tree-shaken out
   - **And** when building for web, ObjectBox-related code is tree-shaken out

## Tasks / Subtasks

- [ ] Task 1: Refactor `bootstrap.dart` for platform-aware DI (AC: #1, #2, #3, #4)
  - [ ] 1.1 Change signature from `Future<void> bootstrap(FutureOr<Widget> Function() builder)` to `Future<void> bootstrap({required String dbName})`
  - [ ] 1.2 Move `WidgetsFlutterBinding.ensureInitialized()` into bootstrap (first line)
  - [ ] 1.3 Add `kIsWeb` branching: web → `AppDatabase.named(dbName)` + drift repositories; native → `ObjectBox.create(dbName)` + ObjectBox repositories
  - [ ] 1.4 Create `AppBloc` internally with the resolved repositories
  - [ ] 1.5 Pass `AppBloc` to `runApp()` inside existing `runZonedGuarded`
  - [ ] 1.6 Add all necessary imports for both datasource stacks
  - [ ] 1.7 Dartdoc on function, kIsWeb branching, and all changes
- [ ] Task 2: Simplify `main_development.dart` (AC: #3)
  - [ ] 2.1 Remove all ObjectBox/datasource/repository/model imports
  - [ ] 2.2 Remove global `late final ObjectBox objectbox;`
  - [ ] 2.3 Replace body with `Future<void> main() => bootstrap(dbName: 'test-1');`
  - [ ] 2.4 Update dartdoc
- [ ] Task 3: Simplify `main_staging.dart` (AC: #3)
  - [ ] 3.1 Same pattern as Task 2, with `bootstrap(dbName: 'stg-1')`
- [ ] Task 4: Simplify `main_production.dart` (AC: #3)
  - [ ] 4.1 Same pattern as Task 2, with `bootstrap(dbName: 'prod-1')`
- [ ] Task 5: Verification (AC: all)
  - [ ] 5.1 `flutter analyze` — zero issues on non-generated code
  - [ ] 5.2 `flutter test` — 157 tests pass, zero regressions
  - [ ] 5.3 Verify `app_bloc.dart` is UNCHANGED (already interface-based)

## Dev Notes

### Critical: What This Story IS and IS NOT

**IS:** DI wiring refactoring — connecting existing drift and ObjectBox implementations via `kIsWeb` platform detection. All datasources, repositories, models, use cases, and BLoCs already exist from Epics 1-4.3.

**IS NOT:** Creating any new datasource, repository, model, use case, or BLoC. Do NOT create new feature code.

### Current State of Target Files

**`bootstrap.dart`** — Current signature: `Future<void> bootstrap(FutureOr<Widget> Function() builder)`. Contains `AppBlocObserver` class + `bootstrap()` function. Does NOT handle platform detection or repository creation. Does NOT call `WidgetsFlutterBinding.ensureInitialized()` (that's in main_*.dart).

**`main_development.dart`** — Creates global `late final ObjectBox objectbox;`, initializes with `ObjectBox.create('test-1')`, creates `AppBloc` with ObjectBox repositories. No drift awareness.

**`main_staging.dart`** — Identical pattern to development with `ObjectBox.create('stg-1')`.

**`main_production.dart`** — Identical pattern to production with `ObjectBox.create('prod-1')`.

**`app_bloc.dart`** — Already receives `TimesRepository` and `WageRepository` interfaces as constructor params. Already wraps `MultiRepositoryProvider` + `UseCasesInjection.list()` + `MultiBlocProvider` + `BlocInjections.list()`. **NO CHANGES NEEDED.**

### Refactored bootstrap.dart Target Design

```dart
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:time_money/app/app.dart';
// ObjectBox imports
import 'package:time_money/src/core/services/objectbox_service.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
// Drift imports
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/repositories/drift_times_repository.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart';
// Domain interfaces
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';
```

**Key architectural decisions:**
- `kIsWeb` is available from `package:flutter/widgets.dart` (re-exports `foundation.dart`) — NO extra import needed
- `AppBlocObserver` class stays in `bootstrap.dart` (unchanged)
- `WidgetsFlutterBinding.ensureInitialized()` moves into `bootstrap()` as the first line
- ObjectBox creation is `async` (`await ObjectBox.create(dbName)`), AppDatabase creation is sync (`AppDatabase.named(dbName)`)
- Local variables hold `TimesRepository` and `WageRepository` interfaces
- `AppBloc` created inside bootstrap and passed to `runApp()`
- The global `late final ObjectBox objectbox;` in main_*.dart is **eliminated** — ObjectBox instance lives as a local variable inside bootstrap's closure (stays alive as long as `runZonedGuarded` runs)

### Refactored main_*.dart Target Design

Each entry point becomes a single-line delegation:
```dart
import 'package:time_money/bootstrap.dart';

/// Development entry point.
///
/// Bootstraps the app with the `test-1` database environment.
Future<void> main() => bootstrap(dbName: 'test-1');
```

### kIsWeb Import Clarification

The epics reference `dart:foundation` but this is NOT a valid Dart SDK library. The correct source is `package:flutter/foundation.dart`. However, `package:flutter/widgets.dart` (already imported in bootstrap.dart) re-exports `foundation.dart`, so `kIsWeb` is available without additional imports.

### Tree-Shaking Mechanics

`kIsWeb` is a compile-time constant. When building for web (`dart2js`/`dart2wasm`):
- `kIsWeb == true` → the `else` branch (ObjectBox code) becomes dead code → tree-shaken
- ObjectBox packages (`objectbox`, `objectbox_flutter_libs`) compile to JS/WASM but their runtime code is never reached
- `objectbox_flutter_libs` native binaries are simply absent on web builds

When building for native (AOT):
- `kIsWeb == false` → the `if (kIsWeb)` branch (drift code) becomes dead code → tree-shaken
- drift packages still compile but their code is eliminated from the binary

### Testing Strategy

**No new test files required.** Rationale:
- `bootstrap()` calls `runApp()` + `runZonedGuarded()` — not unit-testable without integration test infrastructure
- `kIsWeb` is a compile-time constant — cannot be mocked in unit tests
- The platform detection logic is a simple `if/else` — its correctness is verified by building and running the app
- All repository implementations are already tested (157 tests from Epics 1-4.3)
- `AppBloc` already receives interfaces — its DI wiring is tested by existing BLoC tests
- Verification: all 157 existing tests must pass with zero regressions

### Codebase State at Story Start

- 157 tests passing from Epics 1-4.3
- Drift infrastructure: `AppDatabase` with `TimesTable` + `WageHourlyTable` (story 4.1)
- Drift datasources: `TimesDriftDatasource`, `WageDriftDatasource` (stories 4.2, 4.3)
- Drift repositories: `DriftTimesRepository`, `DriftWageRepository` (stories 4.2, 4.3)
- ObjectBox datasources: `TimesObjectboxDatasource`, `WageObjectboxDatasource` (from Epic 2-3)
- ObjectBox repositories: `ObjectboxTimesRepository`, `ObjectboxWageRepository` (from Epic 2-3)
- Domain interfaces: `TimesRepository`, `WageRepository` (from Epic 2)
- Use case injections: `TimesUseCasesInjections`, `WageUseCasesInjections` (from Epic 2)
- BLoC injections: `TimesBlocs`, `WageBlocs`, `PaymentCubits` (from Epic 2-3)

### Anti-Patterns to AVOID

1. **Do NOT use GetIt, Injectable, or any service locator package** — project uses Flutter Bloc's native `context.read<T>()` and `RepositoryProvider/BlocProvider`
2. **Do NOT modify `app_bloc.dart`** — it already accepts repository interfaces. The AC "initializes in app_bloc.dart" refers to the fact that AppBloc IS the DI container (`MultiRepositoryProvider`), which is already correct.
3. **Do NOT modify any feature injection files** (`times_injection.dart`, `wage_injection.dart`, `bloc_injections.dart`, `use_cases_injection.dart`) — they resolve via `context.read<T>()` against the repository interfaces, platform-unaware by design
4. **Do NOT create new datasource, repository, model, or entity files** — all exist from previous stories
5. **Do NOT use `dart:io` conditional imports** — the architecture specifies `kIsWeb` directly. Conditional imports are unnecessary at this project scale
6. **Do NOT remove `AppBlocObserver`** from bootstrap.dart — it stays
7. **Do NOT use `import 'package:flutter/material.dart'`** in bootstrap.dart — use `package:flutter/widgets.dart` (current import, sufficient for `WidgetsFlutterBinding`)
8. **Do NOT add `import 'package:flutter/foundation.dart'`** — `kIsWeb` is available via the existing `package:flutter/widgets.dart` import

### Required Imports in Refactored bootstrap.dart

**Keep existing:**
- `dart:async` (for `FutureOr` — check if still needed after signature change; remove if unused)
- `dart:developer` (for `log`)
- `package:bloc/bloc.dart` (for `Bloc.observer`, `BlocObserver`)
- `package:flutter/widgets.dart` (for `WidgetsFlutterBinding`, `runApp`, `FlutterError`, `Widget` + gives `kIsWeb`)

**Add — App layer:**
- `package:time_money/app/app.dart` (for `AppBloc`)

**Add — ObjectBox stack:**
- `package:time_money/src/core/services/objectbox_service.dart`
- `package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart`
- `package:time_money/src/features/times/data/models/time_box.dart`
- `package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart`
- `package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart`
- `package:time_money/src/features/wage/data/models/wage_hourly_box.dart`
- `package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart`

**Add — Drift stack:**
- `package:time_money/src/core/services/app_database.dart`
- `package:time_money/src/features/times/data/datasources/times_drift_datasource.dart`
- `package:time_money/src/features/times/data/repositories/drift_times_repository.dart`
- `package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart`
- `package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart`

**Add — Domain interfaces:**
- `package:time_money/src/features/times/domain/repositories/times_repository.dart`
- `package:time_money/src/features/wage/domain/repositories/wage_repository.dart`

**Remove if unused after refactoring:**
- `dart:async` — check if `FutureOr` is still referenced (the old signature used it; new signature does not)

### Previous Story Intelligence

**From 4.3 (most recent):**
- Zero problems encountered — clean implementations following established patterns
- 18 code review findings all rejected (established patterns validated)
- `on Object catch (e)` is the project standard for error catching
- Dartdoc + `library;` + why-comments mandatory on all test files
- Zero linter tolerance enforced

**From 4.1/4.2:**
- `AppDatabase(NativeDatabase.memory())` for test in-memory databases — existing test infrastructure unaffected
- `AppDatabase.named(dbName)` for production databases — this is the constructor to use in bootstrap
- `ObjectBox.create(path)` for native databases — this is the method to use in bootstrap
- drift `watch()` emits immediately (no `triggerImmediately` flag)
- ObjectBox `watch(triggerImmediately: true)` must be explicit

### Functional Requirements Addressed

| FR | Description | How Addressed |
|-----|-------------|---------------|
| FR24 | Platform-aware datasource selection via kIsWeb in DI | `kIsWeb` branching in bootstrap.dart |
| FR25 | Development environment: test-1 database | `main_development.dart` → `bootstrap(dbName: 'test-1')` |
| FR26 | Staging environment: stg-1 database | `main_staging.dart` → `bootstrap(dbName: 'stg-1')` |
| FR27 | Production environment: prod-1 database | `main_production.dart` → `bootstrap(dbName: 'prod-1')` |
| FR28 | Local on-device persistence via ObjectBox and drift | Both stacks wired through DI |
| FR39 | Use cases created inline with context.read<T>() | Unchanged — `UseCasesInjection.list()` already does this |

### Project Structure Notes

- No new directories or files created
- No structural changes to feature folders
- Only `lib/bootstrap.dart` and `lib/main_*.dart` (4 files) modified
- `app_bloc.dart`, injection files, feature files all UNCHANGED
- File modifications are limited to the app initialization layer — no feature-level changes

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 4, Story 4.4]
- [Source: _bmad-output/planning-artifacts/architecture.md#Platform-Aware DI Pattern]
- [Source: _bmad-output/planning-artifacts/architecture.md#Multi-Environment Configuration]
- [Source: _bmad-output/planning-artifacts/architecture.md#Data Boundaries]
- [Source: _bmad-output/implementation-artifacts/4-1-drift-database-setup-core-infrastructure.md]
- [Source: _bmad-output/implementation-artifacts/4-2-times-feature-drift-datasource-repository-implementation.md]
- [Source: _bmad-output/implementation-artifacts/4-3-wage-feature-drift-datasource-repository-implementation.md]
- [Source: lib/bootstrap.dart — current bootstrap implementation]
- [Source: lib/main_development.dart — current dev entry point]
- [Source: lib/app/view/app_bloc.dart — current DI container]

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
