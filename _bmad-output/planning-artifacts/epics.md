---
stepsCompleted:
  - 'step-01-validate-prerequisites'
  - 'step-02-design-epics'
  - 'step-03-create-stories'
  - 'step-04-final-validation'
status: 'complete'
completedAt: '2026-03-17'
inputDocuments:
  - 'planning-artifacts/prd.md'
  - 'planning-artifacts/architecture.md'
epicCount: 6
storyCount: 25
frCoverage: '53/53'
---

# TimeMoney - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for TimeMoney, decomposing the requirements from the PRD and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: User can create a new time entry by specifying hours and minutes
FR2: User can view a real-time list of all recorded time entries
FR3: User can edit an existing time entry with pre-populated current values
FR4: User can delete an existing time entry
FR5: User can see visual feedback (loading, success, error) for every create, update, and delete action
FR6: User can see the time entry list update automatically when data changes without manual refresh
FR7: User can view the current hourly wage rate
FR8: User can set an initial hourly wage rate (default: $15.00)
FR9: User can update the hourly wage rate
FR10: User can see the wage value update in real time without manual refresh
FR11: User can see visual feedback (loading, success, error) for wage update actions
FR12: User can calculate total payment based on all recorded time entries and the current hourly wage
FR13: User can view a payment summary showing total hours, total minutes, hourly rate, and total payment amount
FR14: System computes payment using the formula: (total duration in minutes / 60) * hourly wage
FR15: User can use the app in English
FR16: User can use the app in Spanish
FR17: User can see all interface text in their selected language — no hardcoded strings in the codebase
FR18: System compiles and runs on Flutter 3.41+ / Dart 3.11+ with zero compilation errors
FR19: Dart 2.x SDK constraint is replaced with Dart 3.11+ constraint and all source files compile under the new SDK
FR20: User can run the app on iOS with all FR1-FR17 capabilities functional
FR21: User can run the app on Android with all FR1-FR17 capabilities functional
FR22: User can run the app on Web with all FR1-FR17 capabilities functional using the web-compatible datasource
FR23: User can run the app on Windows with all FR1-FR17 capabilities functional
FR24: System selects the appropriate datasource implementation based on the target platform automatically — mobile/desktop datasource for native platforms, web datasource for browser
FR25: Developer can run the app in Development environment with isolated database (test-1)
FR26: Developer can run the app in Staging environment with isolated database (stg-1)
FR27: Developer can run the app in Production environment with isolated database (prod-1)
FR28: System persists all time entries and wage data locally on-device
FR29: System provides reactive data streams for both datasource implementations (mobile/desktop and web)
FR30: Mobile and desktop datasource (ObjectBox) supports iOS, Android, and Windows platforms
FR31: Web datasource (drift) supports the Web platform with local persistence
FR32: Both datasource implementations conform to shared Repository interfaces ensuring interchangeability
FR33: Codebase follows feature-first organization where each feature contains all layers (domain, application, infrastructure, presentation)
FR34: Domain layer has zero external dependencies — entities and repository interfaces only
FR35: Application layer contains use cases implementing single-responsibility operations
FR36: Infrastructure layer contains concrete repository implementations and database entities
FR37: Presentation layer contains BLoCs, views, and widgets scoped to their feature
FR38: Shared cross-cutting concerns (failures, services, extensions) reside in a core module
FR39: Dependency injection follows three-tier pattern: Repositories → Use Cases → BLoCs via BLoC-native providers
FR40: All BLoCs use sealed classes for events and states with exhaustive pattern matching
FR41: Domain data classes support copyWith, equality, and JSON serialization via code generation
FR42: All BLoCs follow the standard state pattern: initial, loading, error, success/data
FR43: BLoCs with stream data provide a hasDataStream state for reactive UI rendering
FR44: Payment calculation derives computed state from times list and wage data without user-initiated events
FR45: Unit tests cover all use cases and repository implementations
FR46: BLoC tests cover all state management logic using dedicated BLoC testing utilities
FR47: Widget tests cover presentation layer components
FR48: Golden tests verify zero visual regression across the modernization
FR49: All tests are runnable via `flutter test` with coverage reporting
FR50: CI pipeline runs linting, testing, and coverage reporting on every PR
FR51: CI pipeline verifies builds for all four target platforms
FR52: README contains project overview, architecture diagram, setup instructions, and contribution guide — scannable within 30 seconds
FR53: Each commit message follows conventional commit format (type: description) and references the scope item or migration step it implements

### NonFunctional Requirements

NFR1: All user actions (create, update, delete time entry; update wage) must complete and reflect in the UI within 500ms, excluding the intentional ActionState feedback delay, as measured by widget test timing assertions
NFR2: Reactive data streams must propagate changes to the UI within 100ms of the underlying data mutation, as measured by BLoC test timing
NFR3: App cold start (from launch to interactive main screen) must complete within 2 seconds on target platforms, as measured by Flutter DevTools timeline
NFR4: Payment calculation must execute in under 50ms regardless of the number of time entries, as measured by unit test benchmarks
NFR5: Web datasource CRUD operations must complete within 2x the latency of mobile/desktop datasource operations at the expected data scale (< 1000 entries), as measured by integration test timing on equivalent hardware
NFR6: Zero linter warnings on all non-generated Dart code under strict analysis rules (latest recommended ruleset)
NFR7: Zero unused imports, unused variables, or dead code in the final codebase
NFR8: All public API surfaces follow consistent naming conventions: snake_case files, PascalCase classes, correct layer suffixes (_bloc, _cubit, _use_case, _repository, _view)
NFR9: No dependency placed in the wrong section — code generation tools and build-time-only packages must be in dev_dependencies, not regular dependencies
NFR10: All barrel export files are clean — no circular exports, no re-exports of private APIs
NFR11: All generated files are excluded from static analysis and never manually edited
NFR12: iOS deployment target supports iOS 13+ (or minimum required by Flutter 3.41+)
NFR13: Android minimum SDK supports API 21+ (or minimum required by Flutter 3.41+)
NFR14: Web build functions correctly on modern browsers: Chrome 86+, Firefox 111+, Safari 15.2+ (OPFS required for web datasource persistence)
NFR15: Windows build targets Windows 10+ with MSVC toolchain
NFR16: All dependencies are at their latest stable versions as of 2026 with no deprecated API usage
NFR17: Zero data loss — all CRUD operations must persist reliably across app restarts on every platform
NFR18: ObjectBox 1.7→5.x database migration must preserve all existing dev/staging/production data without manual intervention
NFR19: Error handling must catch all exceptions at the infrastructure layer and return typed failures — no unhandled exceptions propagate to the UI
NFR20: All four platforms must pass identical functional test suites with zero platform-specific failures
NFR21: CI pipeline must complete successfully (lint + test + build for all platforms) before any code is merged to main

### Additional Requirements

