# Story 2.5: Shared Widgets Extraction & DI Cleanup

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to extract shared widgets to the shared module, remove the old presentation folder, and clean up DI to use explicit RepositoryProviders,
so that the codebase uses properly organized shared components and the DI tree is explicit and feature-first compliant (FR38, FR39).

## Acceptance Criteria

1. **Given** flutter_hooks was already removed in Story 1.1 (SDK migration pull-forward)
   **When** the codebase is verified
   **Then** no flutter_hooks references exist in pubspec.yaml, pubspec.lock, or any .dart file
   **And** all 5 former HookWidgets (CreateHourField, CreateMinutesField, UpdateHourField, UpdateMinutesField, WageHourlyField) are already StatefulWidgets
   **Note:** AC1 from epics is pre-satisfied — Story 1.1 converted all HookWidgets to StatefulWidget and removed flutter_hooks. This story only verifies, no work needed.

2. **Given** widgets used by multiple features (CatchErrorBuilder, ErrorView, ShowInfoSection, IconText) live in `lib/src/presentation/widgets/`
   **When** shared widgets are extracted
   **Then** `lib/src/shared/widgets/catch_error_builder.dart` contains CatchErrorBuilder
   **And** `lib/src/shared/widgets/info_section.dart` contains ShowInfoSection
   **And** `lib/src/shared/widgets/icon_text.dart` contains IconText (extracted from info_section.dart)
   **And** `lib/src/shared/widgets/error_view.dart` contains ErrorView
   **And** `lib/src/shared/widgets/widgets.dart` is the barrel export for all shared widgets
   **And** `lib/src/presentation/` folder is deleted entirely (no orphaned files)

3. **Given** `CustomCard` (with `HourField`, `MinutesField`) in `presentation/widgets/custom_card.dart` is dead code
   **When** the old presentation folder is cleaned up
   **Then** `custom_card.dart` is deleted (no feature imports it — times feature uses its own CreateTimeCard/UpdateTimeCard)

4. **Given** DI wiring uses `InjectionRepositories` wrapper class
   **When** the DI setup is updated to use explicit RepositoryProviders
   **Then** `AppBloc` accepts `TimesRepository` and `WageRepository` as separate constructor parameters
   **And** `MultiRepositoryProvider` registers repositories via `RepositoryProvider<TimesRepository>.value()` and `RepositoryProvider<WageRepository>.value()`
   **And** use case injections resolve repositories via `context.read<TimesRepository>()` instead of `injection.timesRepository`
   **And** `InjectionRepositories` class is deleted
   **And** `UseCasesInjection.list()` no longer takes an `InjectionRepositories` parameter
   **And** `context.read<T>()` is used for all dependency resolution
   **And** `context.watch<T>()` is NEVER used for DI resolution — only `context.read<T>()`

5. **Given** all restructuring is complete
   **When** the full app is compiled and exercised
   **Then** all features work identically to pre-restructure behavior
   **And** `flutter analyze` produces zero warnings on the entire codebase
   **And** `flutter test` passes all 23 existing tests
   **And** no orphaned files or imports remain from the old structure

## Tasks / Subtasks

