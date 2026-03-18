# Story 1.3: State Management & FP Dependencies Migration

Status: done

## Story

As a developer,
I want to upgrade flutter_bloc/bloc to 9.x and replace dartz with fpdart,
So that the state management and functional programming foundations are on their latest stable versions compatible with Dart 3.

## Acceptance Criteria

1. **Given** flutter_bloc/bloc at version 8.x and bloc_test at 9.x
   **When** bloc is upgraded to ^9.2.0, flutter_bloc to ^9.1.1, and bloc_test to ^10.0.0
   **Then** `flutter pub get` resolves successfully
   **And** `flutter analyze` reports zero errors
   **And** the project compiles without errors

2. **Given** BLoC event handlers use the `on<Event>` pattern (current)
   **When** bloc 9.x is applied
   **Then** all event handlers function correctly without changes (on<Event> pattern is unchanged in 9.x)
   **And** no deprecated APIs (`BlocOverrides`, `mapEventToState`, `transformEvents`, direct `.listen()`) exist in the codebase

3. **Given** dartz was already replaced with fpdart ^1.2.0 in Story 1.1
   **When** the fpdart version is verified as latest stable
   **Then** fpdart ^1.2.0 is confirmed as the latest stable version (no action needed)
   **And** all Either/Unit/right/left usage compiles correctly with bloc 9.x

4. **Given** the state management and FP dependencies are upgraded
   **When** the app is launched on iOS simulator and Android emulator
   **Then** time entry CRUD (create, list, update, delete) works identically
   **And** wage management (fetch, update) works identically
   **And** payment calculation works identically
   **And** no runtime errors occur

5. **Given** all builds must pass
   **When** `flutter build` is run for all flavors
   **Then** `flutter build ios --simulator --flavor development/staging/production` succeeds
   **And** `flutter build apk --debug --flavor development/staging/production` succeeds

## Tasks / Subtasks

