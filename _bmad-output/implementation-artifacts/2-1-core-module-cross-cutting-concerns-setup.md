# Story 2.1: Core Module & Cross-Cutting Concerns Setup

Status: ready-for-dev

## Story

As a developer,
I want to establish the core module with all shared cross-cutting concerns in their correct locations,
so that all features have a stable foundation of shared utilities, error types, and services to depend on (FR38).

## Acceptance Criteria

1. **Given** cross-cutting concerns are scattered across the existing codebase
   **When** the core module is reorganized at `lib/src/core/`
   **Then** `core/errors/failures.dart` contains GlobalFailure and ValueFailure classes
   **And** `core/services/objectbox_service.dart` contains the ObjectBox Store wrapper
   **And** `core/services/app_database.dart` exists as a placeholder for drift (Epic 4)
   **And** `core/ui/action_state.dart` contains the ActionState class
   **And** `core/constants/app_durations.dart` contains timing constants
   **And** `core/extensions/screen_size.dart` contains context extensions

2. **Given** the core module is established
   **When** barrel export files are created for each subfolder
   **Then** each subfolder has a barrel file named `{folder_name}.dart`
   **And** barrel files only re-export — no logic or classes defined within them
   **And** no circular exports exist between barrel files (NFR10)

3. **Given** the core module structure
   **When** `flutter analyze` is run
   **Then** zero warnings are produced on ALL project files
   **And** all imports use absolute paths (`package:time_money/src/core/...`)

4. **Given** the core module tests
   **When** `flutter test` is run
   **Then** core module unit tests pass for failures and action_state

## Tasks / Subtasks

