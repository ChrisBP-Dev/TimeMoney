---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-03-17'
inputDocuments:
  - 'planning-artifacts/prd.md'
  - 'planning-artifacts/prd-validation-report.md'
  - 'planning-artifacts/product-brief-TimeMoney.md'
  - 'planning-artifacts/product-brief-TimeMoney-distillate.md'
  - '_bmad-output/project-context.md'
  - 'docs/index.md'
  - 'docs/project-overview.md'
  - 'docs/architecture.md'
  - 'docs/data-models.md'
  - 'docs/component-inventory.md'
  - 'docs/source-tree-analysis.md'
  - 'docs/development-guide.md'
workflowType: 'architecture'
project_name: 'TimeMoney'
user_name: 'Christopher'
date: '2026-03-17'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**

53 functional requirements organized into 12 categories:

| Category | FRs | Architectural Implication |
|---|---|---|
| Time Entry Management | FR1-FR6 | CRUD operations with reactive streams, ActionState feedback pattern |
| Wage Management | FR7-FR11 | Single-entity CRUD with reactive stream, default value handling |
| Payment Calculation | FR12-FR14 | Derived/computed state from two data sources, no persistence needed |
| Localization | FR15-FR17 | ARB-based i18n, context.l10n pattern, zero hardcoded strings |
| SDK & Build Verification | FR52-FR53 | Migration foundation — everything builds on current SDK |
| Multi-Platform Support | FR18-FR22 | Platform-aware datasource selection via DI |
| Multi-Environment Support | FR23-FR25 | Isolated database instances per environment |
| Data Persistence | FR26-FR30 | Dual datasource (ObjectBox + drift) behind shared Repository interfaces |
| Architecture & Code Org | FR31-FR37 | Feature-first Clean Architecture, 3-tier DI, layer separation |
| State Management | FR38-FR42 | Sealed classes for BLoC events/states, exhaustive pattern matching |
| Testing | FR43-FR47 | Unit, BLoC, widget, golden tests — full coverage from zero baseline |
| CI/CD & Dev Experience | FR48-FR51 | Automated pipeline, professional README, conventional commits |

**Non-Functional Requirements:**

21 NFRs across 4 categories:

| Category | NFRs | Key Constraints |
|---|---|---|
| Performance | NFR1-NFR5 | UI response <500ms, stream propagation <100ms, cold start <2s, payment calc <50ms, web datasource within 2x of native |
| Code Quality | NFR6-NFR11 | Zero linter warnings, zero dead code, consistent naming, correct dependency placement, clean barrel exports |
| Compatibility | NFR12-NFR16 | iOS 13+, Android API 21+, Chrome 86+/Firefox 111+/Safari 15.2+, Windows 10+, all deps at latest stable |
| Reliability | NFR17-NFR21 | Zero data loss, ObjectBox 1.7→5.x migration preserves data, typed failures (no unhandled exceptions), identical test suites across platforms, CI gate before merge |

**Scale & Complexity:**

- Primary domain: Cross-platform mobile application (Flutter)
- Domain complexity: Low (2 business features, 7 use cases, simple CRUD + calculation)
- Migration complexity: Medium-High (3-year SDK gap, 3 major version jumps on core dependencies)
- Estimated architectural components: ~15 (2 domain models, 2 repository interfaces, 4 repository implementations, 7 use cases, 7 BLoCs/Cubits, core services, DI container)

### Technical Constraints & Dependencies

**Hard Constraints:**

- Flutter 3.41+ / Dart 3.11+ minimum SDK — non-negotiable foundation
- ObjectBox does not support web platform — drift required for web datasource
- Zero functional regressions — all existing features must work identically post-modernization
- No new features — scope is purely modernization
- No UI/UX changes — visual design remains as-is
- Offline-first, local-only — no network, no backend, no cloud

**Migration Sequence Dependencies:**

1. SDK constraint must be raised first (Dart 2.x → 3.11+)
2. ObjectBox 1.7→5.x must follow SDK (may have schema/API changes)
3. BLoC 8.x→9.x requires Dart 3 sealed classes
4. Freezed 2.x→3.x has breaking codegen changes
5. All generated files must be regenerated at intermediate steps
6. Architecture restructure after dependencies are stable
7. Testing after code is in final architecture
8. CI/CD, cleanup, and README as final polish

**Technology Decisions Already Made (from PRD):**

| Decision | Choice | Rejected Alternative |
|---|---|---|
| BLoC events/states | Sealed classes (Dart 3 native) | Freezed for events/states |
| Domain data classes | Freezed 3.x | Eliminate Freezed entirely |
| DI approach | flutter_bloc native (RepositoryProvider/BlocProvider) | get_it + injectable |
| State management | BLoC | Riverpod |
| flutter_hooks | Remove (replace with StatefulWidget) | Keep flutter_hooks |
| Folder spellings | Correct (aplication→application, infraestructure→infrastructure) | Preserve original |
| Web datasource | drift (SQLite via WASM + OPFS) | Skip web support |
| FP library | fpdart | Keep dartz |

### Cross-Cutting Concerns Identified

1. **Platform-aware Dependency Injection:** Runtime platform detection selects ObjectBox or drift datasource. Both implement identical Repository interfaces. DI container must handle this transparently.

2. **Unified Error Handling:** GlobalFailure<F> wraps all infrastructure exceptions. Repositories return Either<GlobalFailure, T>. BLoCs fold Either into typed states. This pattern must be consistent across both datasource implementations.

3. **Reactive Data Streams:** ObjectBox `watch()` and drift equivalent must provide identical Stream<T> behavior to the presentation layer. BLoCs with `hasDataStream` state consume these streams.

4. **Code Generation Pipeline:** Freezed 3.x + ObjectBox 5.x + drift + json_serializable all use build_runner. Generation order and conflict resolution must be managed.

5. **Multi-Environment Isolation:** Three environments (dev/staging/prod) with separate database instances. Both ObjectBox and drift datasources must respect environment-specific database naming.

6. **Localization:** EN/ES via ARB files. All user-facing strings through context.l10n. No changes to localization architecture, but must verify compatibility with Flutter 3.41+.

7. **ActionState Visual Feedback:** Generic pattern used across all CRUD operations (initial→loading→success/error→auto-reset). Must be preserved identically in modernized BLoCs.

8. **Cross-Feature Composition:** ControlHoursPage combines times + wage features. ResultPaymentCubit derives state from both. Architecture must define where cross-feature composition lives in feature-first structure.

## Starter Template Evaluation

### Primary Technology Domain

Cross-platform mobile application (Flutter) — brownfield modernization of an existing VGV CLI-generated project.

### Starter Options Considered

#### Option 1: Very Good CLI (very_good create flutter_app) — Original Generator

**Current State (2026):**
- Very Good CLI remains actively maintained
- Generates Flutter apps with multi-platform support, 3-environment flavors (dev/staging/prod), internationalization, and very_good_analysis linting
- Template includes basic counter app with VGV-opinionated best practices

**What the original VGV scaffold provided (already in TimeMoney):**
- Multi-platform support (iOS, Android, Web, Windows, macOS, Linux)
- Build flavors: development, staging, production
- Internationalization with synthetic code generation (ARB files)
- very_good_analysis linting (strict rules)
- BlocObserver setup in bootstrap
- Folder structure with app/, l10n/, src/ organization

**Evaluation:** Re-scaffolding with VGV CLI would destroy 3 years of business logic, domain models, and infrastructure code. Not applicable for brownfield modernization.

#### Option 2: Fresh Scaffold + Manual Migration

**Approach:** Generate a new VGV project with current Flutter 3.41/Dart 3.11, then port existing code into it.

**Evaluation:** Adds unnecessary risk. The migration sequence (SDK → dependencies → architecture) is better executed in-place with compilation checkpoints. A fresh scaffold would require recreating all platform configurations (Xcode project, Gradle, CMake, web) and risk losing platform-specific customizations.