- [x] Task 1: Create shared/widgets/ and move widgets (AC: #2, #3)
  - [x] 1.1 Create `lib/src/shared/widgets/` directory
  - [x] 1.2 Move `presentation/widgets/catch_error_builder.dart` → `shared/widgets/catch_error_builder.dart` (no changes needed — pure Flutter, no internal imports)
  - [x] 1.3 Move `presentation/widgets/info_section.dart` → `shared/widgets/info_section.dart` — but REMOVE the `IconText` class from this file
  - [x] 1.4 Create `shared/widgets/icon_text.dart` — extract `IconText` class from `info_section.dart` into its own file
  - [x] 1.5 Move `presentation/widgets/views/error_view.dart` → `shared/widgets/error_view.dart` — update internal import from `presentation/widgets/info_section.dart` to `shared/widgets/info_section.dart`
  - [x] 1.6 Create `shared/widgets/widgets.dart` barrel — exports all 4 widget files
  - [x] 1.7 Delete `custom_card.dart` (dead code — verified: zero feature imports)

- [x] Task 2: Update all cross-codebase imports (AC: #2) — apply Pattern 1 from "Exhaustive Import Update Checklist" below to all 6 feature files

- [x] Task 3: Delete old presentation folder (AC: #2, #3)
  - [x] 3.1 Delete entire `lib/src/presentation/` folder tree (widgets.dart barrel, catch_error_builder.dart, custom_card.dart, info_section.dart, views/error_view.dart)
  - [x] 3.2 Verify `lib/src/presentation/` no longer exists

- [x] Task 4: Restructure DI to explicit RepositoryProviders (AC: #4)
  - [x] 4.1 Update `lib/app/view/app_bloc.dart` — replace `InjectionRepositories injection` with `TimesRepository timesRepository` + `WageRepository wageHourlyRepository`. Add `RepositoryProvider<TimesRepository>.value(value: timesRepository)` and `RepositoryProvider<WageRepository>.value(value: wageHourlyRepository)` to `MultiRepositoryProvider.providers` list before use case providers. Change `UseCasesInjection.list(injection)` → `UseCasesInjection.list()`
  - [x] 4.2 Update `lib/src/shared/injections/use_cases_injection.dart` — remove `InjectionRepositories` parameter from `list()`. Keep delegating to feature-specific injections but without passing injection object.
  - [x] 4.3 Update `lib/src/features/times/times_injection.dart` — remove `InjectionRepositories` parameter. Use case creation uses `context.read<TimesRepository>()` instead of `injection.timesRepository`
  - [x] 4.4 Update `lib/src/features/wage/wage_injection.dart` — remove `InjectionRepositories` parameter. Use case creation uses `context.read<WageRepository>()` instead of `injection.wageHourlyRepository`
  - [x] 4.5 Delete `lib/src/shared/injections/injection_repositories.dart`
  - [x] 4.6 Update all 3 `main_*.dart` entry points — replace `InjectionRepositories(...)` with direct repository parameters to `AppBloc`

- [x] Task 5: Build & verify (AC: #1, #5)
  - [x] 5.1 Run `flutter analyze` — zero issues on ALL project files
  - [x] 5.2 Run `flutter test` — all 23 existing tests pass
  - [x] 5.3 Run `flutter build apk --debug --flavor development -t lib/main_development.dart` — app compiles

## Dev Notes

### Critical: AC1 Is Pre-Satisfied (flutter_hooks Already Removed)

Story 1.1 (SDK migration) pulled forward the flutter_hooks removal because there was no Dart 3 compatible version. All 5 HookWidgets were converted to StatefulWidget in Story 1.1. The Epic 1 retrospective explicitly confirms: "flutter_hooks already removed (pull-forward from Story 1.1)".

**Verification only — do NOT attempt to convert widgets or remove pubspec entries. It's already done.**

Current state of the 5 formerly-HookWidget files (all are StatefulWidget):
- `lib/src/features/times/presentation/widgets/create_hour_field.dart`
- `lib/src/features/times/presentation/widgets/create_minutes_field.dart`
- `lib/src/features/times/presentation/widgets/update_hour_field.dart`
- `lib/src/features/times/presentation/widgets/update_minutes_field.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_field.dart`

### Scope Boundaries

**IN SCOPE (Story 2.5):**
- Move shared widgets from `presentation/widgets/` → `shared/widgets/`
- Extract `IconText` class into its own file
- Delete dead code `custom_card.dart` (CustomCard, HourField, MinutesField)
- Delete entire `lib/src/presentation/` folder
- Update all 6 feature file imports
- Restructure DI: replace `InjectionRepositories` with explicit `RepositoryProvider<TimesRepository>` and `RepositoryProvider<WageRepository>`
- Update use case injections to resolve repos via `context.read<T>()`
- Update all 3 entry points (`main_development.dart`, `main_staging.dart`, `main_production.dart`)
- Create shared/widgets barrel export
- Zero `flutter analyze` warnings

**OUT OF SCOPE (do NOT do these):**
- Do NOT convert Freezed to sealed classes — that's Epic 3
- Do NOT modify BLoC/Cubit logic or state management patterns
- Do NOT add drift datasource — that's Epic 4
- Do NOT add platform-aware DI (`kIsWeb` branching) — that's Epic 4
- Do NOT write new tests — tests come in Epic 3/5
- Do NOT resolve the cross-feature dependency where times/wage data views call `PaymentCubit.setList()`/`setWage()` — Epic 3
- Do NOT fix the no-op BlocConsumer listeners — Epic 3
- Do NOT fix hardcoded strings or localization — Epic 4
- Do NOT touch the bootstrap.dart file

### CustomCard Is Dead Code — DELETE It

`custom_card.dart` contains `CustomCard`, `HourField`, and `MinutesField`. These are OLD widgets superseded by the feature-specific StatefulWidget fields:
- `CreateHourField` / `CreateMinutesField` (in times feature)
- `UpdateHourField` / `UpdateMinutesField` (in times feature)
- `WageHourlyField` (in wage feature)

Verified: ZERO imports of `CustomCard`, `HourField`, or `MinutesField` from `custom_card.dart` exist in any feature file. The barrel `widgets.dart` exports it, but no consumer uses it.

### CatchErrorBuilder Must Move to shared/widgets/

The epics AC only lists 3 files for `shared/widgets/` (error_view, info_section, icon_text), but `CatchErrorBuilder` is used by BOTH times and wage features:
- `times/presentation/widgets/list_times_data_view.dart` — uses `CatchErrorBuilder`
- `wage/presentation/widgets/wage_hourly_data_view.dart` — uses `CatchErrorBuilder`

Since `lib/src/presentation/` is being deleted entirely, `CatchErrorBuilder` MUST move to `shared/widgets/`. The epics AC is incomplete on this point.

### IconText Extraction

`IconText` is currently defined in `info_section.dart` alongside `ShowInfoSection`. Per the epics AC, it should be in its own file `icon_text.dart`. Extract it — the class has no dependencies on `ShowInfoSection` and is independently used (e.g., `ErrorView` uses both `ShowInfoSection` and `IconText` but as separate widgets).

After extraction, `info_section.dart` contains ONLY `ShowInfoSection`. `icon_text.dart` contains ONLY `IconText`.

### Target Shared/Widgets Structure

```
lib/src/shared/widgets/
├── widgets.dart                    ← barrel (exports all 4)
├── catch_error_builder.dart        ← from presentation/widgets/
├── error_view.dart                 ← from presentation/widgets/views/
├── icon_text.dart                  ← extracted from info_section.dart
└── info_section.dart               ← from presentation/widgets/ (IconText removed)
```

### Barrel Export Contents

```dart
// shared/widgets/widgets.dart
export 'catch_error_builder.dart';
export 'error_view.dart';
export 'icon_text.dart';
export 'info_section.dart';
```

### error_view.dart Internal Import Update

`error_view.dart` currently imports `ShowInfoSection` and `IconText` via:
```dart
import 'package:time_money/src/presentation/widgets/info_section.dart';
```
After move, this MUST change to use the barrel:
```dart
import 'package:time_money/src/shared/widgets/widgets.dart';
```
Or import the specific files:
```dart
import 'package:time_money/src/shared/widgets/icon_text.dart';
import 'package:time_money/src/shared/widgets/info_section.dart';
```
Use the barrel approach for consistency.

### Exhaustive Import Update Checklist

**Pattern 1: `presentation/widgets/widgets.dart` → `shared/widgets/widgets.dart` (6 feature files):**

1. `lib/src/features/times/presentation/widgets/list_times_data_view.dart`
2. `lib/src/features/times/presentation/widgets/list_times_other_view.dart`
3. `lib/src/features/times/presentation/widgets/error_list_times_view.dart`
4. `lib/src/features/wage/presentation/widgets/wage_hourly_data_view.dart`
5. `lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart`
6. `lib/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart`

**Exact import diff for all 6 files:**
```diff
- import 'package:time_money/src/presentation/widgets/widgets.dart';
+ import 'package:time_money/src/shared/widgets/widgets.dart';
```

**Pattern 2: error_view.dart internal import (1 file — the moving file itself):**
```diff
- import 'package:time_money/src/presentation/widgets/info_section.dart';
+ import 'package:time_money/src/shared/widgets/widgets.dart';
```

**Pattern 3: DI files — InjectionRepositories removal:**
- `lib/app/view/app_bloc.dart` — remove `InjectionRepositories` import, add `TimesRepository` + `WageRepository` imports
- `lib/src/shared/injections/use_cases_injection.dart` — remove `InjectionRepositories` import
- `lib/src/features/times/times_injection.dart` — remove `InjectionRepositories` import, add `TimesRepository` import
- `lib/src/features/wage/wage_injection.dart` — remove `InjectionRepositories` import, add `WageRepository` import
- `lib/main_development.dart` — remove `InjectionRepositories` import
- `lib/main_staging.dart` — remove `InjectionRepositories` import
- `lib/main_production.dart` — remove `InjectionRepositories` import

### DI Restructure Details

**Current DI flow:**
```
main_*.dart → InjectionRepositories(timesRepo, wageRepo) → AppBloc(injection)
  → MultiRepositoryProvider(UseCasesInjection.list(injection))  // use cases
    → MultiBlocProvider(BlocInjections.list())                   // blocs
      → App()
```

**Target DI flow:**
```
main_*.dart → AppBloc(timesRepository, wageHourlyRepository)
  → MultiRepositoryProvider([
      RepositoryProvider<TimesRepository>.value(value: timesRepository),
      RepositoryProvider<WageRepository>.value(value: wageHourlyRepository),
      ...UseCasesInjection.list(),  // use cases resolve repos via context.read
    ])
    → MultiBlocProvider(BlocInjections.list())  // blocs resolve use cases via context.read
      → App()
```

**AppBloc — before:**
```dart
class AppBloc extends StatelessWidget {
  const AppBloc({required this.injection, super.key});
  final InjectionRepositories injection;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: UseCasesInjection.list(injection),
      child: MultiBlocProvider(
        providers: BlocInjections.list(),
        child: const App(),
      ),
    );
  }
}
```

**AppBloc — after:**
```dart
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class AppBloc extends StatelessWidget {
  const AppBloc({
    required this.timesRepository,
    required this.wageHourlyRepository,
    super.key,
  });
  final TimesRepository timesRepository;
  final WageRepository wageHourlyRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TimesRepository>.value(value: timesRepository),
        RepositoryProvider<WageRepository>.value(value: wageHourlyRepository),
        ...UseCasesInjection.list(),
      ],
      child: MultiBlocProvider(
        providers: BlocInjections.list(),
        child: const App(),
      ),
    );
  }
}
```

**UseCasesInjection — before:**
```dart
class UseCasesInjection {
  static List<RepositoryProvider<Object>> list(InjectionRepositories injection) => [
    ...TimesUseCasesInjections.list(injection),
    ...WageUseCasesInjections.list(injection),
  ];
}
```

**UseCasesInjection — after:**
```dart
class UseCasesInjection {
  static List<RepositoryProvider<Object>> list() => [
    ...TimesUseCasesInjections.list(),
    ...WageUseCasesInjections.list(),
  ];
}
```

**TimesUseCasesInjections — before:**
```dart
class TimesUseCasesInjections {
  static List<RepositoryProvider<Object>> list(InjectionRepositories injection) => [
    RepositoryProvider<ListTimesUseCase>(
      create: (context) => ListTimesUseCase(injection.timesRepository),
    ),
    RepositoryProvider<CreateTimeUseCase>(
      create: (context) => CreateTimeUseCase(injection.timesRepository),
    ),
    RepositoryProvider<DeleteTimeUseCase>(
      create: (context) => DeleteTimeUseCase(injection.timesRepository),
    ),
    RepositoryProvider<UpdateTimeUseCase>(
      create: (context) => UpdateTimeUseCase(injection.timesRepository),
    ),
  ];
}
```

**TimesUseCasesInjections — after:**
```dart
class TimesUseCasesInjections {
  static List<RepositoryProvider<Object>> list() => [
    RepositoryProvider<ListTimesUseCase>(
      create: (context) => ListTimesUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<CreateTimeUseCase>(
      create: (context) => CreateTimeUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<DeleteTimeUseCase>(
      create: (context) => DeleteTimeUseCase(context.read<TimesRepository>()),
    ),
    RepositoryProvider<UpdateTimeUseCase>(
      create: (context) => UpdateTimeUseCase(context.read<TimesRepository>()),
    ),
  ];
}
```

**WageUseCasesInjections — before:**
```dart
class WageUseCasesInjections {
  static List<RepositoryProvider<Object>> list(InjectionRepositories injection) => [
    RepositoryProvider<FetchWageUseCase>(
      create: (context) => FetchWageUseCase(injection.wageHourlyRepository),
    ),
    RepositoryProvider<SetWageUseCase>(
      create: (context) => SetWageUseCase(injection.wageHourlyRepository),
    ),
    RepositoryProvider<UpdateWageUseCase>(
      create: (context) => UpdateWageUseCase(injection.wageHourlyRepository),
    ),
  ];
}
```

**WageUseCasesInjections — after:**
```dart
class WageUseCasesInjections {
  static List<RepositoryProvider<Object>> list() => [
    RepositoryProvider<FetchWageUseCase>(
      create: (context) => FetchWageUseCase(context.read<WageRepository>()),
    ),
    RepositoryProvider<SetWageUseCase>(
      create: (context) => SetWageUseCase(context.read<WageRepository>()),
    ),
    RepositoryProvider<UpdateWageUseCase>(
      create: (context) => UpdateWageUseCase(context.read<WageRepository>()),
    ),
  ];
}
```

**main_development.dart — before:**
```dart
await bootstrap(
  () => AppBloc(
    injection: InjectionRepositories(
      timesRepository: ObjectboxTimesRepository(...),
      wageHourlyRepository: ObjectboxWageRepository(...),
    ),
  ),
);
```

**main_development.dart — after:**
```dart
await bootstrap(
  () => AppBloc(
    timesRepository: ObjectboxTimesRepository(...),
    wageHourlyRepository: ObjectboxWageRepository(...),
  ),
);
```

### CRITICAL WARNINGS

**W1: `error_view.dart` uses Freezed `.when()` method on `GlobalDefaultFailure`.**
`failure.when(internalError: ..., timeOutExceeded: ..., serverError: ..., notConnection: ...)` — this is the Freezed pattern matching. Do NOT change this — it will be migrated to sealed class `switch` in Epic 3 when `GlobalFailure` becomes a sealed class.

**W2: Hardcoded Spanish strings in `error_view.dart`.**
Strings like `'Hubo un error interno...'`, `'Se agotó el tiempo de espera'` are hardcoded in Spanish. Pre-existing technical debt. Do NOT fix — localization is Epic 4 scope.

**W3: `'Hubor'` typo in `error_view.dart`.**
`'Hubor un error en el servidor'` should be `'Hubo'`. Pre-existing typo. Do NOT fix — will be resolved with localization strings in Epic 4.

**W4: RepositoryProvider ordering matters.**
`RepositoryProvider<TimesRepository>` and `RepositoryProvider<WageRepository>` MUST appear BEFORE use case providers in the `MultiRepositoryProvider.providers` list. Use cases resolve repos via `context.read<T>()` which requires the repo to already be registered above in the widget tree. If ordering is wrong, `ProviderNotFoundException` will crash the app at startup.

**W5: No test files reference `presentation/widgets/` or `InjectionRepositories`.**
Verified: no files under `test/` import from `presentation/widgets/` or `injection_repositories.dart`. The 23 existing tests are in `core/` and don't touch shared widgets or DI.

**W6: `RepositoryProvider.value()` vs `RepositoryProvider(create:)`**
Use `.value()` for repositories because they are already created externally (in `main_*.dart`). Using `create:` would work too but `.value()` is more explicit and avoids unnecessary lambda wrapping. Note: `RepositoryProvider.value()` is provided by the `flutter_bloc` package — already imported in `app_bloc.dart`, no new import needed.

### Key Differences from Stories 2.2/2.3/2.4

Smallest story in Epic 2: ~5 moved files, ~6 import updates, ~8 DI file changes. No new domain code, no Freezed classes, no build_runner needed. No entities, repositories, or BLoCs created/renamed. Two concerns: widget relocation + DI cleanup.

### Execution Order

**Recommended sequence to minimize broken state:**
1. Create `shared/widgets/` directory
2. Create `icon_text.dart` (extract from `info_section.dart`)
3. Move `catch_error_builder.dart` to `shared/widgets/`
4. Move `info_section.dart` to `shared/widgets/` (with `IconText` removed)
5. Move `error_view.dart` to `shared/widgets/` (update internal import)
6. Create `shared/widgets/widgets.dart` barrel
7. Update all 6 feature file imports (Pattern 1)
8. Delete `lib/src/presentation/` entirely
9. Update DI: `AppBloc` constructor (repos as separate params, RepositoryProvider.value)
10. Update DI: `UseCasesInjection.list()` → no param
11. Update DI: `TimesUseCasesInjections.list()` → `context.read<TimesRepository>()`
12. Update DI: `WageUseCasesInjections.list()` → `context.read<WageRepository>()`
13. Update all 3 `main_*.dart` entry points
14. Delete `injection_repositories.dart`
15. Run `flutter analyze` — fix any issues
16. Run `flutter test`
17. Run `flutter build apk`

### Architecture Compliance

Same rules as all Epic 2 stories:
- Absolute imports only (`package:time_money/src/...`)
- VGA 10.x import order (dart:, package:, project)
- `const` constructors wherever possible
- Barrel files with re-exports only
- No `.freezed.dart` in barrel files

### Import Boundary Compliance After Story 2.5

| Feature | Can Import From | Cannot Import From |
|---------|----------------|-------------------|
| `times` | `core/`, `shared/` | `wage/`, `payment/`, `home/` |
| `wage` | `core/`, `shared/` | `times/`, `payment/`, `home/` |
| `payment` | `core/`, `shared/`, `times/domain/entities/`, `wage/domain/entities/` | `times/data/`, `wage/data/`, `home/` |
| `home` | `core/`, `shared/`, all features' `presentation/` | any feature's `data/` or `domain/` directly |

**After Story 2.5:** both times and wage import shared widgets from `shared/widgets/widgets.dart` ✅. No more `presentation/widgets/` path exists.

### Project Structure Notes

After this story, `lib/src/` has the clean target structure as shown in "Target Shared/Widgets Structure" above, plus `shared/injections/` updated (no `InjectionRepositories` param in `use_cases_injection.dart`, `injection_repositories.dart` deleted).

**Deleted:** `lib/src/presentation/` folder (entire tree), `lib/src/shared/injections/injection_repositories.dart`

The `lib/src/presentation/` folder no longer exists. All UI components are either in `features/{name}/presentation/` or `shared/widgets/`.

### Previous Story Intelligence

**From Story 2.4 (most recent):**
- Feature-first restructure pattern fully validated across 4 features
- Zero-issue linting maintained through all Epic 2 stories
- 23 core tests: `failures_test.dart` (12 tests), `action_state_test.dart` (11 tests) — must still pass
- Import update pattern confirmed: search for old path, replace with new path, verify zero references remain
- Barrel export pattern: re-exports only, no `.freezed.dart`

**From Epic 1 Retrospective:**
- flutter_hooks was removed in Story 1.1 as a pull-forward — no Dart 3 compatible version existed
- Story 2.5 scope was explicitly noted as reduced: "Story 2.5 scope adjustment (flutter_hooks already removed)"

**Pre-Existing Technical Debt (do NOT fix, just be aware):**
- D-1: TextEditingController not synced with bloc state in WageHourlyField (Epic 3)
- D-2: BlocConsumer listener is no-op in multiple widgets (Epic 3)
- D-3: _ActionWidget in FetchWageScreen/ListTimesScreen is dead code placeholder (Epic 3)
- D-4: DeleteTimeBloc `.fold()` result not emitted — CRITICAL LOGIC BUG (Epic 3 Story 3.3)
- D-5: CreateTimeEvent `_Reset` missing handler (Epic 3 Story 3.2)
- D-7: Cross-feature `times/wage → payment` import violation (Epic 3)

### Git Intelligence

**Recent Commits:**
```
c98dff6 chore: code review passed for story 2.4
0c77e76 refactor: restructure payment & home features to feature-first clean architecture layout
5ab8594 docs: validate story 2.4
8ea9e36 docs: create story 2.4 payment & home features feature-first restructure
849124b chore: code review passed for story 2.3
```

**Commit message convention:** `type: description` — use `refactor:` for this story since it's architecture restructuring.

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 2, Story 2.5]
- [Source: _bmad-output/planning-artifacts/architecture.md — Section 3: Frontend Architecture, Section 5: Feature Import Boundaries, DI Pattern]
- [Source: _bmad-output/planning-artifacts/prd.md — FR38, FR39]
- [Source: _bmad-output/implementation-artifacts/2-4-payment-home-features-feature-first-restructure.md — Story 2.4 learnings]
- [Source: _bmad-output/implementation-artifacts/1-1-sdk-constraint-flutter-dart-version-migration.md — flutter_hooks removal confirmation]
- [Source: _bmad-output/implementation-artifacts/epic-1-retro-2026-03-18.md — scope adjustment confirmation]
- [Source: _bmad-output/project-context.md — Rules 1-43]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- `flutter analyze` — zero issues (ran in 2.8s)
- `flutter test` — 23/23 tests passed
- `flutter build apk --debug --flavor development` — built successfully (5.9s)

### Completion Notes List

- AC1 verified: zero `flutter_hooks` references in pubspec.yaml, pubspec.lock, or any .dart file
- AC2 completed: 4 shared widgets extracted to `lib/src/shared/widgets/` with barrel export; `IconText` extracted from `info_section.dart` into own file; `error_view.dart` import updated to use shared barrel; all 6 feature file imports updated from `presentation/widgets/widgets.dart` → `shared/widgets/widgets.dart`
- AC3 completed: `custom_card.dart` (dead code) deleted along with entire `lib/src/presentation/` folder
- AC4 completed: `InjectionRepositories` class deleted; `AppBloc` now accepts `TimesRepository` + `WageRepository` as separate constructor params; `RepositoryProvider.value()` used for both repos in `MultiRepositoryProvider`; use case injections resolve via `context.read<T>()`; `UseCasesInjection.list()` takes no params; `context.watch<T>()` not used anywhere for DI
- AC5 completed: `flutter analyze` zero warnings, `flutter test` 23/23 pass, `flutter build apk` compiles, zero orphaned imports

### Code Review Record

- 2026-03-18: 3-layer adversarial review (Blind Hunter, Edge Case Hunter, Acceptance Auditor)
  - Acceptance Auditor: **PASS** — all ACs 1–5 satisfied, W4 ordering correct, zero analyze warnings, 23 tests pass
  - 1 patch applied: `main_production.dart` import aligned to barrel (`app/app.dart`) matching dev/staging
  - 7 findings deferred: DI ordering runtime risk (W4 by-design), 3× main_*.dart duplication (pre-existing), error_view circular barrel (spec-mandated), IconText input edge cases (pre-existing), testability trade-off (Epic 5 scope)
  - 6 findings rejected as noise

### Change Log

- 2026-03-18: Story 2.5 implemented — shared widgets extraction and DI cleanup
- 2026-03-18: Code review passed — patch P1 applied (main_production.dart barrel import), story done

### File List

**New files:**
- lib/src/shared/widgets/catch_error_builder.dart
- lib/src/shared/widgets/info_section.dart
- lib/src/shared/widgets/icon_text.dart
- lib/src/shared/widgets/error_view.dart
- lib/src/shared/widgets/widgets.dart

**Modified files:**
- lib/app/view/app_bloc.dart
- lib/src/shared/injections/use_cases_injection.dart
- lib/src/features/times/times_injection.dart
- lib/src/features/wage/wage_injection.dart
- lib/main_development.dart
- lib/main_staging.dart
- lib/main_production.dart
- lib/src/features/times/presentation/widgets/list_times_data_view.dart
- lib/src/features/times/presentation/widgets/list_times_other_view.dart
- lib/src/features/times/presentation/widgets/error_list_times_view.dart
- lib/src/features/wage/presentation/widgets/wage_hourly_data_view.dart
- lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart
- lib/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart

**Deleted files:**
- lib/src/presentation/ (entire folder: widgets.dart, catch_error_builder.dart, custom_card.dart, info_section.dart, views/error_view.dart)
- lib/src/shared/injections/injection_repositories.dart