- In-place modernization approach (no re-scaffolding) — existing codebase is the starting point, evolving through sequential, verifiable steps
- SDK constraint must be raised first (Dart 2.x → 3.11+) before any other migration work
- ObjectBox 1.7→5.x migration must follow SDK upgrade — verify schema/API changes and test against existing dev database
- BLoC 8.x→9.x requires Dart 3 sealed classes — must be done after SDK migration
- Freezed 2.x→3.x has breaking codegen changes — all .freezed.dart and .g.dart files must be regenerated at intermediate steps
- All generated files must be regenerated at intermediate steps with compilation verification
- Architecture restructure must happen after dependencies are stable
- Testing must come after code is in final architecture
- CI/CD, cleanup, and README are final polish steps
- Platform-aware DI via `kIsWeb` from `dart:foundation` — compile-time constant enabling tree-shaking
- ObjectBox Store and drift AppDatabase initialized centrally in `core/services/`
- Feature datasources receive references (Box/Table) via constructor injection
- drift single AppDatabase with TimesTable and WageHourlyTable in `core/`
- Environment-aware database naming for both ObjectBox and drift (test-1, stg-1, prod-1)
- Layer naming: Data / Domain / Presentation (not infrastructure/aplication — correct folder spellings)
- Cross-feature composition: `home` feature (shell) + `payment` feature (calculation logic, no Data layer)
- ActionState migrated to sealed class in `core/ui/`
- BLoC consumes streams internally via `emit.forEach` — no StreamBuilder in UI
- ActionFeedback delay preserved at 400ms with `abstract final class AppDurations`
- GlobalFailure + ValueFailure modernized to sealed classes (consistent with BLoC pattern)
- Golden tests scope: HomePage (data + empty states), PaymentResultPage, CRUD dialogs
- Test coverage targets: Use Cases 100%, BLoCs/Cubits 100%, Repository Implementations 100%, Widgets 80%+, Overall floor 85%+
- Test helpers: pump_app.dart (pumpApp with localization + providers) and mocks.dart (shared mock classes via mocktail)
- very_good_analysis latest (~v10.0.0) with generated file exclusions
- CI pipeline: lint + test + coverage + build for 4 platforms via GitHub Actions
- Dependabot configured for daily updates: github-actions + pub
- flutter_hooks removal — replace 5 HookWidgets with StatefulWidget
- Absolute imports exclusively: `package:time_money/...` — linter enforces, no relative imports
- `final class` for all concrete sealed class variants
- `const` constructors wherever possible
- `switch` expressions for state rendering — never if/else chains on state types
- Repository methods always return `Either<GlobalFailure, T>` — never throw

### UX Design Requirements

No UX Design document exists — UI/UX redesign is explicitly out of scope per the PRD. Visual design remains as-is.

### FR Coverage Map

FR1: Epic 3 — Time entry creation modernized with sealed class BLoC pattern
FR2: Epic 3 — Time entry list with emit.forEach reactive stream consumption
FR3: Epic 3 — Time entry edit with pre-populated values via modern state pattern
FR4: Epic 3 — Time entry delete with sealed class ActionState feedback
FR5: Epic 3 — Visual feedback (loading/success/error) via ActionState sealed class
FR6: Epic 3 — Automatic list update via emit.forEach stream subscription
FR7: Epic 3 — Wage display with FetchWageBloc sealed states
FR8: Epic 3 — Initial wage setting with SetWageUseCase
FR9: Epic 3 — Wage update with UpdateWageBloc sealed class pattern
FR10: Epic 3 — Real-time wage update via emit.forEach stream
FR11: Epic 3 — Wage action feedback via ActionState sealed class
FR12: Epic 3 — Payment calculation with PaymentCubit and CalculatePaymentUseCase
FR13: Epic 3 — Payment summary display on PaymentResultPage
FR14: Epic 3 — Payment formula implementation in CalculatePaymentUseCase
FR15: Epic 4 — English localization verified on modernized codebase
FR16: Epic 4 — Spanish localization verified on modernized codebase
FR17: Epic 4 — Zero hardcoded strings via context.l10n pattern
FR18: Epic 1 — Flutter 3.41+ / Dart 3.11+ compilation with zero errors
FR19: Epic 1 — Dart 3.11+ SDK constraint replacing Dart 2.x
FR20: Epic 4 — iOS platform verified with ObjectBox datasource
FR21: Epic 4 — Android platform verified with ObjectBox datasource
FR22: Epic 4 — Web platform functional with drift datasource
FR23: Epic 4 — Windows platform verified with ObjectBox datasource
FR24: Epic 4 — Platform-aware datasource selection via kIsWeb in DI
FR25: Epic 4 — Development environment with isolated database (test-1)
FR26: Epic 4 — Staging environment with isolated database (stg-1)
FR27: Epic 4 — Production environment with isolated database (prod-1)
FR28: Epic 4 — Local on-device persistence via ObjectBox and drift
FR29: Epic 4 — Reactive data streams for both datasource implementations
FR30: Epic 4 — ObjectBox datasource supports iOS, Android, Windows
FR31: Epic 4 — drift datasource supports Web with WASM + OPFS
FR32: Epic 4 — Both datasources conform to shared Repository interfaces
FR33: Epic 2 — Feature-first organization with all layers per feature
FR34: Epic 2 — Domain layer with zero external dependencies
FR35: Epic 2 — Application layer with single-responsibility use cases
FR36: Epic 2 — Infrastructure layer with concrete repository implementations
FR37: Epic 2 — Presentation layer with BLoCs/widgets scoped to feature
FR38: Epic 2 — Core module with shared cross-cutting concerns
FR39: Epic 2 — Three-tier DI pattern via BLoC-native providers
FR40: Epic 3 — Sealed classes for all BLoC events and states
FR41: Epic 3 — Domain data classes with Freezed 3.x (copyWith, equality, JSON)
FR42: Epic 3 — Standard BLoC state pattern (initial/loading/error/success)
FR43: Epic 3 — hasDataStream state for reactive UI rendering in stream BLoCs
FR44: Epic 3 — Payment computed state derived from times + wage without user events
FR45: Epics 3+4 — Unit tests for use cases and repositories written alongside implementation (3.2-3.5, 4.2-4.3)
FR46: Epic 3 — BLoC tests for all state management logic written alongside BLoC migration (3.2-3.5)
FR47: Epic 5 — Widget tests for presentation layer components (5.1, 5.2)
FR48: Epic 5 — Golden tests for zero visual regression verification (5.3)
FR49: Epic 5 — All tests runnable via flutter test with coverage reporting and overall floor validation (5.3)
FR50: Epic 6 — CI pipeline with linting, testing, coverage on every PR
FR51: Epic 6 — CI build verification for all four target platforms
FR52: Epic 6 — Professional README (overview, architecture, setup, contribution)
FR53: Epic 6 — Conventional commit format throughout migration history

## Epic List

### Epic 1: Foundation — SDK & Dependency Modernization
The app compiles and runs on Flutter 3.41+ / Dart 3.11+ with all dependencies upgraded to latest stable versions. Zero functional regressions — all existing features continue working identically. This is the foundation that enables every subsequent modernization epic.
**FRs covered:** FR18, FR19
**NFRs addressed:** NFR16 (latest dependencies), NFR18 (ObjectBox migration preserves data)

### Epic 2: Architecture — Feature-First Restructure
The codebase follows true feature-first Clean Architecture with Data/Domain/Presentation layers inside each feature. Folder spellings corrected. Presentation moved into features. flutter_hooks removed. Core module houses cross-cutting concerns. Daniel sees enterprise-grade structure, Sofía can study the organization.
**FRs covered:** FR33, FR34, FR35, FR36, FR37, FR38, FR39
**NFRs addressed:** NFR8 (naming conventions), NFR9 (correct dependency placement), NFR10 (clean barrel exports)

### Epic 3: Modernization — State Management, Business Logic & Core Tests
All business features (time entry CRUD, wage management, payment calculation) use modern Dart 3 patterns. BLoC events/states migrated to sealed classes with exhaustive pattern matching. ActionState, GlobalFailure, ValueFailure modernized to sealed classes. emit.forEach for stream consumption. switch expressions in widget rendering. Freezed 3.x for domain entities. Test infrastructure established. Unit tests and BLoC tests written alongside implementation — BMad aligned. Daniel sees senior-level code quality, Sofía learns transferable patterns.
**FRs covered:** FR1-FR14, FR40, FR41, FR42, FR43, FR44, FR45 (partial — use cases + ObjectBox repositories), FR46 (BLoC tests)
**NFRs addressed:** NFR1 (UI response <500ms), NFR2 (stream propagation <100ms), NFR4 (payment calc <50ms), NFR19 (typed failures)