#### Option 3: In-Place Modernization (Selected)

**Approach:** Evolve the existing codebase through sequential, verifiable steps — each step produces a compiling, runnable app.

**Evaluation:** Lowest risk, most traceable. Each migration step can be committed independently, creating the meaningful commit history that is a core portfolio requirement (Daniel's journey). This is also the approach that demonstrates genuine modernization skill — not just "I can scaffold a new project."

### Selected Approach: In-Place Modernization

**Rationale for Selection:**

- **Zero re-scaffolding risk.** The existing codebase is the source of truth. Platform configs, localization setup, environment flavors — all preserved.
- **Traceable migration.** Each step produces a meaningful commit that demonstrates the modernization journey — a core portfolio requirement.
- **Compilation checkpoints.** The app must compile and run at each intermediate step, preventing the "big bang migration" antipattern.
- **Demonstrates real skill.** Taking legacy code forward is harder and more impressive than starting from scratch — this is exactly what Daniel (hiring manager) looks for.

**Initialization Command:**

```bash
# No scaffold command — existing codebase is the starting point.
# Migration begins with SDK constraint update:
# pubspec.yaml: environment.sdk: ">=3.11.0 <4.0.0"
# Then sequential dependency upgrades with compilation verification at each step.
```

**Architectural Decisions Inherited from Original VGV Scaffold:**

**Language & Runtime:**
- Dart 2.19 → migrating to Dart 3.11+ (sealed classes, records, pattern matching, exhaustive switch)
- Flutter 3.41+ (Impeller default, Material modularization)

**Linting:**
- very_good_analysis ^4.0.0 → upgrading to latest (~v10.0.0)
- Strict rules enforced; generated files excluded from analysis

**Build Flavors:**
- Development (test-1), Staging (stg-1), Production (prod-1) — preserved as-is
- Separate entry points: main_development.dart, main_staging.dart, main_production.dart

**Internationalization:**
- EN/ES via ARB files in l10n/arb/ — preserved as-is
- context.l10n convenience accessor pattern maintained

**Code Organization (evolving):**
- FROM: VGV default + custom layering (features for domain/app/infra, separate presentation tree)
- TO: True feature-first (all layers including presentation inside each feature)

**Development Experience:**
- Hot reload preserved across all platforms
- build_runner for code generation (Freezed, ObjectBox, drift, JSON)
- flutter test with coverage reporting

**Note:** The first implementation story should be the SDK constraint update and Flutter/Dart version migration, not a scaffold command.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Layer naming: Data / Domain / Presentation (not infrastructure/aplication)
- Feature-first structure with all 3 layers inside each feature
- BLoC as controller equivalent — presentation layer owns BLoCs
- Datasource concept as lowest layer in Data
- Platform-aware DI via `kIsWeb`

**Important Decisions (Shape Architecture):**
- Cross-feature composition: `home` feature (shell) + `payment` feature (calculation logic)
- ActionState migrated to sealed class
- BLoC consumes streams internally via `emit.forEach` — no StreamBuilder in UI
- ActionFeedback delay preserved at 400ms with descriptive naming
- Golden tests for visual regression proof
- Repository naming: Objectbox/Drift prefix on implementations

**Deferred Decisions (Post-MVP):**
- None — all critical decisions resolved

### Data Architecture

**Layer Structure (per feature):**

| Layer | Contents | Dependency Direction |
|---|---|---|
| **Domain** | Entities, Repository interfaces (abstract), Use Cases | Innermost — zero external dependencies |
| **Data** | Repository implementations, Datasources, DB Models | Depends on Domain (implements interfaces) |
| **Presentation** | BLoC/Cubit, Pages, Widgets | Depends on Domain (calls use cases via BLoC) |

**Hierarchical Flow (layers never skip):**

```
Widget → BLoC (event) → Use Case → Repository Interface → Repository Impl → Datasource
  Presentation              Domain                              Data              Data
```

**Database Service Initialization:**
- ObjectBox `Store` and drift `AppDatabase` initialized centrally in `core/`
- Feature datasources receive references (Box/Table) via constructor injection
- Bootstrap creates the appropriate service based on platform, DI wires the rest

**Platform Detection:**
- `kIsWeb` from `dart:foundation` — compile-time constant enabling tree-shaking
- Simple conditional in bootstrap: `kIsWeb` → drift, else → ObjectBox
- No additional platform abstraction needed at this scale

**drift Configuration:**
- Single `AppDatabase extends GeneratedDatabase` in `core/`
- Contains `TimesTable` and `WageHourlyTable`
- Environment-aware database naming (test-1, stg-1, prod-1) — same pattern as ObjectBox

**Entity Naming Conventions:**

| Datasource | Suffix | Example |
|---|---|---|
| ObjectBox | `Box` | `TimeBox`, `WageHourlyBox` |
| drift | `Table` | `TimesTable`, `WageHourlyTable` |
| Domain | None (entity) | `TimeEntry`, `WageHourly` |

### Authentication & Security

Not applicable — TimeMoney is offline-first with no backend, no authentication, no network communication. All data is local-only.

### API & Communication Patterns

Not applicable — no API, no backend, no remote communication. Error handling is already decided: `GlobalFailure` + `Either` from fpdart + typed BLoC states.

### Frontend Architecture

**Feature-First Directory Structure (Target):**

```
lib/src/
├── core/
│   ├── errors/
│   │   └── failures.dart              (GlobalFailure sealed class)
│   ├── services/
│   │   ├── objectbox_service.dart     (ObjectBox Store wrapper)
│   │   └── app_database.dart          (drift Database)
│   ├── ui/
│   │   └── action_state.dart          (ActionState<T> sealed class)
│   └── constants/
│       └── app_durations.dart         (abstract final class)
├── features/
│   ├── times/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── times_objectbox_datasource.dart
│   │   │   │   └── times_drift_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── time_box.dart
│   │   │   │   └── times_table.dart
│   │   │   └── repositories/
│   │   │       ├── objectbox_times_repository.dart
│   │   │       └── drift_times_repository.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── time_entry.dart
│   │   │   ├── repositories/
│   │   │   │   └── times_repository.dart  (abstract)
│   │   │   └── use_cases/
│   │   │       ├── create_time_use_case.dart
│   │   │       ├── delete_time_use_case.dart
│   │   │       ├── list_times_use_case.dart
│   │   │       └── update_time_use_case.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── create_time_bloc.dart
│   │       │   ├── delete_time_bloc.dart
│   │       │   ├── list_times_bloc.dart
│   │       │   └── update_time_bloc.dart
│   │       ├── pages/
│   │       └── widgets/
│   ├── wage/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── payment/
│   │   ├── domain/
│   │   │   └── use_cases/
│   │   │       └── calculate_payment_use_case.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── payment_cubit.dart
│   │       └── pages/
│   │           └── payment_result_page.dart
│   └── home/
│       └── presentation/
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               └── calculate_payment_button.dart
└── shared/
    └── widgets/
        ├── error_view.dart
        └── info_section.dart
```

**Cross-Feature Composition:**
- `home` feature — shell/composition feature, presentation only, orchestrates times + wage + payment on one screen
- `payment` feature — owns calculation logic (use case + cubit + result page), no Data layer (derives from times + wage)

**ActionState Modernization:**
- Migrated from Freezed to `sealed class ActionState<T>` in `core/ui/`
- Variants: `ActionInitial`, `ActionLoading`, `ActionSuccess<T>`, `ActionError`
- Consistent with BLoC events/states using sealed classes — no mixed patterns

**BLoC Stream Consumption:**
- BLoCs consume reactive streams internally via `emit.forEach` (BLoC 9.x pattern)
- UI uses only `BlocBuilder` / `BlocSelector` — no `StreamBuilder` in widgets
- States: `loading`, `empty`, `loaded(data)`, `error(failure)`
- Cleaner separation: widgets don't know data comes from a stream

**ActionFeedback Timing:**
- `AppDurations.actionFeedback = Duration(milliseconds: 400)`
- Preserved as intentional UX pattern for CRUD feedback visibility
- `abstract final class AppDurations` — Dart 3 best practice for constants

### Infrastructure & Deployment

**Test Coverage Targets:**

| Layer | Target | Rationale |
|---|---|---|
| Use Cases | 100% | Pure business logic, no excuses |
| BLoCs/Cubits | 100% | Every state transition must be verified |
| Repository Implementations | 100% | Data mapping correctness guaranteed |
| Widgets | 80%+ | Presentation components tested, trivial wrappers excluded |
| Golden tests | Main pages + dialogs | Visual regression proof for portfolio |
| **Overall floor** | **85%+** | On non-generated code |

**Golden Tests Strategy:**
- Scope: HomePage (data + empty states), PaymentResultPage, CRUD dialogs
- Not per individual widget — widget tests cover those
- Generated as final step after all migration is complete
- Stored in `test/goldens/`, updated via `flutter test --update-goldens`
- Native Flutter `matchesGoldenFile` — no external dependencies

**Naming Conventions:**

| Type | Pattern | Example |
|---|---|---|
| Repository interface | `{Feature}Repository` | `TimesRepository` |
| ObjectBox repository | `Objectbox{Feature}Repository` | `ObjectboxTimesRepository` |
| drift repository | `Drift{Feature}Repository` | `DriftTimesRepository` |
| ObjectBox datasource | `{Feature}ObjectboxDatasource` | `TimesObjectboxDatasource` |
| drift datasource | `{Feature}DriftDatasource` | `TimesDriftDatasource` |
| ObjectBox model | `{Name}Box` | `TimeBox` |
| drift model | `{Name}Table` | `TimesTable` |
| Domain entity | Plain name | `TimeEntry`, `WageHourly` |
| BLoC | `{Action}{Feature}Bloc` | `CreateTimeBloc` |
| Cubit | `{Feature}Cubit` | `PaymentCubit` |
| Use Case | `{Action}{Feature}UseCase` | `CreateTimeUseCase` |

### Decision Impact Analysis

**Implementation Sequence:**
1. SDK + dependency migration (foundation)
2. Architecture restructure to Data/Domain/Presentation feature-first
3. Sealed classes for BLoC events/states + ActionState
4. BLoC 9.x migration with `emit.forEach` stream pattern
5. Multi-datasource implementation (ObjectBox datasources + drift datasources)
6. flutter_hooks removal (StatefulWidget replacement)
7. Naming convention corrections (repositories, folders, entities)
8. Testing suite (use cases → BLoCs → repositories → widgets → goldens)
9. CI/CD pipeline update
10. Code quality cleanup + professional README

**Cross-Component Dependencies:**
- Architecture restructure (2) must complete before multi-datasource (5) — datasources need to live in the new structure
- Sealed classes (3) and BLoC 9.x (4) can be done together — they're interrelated
- Testing (8) requires stable architecture and code — must come after 2-7
- Golden tests are last within testing — need final UI in place

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:** 6 areas where AI agents could make different choices

### Naming Patterns

**File Naming:**

| Element | Convention | Example |
|---|---|---|
| All Dart files | snake_case | `create_time_use_case.dart` |
| BLoC files | `{action}_{feature}_bloc.dart` | `create_time_bloc.dart` |
| BLoC event files | `{action}_{feature}_event.dart` | `create_time_event.dart` |
| BLoC state files | `{action}_{feature}_state.dart` | `create_time_state.dart` |
| Cubit files | `{feature}_cubit.dart` | `payment_cubit.dart` |
| Cubit state files | `{feature}_state.dart` | `payment_state.dart` |
| Entity files | `{entity_name}.dart` | `time_entry.dart` |
| Use case files | `{action}_{feature}_use_case.dart` | `create_time_use_case.dart` |
| Repository interface | `{feature}_repository.dart` | `times_repository.dart` |
| Repository impl | `{datasource}_{feature}_repository.dart` | `objectbox_times_repository.dart` |
| Datasource files | `{feature}_{datasource}_datasource.dart` | `times_objectbox_datasource.dart` |
| DB model files | `{name}_{suffix}.dart` | `time_box.dart`, `times_table.dart` |
| Page files | `{feature}_page.dart` or `{name}_page.dart` | `home_page.dart` |
| Widget files | `{descriptive_name}.dart` | `time_card.dart`, `edit_button.dart` |
| Barrel exports | `{folder_name}.dart` | `use_cases.dart`, `widgets.dart` |

**Class Naming:**

| Element | Convention | Example |
|---|---|---|
| Entities | PascalCase, descriptive | `TimeEntry`, `WageHourly` |
| BLoC classes | `{Action}{Feature}Bloc` | `CreateTimeBloc` |
| BLoC events | `sealed class {Action}{Feature}Event` | `sealed class CreateTimeEvent` |
| BLoC states | `sealed class {Action}{Feature}State` | `sealed class CreateTimeState` |
| Cubit classes | `{Feature}Cubit` | `PaymentCubit` |
| Use cases | `{Action}{Feature}UseCase` | `CreateTimeUseCase` |
| Repository interfaces | `{Feature}Repository` (abstract) | `TimesRepository` |
| Repository impls | `{Datasource}{Feature}Repository` | `ObjectboxTimesRepository` |
| Datasources | `{Feature}{Datasource}Datasource` | `TimesObjectboxDatasource` |
| ObjectBox models | `{Name}Box` | `TimeBox` |
| drift tables | `{Name}Table` | `TimesTable` |
| Failure types | `{Scope}Failure` | `GlobalFailure` |
| Pages | `{Name}Page` | `HomePage` |
| Widgets | Descriptive PascalCase | `TimeCard`, `EditButton` |

**Variable/Parameter Naming:**

- All variables: camelCase — `timeEntry`, `wageHourly`, `isLoading`
- Private fields: underscore prefix — `_subscription`, `_repository`
- Constants: camelCase — `actionFeedback` (inside `abstract final class`)
- Type parameters: single uppercase letter — `T`, `F`
- Named parameters preferred over positional for 2+ params

**Import Conventions:**

- ALWAYS absolute imports: `package:time_money/src/features/times/...`
- NEVER relative imports — linter enforces this
- Import order (enforced by very_good_analysis):
  1. `dart:` libraries
  2. `package:` third-party
  3. `package:time_money/` project imports

### Structure Patterns

**Test Organization — Mirror source structure:**

```
test/
├── src/
│   ├── core/
│   │   └── ui/
│   │       └── action_state_test.dart
│   ├── features/
│   │   ├── times/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── times_objectbox_datasource_test.dart
│   │   │   │   └── repositories/
│   │   │   │       └── objectbox_times_repository_test.dart
│   │   │   ├── domain/
│   │   │   │   └── use_cases/
│   │   │   │       ├── create_time_use_case_test.dart
│   │   │   │       └── ...
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── create_time_bloc_test.dart
│   │   │       │   └── ...
│   │   │       └── widgets/
│   │   │           └── time_card_test.dart
│   │   └── ...
│   └── shared/
│       └── widgets/
├── goldens/
│   ├── home_page_with_data.png
│   ├── home_page_empty.png
│   └── ...
└── helpers/
    ├── pump_app.dart
    └── mocks.dart
```

**Rule:** Every source file `lib/src/path/file.dart` has its test at `test/src/path/file_test.dart`. No exceptions.

**Barrel Export Rules:**

- Each folder with 2+ public files gets a barrel file named `{folder_name}.dart`
- Barrel files ONLY re-export — no logic, no classes
- Features export from their layer barrel: `data.dart`, `domain.dart`, `presentation.dart`
- NEVER circular exports — barrel at layer level, not across layers
- Domain barrel NEVER exports Data layer content

**Shared vs Feature Widgets:**

| Location | What belongs there | Example |
|---|---|---|
| `features/{name}/presentation/widgets/` | Widgets used only by that feature | `TimeCard`, `CreateHourField` |
| `shared/widgets/` | Widgets used by 2+ features | `ErrorView`, `InfoSection` |
| `core/ui/` | Non-widget UI utilities | `ActionState`, `AppDurations` |

**Rule:** A widget starts in its feature. Only move to `shared/` when a second feature needs it.

### Communication Patterns

**BLoC Event Naming:**

Events are sealed classes with subclasses describing the user action:

```dart
sealed class CreateTimeEvent {
  const CreateTimeEvent();
}

final class CreateTimeHourChanged extends CreateTimeEvent {
  const CreateTimeHourChanged(this.hour);
  final int hour;
}

final class CreateTimeMinutesChanged extends CreateTimeEvent {
  const CreateTimeMinutesChanged(this.minutes);
  final int minutes;
}

final class CreateTimeSubmitted extends CreateTimeEvent {
  const CreateTimeSubmitted();
}

final class CreateTimeReset extends CreateTimeEvent {
  const CreateTimeReset();
}
```

**Pattern rules:**
- Event names describe WHAT happened, not what should happen: `Submitted`, not `Submit`
- Past tense for data changes: `HourChanged`, `MinutesChanged`
- Imperative for actions: `Submitted`, `Reset`
- Always `const` constructors
- `final class` for leaf events (prevents further extension)

**BLoC State Naming:**

States are sealed classes describing the current condition:

```dart
sealed class ListTimesState {
  const ListTimesState();
}

final class ListTimesInitial extends ListTimesState {
  const ListTimesInitial();
}

final class ListTimesLoading extends ListTimesState {
  const ListTimesLoading();
}

final class ListTimesLoaded extends ListTimesState {
  const ListTimesLoaded(this.times);
  final List<TimeEntry> times;
}

final class ListTimesEmpty extends ListTimesState {
  const ListTimesEmpty();
}

final class ListTimesError extends ListTimesState {
  const ListTimesError(this.failure);
  final GlobalFailure failure;
}
```

**Pattern rules:**
- State names are adjectives/past participles: `Loaded`, `Loading`, `Initial`, not `Load`, `Start`
- Every BLoC has at minimum: `Initial`, `Loading`, `Error`
- Data-carrying states have `final` fields (immutable)
- `final class` for all concrete states

**BLoC Handler Pattern:**

```dart
// Standard CRUD action handler:
on<CreateTimeSubmitted>((event, emit) async {
  emit(const CreateTimeState.loading());
  final result = await _createTimeUseCase(time);
  result.fold(
    (failure) {
      emit(CreateTimeState.error(failure));
    },
    (time) async {
      emit(CreateTimeState.success(time));
      await Future.delayed(AppDurations.actionFeedback);
      emit(const CreateTimeState.initial());
    },
  );
});

// Stream consumption handler:
on<ListTimesRequested>((event, emit) async {
  emit(const ListTimesState.loading());
  final result = _listTimesUseCase();
  result.fold(
    (failure) => emit(ListTimesState.error(failure)),
    (stream) => emit.forEach(
      stream,
      onData: (times) => times.isEmpty
          ? const ListTimesState.empty()
          : ListTimesState.loaded(times),
      onError: (error, _) => ListTimesState.error(
        GlobalFailure.internalError(error),
      ),
    ),
  );
});
```

### Process Patterns

**Error Handling — Layer by Layer:**

| Layer | Pattern | Rule |
|---|---|---|
| Datasource | `try/catch` all exceptions, rethrow as typed exceptions or let propagate | Datasources may throw |
| Repository Impl | Catches all exceptions, wraps in `GlobalFailure`, returns `Left` | NEVER throws — always returns Either |
| Use Case | Passes through Either without modification | No try/catch needed |
| BLoC | Folds Either into success/error states | NEVER catches exceptions directly |
| Widget | Pattern matches on BLoC state to render appropriate view | No error logic in widgets |

**Rule:** Exceptions STOP at the Repository layer. Above that, everything is typed `Either<GlobalFailure, T>`.

**Use Case Pattern:**

```dart
class CreateTimeUseCase {
  const CreateTimeUseCase(this._repository);
  final TimesRepository _repository;

  Future<Either<GlobalFailure, TimeEntry>> call(TimeEntry time) {
    return _repository.create(time);
  }
}
```

**Rules:**
- One use case = one operation
- Constructor receives repository interface (not implementation)
- Single `call` method (callable class pattern)
- `const` constructor when possible
- No business logic beyond orchestration

**Repository Interface Pattern:**

```dart
abstract class TimesRepository {
  Either<GlobalFailure, Stream<List<TimeEntry>>> fetchTimesStream();
  Future<Either<GlobalFailure, TimeEntry>> create(TimeEntry time);
  Future<Either<GlobalFailure, TimeEntry>> update(TimeEntry time);
  Future<Either<GlobalFailure, Unit>> delete(TimeEntry time);
}
```

**Rules:**
- Abstract class in `domain/repositories/`
- Return types always `Either<GlobalFailure, T>` or `Either<GlobalFailure, Stream<T>>`
- Parameters use domain entities, never DB models
- `Unit` (from fpdart) for void-like success responses

**Datasource Pattern:**

```dart
class TimesObjectboxDatasource {
  const TimesObjectboxDatasource(this._box);
  final Box<TimeBox> _box;

  Stream<List<TimeBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
      (query) => query.find(),
    );
  }

  int put(TimeBox timeBox) => _box.put(timeBox);
  bool remove(int id) => _box.remove(id);
}
```

**Rules:**
- Works with DB models only (TimeBox, not TimeEntry)
- No Either wrapping — that's the Repository's job
- May throw exceptions — Repository catches them
- Receives DB-specific dependencies (Box, Database) via constructor

**DI Registration Pattern:**

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<TimesRepository>(
      create: (_) => kIsWeb
          ? DriftTimesRepository(TimesDriftDatasource(database))
          : ObjectboxTimesRepository(TimesObjectboxDatasource(store.box<TimeBox>())),
    ),
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ListTimesBloc(
          ListTimesUseCase(context.read<TimesRepository>()),
        ),
      ),
    ],
    child: const App(),
  ),
);
```

**Rules:**
- Repositories registered first, BLoCs second
- Platform-aware selection happens at Repository registration
- Use cases created inline — lightweight, stateless
- `context.read<T>()` to resolve dependencies, never `context.watch<T>()`

**Widget State Rendering Pattern:**

```dart
BlocBuilder<ListTimesBloc, ListTimesState>(
  builder: (context, state) => switch (state) {
    ListTimesInitial() => const SizedBox.shrink(),
    ListTimesLoading() => const CircularProgressIndicator(),
    ListTimesEmpty() => const EmptyTimesView(),
    ListTimesLoaded(:final times) => TimesListView(times: times),
    ListTimesError(:final failure) => ErrorView(failure: failure),
  },
)
```

**Rules:**
- `switch` expression with exhaustive pattern matching — compiler enforces all states handled
- Destructuring to extract state fields: `ListTimesLoaded(:final times)`
- One view widget per state for complex UIs, inline for simple states
- NEVER check `state is SomeState` — always use switch expression

### Enforcement Guidelines

**All AI Agents MUST:**

1. Run `dart analyze` before considering any file complete — zero warnings on non-generated code
2. Use absolute imports exclusively — `package:time_money/...`
3. Follow the sealed class pattern for ALL new BLoC events and states — no Freezed for BLoC types
4. Place files in the correct layer and feature — never cross layer boundaries
5. Write `const` constructors wherever possible
6. Use `final class` for all concrete (leaf) sealed class variants
7. Return `Either<GlobalFailure, T>` from all repository methods — never throw
8. Use `switch` expressions for state rendering — never `if/else` chains on state types
9. Mirror source file paths exactly in test file paths
10. Never manually edit generated files (*.g.dart, *.freezed.dart, objectbox.g.dart)

### Anti-Patterns

**NEVER do these:**

```dart
// ❌ Relative import
import '../../../core/errors/failures.dart';
// ✅ Absolute import
import 'package:time_money/src/core/errors/failures.dart';

