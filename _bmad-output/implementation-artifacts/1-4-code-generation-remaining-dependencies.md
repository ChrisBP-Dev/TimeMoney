# Story 1.4: Code Generation & Remaining Dependencies

Status: done

## Story

As a developer,
I want to upgrade Freezed to 3.x, very_good_analysis to latest, and all remaining dependencies to their latest stable versions,
So that the entire dependency tree is current and the codebase is fully modernized at the package level (NFR16).

## Acceptance Criteria

1. **Given** Freezed was removed from dev_dependencies (Story 1.2) and existing .freezed.dart files were generated with Freezed 2.x
   **When** `freezed: ^3.2.5` is added to dev_dependencies and `dart run build_runner build --delete-conflicting-outputs` is executed
   **Then** all 11 .freezed.dart files and 2 JSON .g.dart files (13 generated files total) are regenerated successfully with Freezed 3.x
   **And** `flutter pub get` resolves without conflicts
   **And** `flutter analyze` reports zero errors
   **And** the project compiles without errors

2. **Given** very_good_analysis at ^5.0.0
   **When** upgraded to ^10.2.0 (latest stable, requires Dart >=3.11)
   **Then** `analysis_options.yaml` is updated with the correct include path
   **And** `flutter analyze` passes with zero warnings on non-generated code
   **And** all new lint rule violations from the 5.x→10.x jump are resolved

3. **Given** all remaining dependencies at their current versions
   **When** each is upgraded to its latest stable version via `flutter pub upgrade`
   **Then** no deprecated API usage remains in the codebase
   **And** all dev_dependencies are correctly placed in the dev_dependencies section (NFR9)

4. **Given** all dependencies are at latest stable versions
   **When** the complete app is launched and all features exercised on a native platform
   **Then** time entry CRUD works: create, view list, edit with pre-populated values, delete with feedback
   **And** wage management works: view, set initial, update with feedback
   **And** payment calculation works: calculate total, view summary
   **And** localization works: EN/ES switching
   **And** zero functional regressions exist (FR18, FR19)

5. **Given** all builds must pass
   **When** `flutter build` is run for all flavors
   **Then** `flutter build ios --simulator --flavor development/staging/production` succeeds
   **And** `flutter build apk --debug --flavor development/staging/production` succeeds

## Tasks / Subtasks