### Epic 4: Platform — Multi-Datasource, Multi-Platform & Localization
drift datasource implemented for web platform. ObjectBox datasources modernized in new architecture. Platform-aware DI via kIsWeb. All four platforms (iOS, Android, Web, Windows) verified with full FR1-FR17 functionality. Multi-environment support (dev/staging/prod) with isolated databases for both datasources. EN/ES localization verified on modernized codebase. drift datasource and repository tests written alongside implementation — BMad aligned.
**FRs covered:** FR15, FR16, FR17, FR20, FR21, FR22, FR23, FR24, FR25, FR26, FR27, FR28, FR29, FR30, FR31, FR32, FR45 (partial — drift repositories)
**NFRs addressed:** NFR3 (cold start <2s), NFR5 (web datasource within 2x native), NFR12-NFR15 (platform compatibility), NFR17 (zero data loss), NFR20 (identical test suites across platforms)

### Epic 5: Quality — Widget Tests, Golden Tests & Coverage Validation
Widget tests for presentation layer components (80%+ coverage) split by feature scope: data features (times, wage) in Story 5.1 and composition features (home, payment, shared) in Story 5.2. Golden tests for visual regression proof (HomePage, PaymentResultPage, CRUD dialogs) in Story 5.3. Coverage gap validation ensuring overall floor 85%+. Unit and BLoC tests were already written alongside implementation in Epics 3-4 — this epic completes the testing pyramid with presentation-layer and visual regression coverage.
**FRs covered:** FR47, FR48, FR49
**NFRs addressed:** NFR6 (zero linter warnings), NFR7 (zero dead code), NFR11 (generated files excluded from analysis), NFR20 (identical suites across platforms)

### Epic 6: Polish — CI/CD Pipeline & Professional Documentation
GitHub Actions pipeline with linting, testing, coverage reporting, and build verification for all four platforms. Professional README scannable in 30 seconds. Dependabot for automated dependency updates. Code quality final cleanup (zero orphaned code, clean exports). The project is presentation-ready as portfolio piece and open-source reference.
**FRs covered:** FR50, FR51, FR52, FR53
**NFRs addressed:** NFR6 (zero warnings final pass), NFR7 (zero dead code final pass), NFR21 (CI gate before merge)

## Epic 1: Foundation — SDK & Dependency Modernization

The app compiles and runs on Flutter 3.41+ / Dart 3.11+ with all dependencies upgraded to latest stable versions. Zero functional regressions — all existing features continue working identically. This is the foundation that enables every subsequent modernization epic.

### Story 1.1: SDK Constraint & Flutter/Dart Version Migration

As a developer,
I want to upgrade the SDK constraint from Dart 2.x to Dart 3.11+ and Flutter to 3.41+,
So that the codebase runs on a current, supported SDK and enables all modern Dart 3 language features.

**Acceptance Criteria:**

**Given** the existing pubspec.yaml has SDK constraint `>=2.19.0 <3.0.0`
**When** the SDK constraint is updated to `>=3.11.0 <4.0.0` and Flutter is upgraded to 3.41+ stable
**Then** `flutter --version` reports Flutter 3.41+ and Dart 3.11+
**And** all platform configurations (Xcode project, Gradle build files, web index.html, Windows CMake) are updated to match the new SDK requirements

**Given** the updated SDK constraint
**When** `flutter analyze` is run on the codebase
**Then** all Dart 2.x-specific breaking changes are identified and fixed (deprecated APIs, syntax changes)
**And** the project compiles without errors (`flutter build` succeeds for at least one platform)

**Given** the SDK migration is complete
**When** the app is launched on any native platform
**Then** all existing features (time entry CRUD, wage management, payment calculation) function identically to pre-migration behavior
**And** no runtime errors occur during normal usage

### Story 1.2: ObjectBox Migration & Data Verification

As a developer,
I want to upgrade ObjectBox from 1.7 to 5.x and verify data migration integrity,
So that the local database layer is current and existing user data is preserved across the major version upgrade.

**Acceptance Criteria:**

**Given** ObjectBox 1.7 is specified in pubspec.yaml
**When** the dependency is upgraded to ObjectBox 5.x (latest stable)
**Then** the project compiles without errors
**And** all ObjectBox-related generated files (objectbox.g.dart, objectbox-model.json) are regenerated successfully

**Given** an existing development database (test-1) with time entries and wage data created under ObjectBox 1.7
**When** the app is launched with ObjectBox 5.x
**Then** all existing time entries are readable and display correctly
**And** all existing wage data is preserved and displays correctly
**And** no data loss occurs during the schema migration (NFR18)

**Given** ObjectBox 5.x is running
**When** CRUD operations are performed (create, read, update, delete time entries; update wage)
**Then** all operations complete successfully
**And** data persists correctly across app restarts (NFR17)

### Story 1.3: State Management & FP Dependencies Migration

As a developer,
I want to upgrade flutter_bloc/bloc to 9.x and replace dartz with fpdart,
So that the state management and functional programming foundations are on their latest stable versions compatible with Dart 3.

**Acceptance Criteria:**

**Given** flutter_bloc/bloc at version 8.x and dartz as FP dependency
**When** flutter_bloc and bloc are upgraded to 9.x (latest stable)
**Then** the project compiles without errors
**And** all BLoC event handlers and state emissions function correctly

**Given** dartz is used throughout the codebase for Either, Unit, and functional patterns
**When** dartz is replaced with fpdart
**Then** all import statements reference fpdart instead of dartz
**And** all Either usage (Left/Right, fold) works identically with fpdart's API
**And** the project compiles without errors

**Given** the state management and FP dependencies are upgraded
**When** the app is launched and all features exercised
**Then** time entry CRUD, wage management, and payment calculation work identically to pre-migration behavior
**And** no runtime errors occur

### Story 1.4: Code Generation & Remaining Dependencies

As a developer,
I want to upgrade Freezed to 3.x, very_good_analysis to latest, and all remaining dependencies to their latest stable versions,
So that the entire dependency tree is current and the codebase is fully modernized at the package level (NFR16).

**Acceptance Criteria:**

**Given** Freezed 2.x, build_runner, json_serializable, and very_good_analysis at outdated versions
**When** Freezed is upgraded to 3.x and all codegen dependencies are upgraded to latest stable
**Then** all generated files (.freezed.dart, .g.dart) are regenerated successfully via `dart run build_runner build --delete-conflicting-outputs`
**And** the project compiles without errors

**Given** very_good_analysis at an outdated version
**When** upgraded to latest stable (~v10.0.0)
**Then** `flutter analyze` passes with zero warnings on non-generated code
**And** analysis_options.yaml correctly excludes generated files

**Given** all remaining dependencies (equatable, intl, flutter_localizations, etc.)
**When** each is upgraded to its latest stable version
**Then** no deprecated API usage remains in the codebase
**And** all dev_dependencies (build_runner, freezed_annotation, etc.) are correctly placed in the dev_dependencies section (NFR9)

**Given** all dependencies are at latest stable versions
**When** the complete app is launched and all features exercised on a native platform
**Then** time entry CRUD works: create, view list, edit with pre-populated values, delete with feedback
**And** wage management works: view, set initial, update with feedback
**And** payment calculation works: calculate total, view summary
**And** localization works: EN/ES switching
**And** zero functional regressions exist compared to the original codebase (FR18, FR19)

## Epic 2: Architecture — Feature-First Restructure

The codebase follows true feature-first Clean Architecture with Data/Domain/Presentation layers inside each feature. Folder spellings corrected. Presentation moved into features. flutter_hooks removed. Core module houses cross-cutting concerns. Daniel sees enterprise-grade structure, Sofía can study the organization.

### Story 2.1: Core Module & Cross-Cutting Concerns Setup

As a developer,
I want to establish the core module with all shared cross-cutting concerns in their correct locations,
So that all features have a stable foundation of shared utilities, error types, and services to depend on (FR38).

