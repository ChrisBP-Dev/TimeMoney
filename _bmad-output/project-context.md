---
project_name: 'TimeMoney'
user_name: 'Christopher'
date: '2026-03-20'
sections_completed:
  ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'quality_rules', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 101
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Framework**: Flutter 3.41+ | Dart SDK >=3.11.0 <4.0.0
- **State Management**: bloc ^9.2.0, flutter_bloc ^9.1.1
- **Domain Data Classes**: freezed ^3.2.5, freezed_annotation ^3.1.0 (domain entities only — NOT for BLoC states/events)
- **Error Handling**: fpdart ^1.2.0 (Either monad — replaced dartz)
- **Persistence (native)**: objectbox ^5.2.0 (iOS, Android, Windows — local NoSQL via FFI)
- **Persistence (web)**: drift ^2.32.0 + drift_flutter (SQLite via WASM + OPFS)
- **Code Generation**: build_runner ^2.4.14, json_serializable ^6.6.1, objectbox_generator ^5.2.0, drift_dev
- **Linting**: very_good_analysis ^10.2.0 (strict, public_member_api_docs enabled)
- **Testing**: bloc_test ^10.0.0, mocktail ^1.0.0
- **i18n**: intl ^0.20.0 (en, es via ARB files)
- **Environments**: 3 flavors — development, staging, production
- **Platforms**: iOS, Android, Web, Windows (multi-platform with platform-aware DI)

## Critical Implementation Rules

### Dart Language Rules

- **Absolute imports only**: Always use `package:time_money/...` — never relative imports
- **Dart 3 sealed classes for BLoC states/events**: Use native `sealed class` + `final class` subtypes — Freezed is NOT used for states/events anymore
- **Freezed only for domain entities**: `@freezed` annotation reserved exclusively for data classes (`TimeEntry`, `WageHourly`) — domain layer only
- **Either for all error returns**: Repository methods return `Either<GlobalFailure, T>` via fpdart — never throw exceptions from repositories
- **Type aliases for return types**: Define `typedef` for complex return types (e.g., `typedef CreateTimeResult = Future<Either<GlobalFailure, TimeEntry>>`)
- **Private constructor pattern**: Freezed classes with custom getters/methods need `const ClassName._();` private constructor
- **Extension methods for business logic**: Complex computations on collections use extensions (e.g., `extension CalculatePay on List<TimeEntry>`)
- **Extension methods for data mapping**: Use extensions on generated DB types for domain conversion (e.g., `extension ConvertTimesTableData on TimesTableData { TimeEntry get toTimeEntry => ... }`)
- **Manual equality on sealed classes**: `final class` subtypes of sealed classes must implement `operator ==` and `hashCode` manually (Freezed does NOT generate these for non-Freezed classes)
- **Generated files excluded from analysis**: `*.g.dart`, `*.freezed.dart` are excluded in `analysis_options.yaml` — never edit these manually
- **Run `build_runner` after model changes**: `dart run build_runner build --delete-conflicting-outputs` after modifying any Freezed, ObjectBox, or Drift entity
- **Dartdoc comments mandatory**: All public classes, methods, and fields must have `///` dartdoc comments — `public_member_api_docs` linter rule is enabled
- **Conditional imports for platform code**: Use `import 'web.dart' if (dart.library.io) 'native.dart'` pattern for compile-time platform selection — never use runtime `kIsWeb` checks in bootstrap/DI code

### Flutter & BLoC Framework Rules