- [ ] Task 1: Reorganize core/errors/ (AC: #1)
  - [ ] 1.1 Create `lib/src/core/errors/` folder
  - [ ] 1.2 Move `core/failures/failures.dart` → `core/errors/failures.dart`
  - [ ] 1.3 Move `core/failures/failures.freezed.dart` → `core/errors/failures.freezed.dart`
  - [ ] 1.4 Delete empty `core/failures/` folder
  - [ ] 1.5 Verify `part 'failures.freezed.dart'` directive is unchanged (relative path stays valid since both files move together)
  - [ ] 1.6 Update ALL 14 imports referencing `core/failures/failures.dart` → `core/errors/failures.dart`

- [ ] Task 2: Reorganize core/ui/ (AC: #1)
  - [ ] 2.1 Create `lib/src/core/ui/` folder
  - [ ] 2.2 Move `core/unions/action_state.dart` → `core/ui/action_state.dart`
  - [ ] 2.3 Move `core/unions/action_state.freezed.dart` → `core/ui/action_state.freezed.dart`
  - [ ] 2.4 Delete empty `core/unions/` folder
  - [ ] 2.5 Verify `part 'action_state.freezed.dart'` directive is unchanged (relative path stays valid since both files move together)
  - [ ] 2.6 Update import inside action_state.dart from `core/failures/failures.dart` → `core/errors/failures.dart`
  - [ ] 2.7 Update ALL 6 imports referencing `core/unions/action_state.dart` → `core/ui/action_state.dart`

- [ ] Task 3: Reorganize core/services/ (AC: #1)
  - [ ] 3.1 Rename `core/services/objectbox.dart` → `core/services/objectbox_service.dart`
  - [ ] 3.2 Update ALL 5 imports referencing `core/services/objectbox.dart` → `core/services/objectbox_service.dart`
  - [ ] 3.3 Create `core/services/app_database.dart` as drift placeholder

- [ ] Task 4: Create core/constants/ (AC: #1)
  - [ ] 4.1 Create `lib/src/core/constants/` folder
  - [ ] 4.2 Create `core/constants/app_durations.dart` with `abstract final class AppDurations` containing `actionFeedback = Duration(milliseconds: 400)`
  - [ ] 4.3 Move `core/break_points.dart` → `core/constants/break_points.dart`
  - [ ] 4.4 Update the 1 import referencing `core/break_points.dart` → `core/constants/break_points.dart` (in screen_size.dart)
  - [ ] 4.5 Update import inside `break_points.dart` from `core/screen_type.dart` → `core/extensions/screen_type.dart` (cross-dependency with Task 5)
  - [ ] 4.6 Update ALL 8 references to `Consts.delayed` across BLoC files (4) and widget files (4) — see Consts.delayed Replacement Patterns section below — and update imports from `shared/consts/consts.dart` → `core/constants/app_durations.dart`
  - [ ] 4.7 Delete `shared/consts/consts.dart` after migration (delete `shared/consts/` folder — it will be empty)

- [ ] Task 5: Reorganize core/extensions/ (AC: #1)
  - [ ] 5.1 Move `core/screen_type.dart` → `core/extensions/screen_type.dart`
  - [ ] 5.2 Update ALL 2 imports referencing `core/screen_type.dart` → `core/extensions/screen_type.dart` (in screen_size.dart and break_points.dart — note: break_points.dart was already handled in Task 4.5)
  - [ ] 5.3 Update BOTH imports in `screen_size.dart`: `core/break_points.dart` → `core/constants/break_points.dart` AND `core/screen_type.dart` → `core/extensions/screen_type.dart`
  - [ ] 5.4 Verify `declarative_bool.dart` already in correct location

- [ ] Task 6: Create barrel exports (AC: #2)
  - [ ] 6.1 Create `core/errors/errors.dart` — re-exports failures.dart
  - [ ] 6.2 Create `core/services/services.dart` — re-exports objectbox_service.dart, app_database.dart
  - [ ] 6.3 Create `core/ui/ui.dart` — re-exports action_state.dart
  - [ ] 6.4 Create `core/constants/constants.dart` — re-exports app_durations.dart, break_points.dart
  - [ ] 6.5 Create `core/extensions/extensions.dart` — re-exports screen_size.dart, screen_type.dart, declarative_bool.dart

- [ ] Task 7: Run `build_runner` to regenerate (AC: #3)
  - [ ] 7.1 Run `dart run build_runner build --delete-conflicting-outputs`
  - [ ] 7.2 Verify generated files appear in new locations (core/errors/, core/ui/)

- [ ] Task 8: Verify zero warnings (AC: #3)
  - [ ] 8.1 Run `flutter analyze` — must produce zero warnings
  - [ ] 8.2 Fix any remaining import issues across the entire codebase

- [ ] Task 9: Write core module tests (AC: #4)
  - [ ] 9.1 Create `test/src/core/errors/failures_test.dart`
  - [ ] 9.2 Create `test/src/core/ui/action_state_test.dart`
  - [ ] 9.3 Run `flutter test` — all tests pass

- [ ] Task 10: Build verification (AC: #1, #3)
  - [ ] 10.1 Run `flutter build apk --debug --flavor development -t lib/main_development.dart`
  - [ ] 10.2 Verify the app compiles without errors

## Dev Notes

### Critical: Scope Boundaries

**IN SCOPE (Story 2.1):**
- Reorganize core/ folder structure (rename folders, move files)
- Create drift placeholder file
- Create AppDurations constants class
- Create barrel exports for all core/ subfolders
- Update ALL imports across the entire codebase
- Write unit tests for core/errors and core/ui
- Zero `flutter analyze` warnings

**OUT OF SCOPE (do NOT do these):**
- Do NOT convert Freezed unions to sealed classes — that's Epic 3, Story 3.1
- Do NOT decompose ObjectBox business logic into feature datasources — that's Stories 2.2/2.3
- Do NOT restructure features/ folder — that's Stories 2.2-2.4
- Do NOT move shared/injections/ — that's Story 2.5
- Do NOT move presentation/ widgets — that's Stories 2.2-2.5
- Do NOT create or modify shared/widgets/ — that's Story 2.5
- Do NOT touch any .arb localization files
- Do NOT modify any BLoC logic or state management

### Current → Target File Mapping

| Current Path | Target Path | Action |
|---|---|---|
| `core/failures/failures.dart` | `core/errors/failures.dart` | Move (rename folder) |
| `core/failures/failures.freezed.dart` | `core/errors/failures.freezed.dart` | Move with source |
| `core/unions/action_state.dart` | `core/ui/action_state.dart` | Move (rename folder) |
| `core/unions/action_state.freezed.dart` | `core/ui/action_state.freezed.dart` | Move with source |
| `core/services/objectbox.dart` | `core/services/objectbox_service.dart` | Rename file |
| `core/break_points.dart` | `core/constants/break_points.dart` | Move to constants/ |
| `core/screen_type.dart` | `core/extensions/screen_type.dart` | Move to extensions/ |
| `core/extensions/screen_size.dart` | `core/extensions/screen_size.dart` | Already correct |
| `core/extensions/declarative_bool.dart` | `core/extensions/declarative_bool.dart` | Already correct |
| `shared/consts/consts.dart` | `core/constants/app_durations.dart` | Replace with new class |
| NEW | `core/services/app_database.dart` | Create placeholder |
| NEW | `core/errors/errors.dart` | Create barrel |
| NEW | `core/services/services.dart` | Create barrel |
| NEW | `core/ui/ui.dart` | Create barrel |
| NEW | `core/constants/constants.dart` | Create barrel |
| NEW | `core/extensions/extensions.dart` | Create barrel |

### Target Core Module Structure

```
lib/src/core/
├── constants/
│   ├── constants.dart              ← barrel export
│   ├── app_durations.dart          ← NEW (replaces shared/consts/consts.dart)
│   └── break_points.dart           ← moved from core/break_points.dart
├── errors/
│   ├── errors.dart                 ← barrel export
│   ├── failures.dart               ← moved from core/failures/failures.dart
│   └── failures.freezed.dart       ← generated, moved with source
├── extensions/
│   ├── extensions.dart             ← barrel export
│   ├── screen_size.dart            ← already here
│   ├── screen_type.dart            ← moved from core/screen_type.dart
│   └── declarative_bool.dart       ← already here
├── services/
│   ├── services.dart               ← barrel export
│   ├── objectbox_service.dart      ← renamed from core/services/objectbox.dart
│   └── app_database.dart           ← NEW (drift placeholder)
└── ui/
    ├── ui.dart                     ← barrel export
    ├── action_state.dart           ← moved from core/unions/action_state.dart
    └── action_state.freezed.dart   ← generated, moved with source
```

### AppDurations Implementation

Replace `Consts` class (shared/consts/consts.dart) with:

```dart
/// Timing constants used across the application.
abstract final class AppDurations {
  /// Delay after CRUD action success/error before resetting to initial state.
  /// Provides visual feedback to the user (400ms).
  static const actionFeedback = Duration(milliseconds: 400);
}
```

**IMPORTANT:** The timing changes from 500ms → 400ms per architecture spec. `Consts.delayed` was a `Future<void>` getter. All 8 consumer files must be updated.

### Consts.delayed Replacement Patterns

There are **3 distinct usage patterns** across 8 files. Search for `Consts.delayed` (without trailing semicolon) to catch all variants:

**Pattern 1 — Bare await (4 BLoC files):**
```dart
// OLD:
await Consts.delayed;
// NEW:
await Future<void>.delayed(AppDurations.actionFeedback);
```
Files: `create_time_bloc.dart`, `update_time_bloc.dart`, `delete_time_bloc.dart`, `update_wage_hourly_bloc.dart`

**Pattern 2 — Chained `.whenComplete()` (2 widget files):**
```dart
// OLD:
await Consts.delayed.whenComplete(
  () => Navigator.of(context).pop(),
);
// NEW:
await Future<void>.delayed(AppDurations.actionFeedback).whenComplete(
  () => Navigator.of(context).pop(),
);
```
Files: `create_time_button.dart`, `update_time_button.dart`

**Pattern 3 — Chained `.then()` (2 widget files):**
```dart
// OLD:
await Consts.delayed.then(
  (value) => Navigator.of(context).pop(),
);
// NEW:
await Future<void>.delayed(AppDurations.actionFeedback).then(
  (value) => Navigator.of(context).pop(),
);
```
Files: `delete_time_button.dart`, `set_wage_button.dart`

**Verification:** After migration, grep for `Consts` across `lib/` — zero results expected. Also remove `import 'dart:async';` from `consts.dart` consumers only if no other async usage remains in each file.

### drift Placeholder Implementation

```dart
/// Placeholder for drift database implementation.
///
/// Will be fully implemented in Epic 4 (Multi-Datasource, Multi-Platform).
/// This file establishes the correct location per architecture spec.
class AppDatabase {
  /// Placeholder constructor.
  const AppDatabase();
}
```

### Barrel Export Format

Each barrel file follows this pattern:
```dart
export 'file_one.dart';
export 'file_two.dart';
```

No `library` directive, no logic, no classes. Just re-exports.

**EXCEPTION:** Do NOT export generated `.freezed.dart` or `.g.dart` files in barrels. Only export the source `.dart` files.

### Import Update Strategy

Search the entire `lib/` and `test/` trees for these import patterns and update:

| Search Pattern | Replace With | Expected Count |
|---|---|---|
| `core/failures/failures.dart` | `core/errors/failures.dart` | 14 files |
| `core/unions/action_state.dart` | `core/ui/action_state.dart` | 6 files |
| `core/services/objectbox.dart` | `core/services/objectbox_service.dart` | 5 files |
| `core/break_points.dart` | `core/constants/break_points.dart` | 1 file |
| `core/screen_type.dart` | `core/extensions/screen_type.dart` | 2 files |
| `shared/consts/consts.dart` | `core/constants/app_durations.dart` | 8 files |

Every import must use absolute paths: `package:time_money/src/...`. See **Exhaustive Import Update Checklist** below for exact file paths per pattern.

### ObjectBox Service — Keep Current Functionality

The `ObjectBox` class in `objectbox_service.dart` keeps ALL current methods (create, close, getTimesStream, getWageHourlyStream, Box references). Do NOT remove business logic — feature datasources will absorb it in Stories 2.2/2.3. Only rename the file.

### Testing Approach

**test/src/core/errors/failures_test.dart:**
- Test GlobalFailure factory constructors: serverError, notConnection, timeOutExceeded, internalError
- Test GlobalFailure.fromException with SocketException → notConnection
- Test GlobalFailure.fromException with TimeoutException → timeOutExceeded
- Test GlobalFailure.fromException with generic Exception → internalError
- Test ValueFailure factory constructors: characterLimitExceeded, shortOrNullCharacters, invalidFormat
- Test GlobalDefaultFailure typedef resolves to GlobalFailure<dynamic>

**test/src/core/ui/action_state_test.dart:**
- Test ActionState factory constructors: initial, loading, error, success
- Test ActionInfo extension: isInitial, isLoading, isSuccess, isError for each state
- Test `.when()` method dispatches correctly for each variant

**Import in tests:** Use `package:time_money/src/core/errors/failures.dart` and `package:time_money/src/core/ui/action_state.dart`

### Pre-Existing Info-Level Hints

VGA 10.x introduced 17 info-level hints across the codebase. If you encounter them in files you're modifying (updating imports), fix them. Do NOT go hunting for hints in files you're not touching.

### Exhaustive Import Update Checklist

Verified via codebase grep — use these exact counts to confirm completeness. All paths relative to `lib/src/`.

**`core/failures/failures.dart` → `core/errors/failures.dart` (14 files):**
1. `core/unions/action_state.dart` (internal — becomes `core/ui/action_state.dart`)
2. `features/times/domain/times_repository.dart`
3. `features/times/infraestructure/i_times_objectbox_repository.dart`
4. `features/wage_hourly/domain/wage_hourly_repository.dart`
5. `features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`
6. `presentation/control_hours/times/create_time/bloc/create_time_bloc.dart`
7. `presentation/control_hours/times/delete_time/bloc/delete_time_bloc.dart`
8. `presentation/control_hours/times/list_times/bloc/list_times_bloc.dart`
9. `presentation/control_hours/times/list_times/views/error_list_times_view.dart`
10. `presentation/control_hours/times/update_time/bloc/update_time_bloc.dart`
11. `presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart`
12. `presentation/control_hours/wage_hourly/fetch_wage/views/error_fetch_wage_hourly_view.dart`
13. `presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart`
14. `presentation/widgets/views/error_view.dart`

**`core/unions/action_state.dart` → `core/ui/action_state.dart` (6 files):**
1. `presentation/control_hours/times/create_time/bloc/create_time_bloc.dart`
2. `presentation/control_hours/times/create_time/widgets/create_time_button.dart`
3. `presentation/control_hours/times/update_time/bloc/update_time_bloc.dart`
4. `presentation/control_hours/times/update_time/widgets/update_time_button.dart`
5. `presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart`
6. `presentation/control_hours/wage_hourly/update_wage/widgets/set_wage_button.dart`

**`core/services/objectbox.dart` → `core/services/objectbox_service.dart` (5 files):**
1. `features/times/infraestructure/i_times_objectbox_repository.dart`
2. `features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`
3. `../../main_development.dart` (lib/main_development.dart)
4. `../../main_staging.dart` (lib/main_staging.dart)
5. `../../main_production.dart` (lib/main_production.dart)

**`shared/consts/consts.dart` → `core/constants/app_durations.dart` (8 files):**
1. `presentation/control_hours/times/create_time/bloc/create_time_bloc.dart`
2. `presentation/control_hours/times/create_time/widgets/create_time_button.dart`
3. `presentation/control_hours/times/delete_time/bloc/delete_time_bloc.dart`
4. `presentation/control_hours/times/delete_time/widgets/delete_time_button.dart`
5. `presentation/control_hours/times/update_time/bloc/update_time_bloc.dart`
6. `presentation/control_hours/times/update_time/widgets/update_time_button.dart`
7. `presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart`
8. `presentation/control_hours/wage_hourly/update_wage/widgets/set_wage_button.dart`

**`core/break_points.dart` → `core/constants/break_points.dart` (1 file):**
1. `core/extensions/screen_size.dart`

**`core/screen_type.dart` → `core/extensions/screen_type.dart` (2 files):**
1. `core/extensions/screen_size.dart`
2. `core/break_points.dart` (which itself moves to `core/constants/break_points.dart`)

**Total: 36 file-level import changes across 6 patterns. No test files currently import these modules.**

### Project Structure Notes

- The codebase currently uses misspelled folders: `aplication` and `infraestructure`. Do NOT correct these spellings in Story 2.1 — folder spelling correction happens as part of feature restructuring in Stories 2.2-2.4.
- The `shared/injections/` folder stays as-is. DI restructuring is Story 2.5 scope.
- The `lib/src/presentation/` folder stays as-is. Presentation moves into features in Stories 2.2-2.4.

### Architecture Compliance

- **Import style:** Always absolute `package:time_money/src/...` — NEVER relative
- **Import order (VGA 10.x enforced):** (1) `dart:` (2) `package:` third-party (3) `package:time_money/` project
- **Barrel files:** ONLY re-exports, no logic
- **No circular exports** between barrels
- **const constructors** wherever possible
- **abstract final class** for AppDurations (Dart 3 best practice for constants)

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 2, Story 2.1]
- [Source: _bmad-output/planning-artifacts/architecture.md — Section 3: Project Structure, Section 4: Cross-Cutting Concerns, Section 7: ADRs]
- [Source: _bmad-output/planning-artifacts/prd.md — FR38, NFR8, NFR9, NFR10]
- [Source: _bmad-output/implementation-artifacts/1-4-code-generation-remaining-dependencies.md — Freezed 3.x learnings, VGA 10.x upgrade]
- [Source: _bmad-output/implementation-artifacts/epic-1-retro-2026-03-18.md — Pre-existing technical debt D-1 through D-5]
- [Source: _bmad-output/project-context.md — Rules 1-43, technology stack]

### Previous Story Intelligence

**From Epic 1 Retrospective:**
- Zero technical debt introduced across 4 stories
- 3-layer adversarial code review caught 4 Bad Specs — treat spec versions as hypotheses
- Zero linter tolerance enforced — no story marked done with warnings
- Tests alongside implementation starting Epic 2
- Incremental migration prevents conflicts

**From Story 1.4 (most recent):**
- Freezed 3.x generates `when`/`map` as extension methods (ActionStatePatterns<T>) — if moving action_state.dart, verify widget files that call `.when()` still have correct imports after the move
- VGA 10.x requires `on Object catch (e)` not `catch (e)` — already applied in Story 1.4
- build.yaml exists at project root with Freezed 3.x backward-compat config (when/map enabled)
- 13 .freezed.dart files and 2 .g.dart files exist — after running build_runner, verify the count matches

**Pre-Existing Technical Debt (do NOT fix, just be aware):**
- D-1: TextEditingController not synced with bloc state (Epic 2-3)
- D-2: BlocConsumer listener is no-op in 5 widgets (Epic 2-3)
- D-3: StackTrace captured but discarded in error_view.dart (Epic 3)
- D-4: DeleteTimeBloc `.fold()` result not emitted — CRITICAL LOGIC BUG (Epic 3 Story 3.3)
- D-5: CreateTimeEvent `_Reset` missing handler (Epic 3 Story 3.2)

### Git Intelligence

**Recent Commits (Epic 1 complete):**
```
28a28c9 docs: epic 1 retrospective completed
a990031 chore: code review passed for story 1.4
41838a2 chore: upgrade Freezed 2.x → 3.x, very_good_analysis 5.x → 10.x
474dff1 docs: validate and enhance story 1.4
f2299be docs: create story 1.4
```

**Commit message convention:** `type: description` — use `refactor:` for this story since it's reorganization.

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