**Acceptance Criteria:**

**Given** cross-cutting concerns are scattered across the existing codebase
**When** the core module is created at `lib/src/core/`
**Then** `core/errors/failures.dart` contains GlobalFailure and ValueFailure classes
**And** `core/services/objectbox_service.dart` contains the ObjectBox Store wrapper
**And** `core/services/app_database.dart` exists as a placeholder for drift (to be implemented in Epic 4)
**And** `core/ui/action_state.dart` contains the ActionState class
**And** `core/constants/app_durations.dart` contains timing constants
**And** `core/extensions/screen_size.dart` contains context extensions

**Given** the core module is established
**When** barrel export files are created for each subfolder
**Then** each folder with 2+ public files has a barrel file named `{folder_name}.dart`
**And** barrel files only re-export — no logic or classes defined within them
**And** no circular exports exist between barrel files (NFR10)

**Given** the core module structure
**When** `flutter analyze` is run
**Then** zero warnings are produced on core module files
**And** all imports use absolute paths (`package:time_money/src/core/...`)

### Story 2.2: Times Feature — Feature-First Restructure

As a developer,
I want to restructure the times feature into a self-contained feature-first module with Data/Domain/Presentation layers,
So that all time entry code is organized in a single feature directory following Clean Architecture principles (FR33, FR36, FR37).

**Acceptance Criteria:**

**Given** times-related code is spread across separate domain, infrastructure, and presentation trees
**When** the code is restructured into `lib/src/features/times/`
**Then** `times/domain/entities/` contains TimeEntry entity and generated files
**And** `times/domain/repositories/` contains the abstract TimesRepository interface
**And** `times/domain/use_cases/` contains CreateTimeUseCase, DeleteTimeUseCase, ListTimesUseCase, UpdateTimeUseCase
**And** `times/data/repositories/` contains the ObjectBox repository implementation
**And** `times/data/datasources/` contains the ObjectBox datasource
**And** `times/data/models/` contains TimeBox (ObjectBox entity)
**And** `times/presentation/bloc/` contains all times BLoCs (create, delete, list, update) with events and states
**And** `times/presentation/pages/` contains CreateTimePage and UpdateTimePage
**And** `times/presentation/widgets/` contains all times-specific widgets

**Given** the domain layer is restructured
**When** examining `times/domain/` imports
**Then** the domain layer has zero external dependencies except fpdart (FR34)
**And** domain entities and repository interfaces do not import from Data or Presentation layers

**Given** folder spellings in the original codebase (aplication, infraestructure)
**When** the restructure is complete
**Then** all folder names use correct English spelling (domain, data, presentation)
**And** no references to old folder paths remain in the codebase

**Given** the times feature restructure is complete
**When** the app is compiled and launched
**Then** time entry CRUD functionality works identically to pre-restructure behavior
**And** `flutter analyze` produces zero warnings on times feature files

### Story 2.3: Wage Feature — Feature-First Restructure

As a developer,
I want to restructure the wage feature into a self-contained feature-first module with Data/Domain/Presentation layers,
So that all wage management code is organized following the same pattern as the times feature (FR33, FR35).

**Acceptance Criteria:**

**Given** wage-related code is spread across separate domain, infrastructure, and presentation trees
**When** the code is restructured into `lib/src/features/wage/`
**Then** `wage/domain/entities/` contains WageHourly entity and generated files
**And** `wage/domain/repositories/` contains the abstract WageRepository interface
**And** `wage/domain/use_cases/` contains FetchWageUseCase, SetWageUseCase, UpdateWageUseCase
**And** `wage/data/repositories/` contains the ObjectBox repository implementation
**And** `wage/data/datasources/` contains the ObjectBox datasource
**And** `wage/data/models/` contains WageHourlyBox (ObjectBox entity)
**And** `wage/presentation/bloc/` contains FetchWageBloc and UpdateWageBloc with events and states
**And** `wage/presentation/pages/` contains UpdateWagePage
**And** `wage/presentation/widgets/` contains all wage-specific widgets

**Given** the wage domain layer
**When** examining imports
**Then** `wage/domain/` has zero external dependencies except fpdart (FR34)
**And** use cases implement single-responsibility operations (FR35)

**Given** the wage feature restructure is complete
**When** the app is compiled and launched
**Then** wage management works identically: view current wage, set initial wage ($15.00 default), update wage with feedback
**And** `flutter analyze` produces zero warnings on wage feature files

### Story 2.4: Payment & Home Features — Feature-First Restructure

As a developer,
I want to create the payment feature (domain + presentation only) and home feature (presentation shell),
So that cross-feature composition follows Clean Architecture with proper boundaries and separation (FR33, FR37).

**Acceptance Criteria:**

**Given** payment calculation logic exists in the codebase
**When** the payment feature is created at `lib/src/features/payment/`
**Then** `payment/domain/use_cases/` contains CalculatePaymentUseCase
**And** `payment/presentation/cubit/` contains PaymentCubit and PaymentState
**And** `payment/presentation/pages/` contains PaymentResultPage
**And** payment feature has NO data layer (calculation derives from times + wage data)

**Given** the home page composes times, wage, and payment features
**When** the home feature is created at `lib/src/features/home/`
**Then** `home/presentation/pages/` contains HomePage
**And** `home/presentation/widgets/` contains CalculatePaymentButton
**And** home feature has NO data or domain layers (pure composition shell)

**Given** cross-feature boundaries
**When** examining payment feature imports
**Then** payment imports only domain entities from times and wage — never their data or presentation layers
**And** home composes presentation widgets from all features but does not access their internals

**Given** the restructure is complete
**When** the app is compiled and launched
**Then** the home page displays wage info, time entries list, and action buttons
**And** payment calculation works correctly from the home page
**And** `flutter analyze` produces zero warnings

### Story 2.5: flutter_hooks Removal & Shared Widgets Extraction

As a developer,
I want to remove the flutter_hooks dependency and extract shared widgets to the shared module,
So that the codebase uses standard Flutter patterns and shared components are properly organized (FR38, FR39).

**Acceptance Criteria:**

**Given** 5 widgets use HookWidget with flutter_hooks (CreateHourField, CreateMinutesField, UpdateHourField, UpdateMinutesField, WageHourlyField)
**When** each HookWidget is replaced with StatefulWidget
**Then** all 5 widgets use standard StatefulWidget with TextEditingController lifecycle management
**And** flutter_hooks is removed from pubspec.yaml
**And** no imports of flutter_hooks remain in the codebase

**Given** widgets used by multiple features (ErrorView, InfoSection, IconText)
**When** shared widgets are extracted
**Then** `lib/src/shared/widgets/` contains error_view.dart, info_section.dart, and icon_text.dart
**And** each shared widget has a barrel export
**And** feature-specific widgets remain inside their respective feature's `presentation/widgets/`

**Given** DI wiring needs to support the feature-first structure
**When** the app bootstrap and DI setup is updated
**Then** `app/view/app_bloc.dart` uses MultiRepositoryProvider for repository registration
**And** MultiBlocProvider registers all BLoCs with use cases resolved from RepositoryProviders
**And** DI follows three-tier pattern: Repositories → Use Cases → BLoCs (FR39)
**And** `context.read<T>()` is used to resolve dependencies, never `context.watch<T>()`

**Given** all restructuring is complete
**When** the full app is compiled and exercised
**Then** all features work identically to pre-restructure behavior
**And** `flutter analyze` produces zero warnings on the entire codebase
**And** no orphaned files or imports remain from the old structure

## Epic 3: Modernization — State Management, Business Logic & Core Tests

All business features (time entry CRUD, wage management, payment calculation) use modern Dart 3 patterns. BLoC events/states migrated to sealed classes with exhaustive pattern matching. ActionState, GlobalFailure, ValueFailure modernized to sealed classes. emit.forEach for stream consumption. switch expressions in widget rendering. Freezed 3.x for domain entities. Test infrastructure established and unit/BLoC tests written alongside implementation — BMad aligned. Daniel sees senior-level code quality, Sofía learns transferable patterns.