// ❌ Widget calling use case directly (skipping BLoC)
onPressed: () => createTimeUseCase(time),
// ✅ Widget sends event to BLoC
onPressed: () => context.read<CreateTimeBloc>().add(const CreateTimeSubmitted()),

// ❌ if/else chain for state rendering
if (state is ListTimesLoading) { ... }
else if (state is ListTimesLoaded) { ... }
// ✅ Exhaustive switch expression
switch (state) {
  ListTimesLoading() => ...,
  ListTimesLoaded(:final times) => ...,
}

// ❌ BLoC catching exceptions directly
try { await useCase(data); } catch (e) { emit(ErrorState(e)); }
// ✅ BLoC folding Either
final result = await useCase(data);
result.fold(
  (failure) => emit(ErrorState(failure)),
  (data) => emit(SuccessState(data)),
);

// ❌ Throwing from repository
throw Exception('Not found');
// ✅ Returning typed failure
return left(const GlobalFailure.internalError('Not found'));

// ❌ Mutable state in BLoC
emit(state.copyWith(loading: true));
// ✅ Distinct sealed class states
emit(const CreateTimeState.loading());
```

## Project Structure & Boundaries

### Complete Project Directory Structure

```
TimeMoney/
├── pubspec.yaml                           # Package manifest — Flutter 3.41+ / Dart 3.11+
├── analysis_options.yaml                  # very_good_analysis latest, generated file exclusions
├── l10n.yaml                              # Localization config
├── README.md                              # Professional README (portfolio entry point)
├── .gitignore
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── dependabot.yaml                    # Daily updates: github-actions + pub
│   ├── cspell.json                        # Spell-check config
│   └── workflows/
│       └── main.yaml                      # CI: lint + test + coverage + build (4 platforms)
│
├── lib/
│   ├── main_development.dart              # Entry: dev environment (db: test-1)
│   ├── main_staging.dart                  # Entry: staging environment (db: stg-1)
│   ├── main_production.dart               # Entry: production environment (db: prod-1)
│   ├── bootstrap.dart                     # App init: BlocObserver, platform detection, DB init
│   ├── objectbox.g.dart                   # ⚙️ Generated: ObjectBox model definitions
│   │
│   ├── app/
│   │   ├── app.dart                       # Barrel export
│   │   └── view/
│   │       ├── app.dart                   # MaterialApp: Material 3, theme, localization
│   │       └── app_bloc.dart              # DI setup: MultiRepositoryProvider → MultiBlocProvider
│   │
│   ├── l10n/
│   │   ├── l10n.dart                      # Extension: context.l10n accessor
│   │   └── arb/
│   │       ├── app_en.arb                 # English strings
│   │       └── app_es.arb                 # Spanish strings
│   │
│   └── src/
│       ├── core/
│       │   ├── errors/
│       │   │   └── failures.dart          # GlobalFailure + ValueFailure sealed classes
│       │   ├── services/
│       │   │   ├── objectbox_service.dart  # ObjectBox Store wrapper (native platforms)
│       │   │   ├── app_database.dart       # drift AppDatabase (web platform)
│       │   │   └── app_database.g.dart     # ⚙️ Generated: drift
│       │   ├── ui/
│       │   │   └── action_state.dart       # ActionState<T> sealed class
│       │   ├── constants/
│       │   │   └── app_durations.dart      # abstract final class AppDurations
│       │   └── extensions/
│       │       └── screen_size.dart        # Context extensions: isMobile, getWidth
│       │
│       ├── features/
│       │   │
│       │   ├── times/                      # ── FEATURE: Time Entry Management ──
│       │   │   ├── data/
│       │   │   │   ├── datasources/
│       │   │   │   │   ├── times_objectbox_datasource.dart   # Box<TimeBox> operations
│       │   │   │   │   └── times_drift_datasource.dart       # TimesTable queries
│       │   │   │   ├── models/
│       │   │   │   │   ├── time_box.dart                     # ObjectBox @Entity + converters
│       │   │   │   │   └── times_table.dart                  # drift Table definition
│       │   │   │   └── repositories/
│       │   │   │       ├── objectbox_times_repository.dart   # implements TimesRepository
│       │   │   │       └── drift_times_repository.dart       # implements TimesRepository
│       │   │   ├── domain/
│       │   │   │   ├── entities/
│       │   │   │   │   ├── time_entry.dart                   # Freezed domain entity
│       │   │   │   │   ├── time_entry.freezed.dart           # ⚙️ Generated
│       │   │   │   │   └── time_entry.g.dart                 # ⚙️ Generated (JSON)
│       │   │   │   ├── repositories/
│       │   │   │   │   └── times_repository.dart             # abstract interface
│       │   │   │   └── use_cases/
│       │   │   │       ├── create_time_use_case.dart
│       │   │   │       ├── delete_time_use_case.dart
│       │   │   │       ├── list_times_use_case.dart
│       │   │   │       └── update_time_use_case.dart
│       │   │   └── presentation/
│       │   │       ├── bloc/
│       │   │       │   ├── create_time_bloc.dart
│       │   │       │   ├── create_time_event.dart
│       │   │       │   ├── create_time_state.dart
│       │   │       │   ├── delete_time_bloc.dart
│       │   │       │   ├── delete_time_event.dart
│       │   │       │   ├── delete_time_state.dart
│       │   │       │   ├── list_times_bloc.dart
│       │   │       │   ├── list_times_event.dart
│       │   │       │   ├── list_times_state.dart
│       │   │       │   ├── update_time_bloc.dart
│       │   │       │   ├── update_time_event.dart
│       │   │       │   └── update_time_state.dart
│       │   │       ├── pages/
│       │   │       │   ├── create_time_page.dart              # AlertDialog for create
│       │   │       │   └── update_time_page.dart              # AlertDialog for update/delete
│       │   │       └── widgets/
│       │   │           ├── time_card.dart
│       │   │           ├── info_time.dart
│       │   │           ├── edit_button.dart
│       │   │           ├── create_time_card.dart
│       │   │           ├── create_hour_field.dart             # StatefulWidget (was HookWidget)
│       │   │           ├── create_minutes_field.dart          # StatefulWidget (was HookWidget)
│       │   │           ├── create_time_button.dart
│       │   │           ├── update_time_card.dart
│       │   │           ├── update_hour_field.dart             # StatefulWidget (was HookWidget)
│       │   │           ├── update_minutes_field.dart          # StatefulWidget (was HookWidget)
│       │   │           ├── update_time_button.dart
│       │   │           └── delete_time_button.dart
│       │   │
│       │   ├── wage/                       # ── FEATURE: Hourly Wage Management ──
│       │   │   ├── data/
│       │   │   │   ├── datasources/
│       │   │   │   │   ├── wage_objectbox_datasource.dart
│       │   │   │   │   └── wage_drift_datasource.dart
│       │   │   │   ├── models/
│       │   │   │   │   ├── wage_hourly_box.dart              # ObjectBox @Entity + converters
│       │   │   │   │   └── wage_hourly_table.dart            # drift Table definition
│       │   │   │   └── repositories/
│       │   │   │       ├── objectbox_wage_repository.dart
│       │   │   │       └── drift_wage_repository.dart
│       │   │   ├── domain/
│       │   │   │   ├── entities/
│       │   │   │   │   ├── wage_hourly.dart                  # Freezed domain entity
│       │   │   │   │   ├── wage_hourly.freezed.dart          # ⚙️ Generated
│       │   │   │   │   └── wage_hourly.g.dart                # ⚙️ Generated (JSON)
│       │   │   │   ├── repositories/
│       │   │   │   │   └── wage_repository.dart              # abstract interface
│       │   │   │   └── use_cases/
│       │   │   │       ├── fetch_wage_use_case.dart
│       │   │   │       ├── set_wage_use_case.dart
│       │   │   │       └── update_wage_use_case.dart
│       │   │   └── presentation/
│       │   │       ├── bloc/
│       │   │       │   ├── fetch_wage_bloc.dart
│       │   │       │   ├── fetch_wage_event.dart
│       │   │       │   ├── fetch_wage_state.dart
│       │   │       │   ├── update_wage_bloc.dart
│       │   │       │   ├── update_wage_event.dart
│       │   │       │   └── update_wage_state.dart
│       │   │       ├── pages/
│       │   │       │   └── update_wage_page.dart              # AlertDialog for wage update
│       │   │       └── widgets/
│       │   │           ├── wage_hourly_card.dart
│       │   │           ├── wage_hourly_info.dart
│       │   │           ├── update_wage_button.dart
│       │   │           ├── wage_hourly_field.dart             # StatefulWidget (was HookWidget)
│       │   │           └── set_wage_button.dart
│       │   │
│       │   ├── payment/                    # ── FEATURE: Payment Calculation ──
│       │   │   ├── domain/
│       │   │   │   └── use_cases/
│       │   │   │       └── calculate_payment_use_case.dart
│       │   │   └── presentation/
│       │   │       ├── cubit/
│       │   │       │   ├── payment_cubit.dart
│       │   │       │   └── payment_state.dart
│       │   │       └── pages/
│       │   │           └── payment_result_page.dart
│       │   │
│       │   └── home/                       # ── FEATURE: Shell/Composition ──
│       │       └── presentation/
│       │           ├── pages/
│       │           │   └── home_page.dart                     # Main screen: wage + times + actions
│       │           └── widgets/
│       │               └── calculate_payment_button.dart
│       │
│       └── shared/
│           └── widgets/
│               ├── error_view.dart                            # Pattern-matched GlobalFailure display
│               ├── info_section.dart                          # Empty state / info display
│               └── icon_text.dart                             # Scalable text-based icon
│
├── test/
│   ├── src/
│   │   ├── core/
│   │   │   ├── errors/
│   │   │   │   └── failures_test.dart
│   │   │   └── ui/
│   │   │       └── action_state_test.dart
│   │   ├── features/
│   │   │   ├── times/
│   │   │   │   ├── data/
│   │   │   │   │   ├── datasources/
│   │   │   │   │   │   ├── times_objectbox_datasource_test.dart
│   │   │   │   │   │   └── times_drift_datasource_test.dart
│   │   │   │   │   └── repositories/
│   │   │   │   │       ├── objectbox_times_repository_test.dart
│   │   │   │   │       └── drift_times_repository_test.dart
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/
│   │   │   │   │   │   └── time_entry_test.dart
│   │   │   │   │   └── use_cases/
│   │   │   │   │       ├── create_time_use_case_test.dart
│   │   │   │   │       ├── delete_time_use_case_test.dart
│   │   │   │   │       ├── list_times_use_case_test.dart
│   │   │   │   │       └── update_time_use_case_test.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── bloc/
│   │   │   │       │   ├── create_time_bloc_test.dart
│   │   │   │       │   ├── delete_time_bloc_test.dart
│   │   │   │       │   ├── list_times_bloc_test.dart
│   │   │   │       │   └── update_time_bloc_test.dart
│   │   │   │       └── widgets/
│   │   │   │           ├── time_card_test.dart
│   │   │   │           ├── create_time_card_test.dart
│   │   │   │           └── ...
│   │   │   ├── wage/
│   │   │   │   ├── data/
│   │   │   │   │   ├── datasources/
│   │   │   │   │   │   ├── wage_objectbox_datasource_test.dart
│   │   │   │   │   │   └── wage_drift_datasource_test.dart
│   │   │   │   │   └── repositories/
│   │   │   │   │       ├── objectbox_wage_repository_test.dart
│   │   │   │   │       └── drift_wage_repository_test.dart
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/
│   │   │   │   │   │   └── wage_hourly_test.dart
│   │   │   │   │   └── use_cases/
│   │   │   │   │       ├── fetch_wage_use_case_test.dart
│   │   │   │   │       ├── set_wage_use_case_test.dart
│   │   │   │   │       └── update_wage_use_case_test.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── bloc/
│   │   │   │       │   ├── fetch_wage_bloc_test.dart
│   │   │   │       │   └── update_wage_bloc_test.dart
│   │   │   │       └── widgets/
│   │   │   │           └── wage_hourly_card_test.dart
│   │   │   ├── payment/
│   │   │   │   ├── domain/
│   │   │   │   │   └── use_cases/
│   │   │   │   │       └── calculate_payment_use_case_test.dart
│   │   │   │   └── presentation/
│   │   │   │       └── cubit/
│   │   │   │           └── payment_cubit_test.dart
│   │   │   └── home/
│   │   │       └── presentation/
│   │   │           └── pages/
│   │   │               └── home_page_test.dart
│   │   └── shared/
│   │       └── widgets/
│   │           └── error_view_test.dart
│   ├── goldens/
│   │   ├── home_page_with_data.png
│   │   ├── home_page_empty.png
│   │   ├── payment_result_page.png
│   │   ├── create_time_dialog.png
│   │   └── update_time_dialog.png
│   └── helpers/
│       ├── helpers.dart                   # Barrel export
│       ├── pump_app.dart                  # pumpApp() with localization + providers
│       └── mocks.dart                     # Shared mock classes (mocktail)
│
├── android/                               # Android platform config (Gradle)
├── ios/                                   # iOS platform config (Xcode)
├── web/                                   # Web platform config (index.html)
├── windows/                               # Windows platform config (CMake)
└── docs/                                  # Project documentation (existing)
```

### Architectural Boundaries

**Layer Boundaries (enforced per feature):**

```
┌─────────────────────────────────────────────────────────┐
│ PRESENTATION                                             │
│  Pages, Widgets → BLoC/Cubit                            │
│  ✅ Can: call BLoC methods, read BLoC state             │
│  ❌ Cannot: import Data layer, call Use Cases directly   │
├─────────────────────────────────────────────────────────┤
│ DOMAIN                                                   │
│  Entities, Repository interfaces, Use Cases              │
│  ✅ Can: define interfaces, contain pure business logic  │
│  ❌ Cannot: import Data, import Presentation, import any │
│     external package except fpdart                       │
├─────────────────────────────────────────────────────────┤
│ DATA                                                     │
│  Repository impls, Datasources, DB Models                │
│  ✅ Can: import Domain (implements interfaces)           │
│  ❌ Cannot: import Presentation, be imported by Domain   │
└─────────────────────────────────────────────────────────┘
```

**Feature Boundaries:**

| Feature | Can Import From | Cannot Import From |
|---|---|---|
| `times` | `core/`, `shared/` | `wage/`, `payment/`, `home/` |
| `wage` | `core/`, `shared/` | `times/`, `payment/`, `home/` |
| `payment` | `core/`, `shared/`, `times/domain/entities/`, `wage/domain/entities/` | `times/data/`, `wage/data/`, `home/` |
| `home` | `core/`, `shared/`, all features' `presentation/` | any feature's `data/` or `domain/` directly |

**Key boundary rule:** `payment` imports only domain entities from `times` and `wage` — never their data or presentation layers. `home` composes presentation widgets from all features but doesn't access their internals.

**Data Boundaries:**

```
┌──────────────────┐     ┌──────────────────┐
│  ObjectBox Store  │     │   drift Database  │
│  (native: iOS,    │     │   (web only)      │
│   Android, Win)   │     │                   │
├──────────────────┤     ├──────────────────┤
│ Box<TimeBox>      │     │ TimesTable        │
│ Box<WageHourlyBox>│     │ WageHourlyTable   │
└───────┬──────────┘     └───────┬──────────┘
        │                         │
        ▼                         ▼
  Feature Datasources       Feature Datasources
  (receive Box/Table ref)   (receive Database ref)
        │                         │
        ▼                         ▼
  Repository Implementations (map DB models ↔ domain entities)
        │
        ▼
  Repository Interface (abstract — Domain layer)
        │
        ▼
  Use Cases (pure business logic)
        │
        ▼
  BLoC/Cubit (state management)
        │
        ▼
  Widgets (UI rendering)