- **BLoC for complex flows, Cubit for simple state**: Event-driven `Bloc` for CRUD operations with multiple states; `Cubit` for derived/computed state (e.g., `PaymentCubit`)
- **Sealed classes for BLoC states and events**: Every Bloc defines states and events as native Dart 3 `sealed class` hierarchies — NOT Freezed (e.g., `sealed class CreateTimeState`, `final class CreateTimeInitial extends CreateTimeState`)
- **4-state BLoC pattern**: All BLoCs follow: `Initial`, `Loading`, `Error(GlobalFailure)`, `Success(data)` — state fields (hour, minutes) carried across all subtypes
- **ActionState<T> for embedded CRUD tracking**: Generic sealed class (`ActionInitial`, `ActionLoading`, `ActionSuccess(data)`, `ActionError(failure)`) used inside BLoC states for individual action feedback — provides boolean convenience getters (`isInitial`, `isLoading`, `isSuccess`, `isError`)
- **AppDurations.actionFeedback between transitions**: Insert `await Future<void>.delayed(AppDurations.actionFeedback)` (400ms) between loading→result and result→initial emissions for UI feedback
- **3-tier dependency injection**: Repositories → Use Cases → BLoCs, wired in `app_bloc.dart` via `MultiRepositoryProvider` → `UseCasesInjection` → `MultiBlocProvider`
- **Platform-aware DI via conditional imports**: `bootstrap_repositories_native.dart` (ObjectBox) and `bootstrap_repositories_web.dart` (Drift) selected at compile time — `createRepositories(dbName)` returns `({TimesRepository, WageRepository, Future<void> Function() close})` record
- **Database lifecycle management**: Close callback from `createRepositories()` must be registered with `WidgetsBindingObserver` to close DB on `AppLifecycleState.detached`
- **Feature-grouped BLoC registration**: Each feature exports a static `list()` method for its BLoCs (e.g., `TimesBlocs.list()`, `WageBlocs.list()`)
- **Clean Architecture layers**: `domain/` (entities + repository interfaces + use_cases) → `data/` (datasources + models + repository implementations) → `presentation/` (bloc + pages + widgets)
- **Dual datasource per feature**: Each feature has ObjectBox datasource (native) + Drift datasource (web) implementing the same repository interface — no code duplication at domain/presentation layers
- **Datasource contract**: Datasources are low-level persistence wrappers — `watchAll()` returns reactive streams, `insert()`/`update()`/`remove()` return metadata (ID or affected row count), never domain entities
- **emit.forEach for reactive streams**: Use `emit.forEach` in BLoC event handlers for stream consumption (both ObjectBox `watch()` and Drift `watchAll()`)
- **Localization via context.l10n**: All user-facing strings must use `context.l10n.stringKey` — never hardcode strings
- **Material 3**: App uses `useMaterial3: true` in theme configuration
- **Cross-feature composition**: Features can depend on other features' domain layer only (e.g., PaymentCubit depends on times + wage use cases)
- **Single Drift database**: One `AppDatabase` aggregates all feature tables via `@DriftDatabase(tables: [...])` — no per-feature databases
- **Drift web setup**: Uses `driftDatabase()` with WASM (`sqlite3.wasm`) + OPFS storage; native uses file-system driver via `drift_flutter`

### Testing Rules

- **Test framework**: `flutter_test` (widget), `bloc_test` (BLoC), `mocktail` (mocking)
- **Test helper infrastructure**: `test/helpers/pump_app.dart` provides `pumpApp(widget)` extension that wraps widgets with localization and required providers — always use it for widget tests
- **Mock with mocktail, not mockito**: Use `class MockTimesRepository extends Mock implements TimesRepository {}` pattern — declared locally in each test file
- **BLoC test structure**: Use `blocTest<BlocType, StateType>()` with `build`, `act`, `expect` pattern from `bloc_test` package
- **Test command**: `flutter test --coverage --test-randomize-ordering-seed random`
- **Coverage report**: `genhtml coverage/lcov.info -o coverage/`
- **Test file naming**: Mirror source path exactly — `lib/src/features/times/domain/use_cases/create_time_use_case.dart` → `test/src/features/times/domain/use_cases/create_time_use_case_test.dart`
- **Test organization**: Unit tests for use cases, BLoC tests for state management, widget tests for presentation layer — all fully implemented
- **Group structure**: Use `group('ClassName', () { ... })` wrapping related tests with descriptive `test('returns Right with X on success')` names
- **setUp pattern**: Initialize mocks and SUT in `setUp()` — declare as `late` variables at group scope
- **Const test fixtures**: Define test data as top-level `const` values (e.g., `const testTime = TimeEntry(hour: 1, minutes: 30)`)
- **Verify calls**: Always `verify(() => mock.method(args)).called(1)` after assertions to confirm repository interaction
- **Tests ship with implementation**: Every story delivers tests alongside production code — never deferred
- **Drift tests use in-memory database**: Use `NativeDatabase.memory()` for Drift integration tests — fast, isolated, no filesystem cleanup needed
- **Datasource tests validate stream reactivity**: Drift datasource tests must verify `watchAll()` emits updated data after mutations (insert, update, remove)
- **Repository tests mock datasources**: Drift repository tests mock the datasource layer (not the database) and verify `Either<GlobalFailure, T>` wrapping and exception-to-failure mapping
- **Affected-row semantics in tests**: Test that update/remove operations handle 0-row results (non-existent ID) as failure cases
- **Test documentation standard**: Test files require `library;` dartdoc comment, `group()` comments explaining purpose, and `test()` names as complete descriptive sentences