### Story 3.1: Core Sealed Classes, Test Infrastructure & Core Tests

As a developer,
I want to migrate ActionState, GlobalFailure, and ValueFailure to sealed classes, and establish the test infrastructure with core unit tests,
So that all union types use native sealed classes consistently and the testing foundation is ready for all subsequent stories (FR40).

**Acceptance Criteria:**

**Given** ActionState uses Freezed for union type generation
**When** ActionState is migrated to a sealed class in `core/ui/action_state.dart`
**Then** `sealed class ActionState<T>` has variants: `ActionInitial`, `ActionLoading`, `ActionSuccess<T>`, `ActionError`
**And** all variants use `final class` keyword
**And** all variants have `const` constructors
**And** the Freezed-generated file for ActionState is removed

**Given** GlobalFailure and ValueFailure use Freezed for union types
**When** they are migrated to sealed classes in `core/errors/failures.dart`
**Then** `sealed class GlobalFailure` has appropriate failure variants (e.g., `InternalError`, `UnexpectedError`)
**And** `sealed class ValueFailure` has appropriate validation variants
**And** all variants use `final class` keyword with `const` constructors
**And** Freezed-generated files for failures are removed

**Given** AppDurations contains timing constants
**When** it is defined in `core/constants/app_durations.dart`
**Then** it uses `abstract final class AppDurations` (Dart 3 best practice for constants)
**And** `actionFeedback` is set to `Duration(milliseconds: 400)`

**Given** test infrastructure does not yet exist
**When** test helpers are created in `test/helpers/`
**Then** `test/helpers/pump_app.dart` provides `pumpApp()` with localization and provider setup
**And** `test/helpers/mocks.dart` provides shared mock classes via mocktail for TimesRepository, WageRepository, and all use cases
**And** `test/helpers/helpers.dart` barrel-exports all helpers
**And** `flutter test` runs successfully with the helpers available

**Given** core sealed classes are migrated and test infrastructure is ready
**When** core unit tests are written
**Then** `test/src/core/ui/action_state_test.dart` tests all ActionState variants and type matching
**And** `test/src/core/errors/failures_test.dart` tests GlobalFailure and ValueFailure variants
**And** all core tests pass via `flutter test`

**Given** all core work is complete
**When** `flutter analyze` is run
**Then** zero warnings are produced on core and test files

### Story 3.2: Times Feature — List & Create BLoC Migration

As a user,
I want to view my time entries in real time and create new ones using modern reactive patterns,
So that listing and creating time entries remains fast and reliable with proper visual feedback (FR1, FR2, FR5, FR6, FR40, FR43).

**Acceptance Criteria:**

**Given** CreateTimeBloc uses Freezed-generated events and states
**When** migrated to sealed classes
**Then** `sealed class CreateTimeEvent` has variants: `CreateTimeHourChanged`, `CreateTimeMinutesChanged`, `CreateTimeSubmitted`, `CreateTimeReset`
**And** `sealed class CreateTimeState` has variants: `CreateTimeInitial`, `CreateTimeLoading`, `CreateTimeSuccess`, `CreateTimeError`
**And** all variants use `final class` with `const` constructors
**And** the handler uses `result.fold()` to map Either to states
**And** success state triggers `AppDurations.actionFeedback` delay then resets to initial (FR5)

**Given** ListTimesBloc consumes a reactive stream
**When** migrated to sealed classes with emit.forEach
**Then** `sealed class ListTimesEvent` has `ListTimesRequested` variant
**And** `sealed class ListTimesState` has variants: `ListTimesInitial`, `ListTimesLoading`, `ListTimesLoaded`, `ListTimesEmpty`, `ListTimesError`
**And** stream consumption uses `emit.forEach` internally — no StreamBuilder in UI (FR6, FR43)
**And** the time entry list updates automatically when data changes (FR2)

**Given** list and create presentation widgets render BLoC states
**When** updated to use pattern matching
**Then** `BlocBuilder` widgets for ListTimesBloc and CreateTimeBloc use `switch` expressions with exhaustive pattern matching
**And** destructuring extracts state fields: e.g., `ListTimesLoaded(:final times)`
**And** no `if/else` chains on state types remain

**Given** list and create BLoC migrations are complete
**When** the app is launched and time entry features exercised
**Then** user can create time entries (FR1), view real-time list (FR2)
**And** visual feedback shows for create action (FR5)
**And** list updates automatically without manual refresh (FR6)

**Given** list and create BLoCs have reached their final sealed class form
**When** unit and BLoC tests are written alongside implementation
**Then** `test/src/features/times/domain/use_cases/create_time_use_case_test.dart` tests create use case (100% coverage)
**And** `test/src/features/times/domain/use_cases/list_times_use_case_test.dart` tests list use case (100% coverage)
**And** `test/src/features/times/data/repositories/objectbox_times_repository_test.dart` tests ObjectBox repository implementation (100% coverage)
**And** `test/src/features/times/presentation/bloc/create_time_bloc_test.dart` tests all state transitions: initial → loading → success → reset, and initial → loading → error
**And** `test/src/features/times/presentation/bloc/list_times_bloc_test.dart` tests stream subscription via emit.forEach, empty state, loaded state, error state
**And** all tests pass via `flutter test`

### Story 3.3: Times Feature — Update & Delete BLoC Migration

As a user,
I want to edit and delete existing time entries using modern reactive patterns,
So that correcting mistakes and removing entries remains fast with proper visual feedback (FR3, FR4, FR5, FR40, FR42).

**Acceptance Criteria:**

**Given** UpdateTimeBloc uses Freezed-generated events and states
**When** migrated to sealed classes
**Then** `sealed class UpdateTimeEvent` has appropriate variants for field changes and submission
**And** `sealed class UpdateTimeState` follows the standard state pattern: initial → loading → success/error → auto-reset (FR42)
**And** update dialog pre-populates with current values (FR3)
**And** all variants use `final class` with `const` constructors

**Given** DeleteTimeBloc uses Freezed-generated events and states
**When** migrated to sealed classes
**Then** `sealed class DeleteTimeEvent` has appropriate variants
**And** `sealed class DeleteTimeState` follows the standard state pattern: initial → loading → success/error → auto-reset (FR42)
**And** delete provides ActionState feedback (FR4)

**Given** update and delete presentation widgets render BLoC states
**When** updated to use pattern matching
**Then** `BlocBuilder` widgets for UpdateTimeBloc and DeleteTimeBloc use `switch` expressions with exhaustive pattern matching
**And** no `if/else` chains on state types remain

**Given** update and delete BLoC migrations are complete
**When** the app is launched and time entry features exercised
**Then** user can edit with pre-populated values (FR3), delete entries (FR4)
**And** visual feedback shows for update and delete actions (FR5)

**Given** update and delete BLoCs have reached their final sealed class form
**When** unit and BLoC tests are written alongside implementation
**Then** `test/src/features/times/domain/use_cases/update_time_use_case_test.dart` tests update use case (100% coverage)
**And** `test/src/features/times/domain/use_cases/delete_time_use_case_test.dart` tests delete use case (100% coverage)
**And** `test/src/features/times/presentation/bloc/update_time_bloc_test.dart` tests all state transitions
**And** `test/src/features/times/presentation/bloc/delete_time_bloc_test.dart` tests all state transitions
**And** all tests pass via `flutter test`

### Story 3.4: Wage Feature — Sealed Class BLoC Migration

As a user,
I want wage management to use modern reactive patterns internally,
So that viewing and updating my hourly wage remains fast with real-time feedback (FR7-FR11, FR40, FR42, FR43).