```

### Requirements to Structure Mapping

**FR1-FR6 (Time Entry Management):**
- `features/times/` — complete feature with all 3 layers
- BLoCs: `CreateTimeBloc`, `DeleteTimeBloc`, `ListTimesBloc`, `UpdateTimeBloc`
- Use Cases: one per CRUD operation
- Datasources: ObjectBox + drift implementations

**FR7-FR11 (Wage Management):**
- `features/wage/` — complete feature with all 3 layers
- BLoCs: `FetchWageBloc`, `UpdateWageBloc`
- Use Cases: fetch, set, update
- Datasources: ObjectBox + drift implementations

**FR12-FR14 (Payment Calculation):**
- `features/payment/` — domain + presentation only (no data layer)
- Cubit: `PaymentCubit`
- Use Case: `CalculatePaymentUseCase`

**FR15-FR17 (Localization):**
- `l10n/arb/` — EN/ES ARB files
- `l10n/l10n.dart` — context.l10n accessor

**FR18-FR22 (Multi-Platform):**
- `bootstrap.dart` — platform detection via `kIsWeb`
- `app/view/app_bloc.dart` — platform-aware DI
- `core/services/` — ObjectBox + drift service initialization

**FR23-FR25 (Multi-Environment):**
- `main_development.dart`, `main_staging.dart`, `main_production.dart`
- Each passes environment-specific DB name to bootstrap

**FR26-FR30 (Data Persistence):**
- `features/*/data/datasources/` — ObjectBox + drift datasources
- `features/*/data/repositories/` — dual implementations
- `features/*/domain/repositories/` — shared abstract interfaces
- `core/services/` — Store + Database initialization

**FR31-FR37 (Architecture & Code Organization):**
- Enforced by the directory structure itself
- Feature-first with Data/Domain/Presentation layers

**FR38-FR42 (State Management):**
- `features/*/presentation/bloc/` — sealed classes for events/states
- `core/ui/action_state.dart` — shared ActionState sealed class

**FR43-FR47 (Testing):**
- `test/src/` mirrors `lib/src/` exactly
- `test/goldens/` for visual regression tests
- `test/helpers/` for shared test utilities

**FR48-FR51 (CI/CD):**
- `.github/workflows/main.yaml` — updated pipeline
- `README.md` — professional documentation

### Cross-Cutting Concerns Mapping

| Concern | Location | Used By |
|---|---|---|
| Error handling (GlobalFailure) | `core/errors/failures.dart` | All features' repositories + BLoCs |
| ActionState feedback | `core/ui/action_state.dart` | All CRUD BLoCs |
| Timing constants | `core/constants/app_durations.dart` | All CRUD BLoCs |
| ObjectBox Store | `core/services/objectbox_service.dart` | times + wage datasources |
| drift Database | `core/services/app_database.dart` | times + wage datasources |
| Shared error UI | `shared/widgets/error_view.dart` | All features' error states |
| Shared info UI | `shared/widgets/info_section.dart` | All features' empty states |
| Localization | `l10n/` | All presentation widgets |
| DI wiring | `app/view/app_bloc.dart` | App root — wires everything |
| Test helpers | `test/helpers/` | All test files |

### Data Flow

**CRUD Write Flow (e.g., Create Time Entry):**
```
User taps "Create" → Widget dispatches CreateTimeSubmitted
  → CreateTimeBloc.on<CreateTimeSubmitted>
    → CreateTimeUseCase.call(timeEntry)
      → TimesRepository.create(timeEntry)          [abstract]
        → ObjectboxTimesRepository.create(timeEntry) [impl]
          → TimesObjectboxDatasource.put(timeBox)
            → Box<TimeBox>.put(timeBox)              [ObjectBox]
  ← returns Either<GlobalFailure, TimeEntry>
  → BLoC emits CreateTimeSuccess(timeEntry)
  → await AppDurations.actionFeedback
  → BLoC emits CreateTimeInitial()
  → Widget renders success → then resets
