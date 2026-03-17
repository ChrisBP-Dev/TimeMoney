# Story 1.1: SDK Constraint & Flutter/Dart Version Migration

Status: ready-for-dev

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

- [ ] Task 1: Update Flutter SDK to 3.41+ stable (AC: #1)
  - [ ] 1.1 Run `flutter upgrade` to get Flutter 3.41+ on stable channel
  - [ ] 1.2 Verify `flutter --version` reports Flutter 3.41+ and Dart 3.11+
  - [ ] 1.3 If stable channel doesn't have 3.41+, pin the exact latest stable version

- [ ] Task 2: Update pubspec.yaml SDK constraint (AC: #1)
  - [ ] 2.1 Change `sdk: ">=2.19.2 <3.0.0"` to `sdk: ">=3.11.0 <4.0.0"`
  - [ ] 2.2 Remove the `flutter: 3.7.5` pin — let Flutter resolve from channel
  - [ ] 2.3 Run `flutter pub get` — expect failures from dependencies with `<3.0.0` constraints

- [ ] Task 3: Resolve dependency Dart 3 compatibility (AC: #2)
  - [ ] 3.1 Bump all dependencies to minimum Dart 3-compatible versions per the table below. Only version bumps — major API migrations happen in stories 1.2-1.4
  - [ ] 3.2 **ObjectBox**: Bump to `objectbox: ^2.0.0`, `objectbox_flutter_libs: ^2.1.0`, `objectbox_generator: ^2.1.0` (minimum Dart 3-compatible versions). Do NOT jump to 5.x — Story 1.2 handles the full migration with schema/data verification
  - [ ] 3.3 **flutter_hooks**: No published Dart 3 version exists (last release 0.21.3+1 has SDK `<3.0.0`). Remove the dependency and convert all 5 HookWidget usages to StatefulWidget. The 5 files are listed in Dev Notes below. Document removal in Completion Notes (planned for Story 2.5, pulled forward here)
  - [ ] 3.4 **dartz**: Package is abandoned (last release Dec 2021, no Dart 3 version). Replace with `fpdart: ^1.2.0` in the 4 files listed in Dev Notes below. `Either`/`Left`/`Right` API is similar but import path and some signatures differ. Document scope pull-forward from Story 1.3 in Completion Notes
  - [ ] 3.5 **freezed**: Bump `freezed` to `^3.0.0` and `freezed_annotation` to `^2.4.2` for Dart 3 compilation. Do NOT regenerate `.freezed.dart` files or migrate when/map API — that is Story 1.4. Existing generated files are committed and should compile as-is
  - [ ] 3.6 **intl**: Bump to `^0.20.0` (minimum Dart 3-compatible version, requires Dart >=3.3.0). Re-verify `flutter gen-l10n` after upgrade
  - [ ] 3.7 **very_good_analysis**: Bump to `^5.0.0` (minimum Dart 3 version — lint rule changes only, adopting latest rules is Story 1.4)
  - [ ] 3.8 **mocktail**: Bump to `^1.0.0` (minimum Dart 3 version, no breaking API changes)
  - [ ] 3.9 Move `build_runner`, `freezed`, `json_serializable` from `dependencies` to `dev_dependencies` (NFR9)
  - [ ] 3.10 Verify `flutter pub get` resolves successfully
  - [ ] 3.11 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate ObjectBox `.g.dart` files only. Do NOT regenerate `.freezed.dart` files — keep existing generated files until Story 1.4 (freezed 3.x has breaking codegen changes: removes `when`/`map` methods, requires `sealed`/`abstract` classes, which needs source code migration)

- [ ] Task 4: Update Android platform configuration (AC: #1)
  - [ ] 4.1 Update `android/build.gradle`: Kotlin version 1.7.10 → 1.8.0+, AGP 7.2.0 → 8.9.1+
  - [ ] 4.2 Update `android/gradle/wrapper/gradle-wrapper.properties`: Gradle 7.4 → 8.11.1+
  - [ ] 4.3 Update `android/app/build.gradle`: compileSdk → 35, targetSdk → 35, minSdk → 21, Java → JavaVersion.VERSION_17
  - [ ] 4.4 Migrate Gradle plugin application from imperative `apply plugin:` to declarative `plugins {}` block — AGP 8.x+ requires this. See Gradle Migration Details in Dev Notes
  - [ ] 4.5 **CRITICAL:** Re-verify all three build flavors (development, staging, production) and application IDs are preserved after migration. Preserve flavor-specific suffixes (`.dev`, `.stg`)
  - [ ] 4.6 Verify `flutter build apk` succeeds

- [ ] Task 5: Update iOS platform configuration (AC: #1)
  - [ ] 5.1 Uncomment and update `ios/Podfile` platform to `platform :ios, '13.0'`
  - [ ] 5.2 Update Xcode project deployment target to iOS 13.0 in `ios/Runner.xcodeproj/project.pbxproj`
  - [ ] 5.3 Run `cd ios && pod install && cd ..`
  - [ ] 5.4 Verify `flutter build ios --no-codesign` succeeds (if on macOS)

- [ ] Task 6: Update Web platform configuration (AC: #1)
  - [ ] 6.1 Review `web/index.html` for deprecated Flutter bootstrap — update if needed
  - [ ] 6.2 Update service worker and Flutter.js loading if Flutter's web bootstrap changed
  - [ ] 6.3 Verify `flutter build web` succeeds

- [ ] Task 7: Update Windows platform configuration (AC: #1)
  - [ ] 7.1 Review `windows/CMakeLists.txt` for any required changes
  - [ ] 7.2 Check `windows/runner/flutter_window.cpp` for `ForceRedraw()` migration
  - [ ] 7.3 Verify `flutter build windows` succeeds (if on Windows)

- [ ] Task 8: Fix Dart 3 breaking changes in source code (AC: #2)
  - [ ] 8.1 Fix any classes used as mixins — add `mixin class` modifier or convert to `mixin`
  - [ ] 8.2 Run `dart fix --dry-run` first to preview all auto-fixable changes
  - [ ] 8.3 Run `dart fix --apply` to auto-fix deprecated API usage
  - [ ] 8.4 Fix `lib/src/presentation/control_hours/control_hours_page.dart:31`: replace `.withOpacity(.2)` with `.withValues(alpha: .2)` and `colorScheme.background` with `colorScheme.surface` (both deprecated in Flutter 3.22+/3.38+). This is the only Color API usage in the codebase
  - [ ] 8.5 Fix any named parameter default syntax (`:` → `=`)
  - [ ] 8.6 Fix any other Dart 3 compilation errors
  - [ ] 8.7 Verify localization generation still works: run `flutter gen-l10n` (project uses `generate: true` in pubspec.yaml)
  - [ ] 8.8 Run `flutter analyze` — resolve all errors (warnings from dependency upgrades may remain until stories 1.2-1.4)

- [ ] Task 9: Compilation and runtime verification (AC: #2, #3)
  - [ ] 9.1 Run `flutter analyze` — zero errors
  - [ ] 9.2 Run `flutter build apk` or `flutter build` for at least one platform — succeeds
  - [ ] 9.3 Run `flutter test` — should pass (no tests to fail, but test helpers and compilation must succeed)
  - [ ] 9.4 Launch app on a native platform (Android emulator or device preferred)
  - [ ] 9.5 Verify all three flavors compile: `main_development.dart`, `main_staging.dart`, `main_production.dart`
  - [ ] 9.6 Verify time entry CRUD works: create, view list, edit, delete
  - [ ] 9.7 Verify wage management works: view, update
  - [ ] 9.8 Verify payment calculation works: calculate, view summary
  - [ ] 9.9 Verify localization works: EN/ES strings display correctly

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

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