**Acceptance Criteria:**

**Given** FetchWageBloc uses Freezed-generated events and states
**When** migrated to sealed classes with emit.forEach
**Then** `sealed class FetchWageEvent` has `FetchWageRequested` variant
**And** `sealed class FetchWageState` has variants: `FetchWageInitial`, `FetchWageLoading`, `FetchWageLoaded`, `FetchWageError`
**And** stream consumption uses `emit.forEach` — no StreamBuilder in UI (FR10, FR43)
**And** wage value updates in real time without manual refresh (FR10)

**Given** UpdateWageBloc uses Freezed-generated events and states
**When** migrated to sealed classes
**Then** `sealed class UpdateWageEvent` has appropriate variants for field changes and submission
**And** `sealed class UpdateWageState` follows the standard pattern: initial → loading → success/error → auto-reset (FR42)
**And** visual feedback shows for wage update actions (FR11)

**Given** SetWageUseCase handles initial wage setting
**When** the wage feature is exercised
**Then** initial wage defaults to $15.00 (FR8)
**And** user can view current wage (FR7) and update it (FR9)

**Given** wage presentation widgets render BLoC states
**When** updated to use pattern matching
**Then** all `BlocBuilder` widgets use `switch` expressions with exhaustive matching
**And** no `if/else` chains on state types remain

**Given** all wage BLoC migrations are complete
**When** the app is launched and wage features exercised
**Then** all FR7-FR11 capabilities function correctly with modern patterns

**Given** wage BLoCs have reached their final sealed class form
**When** unit and BLoC tests are written alongside implementation
**Then** `test/src/features/wage/domain/use_cases/fetch_wage_use_case_test.dart` tests fetch use case (100% coverage)
**And** `test/src/features/wage/domain/use_cases/set_wage_use_case_test.dart` tests set use case (100% coverage)
**And** `test/src/features/wage/domain/use_cases/update_wage_use_case_test.dart` tests update use case (100% coverage)
**And** `test/src/features/wage/data/repositories/objectbox_wage_repository_test.dart` tests ObjectBox repository implementation (100% coverage)
**And** `test/src/features/wage/presentation/bloc/fetch_wage_bloc_test.dart` tests stream subscription, loaded state, error state
**And** `test/src/features/wage/presentation/bloc/update_wage_bloc_test.dart` tests all state transitions: initial → loading → success → reset, and initial → loading → error
**And** all tests pass via `flutter test`

### Story 3.5: Payment Feature — Cubit Modernization & Cross-Feature Composition

As a user,
I want to calculate my total payment based on recorded time entries and current hourly wage,
So that I can see an accurate payment summary with total hours, minutes, rate, and payment amount (FR12-FR14, FR44).

**Acceptance Criteria:**

**Given** PaymentCubit derives state from times list and wage data
**When** modernized with sealed class states
**Then** `sealed class PaymentState` has appropriate variants for data availability and calculation result
**And** payment calculation derives computed state without user-initiated events (FR44)
**And** PaymentCubit receives times and wage data from HomePage composition

**Given** CalculatePaymentUseCase implements the payment formula
**When** invoked with a list of time entries and an hourly wage
**Then** the formula `(total duration in minutes / 60) * hourly wage` is applied correctly (FR14)
**And** the result is returned as `Either<GlobalFailure, PaymentResult>`

**Given** the home page composes times, wage, and payment features
**When** ListTimesBloc emits loaded times and FetchWageBloc emits loaded wage
**Then** PaymentCubit receives both data sets via HomePage composition
**And** the user can tap "Calculate Payment" to trigger calculation (FR12)

**Given** payment calculation completes
**When** the result is displayed on PaymentResultPage
**Then** the summary shows total hours, total minutes, hourly rate, and total payment amount (FR13)
**And** all values are formatted correctly

**Given** all payment modernization is complete
**When** the full flow is exercised (enter times → set wage → calculate)
**Then** the payment result matches manual calculation
**And** `flutter analyze` produces zero warnings

**Given** payment logic has reached its final form
**When** unit and BLoC tests are written alongside implementation
**Then** `test/src/features/payment/domain/use_cases/calculate_payment_use_case_test.dart` tests the payment formula with standard inputs, edge cases (zero entries, zero wage), and large data sets (100% coverage)
**And** `test/src/features/payment/presentation/cubit/payment_cubit_test.dart` tests state transitions: setting times, setting wage, calculating result, error handling
**And** payment calculation unit test verifies execution under 50ms (NFR4)
**And** all tests pass via `flutter test`

### Story 3.6: Domain Entities & Naming Conventions Final Pass

As a developer,
I want to verify Freezed 3.x domain entities and apply final naming conventions across the codebase,
So that domain data classes support copyWith/equality/JSON and all code follows consistent naming patterns (FR41, NFR8).

**Acceptance Criteria:**

**Given** TimeEntry and WageHourly are domain data classes
**When** verified with Freezed 3.x
**Then** both entities support `copyWith`, equality comparison, and JSON serialization via generated code (FR41)
**And** generated files (.freezed.dart, .g.dart) exist and are current
**And** Freezed is used ONLY for domain data classes — not for BLoC events, states, or failure types

**Given** the Architecture document defines naming conventions
**When** a full naming conventions pass is applied
**Then** all files follow snake_case naming: `{action}_{feature}_bloc.dart`, `{feature}_repository.dart`, etc. (NFR8)
**And** all classes follow PascalCase with correct suffixes: `CreateTimeBloc`, `TimesRepository`, `CreateTimeUseCase`
**And** repository interfaces use `{Feature}Repository` pattern
**And** repository implementations use `Objectbox{Feature}Repository` pattern
**And** datasources use `{Feature}ObjectboxDatasource` pattern

**Given** import conventions
**When** all imports are verified
**Then** all imports use absolute paths: `package:time_money/src/...`
**And** no relative imports exist in the codebase
**And** import order follows: dart: → package: third-party → package:time_money/

**Given** the naming pass is complete
**When** `flutter analyze` is run
**Then** zero warnings on non-generated code (NFR6)
**And** zero unused imports or variables (NFR7)
**And** the app compiles and all features work correctly

## Epic 4: Platform — Multi-Datasource, Multi-Platform & Localization

drift datasource implemented for web platform. ObjectBox datasources modernized in new architecture. Platform-aware DI via kIsWeb. All four platforms (iOS, Android, Web, Windows) verified with full FR1-FR17 functionality. Multi-environment support (dev/staging/prod) with isolated databases for both datasources. EN/ES localization verified on modernized codebase.

### Story 4.1: drift Database Setup & Core Infrastructure

As a developer,
I want to set up the drift database with table definitions and web-compatible persistence,
So that the web platform has a fully functional local data layer using SQLite via WASM + OPFS (FR31).

**Acceptance Criteria:**

**Given** drift is added as a dependency in pubspec.yaml
**When** `AppDatabase extends GeneratedDatabase` is created in `core/services/app_database.dart`
**Then** the database class defines `TimesTable` and `WageHourlyTable` with columns matching domain entity fields
**And** drift codegen files (app_database.g.dart) are generated successfully via build_runner

**Given** web platform requires WASM + OPFS for persistence
**When** drift is configured for web
**Then** the web database uses `WasmDatabase` with OPFS backend
**And** the configuration supports Chrome 86+, Firefox 111+, Safari 15.2+ (NFR14)

**Given** three environments exist (dev/staging/prod)
**When** the drift database is initialized
**Then** environment-aware database naming is applied (test-1, stg-1, prod-1) — matching the ObjectBox pattern
**And** each environment uses an isolated database instance (FR25, FR26, FR27)

**Given** the drift database setup is complete
**When** `flutter analyze` is run
**Then** zero warnings on drift-related files
**And** generated files are excluded from static analysis (NFR11)

### Story 4.2: Times Feature — drift Datasource & Repository Implementation