```

**Reactive Read Flow (e.g., List Times):**
```
HomePage builds → Widget dispatches ListTimesRequested
  → ListTimesBloc.on<ListTimesRequested>
    → ListTimesUseCase.call()
      → TimesRepository.fetchTimesStream()         [abstract]
        → ObjectboxTimesRepository.fetchTimesStream() [impl]
          → TimesObjectboxDatasource.watchAll()
            → Box<TimeBox>.query().watch()          [ObjectBox]
  ← returns Either<GlobalFailure, Stream<List<TimeEntry>>>
  → BLoC uses emit.forEach(stream)
  → On each stream emission: BLoC emits ListTimesLoaded(times)
  → Widget rebuilds via BlocBuilder with new data
```

**Payment Calculation Flow:**
```
ListTimesBloc emits ListTimesLoaded(times) → HomePage updates PaymentCubit.setTimes(times)
FetchWageBloc emits FetchWageLoaded(wage)  → HomePage updates PaymentCubit.setWage(wage)

User taps "Calculate" → reads PaymentCubit state
  → CalculatePaymentUseCase.call(times, wage)
  → Returns payment result
  → Navigator pushes PaymentResultPage with result
```

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:**
All technology choices are mutually compatible:
- Flutter 3.41+ / Dart 3.11+ — confirmed latest stable (Feb 2026)
- BLoC 9.x with sealed classes — requires Dart 3, which we have
- Freezed 3.x for domain entities — compatible with Dart 3.11
- ObjectBox 5.x — compatible with Flutter 3.41
- drift 2.32+ — compatible with Flutter 3.41, web via WASM+OPFS
- fpdart — Dart 3 compatible, actively maintained
- very_good_analysis latest — compatible with Dart 3.11
- No version conflicts detected between any dependency pair

**Pattern Consistency:**
- Sealed classes used consistently: BLoC events, BLoC states, ActionState, GlobalFailure, ValueFailure — all union/discriminated types
- Freezed used consistently: only for domain data classes (TimeEntry, WageHourly) where copyWith + equality + JSON are needed
- `final class` for all leaf sealed variants — consistent Dart 3 idiom
- `Either<GlobalFailure, T>` from fpdart — consistent error channel across all repositories and use cases
- `emit.forEach` — consistent stream consumption pattern across all stream-based BLoCs
- `switch` expressions — consistent state rendering across all BlocBuilders
- Naming conventions form a coherent, predictable system — no overlaps or ambiguities

**Structure Alignment:**
- Feature-first Data/Domain/Presentation directly enables all architectural decisions
- Layer boundaries are enforceable via import rules — Domain imports nothing external except fpdart
- Datasource pattern supports ObjectBox/drift dual implementation cleanly
- Cross-feature composition (home + payment) follows the same patterns as business features
- Test structure mirrors source exactly — no ambiguity about where tests go

### Requirements Coverage Validation ✅

**Functional Requirements Coverage:**

| FR Category | FRs | Architectural Support | Status |
|---|---|---|---|
| Time Entry Management | FR1-FR6 | `features/times/` — full CRUD + reactive streams via emit.forEach + ActionState feedback | ✅ |
| Wage Management | FR7-FR11 | `features/wage/` — full CRUD + reactive stream + default value (15.0) in entity | ✅ |
| Payment Calculation | FR12-FR14 | `features/payment/` — CalculatePaymentUseCase + PaymentCubit + PaymentResultPage | ✅ |
| Localization | FR15-FR17 | `l10n/arb/` — EN/ES ARB files, context.l10n, zero hardcoded strings | ✅ |
| SDK & Build | FR52-FR53 | Flutter 3.41+ / Dart 3.11+ specified as minimum SDK | ✅ |
| Multi-Platform | FR18-FR22 | `kIsWeb` platform detection, dual datasources, platform-aware DI | ✅ |
| Multi-Environment | FR23-FR25 | Three entry points with isolated DB names (test-1, stg-1, prod-1) | ✅ |
| Data Persistence | FR26-FR30 | ObjectBox + drift datasources, shared Repository interfaces, reactive streams | ✅ |
| Architecture | FR31-FR37 | Feature-first with Data/Domain/Presentation, 3-tier DI, layer separation | ✅ |
| State Management | FR38-FR42 | Sealed classes, exhaustive pattern matching, emit.forEach, computed state in PaymentCubit | ✅ |
| Testing | FR43-FR47 | Test structure defined, coverage targets per layer, golden test strategy | ✅ |
| CI/CD | FR48-FR51 | Pipeline defined, README planned, conventional commits | ✅ |

**53/53 functional requirements architecturally supported.**

**Non-Functional Requirements Coverage:**

| NFR Category | NFRs | Architectural Support | Status |
|---|---|---|---|
| Performance | NFR1-NFR5 | Local-only operations inherently fast; reactive streams via ObjectBox watch()/drift equivalent; BLoC emit.forEach minimizes UI rebuild overhead; payment calc is pure computation | ✅ |
| Code Quality | NFR6-NFR11 | very_good_analysis (strict), naming conventions enforced, barrel export rules, correct dependency placement, generated files excluded | ✅ |
| Compatibility | NFR12-NFR16 | Platform targets specified (iOS 13+, Android API 21+, Chrome 86+, Windows 10+), OPFS browser support documented, all deps at latest stable | ✅ |
| Reliability | NFR17-NFR21 | Either<GlobalFailure, T> prevents unhandled exceptions, ObjectBox migration path documented, identical test suites via shared Repository interfaces, CI gate enforced | ✅ |

**21/21 non-functional requirements architecturally supported.**

### Implementation Readiness Validation ✅

**Decision Completeness:**
- All critical decisions documented with specific technology versions ✅
- Implementation patterns include concrete Dart code examples for every pattern ✅
- Consistency rules are specific and enforceable (10 mandatory rules + anti-patterns) ✅
- Examples provided for: BLoC events, states, handlers, use cases, repositories, datasources, DI, widget rendering ✅

**Structure Completeness:**
- Complete directory tree with every file annotated ✅
- Test structure mirrors source structure exactly ✅
- Golden test locations specified ✅
- All integration points (DI wiring, cross-feature, platform detection) clearly specified ✅

**Pattern Completeness:**
- All 6 identified conflict points have defined patterns ✅
- Naming conventions cover every architectural element ✅
- Communication patterns (events, states, handlers) fully specified with code ✅
- Process patterns (error handling per layer, DI registration, state rendering) complete ✅

### Gap Analysis Results

**Critical Gaps:** None found

**Important Gaps (resolved during validation):**

1. **GlobalFailure + ValueFailure modernization:** These are union/discriminated types, not data classes. Per the sealed class decision, they migrate to sealed classes — consistent with BLoC events/states and ActionState. Freezed is only for domain data classes (TimeEntry, WageHourly).

2. **ObjectBox 1.7→5.x data migration validation:** Implementation-level concern. Validated in first implementation story by running app against existing dev database. Architecture supports this via Datasource abstraction — if migration fails, only the Datasource layer changes.

**Nice-to-Have Gaps:**

1. **Input validation pattern:** Validation for simple numeric inputs (hours/minutes) stays in BLoC event handlers. No separate validation layer needed at this scale.

### Architecture Completeness Checklist

**✅ Requirements Analysis**

- [x] Project context thoroughly analyzed (53 FRs, 21 NFRs mapped)
- [x] Scale and complexity assessed (low domain, medium-high migration)
- [x] Technical constraints identified (SDK, platform, zero regressions)
- [x] Cross-cutting concerns mapped (8 concerns with locations)

**✅ Architectural Decisions**

- [x] Critical decisions documented with versions (Flutter 3.41+, Dart 3.11+, BLoC 9.x, etc.)
- [x] Technology stack fully specified (all packages with target versions)
- [x] Integration patterns defined (platform-aware DI, stream consumption, cross-feature composition)
- [x] Performance considerations addressed (local-only, reactive streams, efficient state management)

**✅ Implementation Patterns**

- [x] Naming conventions established (files, classes, variables, imports)
- [x] Structure patterns defined (barrel exports, shared vs feature widgets, test mirroring)
- [x] Communication patterns specified (BLoC events/states, handlers, DI registration)
- [x] Process patterns documented (error handling per layer, ActionState flow, widget rendering)

**✅ Project Structure**

- [x] Complete directory structure defined (every file listed)
- [x] Component boundaries established (layer + feature import rules)
- [x] Integration points mapped (DI, cross-feature, platform detection)
- [x] Requirements to structure mapping complete (all 53 FRs mapped to directories)

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** High — all requirements covered, all decisions coherent, comprehensive patterns with code examples

**Key Strengths:**
- Zero ambiguity in layer structure — Data/Domain/Presentation with enforced boundaries
- Complete code examples for every pattern — AI agents can copy the patterns directly
- Dual datasource architecture is clean — Repository interface is the single abstraction
- Migration sequence is well-defined — each step produces a compilable app
- Feature boundaries prevent accidental coupling between features

**Areas for Future Enhancement:**
- If the app grows beyond 4 features, evaluate feature-level barrel exports for cleaner imports
- If drift tables grow complex, consider drift DAO pattern for query organization
- If CI pipeline needs platform-specific testing, evaluate GitHub Actions matrix strategy

### Implementation Handoff

**AI Agent Guidelines:**

- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently across all components
- Respect project structure and boundaries — never cross layer or feature boundaries
- Use the sealed class pattern for ALL union types (BLoC events, states, ActionState, GlobalFailure, ValueFailure)
- Use Freezed ONLY for domain data classes (TimeEntry, WageHourly)
- Refer to this document for all architectural questions before making independent decisions

**First Implementation Priority:**
```bash
# Step 1: SDK constraint update
# pubspec.yaml: environment.sdk: ">=3.11.0 <4.0.0"
# Update Flutter to 3.41+ stable channel
# Verify compilation with: flutter analyze && flutter test
```

**Implementation Sequence:**
1. SDK + dependency migration (compilation checkpoints)
2. Architecture restructure to Data/Domain/Presentation feature-first
3. Sealed classes for BLoC events/states + ActionState + GlobalFailure
4. BLoC 9.x migration with emit.forEach stream pattern
5. Multi-datasource implementation (ObjectBox + drift datasources)
6. flutter_hooks removal → StatefulWidget
7. Naming convention corrections
8. Testing suite (use cases → BLoCs → repositories → widgets → goldens)
9. CI/CD pipeline update
10. Code quality cleanup + professional README

