# Story 4.5: Multi-Platform Verification & Localization Validation

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want the app to work identically on iOS, Android, Web, and Windows with full bilingual support,
so that I can use TimeMoney on any platform in my preferred language (FR15-FR23, FR30).

## Acceptance Criteria

1. **AC1 — iOS Platform Verification:** Given the multi-datasource architecture is complete, when the app is built and launched on iOS, then all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR20), and iOS deployment target supports iOS 13+ (NFR12).

2. **AC2 — Android Platform Verification:** Given the app is built for Android, when launched on an Android device or emulator, then all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR21), and Android minimum SDK supports API 21+ (NFR13).

3. **AC3 — Web Platform Verification:** Given the app is built for Web, when launched in Chrome, Firefox, or Safari, then all FR1-FR17 capabilities function correctly using the drift datasource (FR22), and data persists via OPFS across browser sessions (NFR14), and CRUD operations complete within 2x the latency of native operations (NFR5).

4. **AC4 — Windows Platform Verification:** Given the app is built for Windows, when launched on Windows 10+, then all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR23), and Windows build targets MSVC toolchain (NFR15).

5. **AC5 — English Localization:** Given localization is configured with EN/ES ARB files, when the app is used in English, then all interface text displays in English (FR15), and zero hardcoded strings exist — all text uses `context.l10n` pattern (FR17).

6. **AC6 — Spanish Localization:** Given localization is configured, when the app language is switched to Spanish, then all interface text displays in Spanish (FR16), and zero hardcoded strings exist (FR17).

7. **AC7 — Cold Start Performance:** Given the app is cold-started on any platform, when measuring time from launch to interactive main screen, then the app is interactive within 2 seconds (NFR3).

8. **AC8 — Cross-Platform Parity:** Given all platform and localization verification is complete, when comparing functionality across all four platforms, then all platforms pass identical functional verification with zero platform-specific failures (NFR20).

## Tasks / Subtasks