### Code Quality & Style Rules

- **Linting**: `very_good_analysis` ^10.2.0 — strict rules enforced; zero warnings policy, `flutter analyze` must pass clean
- **Dartdoc**: `public_member_api_docs` enabled — all public classes, methods, fields, and top-level declarations require `///` comments
- **File naming**: snake_case for all files with type suffixes: `_bloc.dart`, `_event.dart`, `_state.dart`, `_cubit.dart`, `_use_case.dart`, `_repository.dart`, `_datasource.dart`, `_page.dart`
- **Class naming**: PascalCase — repository implementations prefixed with datasource name (e.g., `ObjectboxTimesRepository`, `DriftTimesRepository`), DB entities suffixed by storage type (`TimeBox` for ObjectBox, `TimesTable` for Drift)
- **Drift naming conventions**: Tables as `{Feature}Table` (e.g., `TimesTable`, `WageHourlyTable`), datasources as `{Feature}DriftDatasource`, repositories as `Drift{Feature}Repository`, generated data classes as `{Table}Data` (e.g., `TimesTableData`)
- **BLoC naming**: `{Action}{Feature}Bloc` → `CreateTimeBloc`, `ListTimesBloc`, `UpdateTimeBloc`, `DeleteTimeBloc`
- **Use Case naming**: `{Action}{Feature}UseCase` → `CreateTimeUseCase`, `ListTimesUseCase`
- **Feature folder structure**: Each feature has up to 3 layers: `domain/` (entities, repositories, use_cases), `data/` (datasources, models, repositories), `presentation/` (bloc, pages, widgets)
- **Dual datasource files per feature**: Each feature's `data/datasources/` contains both `{feature}_objectbox_datasource.dart` and `{feature}_drift_datasource.dart`; `data/models/` contains both `{feature}_box.dart` and `{feature}_table.dart`
- **Barrel exports**: Each folder with 2+ public files gets a barrel file — named after the folder content (e.g., `entities.dart`, `use_cases.dart`); barrel files start with `library;` directive
- **Presentation organized by CRUD**: BLoC files grouped as `create_time_bloc.dart`, `list_times_bloc.dart`, etc. within a single `bloc/` directory
- **Shared code in core/**: Cross-cutting concerns in `lib/src/core/` — errors (failures), services (ObjectBox, AppDatabase), extensions, UI (ActionState), constants, locale
- **Reusable widgets in shared/**: Cross-feature UI components in `lib/src/shared/widgets/` (e.g., `error_view.dart`, `info_section.dart`, `icon_text.dart`)
- **Import order**: `dart:` → `package:` (external) → `package:time_money/` (project) — enforced by linter
- **Bootstrap files at lib/ root**: `bootstrap.dart` (platform-agnostic), `bootstrap_repositories_native.dart`, `bootstrap_repositories_web.dart` — not inside `src/`

### Development Workflow Rules

- **Entry points per flavor**: `main_development.dart`, `main_staging.dart`, `main_production.dart` — each calls `bootstrap(dbName: 'test-1'|'stg-1'|'prod-1')` for environment-isolated databases
- **Bootstrap pattern**: All flavors call `bootstrap()` from `bootstrap.dart` which sets up `BlocObserver`, registers lifecycle observer for DB cleanup, and runs the app in a guarded zone with `_BootstrapErrorApp` fallback UI
- **Platform-aware initialization**: `bootstrap()` calls `createRepositories(dbName)` — resolved at compile time to ObjectBox (native) or Drift (web) via conditional imports
- **ObjectBox initialization**: `ObjectboxService.create()` is async and must complete before app starts — called in `bootstrap_repositories_native.dart`
- **Drift initialization**: `AppDatabase.named(dbName)` creates database with platform-aware connection — WASM+OPFS on web, file system on native — called in `bootstrap_repositories_web.dart`
- **Code generation workflow**: After modifying Freezed/ObjectBox/Drift entities: `dart run build_runner build --delete-conflicting-outputs`
- **Localization workflow**: After modifying `.arb` files, run `flutter gen-l10n` to regenerate localization code
- **Git commit prefixes**: `feat:` (new features), `refactor:` (code improvements), `fix:` (bug fixes), `chore:` (admin/reviews), `docs:` (documentation)
- **Story-driven development**: Each story delivers implementation + tests together, status set to `review` (never `done`) — only code review decides done
- **CI/CD**: GitHub Actions with semantic PR validation, flutter_package build/test, spell-check on markdown
- **Multi-platform testing**: When touching persistence or DI code, verify changes across native (ObjectBox) and web (Drift) paths — both datasources must maintain behavioral parity
- **BMad workflow**: Sprint planning → story creation → story validation → dev story → code review → retrospective
- **Project context updates**: `project-context.md` must be reviewed and updated at each epic retrospective closure

### Critical Don't-Miss Rules

**Anti-Patterns to Avoid:**
- NEVER throw exceptions from repository implementations — always catch with `on Object catch (e)` and wrap in `GlobalFailure.fromException(e)` returning `left()`
- NEVER edit generated files (`*.g.dart`, `*.freezed.dart`, `objectbox.g.dart`, `objectbox-model.json`)
- NEVER use relative imports — the linter will reject them
- NEVER use Freezed for BLoC states/events — use native Dart 3 sealed classes
- NEVER hardcode user-facing strings — always add to `.arb` files and use `context.l10n`
- NEVER create a BLoC state without the 4-state pattern (Initial/Loading/Error/Success)
- NEVER skip `AppDurations.actionFeedback` delay between BLoC state transitions — UI animations depend on it
- NEVER leave linter warnings — zero tolerance policy, `flutter analyze` must be clean
- NEVER mark a story as `done` — set to `review` only; code review decides done
- NEVER defer tests — every story ships tests with implementation
- NEVER use runtime `kIsWeb` checks for platform DI — use conditional imports (`if (dart.library.io)`) for compile-time selection
- NEVER import ObjectBox packages in web bootstrap or Drift web packages in native bootstrap — conditional imports enforce separation at compile time
- NEVER create per-feature Drift databases — all tables aggregate in single `AppDatabase`
- NEVER accept "pre-existing" as justification for ignoring tech debt — must resolve or have explicit plan

**Edge Cases:**
- ObjectBox `put()` returns an `int` ID — domain models use `@Default(0) int id` for new entities
- Drift `insert()` also returns an `int` auto-increment ID — same `@Default(0) int id` convention applies
- Drift `update()`/`remove()` return affected row count — 0 rows means record not found, must be handled as failure in repository
- Drift wage repository: when `id == 0`, performs insert instead of update — mirrors ObjectBox `put()` behavior where id=0 means new entity
- `GlobalFailure.fromException()` handles `TimeoutException` → `TimeOutExceeded()` and everything else → `InternalError`. Platform-specific mappings (e.g. `SocketException` → `NotConnection`) belong in the data layer per Dependency Inversion, NOT in the domain factory
- `TimeBox` and `WageHourlyBox` are ObjectBox-specific entities; `TimesTable` and `WageHourlyTable` are Drift-specific — always map between them and domain models using conversion extensions (`.toTimeEntry`, `.toWageHourly`)
- Sealed class subtypes must carry parent state fields (e.g., `hour`, `minutes` carried in all `CreateTimeState` subtypes)

**Performance:**
- Use reactive streams (`watch()` for ObjectBox, `watchAll()` for Drift) with `emit.forEach` instead of polling for list updates
- BLoC `emit()` after async operations — never emit synchronously in constructors
- Use `const` constructors wherever possible for sealed class instances
- Drift `NativeDatabase.memory()` for tests only — never in production; production uses `driftDatabase()` with platform-aware executor

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review at each epic retrospective for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-03-20