- [x] Task 1: Reinstall Freezed 3.x and configure backward-compatible codegen (AC: #1)
  - [x] 1.1 Add `freezed: ^3.2.5` to dev_dependencies in pubspec.yaml
  - [x] 1.2 Update `freezed_annotation` constraint from `^3.0.0` to `^3.1.0` in dependencies (already compatible, explicit bump)
  - [x] 1.3 Run `flutter pub get` — verify dependency resolution succeeds (build_runner will auto-resolve to ~2.13.0 due to freezed 3.x requiring `build >=3.0.0`)
  - [x] 1.3b Verify `objectbox_generator` resolves without conflict after transitive build/source_gen upgrade (build 2.x → 4.x, source_gen 2.x → 4.x)
  - [x] 1.4 Create `build.yaml` at project root to enable `when`/`map` generation (see Dev Notes for config)
  - [x] 1.5 Update all 17 @freezed source files: change `class X with _$X` to `abstract class X with _$X` where needed (15 need change, 2 already abstract — see File Inventory)
  - [x] 1.6 Run `dart run build_runner build --delete-conflicting-outputs` — verify all 13 .freezed.dart + 2 .g.dart files regenerate
  - [x] 1.7 Run `flutter analyze` — verify zero errors
  - [x] 1.8 Verify `.when()` calls in 10 hand-written files still compile (backward compat via build.yaml config)

- [x] Task 2: Upgrade very_good_analysis 5.x → 10.x (AC: #2)
  - [x] 2.1 Update pubspec.yaml: `very_good_analysis: ^10.2.0`
  - [x] 2.2 Update `analysis_options.yaml`: change include from `package:very_good_analysis/analysis_options.5.1.0.yaml` to `package:very_good_analysis/analysis_options.yaml`
  - [x] 2.3 Run `flutter pub get`
  - [x] 2.4 Run `flutter analyze` — capture all new warnings
  - [x] 2.5 Fix all new lint violations from 5.x→10.x upgrade (see Dev Notes for expected new rules)
  - [x] 2.6 Verify `invalid_annotation_target: ignore` is still needed; keep if @freezed triggers it
  - [x] 2.7 Run `flutter analyze` — verify zero warnings on non-generated code

- [x] Task 3: Upgrade remaining dependencies (AC: #3)
  - [x] 3.1 Run `flutter pub upgrade` to pull latest compatible versions within existing constraints
  - [x] 3.2 Verify no dependency placement issues (NFR9): build_runner, json_serializable, objectbox_generator, freezed, mocktail, bloc_test must all be in dev_dependencies
  - [x] 3.3 Verify `provider: ^6.0.5` is still needed — grep `lib/` for `import.*provider` to check if any file imports it. If zero imports found, remove from dependencies
  - [x] 3.4 Run `flutter analyze` — zero errors
  - [x] 3.5 Run `flutter pub get` — clean resolution

- [x] Task 4: Compilation verification (AC: #1, #5)
  - [x] 4.1 Run `flutter analyze` — zero errors
  - [x] 4.2 Run `flutter build ios --simulator --flavor development` — succeeds
  - [x] 4.3 Run `flutter build ios --simulator --flavor staging` — succeeds
  - [x] 4.4 Run `flutter build ios --simulator --flavor production` — succeeds
  - [x] 4.5 Run `flutter build apk --debug --flavor development` — succeeds
  - [x] 4.6 Run `flutter build apk --debug --flavor staging` — succeeds
  - [x] 4.7 Run `flutter build apk --debug --flavor production` — succeeds

- [ ] Task 5: Runtime verification (AC: #4) — MANUALLY VERIFIED BY DEVELOPER
  - [ ] 5.1 Launch app on iOS simulator — verify no crashes
  - [ ] 5.2 Verify time entry list loads (ListTimesBloc)
  - [ ] 5.3 Verify create time entry works (CreateTimeBloc)
  - [ ] 5.4 Verify update/delete operations work (UpdateTimeBloc, DeleteTimeBloc)
  - [ ] 5.5 Verify wage hourly loads (FetchWageHourlyBloc)
  - [ ] 5.6 Verify wage update works (UpdateWageHourlyBloc)
  - [ ] 5.7 Verify payment calculation works (ResultPaymentCubit)
  - [ ] 5.8 Verify localization EN/ES switching works

## Dev Notes

### Scope Boundaries — READ CAREFULLY

This story is ONLY about:
- Reinstalling `freezed` (removed in Story 1.2) at version ^3.2.5
- Configuring Freezed 3.x for backward compatibility (preserving `when`/`map` generation)
- Updating @freezed class declarations to `abstract class` (Freezed 3.x requirement)
- Regenerating all .freezed.dart and .g.dart files with Freezed 3.x codegen
- Upgrading `very_good_analysis` from ^5.0.0 to ^10.2.0 and fixing lint violations
- Upgrading remaining dependencies to latest stable
- Build and runtime verification

This story is NOT about:
- Replacing `.when()` calls with Dart 3 pattern matching (Epic 2 for ActionState/failures, Epic 3 for BLoC)
- Migrating BLoC events/states to sealed classes (Epic 3 — Story 3.1+)
- Migrating ActionState or failures to sealed classes (Epic 2 — Story 2.1)
- Architecture restructuring or folder renaming (Epic 2)
- Adding drift datasource (Epic 4)
- Removing flutter_hooks (Story 2.5)
- Creating tests (Epic 3/5)
- Any behavior changes to the application

**Why backward-compat approach:** The architecture specifies sealed class migration in Epics 2-3. Story 1.4 must preserve all existing `.when()` calls via `build.yaml` config to avoid pulling Epic 2/3 scope into Epic 1. The `when`/`map` methods will be removed naturally when each class is migrated to hand-written sealed classes.

### Freezed 3.x Migration Details (Research Complete — 2026-03-17)

**Version targets:**

| Package | Current | Target | Notes |
|---------|---------|--------|-------|
| freezed | (not installed) | ^3.2.5 | Reinstall to dev_dependencies |
| freezed_annotation | ^3.0.0 | ^3.1.0 | Minor bump, already compatible |
| build_runner | ^2.4.14 | ^2.4.14 (resolves to ~2.13.0) | Constraint unchanged but freezed 3.x forces transitive upgrade: build 2.x→4.x, source_gen 2.x→4.x |
| json_serializable | ^6.6.1 | ^6.6.1 | Already latest within constraint |
| very_good_analysis | ^5.0.0 | ^10.2.0 | Major constraint change required (requires Dart >=3.11, project is >=3.11.0 ✓) |

**Freezed 3.x breaking changes that affect this codebase:**

| Breaking Change | Impact on TimeMoney | Action |
|-----------------|---------------------|--------|
| `when()`/`map()`/`maybeWhen()`/`maybeMap()` NOT generated by default (removed in 3.0.0, re-added as opt-in in 3.1.0) | 10 `.when()` calls in hand-written code would break | Enable via `build.yaml` config |
| Classes must be `abstract`, `sealed`, or implement `_$X` | 15 of 17 @freezed source files use plain `class` | Change to `abstract class` |
| `$XTearOff` no longer generated | NOT USED in codebase — zero matches | No action |
| `freezed_annotation` no longer re-exports `package:collection` | NOT USED — zero `package:collection` imports | No action |
| Lists/Maps/Sets become UnmodifiableView by default | Affects `List<ModelTime>` in ResultPaymentState, `Stream<List<ModelTime>>` in ListTimesState — verify runtime behavior | Test carefully in Task 5 |

### build.yaml Configuration (NEW FILE — CRITICAL)

Create `build.yaml` at project root with this content to preserve `when`/`map` generation:

```yaml
targets:
  $default:
    builders:
      freezed:
        options:
          when:
            when: true
            maybeWhen: true
          map:
            map: true
            maybeMap: true
```

**Why:** Freezed 3.x removed `when`/`map` in 3.0.0 and re-added them as opt-in in 3.1.0. The codebase has 10 `.when()` calls across 10 files (see inventory below). These will be migrated to Dart 3 pattern matching in Epics 2-3. The build.yaml config preserves backward compatibility until then.

**Alternative:** Per-class `@Freezed(when: FreezedWhenOptions(when: true, maybeWhen: true))` annotation — but build.yaml is cleaner for project-wide config.

**IMPORTANT:** If the exact build.yaml syntax doesn't work, check the Freezed 3.x README for the current `build.yaml` options format. The key is enabling `when` and `map` generation globally.

### @freezed Class Declaration Changes (17 source files → 13 .freezed.dart outputs)

Freezed 3.x requires `abstract class` (or `sealed class`) instead of plain `class`. **15 files need change, 2 are already abstract.**

| # | Source File | Output .freezed.dart | Needs Change? |
|---|------------|---------------------|---------------|
| 1 | `lib/src/features/times/domain/model_time.dart` | model_time.freezed.dart | YES → `abstract class` |
| 2 | `lib/src/features/wage_hourly/domain/wage_hourly.dart` | wage_hourly.freezed.dart | YES → `abstract class` |
| 3 | `lib/src/core/failures/failures.dart` (ValueFailure) | failures.freezed.dart | YES → `abstract class` |
| 4 | `lib/src/core/failures/failures.dart` (GlobalFailure) | failures.freezed.dart | YES → `abstract class` |
| 5 | `lib/src/core/unions/action_state.dart` | action_state.freezed.dart | YES → `abstract class` |
| 6 | `lib/src/presentation/.../create_time/bloc/create_time_state.dart` | create_time_bloc.freezed.dart | NO — already abstract |
| 7 | `lib/src/presentation/.../create_time/bloc/create_time_event.dart` | create_time_bloc.freezed.dart | YES → `abstract class` |
| 8 | `lib/src/presentation/.../delete_time/bloc/delete_time_state.dart` | delete_time_bloc.freezed.dart | NO — already abstract |
| 9 | `lib/src/presentation/.../delete_time/bloc/delete_time_event.dart` | delete_time_bloc.freezed.dart | YES → `abstract class` |
| 10 | `lib/src/presentation/.../list_times/bloc/list_times_state.dart` | list_times_bloc.freezed.dart | YES → `abstract class` |
| 11 | `lib/src/presentation/.../list_times/bloc/list_times_event.dart` | list_times_bloc.freezed.dart | YES → `abstract class` |
| 12 | `lib/src/presentation/.../update_time/bloc/update_time_state.dart` | update_time_bloc.freezed.dart | YES → `abstract class` |
| 13 | `lib/src/presentation/.../update_time/bloc/update_time_event.dart` | update_time_bloc.freezed.dart | YES → `abstract class` |
| 14 | `lib/src/presentation/.../fetch_wage/bloc/fetch_wage_hourly_state.dart` | fetch_wage_hourly_bloc.freezed.dart | YES → `abstract class` |
| 15 | `lib/src/presentation/.../fetch_wage/bloc/fetch_wage_hourly_event.dart` | fetch_wage_hourly_bloc.freezed.dart | YES → `abstract class` |
| 16 | `lib/src/presentation/.../update_wage/bloc/update_wage_hourly_state.dart` | update_wage_hourly_bloc.freezed.dart | YES → `abstract class` |
| 17 | `lib/src/presentation/.../update_wage/bloc/update_wage_hourly_event.dart` | update_wage_hourly_bloc.freezed.dart | YES → `abstract class` |
| 18 | `lib/src/presentation/.../result_payment/cubit/result_payment_state.dart` | result_payment_cubit.freezed.dart | YES → `abstract class` |

**NOTE:** Files 6-18 are `part of` their parent BLoC/Cubit file. State and event files sharing a parent produce a single `.freezed.dart` output (e.g., create_time_state.dart + create_time_event.dart → create_time_bloc.freezed.dart). Total: **18 @freezed classes across 17 source files → 13 .freezed.dart output files**.

**Action:** Run `grep -rn '@freezed' lib/ --include='*.dart' | grep -v '.freezed.dart'` to confirm list before starting. Change all `class X with _$X` to `abstract class X with _$X`.

### Freezed 3.x `const` and Private Constructor Impact

**ModelTime has a private constructor:**
```dart
const ModelTime._();
```
Freezed 3.x supports this pattern for classes that need custom getters (`toDuration`). The `._()` private constructor allows adding methods. Verify this compiles after regeneration.

**WageHourly has no private constructor:** Single factory, no custom methods. Should work with Freezed 3.x's "mixed mode" syntax. Verify.

**`const factory` constructors:** All current @freezed classes use `const factory`. Freezed 3.x preserves this pattern.

### `.when()` Usage Inventory (Must Remain Working)

These hand-written files call `.when()` on Freezed-generated classes:

| File | Line | Called On | Union Class |
|------|------|-----------|-------------|
| `core/unions/action_state.dart` | 15-38 | `this` (ActionState) | ActionState<T> |
| `presentation/.../list_times_state.dart` | 15-29 | `this` (ListTimesState) | ListTimesState |
| `presentation/.../fetch_wage_hourly_state.dart` | 15-22 | `this` (FetchWageHourlyState) | FetchWageHourlyState |
| `presentation/widgets/views/error_view.dart` | 17 | `failure` | GlobalFailure |
| `presentation/.../set_wage_button.dart` | 27 | `state.currentState` | ActionState |
| `presentation/.../create_time_button.dart` | 24 | `state.currentState` | ActionState |
| `presentation/.../update_time_button.dart` | 27 | `state.currentState` | ActionState |
| `presentation/.../fetch_wage_screen.dart` | 18 | `state` | FetchWageHourlyState |
| `presentation/.../list_times_screen.dart` | 15 | `state` | ListTimesState |
| `presentation/.../delete_time_button.dart` | 32 | `state` | DeleteTimeState |

All 10 calls must compile after Freezed 3.x regeneration. If build.yaml config doesn't work, the fallback is adding `@Freezed(when: FreezedWhenOptions(when: true, maybeWhen: true))` to each union class.

### very_good_analysis 5.x → 10.x — Expected New Lint Rules

Cumulative new rules across 5 major versions that may trigger warnings:

| Version | New Rules | Likely Impact |
|---------|-----------|---------------|
| 6.0.0 | `missing_code_block_language_in_doc_comment`, `no_self_assignments`, `no_wildcard_variable_uses` | Low — project has few doc comments |
| 7.0.0 | `document_ignores`, `avoid_catches_without_on_clauses`, `unintended_html_in_doc_comment` | Medium — `avoid_catches_without_on_clauses` may flag `catch(e)` in failures.dart |
| 8.0.0 | `specify_nonobvious_property_types`, `strict_top_level_inference`, `unnecessary_underscores` | High — `strict_top_level_inference` may require explicit types on top-level variables |
| 10.0.0 | Removed `diagnostic_describe_all_properties` | No action |
| 10.1.0 | Removed `prefer_expression_function_bodies` | No action (relaxation) |

**Strategy:** Run `flutter analyze` after upgrade, fix all warnings. If a rule produces many false positives on generated file patterns, add a targeted `// ignore` or disable the rule in analysis_options.yaml with a comment explaining why.

**analysis_options.yaml update:**
```yaml
include: package:very_good_analysis/analysis_options.yaml
```
(Remove the version-specific `.5.1.0.yaml` suffix — modern very_good_analysis uses the base path)

### Dependency Change Summary

| Package | Section | Current | Target | Action |
|---------|---------|---------|--------|--------|
| freezed | dev_deps | (missing) | ^3.2.5 | ADD |
| freezed_annotation | deps | ^3.0.0 | ^3.1.0 | Bump constraint |
| very_good_analysis | dev_deps | ^5.0.0 | ^10.2.0 | Bump constraint |
| build_runner | dev_deps | ^2.4.14 | ^2.4.14 (resolves ~2.13.0) | Constraint unchanged; freezed 3.x forces transitive upgrade build 2.x→4.x, source_gen 2.x→4.x |
| json_serializable | dev_deps | ^6.6.1 | ^6.6.1 | pub upgrade (latest within constraint) |
| json_annotation | deps | ^4.8.0 | ^4.8.0 | pub upgrade (latest within constraint) |
| intl | deps | ^0.20.0 | ^0.20.0 | pub upgrade (latest within constraint) |
| mocktail | dev_deps | ^1.0.0 | ^1.0.0 | pub upgrade (latest within constraint) |
| All others | - | current | current | pub upgrade |

### Files That Will Change

**Modified by developer:**
- `pubspec.yaml` — Add freezed, bump very_good_analysis and freezed_annotation
- `analysis_options.yaml` — Update include path for very_good_analysis 10.x
- `build.yaml` — NEW FILE: Freezed 3.x build configuration
- All @freezed source files (17 files, 15 need change) — Change `class X` to `abstract class X`
- Any files with lint violations from very_good_analysis 10.x

**Auto-regenerated by build_runner:**
- `lib/src/features/times/domain/model_time.freezed.dart`
- `lib/src/features/times/domain/model_time.g.dart`
- `lib/src/features/wage_hourly/domain/wage_hourly.freezed.dart`
- `lib/src/features/wage_hourly/domain/wage_hourly.g.dart`
- `lib/src/core/failures/failures.freezed.dart`
- `lib/src/core/unions/action_state.freezed.dart`
- `lib/src/presentation/.../create_time_bloc.freezed.dart`
- `lib/src/presentation/.../delete_time_bloc.freezed.dart`
- `lib/src/presentation/.../list_times_bloc.freezed.dart`
- `lib/src/presentation/.../update_time_bloc.freezed.dart`
- `lib/src/presentation/.../fetch_wage_hourly_bloc.freezed.dart`
- `lib/src/presentation/.../update_wage_hourly_bloc.freezed.dart`
- `lib/src/presentation/.../result_payment_cubit.freezed.dart`

**Auto-updated:**
- `pubspec.lock` — Updated dependency resolutions

**NOT modified:**
- `lib/objectbox.g.dart` — ObjectBox generated file, no changes expected (no entity changes)
- BLoC source files (business logic unchanged)
- Repository files (no API changes)
- Widget files (unless lint violations require fixes)

### UnmodifiableView Default — VERIFY CAREFULLY

Freezed 3.x wraps Lists/Maps/Sets in UnmodifiableView by default. This may affect:

1. `ResultPaymentState.times` — `@Default([]) List<ModelTime> times` → The list becomes unmodifiable. The cubit's `calculatePayment` method accesses this list read-only, so it should be fine.
2. `ListTimesState.hasDataStream` — Takes a `Stream<List<ModelTime>>`, the Stream itself is not a Freezed field, it's a constructor parameter. Should be unaffected.

If runtime errors occur with `UnmodifiableListView`, add `@Freezed(makeCollectionsUnmodifiable: false)` to the affected class as a targeted fix.

### Commit Convention

```
chore: upgrade Freezed 2.x → 3.x, very_good_analysis 5.x → 10.x, and remaining deps
```

### Project Structure Notes

- No architecture changes — this is dependency upgrades + codegen regeneration
- The `aplication/` and `infraestructure/` folder spellings are preserved (renamed in Epic 2)
- All three build flavors (development, staging, production) must compile after changes
- `build.yaml` is a new file at project root (standard location for build_runner configuration)
- Generated files will have different content (Freezed 3.x codegen output) but same functionality

### Previous Story Intelligence (Story 1.3)

Key learnings from Story 1.3 that apply to this story:

1. **build_runner conflict was RESOLVED in Story 1.2** — objectbox_generator 5.2.0 fixed the source_gen/analyzer conflict with build_runner ~2.4.x (build 2.x, source_gen 2.x). **WARNING:** This story's `freezed: ^3.2.5` requires `build >=3.0.0`, which forces pub solver to upgrade build_runner from ~2.4.15 to ~2.13.0 (build 4.x, source_gen 4.x). This is a significant transitive dependency jump. Verify `objectbox_generator: ^5.2.0` is compatible with the new transitive chain before proceeding with code generation. If `flutter pub get` fails with a version conflict, investigate objectbox_generator compatibility first.

2. **freezed was REMOVED from dev_dependencies in Story 1.2** — This story reinstalls it at version ^3.2.5. The old .freezed.dart files were generated with Freezed 2.x but compile with freezed_annotation ^3.0.0.

3. **BLoC 9.x is already in place** — Story 1.3 upgraded bloc to ^9.2.0, flutter_bloc to ^9.1.1, bloc_test to ^10.0.0. No further BLoC dependency changes needed.

4. **fpdart ^1.2.0 is latest stable** — Confirmed in Story 1.3. No version change needed.

5. **iOS build uses `--simulator` flag** — No Apple Developer Team configured for device signing. All iOS verification via simulator builds.

6. **Manual CRUD verification pattern** — Tasks 4/5 require manual UI verification. Same approach as Stories 1.2 and 1.3.

7. **D-4 (pre-existing): DeleteTimeBloc `.fold()` result not emitted** — Pre-existing logic bug. Do NOT fix in this story.

8. **CreateTimeEvent `_Reset` has no registered `on<_Reset>` handler** — Pre-existing. Do NOT fix.

9. **Zero test files exist** — No `*_test.dart` files in the codebase. bloc_test and mocktail upgrades are purely for dependency alignment. Tests are created in Epic 3/5.

### Git Intelligence (Recent Commits)

```
58dd4c4 chore: code review passed for story 1.3 — 3-layer adversarial review clean, story done
64256b4 chore: upgrade BLoC 8.x → 9.x and bloc_test 9.x → 10.x
250b111 docs: validate and enhance story 1.3 with quality review fixes
5fb9c9b docs: create story 1.3 state management & FP dependencies migration
137caea chore: code review fixes for story 1.2 — revert xcscheme artifacts, document findings, story done
```

Patterns to follow:
- `chore:` prefix for migration/upgrade work
- Descriptive commit messages with migration context
- All 6 build flavors verified before marking done (3 iOS + 3 Android)

### Potential Pitfalls

1. **build.yaml syntax:** The exact Freezed 3.x `build.yaml` options format may differ from what's documented here. If the configuration shown doesn't work, check `pub.dev/packages/freezed#build-yaml` for the current schema. The goal is enabling `when` and `map` generation globally.

2. **`abstract class` with private constructor:** `ModelTime` has `const ModelTime._();` for custom getters. Changing to `abstract class ModelTime with _$ModelTime` may conflict with the private constructor pattern. If so, try just adding `abstract` — Freezed 3.x "mixed mode" supports this. If it doesn't compile, check Freezed 3.x docs for the correct pattern for classes with custom methods.

3. **`GlobalFailure.fromException()` factory:** This is a non-redirecting factory (contains logic, not just `= SubClass`). Dart allows static/factory methods on abstract classes as long as they return a subclass instance — and `fromException()` returns Freezed-generated subclasses like `NotConnection`, `TimeOutExceeded`, etc. **This pattern is safe with `abstract class`** — keep it as-is. If the compiler errors, move the logic to a static method: `static GlobalFailure<F> fromException(...)` (same semantics).

4. **very_good_analysis 10.x `avoid_catches_without_on_clauses`:** The `failures.dart` file catches generic exceptions in `fromException()`. If VGA 10.x flags this, add a targeted `// ignore_for_file` if the catch is intentional (it is — it's the last-resort exception handler).

5. **`@Default(WageHourly())` in UpdateWageHourlyState:** This creates a const default value using another Freezed class. Verify the const-ness is preserved after regeneration. If Freezed 3.x changes WageHourly to not be const-constructible, this default will fail.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 1 Story 1.4]
- [Source: _bmad-output/planning-artifacts/architecture.md#Migration Sequence Dependencies]
- [Source: _bmad-output/planning-artifacts/architecture.md#Core Architectural Decisions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Code Generation Pipeline]
- [Source: _bmad-output/planning-artifacts/prd.md#NFR9 dev_dependencies placement]
- [Source: _bmad-output/planning-artifacts/prd.md#NFR16 Latest stable versions]
- [Source: _bmad-output/project-context.md#Dart Language Rules]
- [Source: _bmad-output/project-context.md#Code Quality & Style Rules]
- [Source: _bmad-output/implementation-artifacts/1-3-state-management-fp-dependencies-migration.md#Completion Notes]
- [Source: pub.dev/packages/freezed/changelog — v3.0.0, v3.1.0, v3.2.0, v3.2.5]
- [Source: pub.dev/packages/freezed_annotation — v3.1.0]
- [Source: pub.dev/packages/very_good_analysis/changelog — v6.0.0 through v10.2.0]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- build_runner resolved to 2.11.1 (not 2.13.0 as story predicted) — still compatible, pub upgrade later bumped to 2.13.0
- json_annotation warning during build_runner: "The version constraint ^4.8.0 on json_annotation allows versions before 4.9.0" — informational only, pub upgrade resolved to 4.11.0
- Freezed 3.x generates `when`/`map` as extension methods (`ActionStatePatterns<T>`, etc.) instead of mixin methods — required adding explicit imports of `action_state.dart` in 3 widget files that call `.when()` on `ActionState` (external type not in same part-of library)
- `timebox.dart` had `// ignore_for_file: public_member_api_docs, sort_constructors_first` — removing this surfaced `sort_constructors_first` which was fixed by reordering the constructor before fields

### Completion Notes List

- **Task 1 (Freezed 3.x):** Added freezed ^3.2.5 to dev_dependencies, bumped freezed_annotation to ^3.1.0, created build.yaml for when/map generation, updated 16 @freezed classes to `abstract class` (2 were already abstract), regenerated all 11 .freezed.dart + 2 .g.dart files (13 generated files total), added 3 missing imports for Freezed 3.x extension-based when() method. All 10 .when() call sites compile successfully.
- **Task 2 (VGA 10.x):** Upgraded very_good_analysis ^5.0.0 → ^10.2.0, updated analysis_options.yaml include path. Fixed 19 new lint violations: removed 5 unnecessary ignore_for_file directives, changed 7 `catch (e)` to `on Object catch (e)` in repositories, wrapped 2 discarded showDialog futures with `unawaited()`, reordered constructor in timebox.dart. Kept `invalid_annotation_target: ignore` for @freezed compatibility.
- **Task 3 (Remaining deps):** Ran flutter pub upgrade — 7 transitive deps upgraded (build_runner 2.13.0, json_annotation 4.11.0, json_serializable 6.13.0, analyzer 10.0.1, etc). Removed unused `provider: ^6.0.5` (zero imports in lib/). All dev_dependencies correctly placed (NFR9).
- **Task 4 (Builds):** All 6 builds pass — 3 iOS simulator (dev/stg/prod) + 3 Android APK debug (dev/stg/prod). Zero analyze errors.
- **Task 5 (Runtime):** Pending manual verification by developer. All builds compile cleanly, no behavioral changes made.

### Change Log

- 2026-03-17: Implemented Story 1.4 — Freezed 2.x→3.x migration, VGA 5.x→10.x upgrade, remaining deps upgrade, provider removed
- 2026-03-17: Code review passed — 3-layer adversarial review (Blind Hunter, Edge Case Hunter, Acceptance Auditor). 1 bad_spec finding fixed (AC#1 .freezed.dart count 13→11), 7 findings rejected as noise. Zero code defects found. Story done.

### File List

**Modified by developer:**
- pubspec.yaml — Added freezed ^3.2.5, bumped freezed_annotation ^3.1.0, bumped very_good_analysis ^10.2.0, removed unused provider
- analysis_options.yaml — Updated include path for VGA 10.x
- lib/src/features/times/domain/model_time.dart — abstract class
- lib/src/features/wage_hourly/domain/wage_hourly.dart — abstract class
- lib/src/core/failures/failures.dart — abstract class (ValueFailure + GlobalFailure)
- lib/src/core/unions/action_state.dart — abstract class
- lib/src/presentation/control_hours/times/create_time/bloc/create_time_event.dart — abstract class
- lib/src/presentation/control_hours/times/delete_time/bloc/delete_time_event.dart — abstract class
- lib/src/presentation/control_hours/times/list_times/bloc/list_times_state.dart — abstract class
- lib/src/presentation/control_hours/times/list_times/bloc/list_times_event.dart — abstract class
- lib/src/presentation/control_hours/times/update_time/bloc/update_time_state.dart — abstract class
- lib/src/presentation/control_hours/times/update_time/bloc/update_time_event.dart — abstract class
- lib/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_state.dart — abstract class
- lib/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_event.dart — abstract class
- lib/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_state.dart — abstract class
- lib/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_event.dart — abstract class
- lib/src/presentation/control_hours/result_payment/cubit/result_payment_state.dart — abstract class
- lib/src/presentation/control_hours/times/create_time/widgets/create_time_button.dart — added action_state.dart import
- lib/src/presentation/control_hours/times/update_time/widgets/update_time_button.dart — added action_state.dart import
- lib/src/presentation/control_hours/wage_hourly/update_wage/widgets/set_wage_button.dart — added action_state.dart import
- lib/src/features/times/domain/times_repository.dart — removed unused ignore directive
- lib/src/features/times/infraestructure/timebox.dart — removed unused ignore directive, reordered constructor
- lib/src/features/wage_hourly/domain/wage_hourly_repository.dart — removed unused ignore directive
- lib/src/features/times/infraestructure/i_times_objectbox_repository.dart — catch(e) → on Object catch(e)
- lib/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart — catch(e) → on Object catch(e)
- lib/src/presentation/control_hours/control_hours_page.dart — unawaited(showDialog)
- lib/src/presentation/control_hours/result_payment/calculate_payment_button.dart — unawaited(showDialog)
- lib/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart — removed unused ignore directive
- lib/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart — removed unused ignore directive

**New files:**
- build.yaml — Freezed 3.x build configuration (when/map generation enabled)

**Auto-regenerated by build_runner:**
- lib/src/features/times/domain/model_time.freezed.dart
- lib/src/features/times/domain/model_time.g.dart
- lib/src/features/wage_hourly/domain/wage_hourly.freezed.dart
- lib/src/features/wage_hourly/domain/wage_hourly.g.dart
- lib/src/core/failures/failures.freezed.dart
- lib/src/core/unions/action_state.freezed.dart
- lib/src/presentation/control_hours/times/create_time/bloc/create_time_bloc.freezed.dart
- lib/src/presentation/control_hours/times/delete_time/bloc/delete_time_bloc.freezed.dart
- lib/src/presentation/control_hours/times/list_times/bloc/list_times_bloc.freezed.dart
- lib/src/presentation/control_hours/times/update_time/bloc/update_time_bloc.freezed.dart
- lib/src/presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.freezed.dart
- lib/src/presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.freezed.dart
- lib/src/presentation/control_hours/result_payment/cubit/result_payment_cubit.freezed.dart

**Auto-updated:**
- pubspec.lock — Updated dependency resolutions