- [ ] Task 1: Extract all hardcoded strings to ARB files (AC: #5, #6)
  - [ ] 1.1 Audit all 41 hardcoded strings across 19 presentation files (see Dev Notes for complete inventory)
  - [ ] 1.2 Define semantic ARB keys in `app_en.arb` for all user-facing strings
  - [ ] 1.3 Add all Spanish translations in `app_es.arb`
  - [ ] 1.4 Run `flutter gen-l10n` to regenerate `AppLocalizations`
  - [ ] 1.5 Fix typos: "Horly" → "Hourly", "Dolars" → "Dollars", "There is no times" → "There are no times"
- [ ] Task 2: Replace all hardcoded strings with `context.l10n` calls (AC: #5, #6)
  - [ ] 2.1 Update Home feature files (home_page.dart, calculate_payment_button.dart)
  - [ ] 2.2 Update Times feature files (create_time_page.dart, update_time_page.dart, list_times_page.dart, create_time_card.dart, custom_create_field.dart, custom_update_field.dart, create_time_button.dart, update_time_button.dart, delete_time_button.dart, list_times_other_view.dart)
  - [ ] 2.3 Update Wage feature files (update_wage_page.dart, fetch_wage_page.dart, wage_hourly_field.dart, wage_hourly_info.dart, set_wage_button.dart, update_wage_button.dart)
  - [ ] 2.4 Update Payment feature files (payment_result_page.dart)
  - [ ] 2.5 Remove placeholder `counterAppBarTitle` key from both ARB files
- [ ] Task 3: Update existing tests for localization changes (AC: #5, #8)
  - [ ] 3.1 Verify `pump_app.dart` helper already provides localization delegates (it does — no changes needed)
  - [ ] 3.2 Update any widget tests that assert hardcoded string values to use localized equivalents
  - [ ] 3.3 Run full test suite — all 157+ existing tests must pass
- [ ] Task 4: Multi-platform build verification (AC: #1, #2, #3, #4, #7, #8)
  - [ ] 4.1 Verify `flutter build ios` compiles with zero errors (iOS 13+ deployment target)
  - [ ] 4.2 Verify `flutter build apk` compiles with zero errors (API 21+ minSdk)
  - [ ] 4.3 Verify `flutter build web` compiles with zero errors
  - [ ] 4.4 Verify `flutter build windows` compiles with zero errors (MSVC toolchain)
  - [ ] 4.5 Verify `flutter analyze` returns zero warnings across entire project
  - [ ] 4.6 Verify `flutter test` passes with zero failures
- [ ] Task 5: Localization validation on running app (AC: #5, #6, #7)
  - [ ] 5.1 Verify all strings render correctly in English
  - [ ] 5.2 Verify all strings render correctly in Spanish
  - [ ] 5.3 Verify no hardcoded string literals remain in presentation layer (grep audit)

## Dev Notes

### What This Story IS

Full localization implementation (extracting 41 hardcoded strings to ARB, replacing with `context.l10n`) + multi-platform build verification. This is the final story in Epic 4 — after this, the app has dual-datasource (ObjectBox + drift), platform-aware DI, bilingual support, and verified builds on all 4 platforms.

### What This Story IS NOT

- NOT creating new features, BLoCs, repositories, or datasources
- NOT modifying business logic, state management, or DI wiring
- NOT adding new platform support (all 4 platforms already configured)
- NOT writing new unit/BLoC tests for business logic (those are complete from stories 4.1-4.4)

### Current Codebase State

- **157 tests passing** from Epics 1-4.4
- **Platform-aware DI** via `kIsWeb` in `bootstrap.dart` (story 4.4)
- **Drift infrastructure** complete: `AppDatabase`, drift datasources/repositories for times + wage (stories 4.1-4.3)
- **ObjectBox infrastructure** complete: ObjectBox datasources/repositories for times + wage (Epics 2-3)
- **Localization infrastructure** exists but is **effectively unused**:
  - `l10n.yaml` configured correctly
  - `lib/l10n/l10n.dart` has `context.l10n` extension
  - `app.dart` has localization delegates + supported locales
  - `pump_app.dart` test helper includes localization
  - But only 1 placeholder ARB key exists (`counterAppBarTitle` — unused in app)
  - **Zero `context.l10n` calls anywhere in presentation layer**
  - **41 hardcoded English strings across 19 presentation files**

### Complete Hardcoded String Inventory

**Home Feature (3 strings, 2 files):**

| File | String | ARB Key Suggestion |
|------|--------|--------------------|
| `home_page.dart` | `'Work Payment Controller'` | `homeTitle` |
| `home_page.dart` | `'Add Time'` | `addTime` |
| `calculate_payment_button.dart` | `'Calculate Payment'` | `calculatePayment` |

**Times Feature (17 strings, 10 files):**

| File | String | ARB Key Suggestion |
|------|--------|--------------------|
| `create_time_page.dart` | `'Create Time:'` | `createTimeTitle` |
| `update_time_page.dart` | `'Update or Delete:'` | `updateOrDeleteTitle` |
| `list_times_page.dart` | `'error'` | `error` |
| `create_time_card.dart` | `'Create Time:'` | `createTimeTitle` (reuse) |
| `custom_create_field.dart` | `'$title:'` | Parameterize: `fieldLabel(title)` |
| `custom_update_field.dart` | `'$title:'` | Parameterize: `fieldLabel(title)` |
| `create_time_button.dart` | `'Create'`, `'Success'`, `'Error'` | `create`, `success`, `error` |
| `update_time_button.dart` | `'Update'`, `'Success'`, `'Error'` | `update`, `success`, `error` |
| `delete_time_button.dart` | `'Delete'`, `'Success'`, `'Error'` | `delete`, `success`, `error` |
| `list_times_other_view.dart` | `'Empty List...\nThere is no times to calculate'` | `emptyTimesMessage` |
| `list_times_other_view.dart` | `'🕰️'` | Keep as-is (emoji, not localizable) |

**Wage Feature (7 strings, 6 files):**

| File | String | ARB Key Suggestion |
|------|--------|--------------------|
| `update_wage_page.dart` | `'Update Horly pay:'` | `updateHourlyPayTitle` (FIX TYPO) |
| `fetch_wage_page.dart` | `'error'` | `error` (reuse) |
| `wage_hourly_field.dart` | `'hourly:'` | `hourlyLabel` |
| `wage_hourly_info.dart` | `'hourly:'` | `hourlyLabel` (reuse) |
| `set_wage_button.dart` | `'Update'`, `'Success'`, `'Error'` | Reuse `update`, `success`, `error` |
| `update_wage_button.dart` | `'change'` | `change` |

**Payment Feature (7 strings, 1 file):**

| File | String | ARB Key Suggestion |
|------|--------|--------------------|
| `payment_result_page.dart` | `'Result Info:'` | `resultInfoTitle` |
| `payment_result_page.dart` | `'Hours:'` | `hoursLabel` |
| `payment_result_page.dart` | `'Minutes:'` | `minutesLabel` |
| `payment_result_page.dart` | `'Hourly:'` | `hourlyLabel` (reuse) |
| `payment_result_page.dart` | `' Dolars'` | `dollarsLabel` (FIX TYPO) |
| `payment_result_page.dart` | `'Worked days:'` | `workedDaysLabel` |
| `payment_result_page.dart` | `'Save'` | `save` |

### Known Typos to Fix

1. `'Update Horly pay:'` → `'Update Hourly Pay:'` in `update_wage_page.dart`
2. `' Dolars'` → `' Dollars'` in `payment_result_page.dart`
3. `'There is no times to calculate'` → `'There are no times to calculate'` in `list_times_other_view.dart`

### ARB Key Design Guidelines

- Use camelCase keys: `homeTitle`, `addTime`, `calculatePayment`
- Reuse common keys: `success`, `error`, `update`, `delete`, `create`
- For parameterized strings like `'$title:'`, use ARB placeholders: `"fieldLabel": "{title}:", "placeholders": { "title": { "type": "String" } }`
- Remove the unused `counterAppBarTitle` key
- Estimated total unique ARB keys: ~25-30 (many strings reuse common words)

### File Paths for Presentation Layer

All under `lib/src/features/`:

```
home/presentation/pages/home_page.dart
home/presentation/widgets/calculate_payment_button.dart
times/presentation/pages/create_time_page.dart
times/presentation/pages/update_time_page.dart
times/presentation/pages/list_times_page.dart
times/presentation/widgets/create_time_card.dart
times/presentation/widgets/custom_create_field.dart
times/presentation/widgets/custom_update_field.dart
times/presentation/widgets/create_time_button.dart
times/presentation/widgets/update_time_button.dart
times/presentation/widgets/delete_time_button.dart
times/presentation/widgets/list_times_other_view.dart
wage/presentation/pages/update_wage_page.dart
wage/presentation/pages/fetch_wage_page.dart
wage/presentation/widgets/wage_hourly_field.dart
wage/presentation/widgets/wage_hourly_info.dart
wage/presentation/widgets/set_wage_button.dart
wage/presentation/widgets/update_wage_button.dart
payment/presentation/pages/payment_result_page.dart
```

### Localization Implementation Pattern

Every widget that displays text needs `context.l10n`:

```dart
// BEFORE (hardcoded):
Text('Create Time:')

// AFTER (localized):
Text(context.l10n.createTimeTitle)
```

Import required in each file:
```dart
import 'package:time_money/l10n/l10n.dart';
```

For parameterized strings:
```dart
// BEFORE:
Text('$title:')

// AFTER:
Text(context.l10n.fieldLabel(title))
```

### Testing Considerations

- `pump_app.dart` already wraps with localization delegates — existing tests should pass after migration
- Widget tests that `find.text('Create')` must change to `find.text(tester.l10n.create)` or use the English fallback
- No new test files required — this is a presentation-layer refactor
- All 157 existing tests must pass with zero regressions after changes

### Anti-Patterns to AVOID

1. Do NOT use `Localizations.of(context)` directly — use the `context.l10n` extension
2. Do NOT create a separate localization helper class — `l10n.dart` extension already exists
3. Do NOT hardcode locale strings like `'en'` or `'es'` — use `AppLocalizations.supportedLocales`
4. Do NOT localize emoji characters (🕰️) — they are universal
5. Do NOT modify domain layer, data layer, BLoCs, or DI wiring
6. Do NOT add new dependencies — `intl` and `flutter_localizations` are already in pubspec.yaml
7. Do NOT create number formatting localization (currency symbols, decimal separators) — out of scope for this story
8. Do NOT use `package:flutter/material.dart` for localization — use `package:time_money/l10n/l10n.dart`

### Platform Build Commands

```bash
# iOS (requires macOS with Xcode)
flutter build ios --no-codesign

# Android
flutter build apk

# Web
flutter build web

# Windows (requires Windows with MSVC)
flutter build windows

# Analysis (all platforms)
flutter analyze

# Tests
flutter test --coverage --test-randomize-ordering-seed random
```

### Project Structure Notes

- All localization files in `lib/l10n/` — ARB files in `arb/`, generated files in `gen/`
- Config in `l10n.yaml` at project root
- `context.l10n` extension in `lib/l10n/l10n.dart`
- App localization delegates configured in `lib/app/view/app.dart`
- Test helper in `test/helpers/pump_app.dart` already includes localization support
- No conflicts with unified project structure

### Functional Requirements Addressed

| FR | Description | How Addressed |
|---|---|---|
| FR15 | App usable in English | All strings extracted to `app_en.arb`, rendered via `context.l10n` |
| FR16 | App usable in Spanish | All strings translated in `app_es.arb`, rendered via `context.l10n` |
| FR17 | Zero hardcoded strings | All 41 hardcoded strings replaced with `context.l10n` calls |
| FR20 | iOS with all FR1-FR17 capabilities | Build verification + localization on iOS |
| FR21 | Android with all FR1-FR17 capabilities | Build verification + localization on Android |
| FR22 | Web with all FR1-FR17 capabilities | Build verification + localization on Web |
| FR23 | Windows with all FR1-FR17 capabilities | Build verification + localization on Windows |
| FR30 | ObjectBox supports iOS, Android, Windows | Platform verification confirms ObjectBox on native platforms |

### NFR Requirements Addressed

| NFR | Description | How Verified |
|---|---|---|
| NFR3 | Cold start < 2 seconds | Manual verification on each platform |
| NFR5 | Web CRUD within 2x native latency | Manual verification on web build |
| NFR12 | iOS 13+ deployment target | Build configuration check |
| NFR13 | Android API 21+ minSdk | Build configuration check |
| NFR14 | Chrome 86+, Firefox 111+, Safari 15.2+ | Web build verification |
| NFR15 | Windows 10+ / MSVC toolchain | Windows build verification |
| NFR20 | Identical functional tests across platforms | `flutter test` passes with zero failures |

### Previous Story Intelligence (Story 4.4)

**Key learnings:**
- `kIsWeb` requires explicit `import 'package:flutter/foundation.dart' show kIsWeb;` — Flutter 3.41 limitation
- Clean refactors following established patterns yield zero actionable code review findings
- `bootstrap.dart` now handles platform-aware DI — do NOT touch it in this story
- All 3 entry points are single-line delegations to `bootstrap(dbName: ...)` — do NOT modify
- `app_bloc.dart` is interface-based and platform-unaware — do NOT modify

**Files modified in 4.4 (do NOT touch):**
- `lib/bootstrap.dart`
- `lib/main_development.dart`
- `lib/main_staging.dart`
- `lib/main_production.dart`

### Git Intelligence

Recent commit pattern: `feat:` for implementations, `docs:` for story/review docs. Story 4.4 was the last implementation — platform-aware DI. All Epic 4 infrastructure (drift DB, datasources, repositories, DI) is complete. This story is the validation/polish layer.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 4, Story 4.5]
- [Source: _bmad-output/planning-artifacts/architecture.md#Localization FR15-FR17]
- [Source: _bmad-output/planning-artifacts/architecture.md#Multi-Platform FR20-FR24]
- [Source: _bmad-output/planning-artifacts/architecture.md#Performance NFR1-NFR5]
- [Source: _bmad-output/planning-artifacts/prd.md#Localization, Multi-Platform, Reliability]
- [Source: _bmad-output/implementation-artifacts/4-4-platform-aware-di-multi-environment-configuration.md]
- [Source: _bmad-output/project-context.md]

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
