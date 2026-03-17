# Story 1.1: SDK Constraint & Flutter/Dart Version Migration

Status: review

## Story

As a developer,
I want to upgrade the SDK constraint from Dart 2.x to Dart 3.11+ and Flutter to 3.41+,
So that the codebase runs on a current, supported SDK and enables all modern Dart 3 language features.

## Acceptance Criteria

1. **Given** the existing pubspec.yaml has SDK constraint `>=2.19.2 <3.0.0` and Flutter `3.7.5`
   **When** the SDK constraint is updated to `>=3.11.0 <4.0.0` and Flutter is upgraded to 3.41+ stable
   **Then** `flutter --version` reports Flutter 3.41+ and Dart 3.11+
   **And** all platform configurations (Xcode project, Gradle build files, web index.html, Windows CMake) are updated to match the new SDK requirements

2. **Given** the updated SDK constraint
   **When** `flutter analyze` is run on the codebase
   **Then** all Dart 2.x-specific breaking changes are identified and fixed (deprecated APIs, syntax changes)
   **And** the project compiles without errors (`flutter build` succeeds for at least one platform)

3. **Given** the SDK migration is complete
   **When** the app is launched on any native platform
   **Then** all existing features (time entry CRUD, wage management, payment calculation) function identically to pre-migration behavior
   **And** no runtime errors occur during normal usage

## Tasks / Subtasks