- [x] Task 1: Update BLoC dependencies in pubspec.yaml (AC: #1)
  - [x] 1.1 Change `bloc: ^8.1.1` to `bloc: ^9.2.0`
  - [x] 1.2 Change `flutter_bloc: ^8.1.2` to `flutter_bloc: ^9.1.1`
  - [x] 1.3 Change `bloc_test: ^9.1.1` to `bloc_test: ^10.0.0`
  - [x] 1.4 Run `flutter pub get` — verify it resolves successfully
  - [x] 1.5 Run `flutter analyze` — verify zero errors

- [x] Task 2: Verify no deprecated BLoC APIs exist (AC: #2)
  - [x] 2.1 Grep for `BlocOverrides` — must find zero matches (already uses `Bloc.observer` static setter in `bootstrap.dart:28`)
  - [x] 2.2 Grep for `mapEventToState` — must find zero matches
  - [x] 2.3 Grep for `transformEvents` — must find zero matches
  - [x] 2.4 Grep for direct `.listen(` on Bloc/Cubit instances — verify none exist (should use `.stream.listen()` if any)
  - [x] 2.5 Verify `AppBlocObserver` in `bootstrap.dart` extends `BlocObserver` correctly (unchanged API in 9.x)

- [x] Task 3: Verify fpdart compatibility (AC: #3)
  - [x] 3.1 Confirm fpdart ^1.2.0 is latest stable (verified: 1.2.0 published Oct 2025, no newer stable)
  - [x] 3.2 Verify all 4 fpdart import files compile: `times_repository.dart`, `i_times_objectbox_repository.dart`, `wage_hourly_repository.dart`, `i_wage_hourly_objectbox_repository.dart`
  - [x] 3.3 Verify `.fold()` usage in BLoC files works with bloc 9.x + fpdart 1.2.0

- [x] Task 4: Compilation verification (AC: #1, #5)
  - [x] 4.1 Run `flutter analyze` — zero errors
  - [x] 4.2 Run `flutter build ios --simulator --flavor development` — succeeds
  - [x] 4.3 Run `flutter build ios --simulator --flavor staging` — succeeds
  - [x] 4.4 Run `flutter build ios --simulator --flavor production` — succeeds
  - [x] 4.5 Run `flutter build apk --debug --flavor development` — succeeds
  - [x] 4.6 Run `flutter build apk --debug --flavor staging` — succeeds
  - [x] 4.7 Run `flutter build apk --debug --flavor production` — succeeds

- [x] Task 5: Runtime verification (AC: #4) — MANUALLY VERIFIED BY DEVELOPER (2026-03-17)
  - [x] 5.1 Launch app on iOS simulator — verify no crashes
  - [x] 5.2 Verify time entry list loads (ListTimesBloc)
  - [x] 5.3 Verify wage hourly loads (FetchWageHourlyBloc)
  - [x] 5.4 Verify create time entry works (CreateTimeBloc)
  - [x] 5.5 Verify update/delete operations work (UpdateTimeBloc, DeleteTimeBloc)
  - [x] 5.6 Verify wage update works (UpdateWageHourlyBloc)
  - [x] 5.7 Verify payment calculation works (ResultPaymentCubit)

## Dev Notes

### Scope Boundaries — READ CAREFULLY

This story is ONLY about:
- Upgrading `bloc` from ^8.1.1 to ^9.2.0
- Upgrading `flutter_bloc` from ^8.1.2 to ^9.1.1
- Upgrading `bloc_test` from ^9.1.1 to ^10.0.0
- Verifying no deprecated BLoC APIs exist in the codebase
- Verifying fpdart ^1.2.0 compatibility with bloc 9.x (it's already the latest stable)
- Build and runtime verification

This story is NOT about:
- Replacing Freezed with sealed classes for BLoC events/states (Epic 3 — Story 3.1+)
- Migrating BLoC stream consumption to `emit.forEach` (Epic 3 — Story 3.2+)
- Architecture restructuring or folder renaming (Epic 2)
- Freezed 2.x → 3.x codegen migration (Story 1.4)
- Any source code changes to BLoC files (the 8.x → 9.x upgrade requires NO code changes for this codebase)
- Fixing pre-existing bugs (see D-4 below) — do NOT fix any existing logic issues

**Why version-bump-only:** Story 1.1 already migrated dartz → fpdart. BLoC 8.x already required `on<Event>` (deprecated `mapEventToState` was removed in 8.0.0). The codebase uses zero deprecated APIs. Sealed class migration and `emit.forEach` adoption are Epic 3. The epics file AC#2 mentions "dartz → fpdart" but that work is complete — this story only verifies fpdart compatibility with bloc 9.x.

### BLoC 9.x Migration Details (Research Complete — 2026-03-17)

**Version targets:**

| Package | Current (resolved) | Target | Notes |
|---------|-------------------|--------|-------|
| bloc | ^8.1.1 (8.1.4) | ^9.2.0 | Latest stable, removes deprecated APIs |
| flutter_bloc | ^8.1.2 (8.1.6) | ^9.1.1 | Latest stable, adds mounted check in listeners |
| bloc_test | ^9.1.1 (9.1.7) | ^10.0.0 | Matches bloc 9.x (bloc_test 9.x matched bloc 8.x) |

**SDK compatibility:** BLoC 9.x requires Dart >=2.14.0 <4.0.0. We have Dart 3.11+ — fully compatible.

**Breaking changes removed in bloc 9.0.0 (NONE affect TimeMoney):**

| Removed API | Status in TimeMoney |
|-------------|-------------------|
| `BlocOverrides` | NOT USED — already uses `Bloc.observer` static setter (`bootstrap.dart:28`) |
| `mapEventToState` | NOT USED — all BLoCs use `on<Event>` handler pattern |
| `transformEvents` | NOT USED — no custom event transformers |
| `TransitionFunction` typedef | NOT USED |
| Direct `.listen()` on Bloc/Cubit | NOT USED |

**Unchanged APIs (no code modifications needed):**
- `on<Event>` handler pattern — identical
- `emit`, `emit.forEach`, `emit.onEach` — identical
- `BlocProvider`, `BlocBuilder`, `BlocConsumer`, `BlocSelector` — identical
- `BlocObserver` class and API — identical (new `onDone` is optional)
- `blocTest` function signature — identical (`build`, `act`, `expect`, etc.)
- Cubit pattern — identical

### fpdart Status (No Action Needed)

fpdart ^1.2.0 is confirmed as the **latest stable version** (published Oct 29, 2025). The 2.0.0-dev.3 prerelease exists but is a rewrite based on `Effect` class and will stay in dev. No version change needed.

The dartz → fpdart migration was completed in Story 1.1. All 4 files already import `package:fpdart/fpdart.dart`:
1. `lib/src/features/times/domain/times_repository.dart`
2. `lib/src/features/times/infraestructure/i_times_objectbox_repository.dart`
3. `lib/src/features/wage_hourly/domain/wage_hourly_repository.dart`
4. `lib/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`

### bloc_test Version Alignment

**Current mismatch:** pubspec.yaml pins `bloc_test: ^9.1.1` which was designed for `bloc 8.x`. When upgrading to `bloc ^9.2.0`, the corresponding `bloc_test` version is `^10.0.0`. The `blocTest` function API is unchanged — the 10.0.0 major version is due to an internal refactor (`EmittableStateStreamableSource` interface decoupling).

**Zero test files exist:** The codebase contains no `*_test.dart` files and no imports of `package:bloc_test`. The bloc_test upgrade is purely to keep dependency alignment — there are no existing tests to break or verify. Test infrastructure is created in Epic 3.

### Existing BLoC Inventory (8 classes — zero changes needed)

| BLoC/Cubit | File | Event Pattern | State Pattern |
|------------|------|---------------|---------------|
| CreateTimeBloc | `lib/src/presentation/.../create_time/bloc/create_time_bloc.dart` | `on<_ChangeHour>`, `on<_ChangeMinutes>`, `on<_Create>` | Single factory with ActionState |
| ListTimesBloc | `lib/src/presentation/.../list_times/bloc/list_times_bloc.dart` | `on<_GetTimes>` | Union: initial/loading/empty/error/hasDataStream |
| DeleteTimeBloc | `lib/src/presentation/.../delete_time/bloc/delete_time_bloc.dart` | `on<_Delete>` | Union: initial/loading/success/error |
| UpdateTimeBloc | `lib/src/presentation/.../update_time/bloc/update_time_bloc.dart` | `on<_Init>`, `on<_ChangeHour>`, `on<_ChangeMinutes>`, `on<_Update>` | Single factory with ActionState |
| FetchWageHourlyBloc | `lib/src/presentation/.../fetch_wage/bloc/fetch_wage_hourly_bloc.dart` | `on<_GetWage>` | Union: initial/loading/empty/error/hasDataStream |
| UpdateWageHourlyBloc | `lib/src/presentation/.../update_wage/bloc/update_wage_hourly_bloc.dart` | `on<_ChangeHourly>`, `on<_Update>` | Single factory with ActionState |
| ResultPaymentCubit | `lib/src/presentation/.../result_payment/cubit/result_payment_cubit.dart` | N/A (Cubit — methods only) | Single factory with list + wage |
| AppBloc | `lib/app/view/app_bloc.dart` | N/A (Widget wrapper) | N/A — BLoC provider composition only |

All use `on<Event>` handlers (BLoC) or direct methods (Cubit). No deprecated patterns found.

### AppBlocObserver (Already Compatible)

`bootstrap.dart:7-28`: `AppBlocObserver extends BlocObserver` with `onChange` override. Registered via `Bloc.observer = const AppBlocObserver();` — this is the 9.x-compatible pattern (NOT the deprecated `BlocOverrides`). No changes needed.

### Dependency Injection (No Changes Needed)

BLoC DI uses `BlocProvider` from flutter_bloc. The registration pattern in `times_blocs.dart`, `wage_hourly_blocs.dart`, and `result_payment_cubits.dart` creates `BlocProvider` instances via `BlocInjections.list()`. This API is unchanged in flutter_bloc 9.x.

### Files That Will Change

**Modified by developer:**
- `pubspec.yaml` — bloc/flutter_bloc/bloc_test version bumps only

**Auto-updated:**
- `pubspec.lock` — Updated dependency resolutions

**NOT modified:**
- Zero source code files — BLoC 8.x → 9.x requires no code changes for this codebase
- All BLoC files — `on<Event>` pattern is unchanged
- All state/event Freezed files — unchanged
- All repository files — fpdart is already latest
- `bootstrap.dart` — `Bloc.observer` already uses 9.x-compatible API
- All DI files — `BlocProvider` API is unchanged

### Commit Convention

```
chore: upgrade BLoC 8.x → 9.x and bloc_test 9.x → 10.x
```

### Project Structure Notes

- No architecture changes — this is a pure dependency version bump
- The `aplication/` and `infraestructure/` folder spellings are preserved (renamed in Epic 2)
- All three build flavors (development, staging, production) must compile after changes
- No source code modifications expected

### Previous Story Intelligence (Story 1.2)

Key learnings from Story 1.2 that apply to this story:

1. **build_runner conflict is RESOLVED** — objectbox_generator 5.2.0 fixed the source_gen/analyzer conflict. `dart run build_runner build` now works. However, this story should NOT run build_runner (no codegen changes are involved).

2. **freezed is still REMOVED from dev_dependencies** — it stays removed. Reinstallation is Story 1.4. Do NOT attempt to reinstall freezed.

3. **Existing .freezed.dart files compile correctly** — they were generated with freezed 2.x but compile with freezed_annotation ^3.0.0. Bloc 9.x does not change this compatibility.

4. **iOS build uses `--simulator` flag** — no Apple Developer Team configured for device signing. All iOS verification via simulator builds.

5. **Manual CRUD verification pattern** — Tasks 4/5 in Story 1.2 required manual UI verification. Same approach applies here for runtime verification.

6. **Code review deferred findings D-1, D-2, D-3** are pre-existing issues unrelated to this story — do not attempt to fix them.

7. **D-4 (NEW): DeleteTimeBloc `.fold()` result not emitted** — In `delete_time_bloc.dart:23`, the line `result.fold(DeleteTimeState.error, (r) => const _Success())` discards the fold result instead of emitting it. The success/error state is never emitted; state jumps directly to `initial()`. This is a pre-existing logic bug unrelated to Story 1.3 — do NOT fix it in this story. It will be addressed in Epic 3 when BLoC files are modernized.

### Git Intelligence (Recent Commits)

```
137caea chore: code review fixes for story 1.2 — revert xcscheme artifacts, document findings, story done
5c81ead chore: migrate ObjectBox 4.x → 5.x with iOS 15.0 target and build_runner fix
1dec3e5 docs: validate and enhance story 1.2 with quality review fixes
13052e7 docs: create story 1.2 ObjectBox migration & data verification
5e54904 chore: code review fixes for story 1.1 — Android build verified, story done
```

Patterns to follow:
- `chore:` prefix for migration/upgrade work
- Descriptive commit messages with migration context
- All 6 build flavors verified before marking done (3 iOS + 3 Android)

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 1 Story 1.3]
- [Source: _bmad-output/planning-artifacts/architecture.md#Migration Sequence Dependencies]
- [Source: _bmad-output/planning-artifacts/architecture.md#Core Architectural Decisions]
- [Source: _bmad-output/planning-artifacts/prd.md#FR40-FR44 State Management]
- [Source: _bmad-output/planning-artifacts/prd.md#NFR16 Latest stable versions]
- [Source: _bmad-output/project-context.md#Flutter & BLoC Framework Rules]
- [Source: _bmad-output/implementation-artifacts/1-2-objectbox-migration-data-verification.md#Completion Notes]
- [Source: _bmad-output/implementation-artifacts/1-1-sdk-constraint-flutter-dart-version-migration.md#Completion Notes]
- [Source: pub.dev/packages/bloc/changelog — v9.0.0, v9.1.0, v9.2.0]
- [Source: pub.dev/packages/flutter_bloc/changelog — v9.0.0, v9.1.0, v9.1.1]
- [Source: pub.dev/packages/bloc_test/changelog — v10.0.0]
- [Source: pub.dev/packages/fpdart — v1.2.0 latest stable]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- Tasks 1–4 executed and verified in single session (2026-03-17)
- All 6 build flavors (3 iOS + 3 Android) compiled successfully
- Zero deprecated BLoC APIs found in codebase
- fpdart ^1.2.0 confirmed compatible with bloc 9.x
- `flutter analyze` reports zero errors (17 pre-existing info-level lint suggestions, unchanged)

### Completion Notes List

- ✅ Task 1: Updated pubspec.yaml — bloc ^8.1.1→^9.2.0, flutter_bloc ^8.1.2→^9.1.1, bloc_test ^9.1.1→^10.0.0. `flutter pub get` resolved successfully. `flutter analyze` zero errors.
- ✅ Task 2: Verified zero deprecated BLoC APIs — BlocOverrides (0), mapEventToState (0), transformEvents (0), direct .listen() (0). AppBlocObserver uses 9.x-compatible `Bloc.observer` static setter.
- ✅ Task 3: fpdart ^1.2.0 confirmed as latest stable. All 4 fpdart import files compile. All `.fold()` usage in BLoC files works with bloc 9.x + fpdart 1.2.0.
- ✅ Task 4: All 6 builds pass — iOS simulator (dev/stg/prod) and Android APK debug (dev/stg/prod).
- ✅ Task 5: Runtime verification completed by developer (2026-03-17). All CRUD operations (time entries create/list/update/delete), wage management (fetch/update), and payment calculation verified working. No runtime errors.
- Note: This was a version-bump-only story — zero source code changes. Only pubspec.yaml modified (3 version bumps). pubspec.lock auto-updated.

### Change Log

- 2026-03-17: Upgraded bloc ^8.1.1→^9.2.0, flutter_bloc ^8.1.2→^9.1.1, bloc_test ^9.1.1→^10.0.0. All 6 builds pass (3 iOS + 3 Android). Runtime CRUD verified by developer. Story complete.
- 2026-03-17: Code review passed — 3-layer adversarial review (Blind Hunter, Edge Case Hunter, Acceptance Auditor). 11 findings raised, all triaged as noise. Zero patch/defer/intent_gap/bad_spec findings. Story marked done.

### Code Review Record

- **Date:** 2026-03-17
- **Reviewer model:** Claude Opus 4.6 (1M context)
- **Review mode:** full (with spec file)
- **Diff scope:** commit range `137caea..HEAD` (3 commits, 4 files changed, 289+/11-)
- **Layers executed:** Blind Hunter, Edge Case Hunter, Acceptance Auditor — all completed successfully
- **Findings summary:** 0 intent_gap, 0 bad_spec, 0 patch, 0 defer, 11 reject (noise)
- **Edge Case Hunter verification:** Exhaustively verified 7 BLoC/Cubit classes, AppBlocObserver, 12 widget files, 4 fpdart files — zero deprecated APIs, zero unhandled edge cases
- **Acceptance Auditor verdict:** All 5 ACs satisfied, scope boundaries respected, D-4 pre-existing bug untouched
- **Pre-existing issues confirmed (not caused by this story):**
  - D-4: DeleteTimeBloc `.fold()` result not emitted (tracked for Epic 3)
  - CreateTimeEvent `_Reset` event has no registered `on<_Reset>` handler (pre-existing)
- **Verdict:** PASS — story marked done

### File List

- `pubspec.yaml` — Modified: bloc ^8.1.1→^9.2.0, flutter_bloc ^8.1.2→^9.1.1, bloc_test ^9.1.1→^10.0.0
- `pubspec.lock` — Auto-updated: dependency resolutions for bloc 9.x ecosystem