As a user on the web platform,
I want to create, view, edit, and delete time entries with the same experience as native platforms,
So that the web app is fully functional for time tracking (FR22, FR29, FR31).

**Acceptance Criteria:**

**Given** the drift database has TimesTable defined
**When** `TimesDriftDatasource` is implemented in `times/data/datasources/`
**Then** it provides CRUD operations: insert, select all, update, delete on TimesTable
**And** it provides a reactive `watchAll()` stream equivalent to ObjectBox's `watch()` (FR29)
**And** it works with drift table row types only (not domain entities)

**Given** the drift datasource is available
**When** `DriftTimesRepository` is implemented in `times/data/repositories/`
**Then** it implements the abstract `TimesRepository` interface (FR32)
**And** it maps between drift table rows and `TimeEntry` domain entities
**And** all methods return `Either<GlobalFailure, T>` — never throw (NFR19)
**And** `fetchTimesStream()` returns `Either<GlobalFailure, Stream<List<TimeEntry>>>`

**Given** both ObjectBox and drift repository implementations exist
**When** comparing their public API
**Then** both conform to the identical `TimesRepository` interface
**And** both provide equivalent reactive stream behavior (FR29)

**Given** the drift times implementation is complete
**When** exercised on the web platform
**Then** CRUD operations complete successfully
**And** the reactive stream emits updates when data changes
**And** data persists across page reloads via OPFS (NFR17)

**Given** drift times datasource and repository are new implementations
**When** unit tests are written alongside implementation
**Then** `test/src/features/times/data/datasources/times_drift_datasource_test.dart` tests all CRUD operations and reactive stream behavior
**And** `test/src/features/times/data/repositories/drift_times_repository_test.dart` tests repository implementation with entity mapping and Either returns (100% coverage)
**And** all tests pass via `flutter test`

### Story 4.3: Wage Feature — drift Datasource & Repository Implementation

As a user on the web platform,
I want to view, set, and update my hourly wage with the same experience as native platforms,
So that wage management is fully functional on the web (FR22, FR29, FR31).

**Acceptance Criteria:**

**Given** the drift database has WageHourlyTable defined
**When** `WageDriftDatasource` is implemented in `wage/data/datasources/`
**Then** it provides operations: insert, select, update on WageHourlyTable
**And** it provides a reactive `watch()` stream for wage data (FR29)
**And** it works with drift table row types only

**Given** the drift datasource is available
**When** `DriftWageRepository` is implemented in `wage/data/repositories/`
**Then** it implements the abstract `WageRepository` interface (FR32)
**And** it maps between drift table rows and `WageHourly` domain entities
**And** all methods return `Either<GlobalFailure, T>` — never throw (NFR19)
**And** initial wage defaults to $15.00 when no wage exists (FR8)

**Given** both ObjectBox and drift wage repository implementations exist
**When** comparing their public API
**Then** both conform to the identical `WageRepository` interface
**And** both provide equivalent reactive stream behavior (FR29)

**Given** the drift wage implementation is complete
**When** exercised on the web platform
**Then** wage view, set, and update operations work correctly
**And** data persists across page reloads (NFR17)

**Given** drift wage datasource and repository are new implementations
**When** unit tests are written alongside implementation
**Then** `test/src/features/wage/data/datasources/wage_drift_datasource_test.dart` tests all operations and reactive stream behavior
**And** `test/src/features/wage/data/repositories/drift_wage_repository_test.dart` tests repository implementation with entity mapping, default wage handling, and Either returns (100% coverage)
**And** all tests pass via `flutter test`

### Story 4.4: Platform-Aware DI & Multi-Environment Configuration

As a developer,
I want the app to automatically select the correct datasource based on the target platform,
So that native platforms use ObjectBox and web uses drift without manual configuration (FR24, FR28).

**Acceptance Criteria:**

**Given** `kIsWeb` from `dart:foundation` is a compile-time constant
**When** the DI container initializes in `bootstrap.dart` and `app/view/app_bloc.dart`
**Then** `kIsWeb == true` → drift datasources and repositories are registered
**And** `kIsWeb == false` → ObjectBox datasources and repositories are registered
**And** BLoCs receive repository interfaces (not implementations) — unaware of the underlying datasource

**Given** the platform-aware DI is configured
**When** `MultiRepositoryProvider` registers repositories
**Then** `RepositoryProvider<TimesRepository>` selects `DriftTimesRepository` or `ObjectboxTimesRepository` based on platform
**And** `RepositoryProvider<WageRepository>` selects `DriftWageRepository` or `ObjectboxWageRepository` based on platform
**And** use cases are created inline with `context.read<T>()` resolution (FR39)

**Given** three entry points exist (main_development.dart, main_staging.dart, main_production.dart)
**When** each entry point initializes the app
**Then** environment-specific database names are passed to bootstrap (test-1, stg-1, prod-1)
**And** both ObjectBox and drift respect the environment-specific naming (FR25, FR26, FR27)
**And** databases are isolated per environment — no cross-contamination

**Given** the DI setup supports tree-shaking via `kIsWeb`
**When** building for a native platform
**Then** drift-related code is tree-shaken out of the native build
**And** when building for web, ObjectBox-related code is tree-shaken out

### Story 4.5: Multi-Platform Verification & Localization Validation

As a user,
I want the app to work identically on iOS, Android, Web, and Windows with full bilingual support,
So that I can use TimeMoney on any platform in my preferred language (FR15-FR23, FR30).

**Acceptance Criteria:**

**Given** the multi-datasource architecture is complete
**When** the app is built and launched on iOS
**Then** all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR20)
**And** iOS deployment target supports iOS 13+ (NFR12)

**Given** the app is built for Android
**When** launched on an Android device or emulator
**Then** all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR21)
**And** Android minimum SDK supports API 21+ (NFR13)

**Given** the app is built for Web
**When** launched in Chrome, Firefox, or Safari
**Then** all FR1-FR17 capabilities function correctly using the drift datasource (FR22)
**And** data persists via OPFS across browser sessions (NFR14)
**And** CRUD operations complete within 2x the latency of native operations (NFR5)

**Given** the app is built for Windows
**When** launched on Windows 10+
**Then** all FR1-FR17 capabilities function correctly using the ObjectBox datasource (FR23)
**And** Windows build targets MSVC toolchain (NFR15)

**Given** localization is configured with EN/ES ARB files
**When** the app is used in English
**Then** all interface text displays in English (FR15)
**And** when switched to Spanish, all interface text displays in Spanish (FR16)
**And** zero hardcoded strings exist — all text uses `context.l10n` pattern (FR17)

**Given** the app is cold-started on any platform
**When** measuring time from launch to interactive main screen
**Then** the app is interactive within 2 seconds (NFR3)

**Given** all platform and localization verification is complete
**When** comparing functionality across all four platforms
**Then** all platforms pass identical functional verification with zero platform-specific failures (NFR20)

## Epic 5: Quality — Widget Tests, Golden Tests & Coverage Validation

Widget tests for presentation layer components (80%+ coverage). Golden tests for visual regression proof (HomePage, PaymentResultPage, CRUD dialogs). Coverage gap validation ensuring overall floor 85%+. Unit and BLoC tests were already written alongside implementation in Epics 3-4 — this epic completes the testing pyramid with presentation-layer and visual regression coverage.

### Story 5.1: Times & Wage Feature Widget Tests

As a developer,
I want comprehensive widget tests for the times and wage feature presentation layers,
So that UI rendering, user interactions, and state-driven display are verified for the two core data features (FR47).

**Acceptance Criteria:**

