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
  - [ ] 3.1 For each dependency that fails `pub get` due to SDK constraint `<3.0.0`, bump to the MINIMUM version supporting Dart 3 (not necessarily latest — major upgrades are stories 1.2-1.4)
  - [ ] 3.2 **ObjectBox**: Find the minimum ObjectBox version that compiles with Dart 3 (likely 2.x or 3.x) — do NOT jump to 5.x yet (Story 1.2 handles the full migration with schema/data verification)
  - [ ] 3.3 **flutter_hooks**: Check pub.dev for a Dart 3-compatible version. If NO Dart 3-compatible version exists, remove the dependency and replace all 5 HookWidget usages with StatefulWidget stubs (this work is planned for Story 2.5 anyway — doing the minimum here unblocks compilation)
  - [ ] 3.4 Move `build_runner`, `freezed`, `json_serializable` from `dependencies` to `dev_dependencies` (NFR9)
  - [ ] 3.5 Verify `flutter pub get` resolves successfully
  - [ ] 3.6 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate all `.freezed.dart` and `.g.dart` files

- [ ] Task 4: Update Android platform configuration (AC: #1)
  - [ ] 4.1 Update `android/build.gradle`: Kotlin version 1.7.10 → 1.8.0+, AGP 7.2.0 → 8.9.1+
  - [ ] 4.2 Update `android/gradle/wrapper/gradle-wrapper.properties`: Gradle 7.4 → 8.11.1+
  - [ ] 4.3 Update `android/app/build.gradle`: compileSdk → 35, targetSdk → 35, minSdk → 21, Java → JavaVersion.VERSION_17
  - [ ] 4.4 Migrate Gradle plugin application from imperative `apply plugin:` to declarative `plugins {}` block in `android/settings.gradle` if required by AGP version
  - [ ] 4.5 Verify `flutter build apk` succeeds

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
  - [ ] 8.4 Fix any named parameter default syntax (`:` → `=`)
  - [ ] 8.5 Fix any other Dart 3 compilation errors
  - [ ] 8.6 Verify localization generation still works: run `flutter gen-l10n` (project uses `generate: true` in pubspec.yaml)
  - [ ] 8.7 Run `flutter analyze` — resolve all errors (warnings from dependency upgrades may remain until stories 1.2-1.4)

- [ ] Task 9: Compilation and runtime verification (AC: #2, #3)
  - [ ] 9.1 Run `flutter analyze` — zero errors
  - [ ] 9.2 Run `flutter build apk` or `flutter build` for at least one platform — succeeds
  - [ ] 9.3 Launch app on a native platform (Android emulator or device preferred)
  - [ ] 9.4 Verify time entry CRUD works: create, view list, edit, delete
  - [ ] 9.5 Verify wage management works: view, update
  - [ ] 9.6 Verify payment calculation works: calculate, view summary
  - [ ] 9.7 Verify localization works: EN/ES strings display correctly

## Dev Notes

### Scope Boundaries — READ CAREFULLY

This story is ONLY about:
- Updating SDK constraint (Dart 2.19 → Dart 3.11+)
- Updating Flutter version (3.7.5 → 3.41+)
- Updating platform configurations (Android, iOS, Web, Windows)
- Fixing Dart 3 breaking changes for compilation
- Bumping dependencies to MINIMUM Dart 3-compatible versions for compilation

This story is NOT about:
- ObjectBox 1.7 → 5.x migration (Story 1.2)
- BLoC 8 → 9 or dartz → fpdart migration (Story 1.3)
- Freezed 2 → 3, very_good_analysis latest, or remaining deps (Story 1.4)
- Architecture restructuring (Epic 2)
- Sealed classes, pattern matching adoption (Epic 3)

### Critical Migration Strategy

This is a Dart 2.x → Dart 3.11+ migration spanning ~3 years of releases. The key challenge: many current dependencies have SDK constraint `<3.0.0` and will fail `flutter pub get` after the SDK constraint is raised.

**Resolution approach:**
1. Update SDK constraint first
2. Run `flutter pub get` — it WILL fail
3. For each failing dependency, find the MINIMUM version that supports Dart 3 (check pub.dev)
4. Bump only to that minimum version — the MAJOR version upgrades happen in stories 1.2-1.4
5. Regenerate all code-gen files
6. Fix Dart 3 syntax issues
7. Verify compilation

**If a dependency has no Dart 3-compatible version:** Document the issue and discuss with the team. This could impact the story scope.

### Dependency-Specific Compatibility Notes

**ObjectBox 1.7.2:** SDK constraint is `<3.0.0`. You MUST bump to an intermediate version (2.x/3.x/4.x) that supports Dart 3. Do NOT jump to 5.x — the full ObjectBox migration with schema verification and data integrity checks is Story 1.2. Find the minimum version on pub.dev that has `sdk: ">=3.0.0"` or similar, bump to that, regenerate `objectbox.g.dart` and `objectbox-model.json`, and verify the existing dev database (`test-1`) still loads.

**flutter_hooks 0.18.6:** This package may have NO Dart 3-compatible version. If pub.dev shows no version with `sdk: >=3.0.0`, remove the dependency entirely and convert all 5 `HookWidget` usages to `StatefulWidget`. This unblocks compilation. The formal flutter_hooks removal is Story 2.5, but if forced here, document it clearly in Completion Notes. The 5 HookWidget files are in `lib/src/presentation/`.

**dartz 0.10.1:** SDK constraint is `>=2.12.0 <3.0.0` — explicitly excludes Dart 3. Check if a newer dartz version supports Dart 3. If not, the replacement with fpdart (Story 1.3) may need to be pulled into this story as a blocker. As a last resort, fork/patch dartz locally.

### Localization Generation

The project uses `generate: true` in `pubspec.yaml` which triggers Flutter's built-in `flutter gen-l10n`. After the SDK upgrade, verify:
- `flutter gen-l10n` runs without errors
- Generated `app_localizations.dart` files are still valid
- EN/ES `.arb` files are still processed correctly

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
  dartz: ^0.10.1
  objectbox: ^1.7.2
  objectbox_flutter_libs: ^1.7.2
  flutter_hooks: ^0.18.6
  path_provider: ^2.0.13
  path: ^1.8.2

dev_dependencies:
  bloc_test: ^9.1.1
  mocktail: ^0.3.0
  objectbox_generator: ^1.7.2
  very_good_analysis: ^4.0.0
```

**Dependencies to move to dev_dependencies (NFR9):** `build_runner`, `freezed`, `json_serializable`

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

1. **Mixin changes**: Classes used with `with` keyword must be declared as `mixin class` or `mixin`. Check all `with` clauses in the codebase.

2. **Named parameter defaults**: Only `=` is allowed (`:` syntax removed). Unlikely in this codebase but verify.

3. **Deprecated Flutter APIs removed across versions 3.7→3.41:**
   - `ThemeData.accentColor` → use `ColorScheme`
   - `SystemChrome.setEnabledSystemUIOverlays` → use `setEnabledSystemUIMode`
   - Multiple widget/theme deprecations across 3.10, 3.13, 3.16, 3.19 releases
   - Run `dart fix --apply` to auto-fix many of these

4. **Material 3 default** (Flutter 3.16+): `ThemeData.useMaterial3` defaults to `true`. The project already sets `useMaterial3: true` — no change needed.

5. **Color API changes** (Flutter 3.38+): Float-based accessors (`.r`/`.g`/`.b`/`.a`) and `withValues()` replace `red`/`green`/`blue`/`opacity`/`withOpacity()`. Check for any Color API usage.

6. **Impeller rendering engine**: Now default on iOS and Android. May cause subtle visual differences — verify UI looks correct.

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

**Option B (manual):** Follow Flutter's migration guide at [Deprecated Imperative Apply of Flutter's Gradle Plugins](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply).

### Android Gradle Migration Steps

1. Update `android/settings.gradle` to use `plugins {}` block with `id "com.android.application"` and `id "org.jetbrains.kotlin.android"`
2. Remove `buildscript` block from `android/build.gradle`
3. Remove `apply plugin:` lines from `android/app/build.gradle`
4. Update `android/gradle/wrapper/gradle-wrapper.properties` to Gradle 8.11.1+
5. **CRITICAL:** Re-verify all three build flavors (development, staging, production) and application IDs are preserved after migration
6. **CRITICAL:** Preserve flavor-specific application ID suffixes (`.dev`, `.stg`)

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

### Files That Import dartz (will need minimum Dart 3-compatible dartz version)

1. `lib/src/features/times/domain/times_repository.dart`
2. `lib/src/features/times/infraestructure/i_times_objectbox_repository.dart`
3. `lib/src/features/wage_hourly/domain/wage_hourly_repository.dart`
4. `lib/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`

### Testing During This Story

- No new tests required in this story — test infrastructure exists but no tests are implemented yet
- Existing test helpers (`test/helpers/pump_app.dart`) must still compile after migration
- Run `flutter test` — should pass (no tests to fail, but compilation must succeed)

### Project Structure Notes

- Alignment: This story touches pubspec.yaml, platform configs, and possibly source files for Dart 3 syntax fixes
- No architecture changes — folder structure remains identical
- All three build flavors (development, staging, production) must be preserved
- Generated files (`.freezed.dart`, `.g.dart`, `objectbox.g.dart`) will be regenerated via `build_runner`

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