- [x] Task 1: Update Flutter SDK to 3.41+ stable (AC: #1)
  - [x] 1.1 Run `flutter upgrade` to get Flutter 3.41+ on stable channel
  - [x] 1.2 Verify `flutter --version` reports Flutter 3.41+ and Dart 3.11+
  - [x] 1.3 If stable channel doesn't have 3.41+, pin the exact latest stable version

- [x] Task 2: Update pubspec.yaml SDK constraint (AC: #1)
  - [x] 2.1 Change `sdk: ">=2.19.2 <3.0.0"` to `sdk: ">=3.11.0 <4.0.0"`
  - [x] 2.2 Remove the `flutter: 3.7.5` pin — let Flutter resolve from channel
  - [x] 2.3 Run `flutter pub get` — expect failures from dependencies with `<3.0.0` constraints

- [x] Task 3: Resolve dependency Dart 3 compatibility (AC: #2)
  - [x] 3.1 Bump all dependencies to minimum Dart 3-compatible versions per the table below. Only version bumps — major API migrations happen in stories 1.2-1.4
  - [x] 3.2 **ObjectBox**: Bumped to `objectbox: ^4.0.0`, `objectbox_flutter_libs: ^4.0.0`, `objectbox_generator: ^4.0.0` (see Completion Notes for version deviation from ^2.0.0)
  - [x] 3.3 **flutter_hooks**: Removed dependency and converted all 5 HookWidget usages to StatefulWidget
  - [x] 3.4 **dartz**: Replaced with `fpdart: ^1.2.0` in all 4 files. API compatible (right/left/unit/Either)
  - [x] 3.5 **freezed**: Bumped `freezed_annotation` to `^3.0.0`. Removed `freezed` from dev_dependencies (see Completion Notes for source_gen conflict). Existing .freezed.dart files compile as-is
  - [x] 3.6 **intl**: Bumped to `^0.20.0`. Localization regenerated with `flutter gen-l10n`
  - [x] 3.7 **very_good_analysis**: Bumped to `^5.0.0`, analysis_options.yaml updated
  - [x] 3.8 **mocktail**: Bumped to `^1.0.0`
  - [x] 3.9 Move `build_runner`, `json_serializable` from `dependencies` to `dev_dependencies` (NFR9)
  - [x] 3.10 Verify `flutter pub get` resolves successfully
  - [x] 3.11 build_runner cannot compile due to source_gen/analyzer version conflict — existing .g.dart files compile correctly with objectbox 4.x. Full ObjectBox regeneration deferred to Story 1.2

- [x] Task 4: Update Android platform configuration (AC: #1)
  - [x] 4.1 Update `android/build.gradle`: Removed buildscript block; `android/settings.gradle`: AGP 8.11.1, Kotlin 2.2.20
  - [x] 4.2 Update `android/gradle/wrapper/gradle-wrapper.properties`: Gradle 7.4 → 8.14
  - [x] 4.3 Update `android/app/build.gradle`: compileSdk → 35, targetSdk → 35, minSdk → 21, Java → JavaVersion.VERSION_17
  - [x] 4.4 Migrate Gradle plugin application from imperative `apply plugin:` to declarative `plugins {}` block
  - [x] 4.5 **CRITICAL:** All three build flavors (development, staging, production) and application IDs preserved. Verified `.dev` and `.stg` suffixes
  - [x] 4.6 Verify `flutter build ios` succeeds (APK build not available on macOS without Android SDK; iOS build verified instead)

- [x] Task 5: Update iOS platform configuration (AC: #1)
  - [x] 5.1 Updated `ios/Podfile` platform to `platform :ios, '13.0'`
  - [x] 5.2 Update Xcode project deployment target to iOS 13.0 in `ios/Runner.xcodeproj/project.pbxproj` (all 9 instances)
  - [x] 5.3 `pod install` ran automatically via `flutter build ios`
  - [x] 5.4 `flutter build ios --no-codesign` succeeds for all 3 flavors

- [x] Task 6: Update Web platform configuration (AC: #1)
  - [x] 6.1 Updated `web/index.html`: replaced deprecated service worker bootstrap with `flutter_bootstrap.js`
  - [x] 6.2 Removed old manual service worker loading script
  - [x] 6.3 Web build fails due to ObjectBox dart:ffi incompatibility (expected — ObjectBox is native-only). Web platform NOT supported for this app

- [x] Task 7: Update Windows platform configuration (AC: #1)
  - [x] 7.1 Updated `windows/CMakeLists.txt`: cmake_policy to modern version range
  - [x] 7.2 No `ForceRedraw()` usage found — no migration needed
  - [x] 7.3 Windows build not available (macOS host). CMake changes are minimal and low-risk

- [x] Task 8: Fix Dart 3 breaking changes in source code (AC: #2)
  - [x] 8.1 No mixin class issues found — all `with _$ClassName` usages are Freezed-generated
  - [x] 8.2 `dart fix --dry-run` previewed: only prefer_const_constructors suggestions (pre-existing)
  - [x] 8.3 Auto-fixable changes are pre-existing lint suggestions, not applied to avoid scope creep
  - [x] 8.4 Fixed `control_hours_page.dart`: `.withOpacity(.2)` → `.withValues(alpha: .2)` and `colorScheme.background` → `colorScheme.surface`
  - [x] 8.5 No named parameter default syntax issues found
  - [x] 8.6 Fixed Dart 3 breaking changes: `_` wildcard in `error_view.dart` (Dart 3 wildcard pattern), `textScaleFactor` → `textScaler` in `info_section.dart`
  - [x] 8.7 Localization generation works. Migrated from deprecated `flutter_gen` synthetic package to `output-dir: lib/l10n/gen` with `l10n.yaml`
  - [x] 8.8 `flutter analyze` — zero errors, 17 info-level lint suggestions (all pre-existing)

- [x] Task 9: Compilation and runtime verification (AC: #2, #3)
  - [x] 9.1 `flutter analyze` — zero errors (17 info only)
  - [x] 9.2 `flutter build ios --no-codesign` — succeeds for all 3 flavors
  - [x] 9.3 No test files exist — test directory compiles (verified via `flutter analyze`)
  - [ ] 9.4 Launch app on a native platform — requires physical device or emulator (manual verification needed by developer)
  - [x] 9.5 All three flavors compile: development, staging, production — verified via `flutter build ios --no-codesign --flavor <name>`
  - [ ] 9.6 Verify time entry CRUD works — requires runtime verification (manual)
  - [ ] 9.7 Verify wage management works — requires runtime verification (manual)
  - [ ] 9.8 Verify payment calculation works — requires runtime verification (manual)
  - [ ] 9.9 Verify localization works — requires runtime verification (manual)

## Dev Notes

### Scope Boundaries — READ CAREFULLY

This story is ONLY about:
- Updating SDK constraint (Dart 2.19 → Dart 3.11+)
- Updating Flutter version (3.7.5 → 3.41+)
- Updating platform configurations (Android, iOS, Web, Windows)
- Fixing Dart 3 breaking changes for compilation
- Bumping dependencies to MINIMUM Dart 3-compatible versions for compilation
- Replacing dartz with fpdart (pulled forward from Story 1.3 — dartz is abandoned with no Dart 3 version)
- Removing flutter_hooks and converting to StatefulWidget (pulled forward from Story 2.5 — no published Dart 3 version)

This story is NOT about:
- ObjectBox 1.7 → 5.x full migration with schema/data verification (Story 1.2)
- BLoC 8 → 9 migration (Story 1.3)
- Freezed 2 → 3 codegen migration and when/map removal (Story 1.4)
- very_good_analysis latest rules adoption (Story 1.4)
- Architecture restructuring (Epic 2)
- Sealed classes, pattern matching adoption (Epic 3)

### Minimum Dart 3-Compatible Versions (Research Complete)

| Package | Current | Target | Section | Notes |
|---------|---------|--------|---------|-------|
| objectbox | ^1.7.2 | ^2.0.0 | dependencies | Major version, min Dart 3. Do NOT jump to 5.x |
| objectbox_flutter_libs | ^1.7.2 | ^2.1.0 | dependencies | Must match objectbox major |
| objectbox_generator | ^1.7.2 | ^2.1.0 | dev_dependencies | Must match objectbox major |
| freezed | ^2.3.2 | ^3.0.0 | dev_dependencies | Version bump only — do NOT regenerate .freezed.dart |
| freezed_annotation | ^2.2.0 | ^2.4.2 | dependencies | Minor breaking: `JsonKey(ignore:true)` → `JsonKey(includeFromJson:false, includeToJson:false)` |
| intl | ^0.17.0 | ^0.20.0 | dependencies | Requires Dart >=3.3.0 |
| mocktail | ^0.3.0 | ^1.0.0 | dev_dependencies | No breaking API changes |
| very_good_analysis | ^4.0.0 | ^5.0.0 | dev_dependencies | Lint rule changes only |
| dartz | ^0.10.1 | **REMOVE** | — | Replace with `fpdart: ^1.2.0` |
| flutter_hooks | ^0.18.6 | **REMOVE** | — | Replace HookWidget → StatefulWidget |
| bloc | ^8.1.1 | ^8.1.1 | dependencies | Already Dart 3 compatible |
| flutter_bloc | ^8.1.2 | ^8.1.2 | dependencies | Already Dart 3 compatible |
| bloc_test | ^9.1.1 | ^9.1.1 | dev_dependencies | Already Dart 3 compatible |
| json_annotation | ^4.8.0 | ^4.8.0 | dependencies | Already Dart 3 compatible |
| json_serializable | ^6.6.1 | ^6.6.1 | dev_dependencies | Already Dart 3 compatible |
| build_runner | ^2.3.3 | ^2.3.3 | dev_dependencies | Already Dart 3 compatible |
| provider | ^6.0.5 | ^6.0.5 | dependencies | Already Dart 3 compatible |
| path_provider | ^2.0.13 | ^2.0.13 | dependencies | Already Dart 3 compatible |
| path | ^1.8.2 | ^1.8.2 | dependencies | Already Dart 3 compatible |

### Critical Migration Strategy

This is a Dart 2.x → Dart 3.11+ migration spanning ~3 years of releases. The key challenge: many current dependencies have SDK constraint `<3.0.0` and will fail `flutter pub get` after the SDK constraint is raised.

**Resolution approach:**
1. Update SDK constraint first
2. Run `flutter pub get` — it WILL fail
3. Bump all dependencies to the minimum Dart 3-compatible versions listed in the table above
4. Replace dartz with fpdart (4 files) and remove flutter_hooks (5 files)
5. Regenerate ObjectBox code-gen files only (NOT freezed)
6. Fix Dart 3 syntax issues and deprecated API calls
7. Verify compilation and runtime behavior

### Dependency-Specific Notes

**ObjectBox 1.7.2 → 2.0.0:** Major version bump with breaking API changes. Bump to `^2.0.0` / `^2.1.0` for flutter_libs and generator. Regenerate `objectbox.g.dart` and `objectbox-model.json`. Verify the existing dev database (`test-1`) still loads. Do NOT jump to 5.x — Story 1.2 handles the full migration with schema verification and data integrity checks.

**flutter_hooks 0.18.6 → REMOVE:** No published Dart 3 version (last release 0.21.3+1 still has SDK `<3.0.0`). Remove the dependency and convert all 5 HookWidget usages to StatefulWidget. The 5 files:
1. `lib/src/presentation/control_hours/times/create_time/widgets/create_hour_field.dart`
2. `lib/src/presentation/control_hours/times/create_time/widgets/create_minutes_field.dart`
3. `lib/src/presentation/control_hours/times/update_time/widgets/update_hour_field.dart`
4. `lib/src/presentation/control_hours/times/update_time/widgets/update_minutes_field.dart`
5. `lib/src/presentation/control_hours/wage_hourly/update_wage/widgets/wage_hourly_field.dart`

Each uses `useTextEditingController()` — replace with a StatefulWidget that creates and disposes a `TextEditingController` in `initState()`/`dispose()`.

**dartz 0.10.1 → REMOVE (replace with fpdart ^1.2.0):** Package is abandoned (last release Dec 2021). No Dart 3 version exists. Replace in these 4 files:
1. `lib/src/features/times/domain/times_repository.dart`
2. `lib/src/features/times/infraestructure/i_times_objectbox_repository.dart`
3. `lib/src/features/wage_hourly/domain/wage_hourly_repository.dart`
4. `lib/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`

Key API differences: `import 'package:dartz/dartz.dart'` → `import 'package:fpdart/fpdart.dart'`. `Either`, `Left`, `Right` exist in fpdart with compatible API. `left()` and `right()` constructors may differ — verify each call site.

**freezed 2.3.2 → 3.0.0 (version bump ONLY):** The entire freezed 2.x line has SDK `<3.0.0`. Bump to `^3.0.0` for `flutter pub get` to succeed. **Do NOT run `build_runner` for freezed or regenerate `.freezed.dart` files.** Freezed 3.x removes `when`/`map` methods and requires `sealed`/`abstract` classes — this code migration is Story 1.4. The existing committed `.freezed.dart` files were generated with freezed 2.x and should compile under Dart 3 + freezed_annotation 2.4.2.

**intl 0.17.0 → 0.20.0:** Versions 0.18.x-0.19.x still had SDK `<3.0.0`. After bumping, re-run `flutter gen-l10n` and verify EN/ES strings generate correctly.

### Localization Generation

The project uses `generate: true` in `pubspec.yaml` which triggers Flutter's built-in `flutter gen-l10n`. After the SDK upgrade and intl bump, verify:
- `flutter gen-l10n` runs without errors
- Generated `app_localizations.dart` files are still valid
- EN/ES `.arb` files (in `lib/l10n/arb/`) are still processed correctly

### Commit Convention

Per project conventions in `project-context.md`, use the `chore:` prefix for this migration work. Example:
```
chore: migrate SDK constraint to Dart 3.11+ and Flutter 3.41+
```

### Current pubspec.yaml State (Pre-Migration)

```yaml
environment:
  sdk: ">=2.19.2 <3.0.0"
  flutter: 3.7.5

dependencies:
  bloc: ^8.1.1
  build_runner: ^2.3.3          # WRONG SECTION — move to dev_dependencies
  flutter_bloc: ^8.1.2
  freezed: ^2.3.2               # WRONG SECTION — move to dev_dependencies
  freezed_annotation: ^2.2.0
  intl: ^0.17.0
  json_annotation: ^4.8.0
  json_serializable: ^6.6.1     # WRONG SECTION — move to dev_dependencies
  provider: ^6.0.5
  dartz: ^0.10.1                # REMOVE — replace with fpdart: ^1.2.0
  objectbox: ^1.7.2
  objectbox_flutter_libs: ^1.7.2
  flutter_hooks: ^0.18.6        # REMOVE — no Dart 3 version
  path_provider: ^2.0.13
  path: ^1.8.2

dev_dependencies:
  bloc_test: ^9.1.1
  mocktail: ^0.3.0
  objectbox_generator: ^1.7.2
  very_good_analysis: ^4.0.0
```

### Platform Configuration Current State

**Android (`android/build.gradle`):**
- Kotlin: `1.7.10` → needs `1.8.0+`
- AGP: `7.2.0` → needs `8.9.1+`

**Android (`android/gradle/wrapper/gradle-wrapper.properties`):**
- Gradle: `7.4` → needs `8.11.1+`

**Android (`android/app/build.gradle`):**
- compileSdk/targetSdk: dynamic (flutter defaults) → ensure `35`
- minSdk: dynamic (flutter defaults) → ensure `21`
- Java: `VERSION_1_8` → needs `VERSION_17`
- Build flavors: production, staging, development (PRESERVE these)
- Application ID: `com.criszx17dev.time_money` with flavor suffixes `.stg`, `.dev` (PRESERVE)

**iOS (`ios/Podfile`):**
- Deployment target: commented out (`# platform :ios, '11.0'`) → set `platform :ios, '13.0'`

**Web (`web/index.html`):**
- Standard Flutter web template — may need bootstrap update for Flutter 3.41+

**Windows (`windows/CMakeLists.txt`):**
- CMake 3.14, C++17 — likely minimal changes

### Dart 3 Breaking Changes to Watch For

1. **Mixin changes**: Classes used with `with` keyword must be declared as `mixin class` or `mixin`. All current `with _$ClassName` usages are Freezed-generated — these compile as-is.

2. **Named parameter defaults**: Only `=` is allowed (`:` syntax removed). Unlikely in this codebase but verify.

3. **Deprecated Flutter APIs removed across versions 3.7→3.41:**
   - `colorScheme.background` → `colorScheme.surface` (deprecated Flutter 3.22+)
   - `.withOpacity()` → `.withValues(alpha:)` (deprecated Flutter 3.38+)
   - Only 1 instance in codebase: `control_hours_page.dart:31`
   - No `accentColor` or `setEnabledSystemUIOverlays` usage found in codebase
   - Run `dart fix --apply` to auto-fix many of these

4. **Material 3 default** (Flutter 3.16+): `ThemeData.useMaterial3` defaults to `true`. The project already sets `useMaterial3: true` — no change needed.

5. **Impeller rendering engine**: Now default on iOS and Android. May cause subtle visual differences — verify UI looks correct.

### Gradle Migration Details

AGP 8.x+ requires declarative plugin application. The current `android/build.gradle` uses:
```groovy
buildscript {
    ext.kotlin_version = '1.7.10'
    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

**Option A (recommended):** Run `flutter create . --platforms android` in the project root to let Flutter auto-migrate the Gradle files to the current template. Then re-apply the build flavors and application ID customizations.

**Option B (manual):**
1. Update `android/settings.gradle` to use `plugins {}` block with `id "com.android.application"` and `id "org.jetbrains.kotlin.android"`
2. Remove `buildscript` block from `android/build.gradle`
3. Remove `apply plugin:` lines from `android/app/build.gradle`
4. Update `android/gradle/wrapper/gradle-wrapper.properties` to Gradle 8.11.1+
5. **CRITICAL:** Re-verify all three build flavors and application IDs are preserved
6. **CRITICAL:** Preserve flavor-specific application ID suffixes (`.dev`, `.stg`)

Reference: [Deprecated Imperative Apply of Flutter's Gradle Plugins](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply)

### Existing Code Structure (DO NOT MODIFY in this story)

```
lib/
├── objectbox.g.dart                    # Generated — will be regenerated
├── objectbox-model.json                # Generated — may be regenerated
├── main_development.dart               # Entry point: DB 'test-1'
├── main_staging.dart                   # Entry point: DB 'stg-1'
├── main_production.dart                # Entry point: DB 'prod-1'
├── bootstrap.dart
├── app/
│   ├── app.dart
│   ├── app_bloc.dart
│   └── routes.dart
└── src/
    ├── core/
    │   ├── break_points.dart
    │   ├── screen_type.dart
    │   ├── extensions/ (declarative_bool, screen_size)
    │   ├── failures/failures.dart (+.freezed.dart)
    │   ├── services/objectbox.dart
    │   └── unions/action_state.dart (+.freezed.dart)
    ├── features/
    │   ├── times/ (domain, aplication, infraestructure)
    │   └── wage_hourly/ (domain, aplication, infraestructure)
    ├── presentation/ (control_hours, times, wage_hourly, widgets)
    └── shared/ (consts, injections)
```

**DO NOT rename** `aplication/` or `infraestructure/` folders — this is the established convention. Folder spelling corrections happen in Epic 2.

### Testing During This Story

- No new tests required — test infrastructure exists but no tests are implemented yet
- Existing test helpers (`test/helpers/pump_app.dart`) must still compile after migration
- Run `flutter test` — should pass (no tests to fail, but compilation must succeed)

### Project Structure Notes

- Alignment: This story touches pubspec.yaml, platform configs, and source files for Dart 3 syntax fixes + dependency replacements
- No architecture changes — folder structure remains identical
- All three build flavors (development, staging, production) must be preserved
- Only ObjectBox `.g.dart` files are regenerated via `build_runner` — `.freezed.dart` files are kept as-is until Story 1.4

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 1 Story 1.1]
- [Source: _bmad-output/planning-artifacts/architecture.md#SDK Migration Strategy]
- [Source: _bmad-output/planning-artifacts/architecture.md#Technology Stack]
- [Source: _bmad-output/planning-artifacts/architecture.md#Migration Sequence Dependencies]
- [Source: _bmad-output/project-context.md#Technology Stack & Versions]
- [Source: _bmad-output/project-context.md#Development Workflow Rules]
- [Source: _bmad-output/planning-artifacts/prd.md#FR18, FR19]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

### Completion Notes List

1. **ObjectBox version deviation**: Story specified `objectbox: ^2.0.0` but `objectbox_generator 2.x` is incompatible with Dart 3.11's `analyzer` version (requires >=8.x, generator 2.x supports <7.0.0). Bumped to `^4.0.0` (all three packages). Existing `.g.dart` files compile correctly with 4.x. Story 1.2 handles full ObjectBox migration with schema/data verification — this change doesn't affect that plan since we're already below 5.x.

2. **freezed version deviation**: Story specified `freezed: ^3.0.0` + `freezed_annotation: ^2.4.2`, but freezed 3.x requires `freezed_annotation ^3.0.0`. Additionally, `objectbox_generator 4.x` constrains `source_gen` to 3.x which conflicts with freezed 3.x (needs source_gen 2.x+). Resolution: bumped `freezed_annotation` to `^3.0.0` and removed `freezed` from dev_dependencies entirely (it's only needed for code generation, which Story 1.4 handles). Existing `.freezed.dart` files compile correctly with `freezed_annotation 3.x`.

3. **build_runner incompatibility**: `build_runner 2.7.1` compiles but `source_gen 3.1.0` is incompatible with `analyzer 8.4.1` at runtime (`getInvocation` method removed). ObjectBox `.g.dart` regeneration deferred to Story 1.2 which will resolve the full ObjectBox dependency chain. Existing generated files compile and work as-is.

4. **flutter_hooks removal** (pulled forward from Story 2.5): Converted all 5 HookWidget files to StatefulWidget with proper TextEditingController lifecycle management (initState/dispose). Functionally equivalent behavior preserved.

5. **dartz → fpdart migration** (pulled forward from Story 1.3): Replaced `import 'package:dartz/dartz.dart'` with `import 'package:fpdart/fpdart.dart'` in all 4 files. API is fully compatible — `Either`, `right()`, `left()`, `unit`, `Unit` all available in fpdart.

6. **Localization migration**: Flutter 3.41 deprecated the `flutter_gen` synthetic package. Migrated to `output-dir: lib/l10n/gen` with `synthetic-package: false` (deprecated flag removed). Updated imports from `package:flutter_gen/gen_l10n/` to `package:time_money/l10n/gen/`.

7. **Dart 3 wildcard pattern fix**: In `error_view.dart`, the parameter `_` was used as a variable reference (`$_`) in a string interpolation. Dart 3 treats `_` as a non-binding wildcard. Renamed to `failedValue` to preserve the existing behavior.

8. **Android Gradle migration**: Fully migrated from imperative `apply plugin:` to declarative `plugins {}` block. Versions match Flutter 3.41.4 template: AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14. Added `namespace` to `android/app/build.gradle` as required by AGP 8.x.

9. **Runtime verification pending**: Tasks 9.4, 9.6-9.9 require manual runtime verification on a device/emulator. All compilation checks pass. Recommend running the app on iOS simulator to verify CRUD, wage management, payment calculation, and localization.

### Change Log

- 2026-03-17: Story 1.1 implementation — SDK constraint migration Dart 2.19 → 3.11+, Flutter 3.7.5 → 3.41.4

### File List

**Modified:**
- `pubspec.yaml` — SDK constraint, dependency versions, moved packages to dev_dependencies
- `analysis_options.yaml` — Updated very_good_analysis reference to 5.1.0
- `l10n.yaml` — Migrated from synthetic-package to output-dir
- `lib/l10n/l10n.dart` — Updated imports for new localization output path
- `lib/src/features/times/domain/times_repository.dart` — dartz → fpdart import
- `lib/src/features/times/infraestructure/i_times_objectbox_repository.dart` — dartz → fpdart import
- `lib/src/features/wage_hourly/domain/wage_hourly_repository.dart` — dartz → fpdart import
- `lib/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart` — dartz → fpdart import
- `lib/src/presentation/control_hours/times/create_time/widgets/create_hour_field.dart` — HookWidget → StatefulWidget
- `lib/src/presentation/control_hours/times/create_time/widgets/create_minutes_field.dart` — HookWidget → StatefulWidget
- `lib/src/presentation/control_hours/times/update_time/widgets/update_hour_field.dart` — HookWidget → StatefulWidget
- `lib/src/presentation/control_hours/times/update_time/widgets/update_minutes_field.dart` — HookWidget → StatefulWidget
- `lib/src/presentation/control_hours/wage_hourly/update_wage/widgets/wage_hourly_field.dart` — HookWidget → StatefulWidget
- `lib/src/presentation/control_hours/control_hours_page.dart` — Deprecated API fix (withOpacity, colorScheme.background)
- `lib/src/presentation/widgets/views/error_view.dart` — Dart 3 wildcard pattern fix
- `lib/src/presentation/widgets/info_section.dart` — textScaleFactor → textScaler
- `android/settings.gradle` — Full rewrite: pluginManagement + plugins block (AGP 8.11.1, Kotlin 2.2.20)
- `android/build.gradle` — Removed buildscript block, modernized clean task
- `android/app/build.gradle` — plugins block, compileSdk 35, targetSdk 35, minSdk 21, Java 17, namespace
- `android/gradle/wrapper/gradle-wrapper.properties` — Gradle 7.4 → 8.14
- `ios/Podfile` — platform :ios, '13.0'
- `ios/Runner.xcodeproj/project.pbxproj` — IPHONEOS_DEPLOYMENT_TARGET 12.0 → 13.0
- `web/index.html` — Replaced service worker bootstrap with flutter_bootstrap.js
- `windows/CMakeLists.txt` — Updated cmake_policy to modern version range

**Generated:**
- `lib/l10n/gen/app_localizations.dart` — Regenerated localization output
- `lib/l10n/gen/app_localizations_en.dart` — Regenerated English localization
- `lib/l10n/gen/app_localizations_es.dart` — Regenerated Spanish localization

**Auto-modified by Flutter tooling:**
- `ios/Runner.xcodeproj/project.pbxproj` — Xcode compatibility upgrades (Flutter build)
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme` — UIScene lifecycle migration
- `ios/Podfile` — Auto-upgraded by Flutter build
- `ios/Runner/AppDelegate.swift` — @UIApplicationMain → @main migration
- `pubspec.lock` — Regenerated with new dependency versions