**Given** times feature has presentation widgets (TimeCard, InfoTime, EditButton, CreateTimeCard, CreateHourField, CreateMinutesField, CreateTimeButton, UpdateTimeCard, UpdateHourField, UpdateMinutesField, UpdateTimeButton, DeleteTimeButton)
**When** widget tests are written for the times feature
**Then** `test/src/features/times/presentation/widgets/time_card_test.dart` verifies time entry data rendering
**And** `test/src/features/times/presentation/widgets/create_time_card_test.dart` verifies create form interaction and validation
**And** key interaction widgets (edit button, delete button, create/update buttons) have tests verifying tap behavior and BLoC event dispatch
**And** page dialogs (CreateTimePage, UpdateTimePage) are tested with mocked BLoCs for full interaction flow

**Given** wage feature has presentation widgets (WageHourlyCard, WageHourlyInfo, UpdateWageButton, WageHourlyField, SetWageButton)
**When** widget tests are written for the wage feature
**Then** `test/src/features/wage/presentation/widgets/wage_hourly_card_test.dart` verifies wage display rendering
**And** UpdateWagePage dialog is tested with mocked BLoCs for form interaction and submission
**And** key interaction widgets have tests verifying tap behavior

**Given** times and wage widget tests are complete
**When** `flutter test` is run
**Then** all times and wage widget tests pass

### Story 5.2: Home, Payment & Shared Widget Tests

As a developer,
I want comprehensive widget tests for the home page composition, payment feature, and shared widgets,
So that the cross-feature composition layer and reusable components are verified automatically (FR47).

**Acceptance Criteria:**

**Given** home and payment features have presentation components
**When** widget tests are written
**Then** `test/src/features/home/presentation/pages/home_page_test.dart` verifies composition of times list, wage card, and action buttons
**And** `test/src/features/payment/presentation/pages/payment_result_page_test.dart` verifies payment summary display with formatted values
**And** CalculatePaymentButton widget is tested for tap behavior

**Given** shared widgets exist (ErrorView, InfoSection, IconText)
**When** widget tests are written
**Then** `test/src/shared/widgets/error_view_test.dart` verifies GlobalFailure pattern-matched rendering
**And** `test/src/shared/widgets/info_section_test.dart` verifies empty state display
**And** all shared widget tests pass

**Given** all widget tests across Stories 5.1 and 5.2 are complete
**When** `flutter test` is run
**Then** all widget tests pass
**And** presentation layer coverage reaches 80%+ on non-generated code (FR47)

### Story 5.3: Golden Tests & Coverage Validation

As a developer,
I want golden tests for visual regression proof and validated overall test coverage,
So that the modernization is provably zero-regression visually and the test suite meets quality targets (FR48, FR49).

**Acceptance Criteria:**

**Given** the UI is in its final state after all modernization
**When** golden tests are created in `test/goldens/`
**Then** `home_page_with_data.png` captures HomePage with populated time entries and wage data
**And** `home_page_empty.png` captures HomePage in empty state
**And** `payment_result_page.png` captures PaymentResultPage with calculated values
**And** `create_time_dialog.png` captures the create time entry dialog
**And** `update_time_dialog.png` captures the update/delete time entry dialog

**Given** golden test files exist
**When** golden tests are run via `flutter test --update-goldens`
**Then** baseline golden images are generated successfully
**And** subsequent runs via `flutter test` match against baselines using native `matchesGoldenFile`
**And** no external golden test dependencies are required (FR48)

**Given** all tests across Epics 3, 4, and 5 are complete
**When** `flutter test --coverage` is run
**Then** a coverage report is generated successfully (FR49)
**And** use case coverage is 100%
**And** BLoC/Cubit coverage is 100%
**And** repository implementation coverage is 100%
**And** presentation layer coverage is 80%+
**And** overall coverage on non-generated code meets the 85%+ floor

**Given** coverage gaps are identified
**When** gaps are below the target thresholds
**Then** additional targeted tests are written to close the gaps
**And** the final coverage report meets all threshold targets

**Given** all tests pass and coverage targets are met
**When** `flutter analyze` is run alongside `flutter test`
**Then** zero linter warnings on all non-generated code (NFR6)
**And** zero unused imports or dead code (NFR7)
**And** generated files are excluded from analysis (NFR11)

## Epic 6: Polish — CI/CD Pipeline & Professional Documentation

GitHub Actions pipeline with linting, testing, coverage reporting, and build verification for all four platforms. Professional README scannable in 30 seconds. Dependabot for automated dependency updates. Code quality final cleanup (zero orphaned code, clean exports). The project is presentation-ready as portfolio piece and open-source reference.

### Story 6.1: GitHub Actions CI/CD Pipeline

As a developer,
I want an automated CI/CD pipeline that validates code quality and builds on every PR,
So that no code is merged without passing lint, test, and build verification for all platforms (FR50, FR51, NFR21).

**Acceptance Criteria:**

**Given** the project needs automated quality gates
**When** `.github/workflows/main.yaml` is created or updated
**Then** the pipeline runs on every pull request to main
**And** the pipeline executes `flutter analyze` for linting verification (FR50)
**And** the pipeline executes `flutter test --coverage` for test execution and coverage reporting (FR50)
**And** the pipeline verifies builds for iOS, Android, Web, and Windows (FR51)
**And** the pipeline fails if any step produces errors — blocking merge (NFR21)

**Given** the project benefits from automated dependency updates
**When** Dependabot is configured at `.github/dependabot.yaml`
**Then** daily update checks are configured for github-actions and pub ecosystems
**And** Dependabot creates PRs for outdated dependencies automatically

**Given** PRs need consistent structure
**When** `.github/PULL_REQUEST_TEMPLATE.md` is created
**Then** the template includes sections for summary, changes, and testing verification

**Given** spell-checking supports code quality
**When** `.github/cspell.json` is configured
**Then** project-specific terms (TimeMoney, ObjectBox, BLoC, etc.) are in the allowed words list
**And** spell-check does not produce false positives on domain terminology

**Given** the CI pipeline is complete
**When** a test PR is created
**Then** the pipeline triggers automatically, runs all steps, and reports results
**And** the pipeline completes successfully with all checks passing

### Story 6.2: Professional README & Final Code Quality Cleanup

As a hiring manager or Flutter developer visiting the repository,
I want a professional README and pristine code quality,
So that I can understand the project's architecture and quality within 30 seconds and trust the code as a reference implementation (FR52, FR53).

**Acceptance Criteria:**

**Given** the repository needs a professional entry point
**When** README.md is written
**Then** it contains a project overview explaining TimeMoney's purpose and modernization scope
**And** it contains an architecture diagram showing feature-first structure with Data/Domain/Presentation layers
**And** it contains setup instructions (clone, install, run) that work on first attempt
**And** it contains a contribution guide with coding standards and PR process
**And** the entire README is scannable within 30 seconds by a hiring manager (FR52)

**Given** the migration history should demonstrate engineering discipline
**When** reviewing the commit history
**Then** each commit follows conventional commit format: `type: description` (FR53)
**And** commits reference the scope item or migration step they implement
**And** the commit sequence tells a coherent modernization story (SDK → architecture → patterns → platform → testing → polish)

**Given** the codebase needs final quality polish
**When** a comprehensive code quality pass is performed
**Then** zero linter warnings exist on all non-generated Dart code (NFR6)
**And** zero unused imports, variables, or dead code remain (NFR7)
**And** all barrel export files are clean — no circular exports, no re-exports of private APIs (NFR10)
**And** all dev_dependencies are correctly separated from regular dependencies (NFR9)
**And** all generated files are excluded from static analysis (NFR11)
**And** no deprecated API usage remains in the codebase (NFR16)

**Given** the project is intended as a portfolio piece and open-source reference
**When** the final state is reviewed holistically
**Then** the repository is presentation-ready: clean code, comprehensive tests, automated pipeline, professional documentation
**And** Daniel (hiring manager) can navigate from README → architecture → code → tests within minutes
**And** Sofía (Flutter dev) can clone, run, and study the patterns as a learning reference
