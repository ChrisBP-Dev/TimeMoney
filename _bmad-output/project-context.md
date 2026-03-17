---
project_name: 'TimeMoney'
user_name: 'Christopher'
date: '2026-03-16'
sections_completed:
  ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'code_quality', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 43
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Framework**: Flutter 3.7.5 | Dart SDK >=2.19.2 <3.0.0
- **State Management**: bloc ^8.1.1, flutter_bloc ^8.1.2
- **Immutability/Unions**: freezed ^2.3.2, freezed_annotation ^2.2.0
- **Persistence**: objectbox ^1.7.2 (local NoSQL)
- **Error Handling**: dartz ^0.10.1 (Either monad)
- **Code Generation**: build_runner ^2.3.3, json_serializable ^6.6.1, objectbox_generator ^1.7.2
- **Linting**: very_good_analysis ^4.0.0 (strict)
- **Testing**: bloc_test ^9.1.1, mocktail ^0.3.0
- **i18n**: intl ^0.17.0 (en, es)
- **Environments**: 3 flavors — development (test-1), staging (stg-1), production (prod-1)

## Critical Implementation Rules

### Dart Language Rules

- **Absolute imports only**: Always use `package:time_money/...` — never relative imports
- **Freezed for all data classes**: Domain entities and state/event classes must use `@freezed` annotation
- **Either for all error returns**: Repository methods return `Either<GlobalFailure<dynamic>, T>` via dartz — never throw exceptions from repositories
- **Type aliases for return types**: Define `typedef` for complex return types (e.g., `typedef CreateTimeResult = Future<Either<GlobalFailure<dynamic>, ModelTime>>`)
- **Private constructor pattern**: Freezed classes with custom getters need `const ClassName._();` private constructor
- **Extension methods for business logic**: Complex computations on collections use extensions (e.g., `extension CalculatePay on List<ModelTime>`)
- **Generated files excluded from analysis**: `*.g.dart`, `*.freezed.dart` are excluded in `analysis_options.yaml` — never edit these manually
- **Run `build_runner` after model changes**: `dart run build_runner build --delete-conflicting-outputs` after modifying any Freezed or ObjectBox entity

### Flutter & BLoC Framework Rules

- **BLoC for complex flows, Cubit for simple state**: Event-driven `Bloc` for CRUD operations with multiple states; `Cubit` for derived/computed state (e.g., `ResultPaymentCubit`)
- **Freezed for all BLoC states and events**: Every Bloc must define states and events as `@freezed` classes with named constructors (e.g., `DeleteTimeState.initial()`, `DeleteTimeState.loading()`, `DeleteTimeState.error()`, `DeleteTimeState.success()`)
- **State pattern**: All BLoCs follow 4-state pattern: `initial`, `loading`, `error(GlobalDefaultFailure)`, `success/data`
- **Consts.delayed between state transitions**: Insert `await Consts.delayed` (500ms) between loading→result and result→initial emissions for UI feedback
- **3-tier dependency injection**: Repositories → Use Cases → BLoCs, wired in `app_bloc.dart` via `MultiRepositoryProvider` → `UseCasesInjection` → `MultiBlocProvider`
- **Feature-grouped BLoC registration**: Each feature exports a static `list()` method for its BLoCs (e.g., `TimesBlocs.list()`, `WageHourlyBlocs.list()`)
- **View-per-state pattern**: Each BLoC state maps to a dedicated view widget (e.g., `list_times_data_view.dart`, `error_list_times_view.dart`, `loading_list_times_view.dart`, `empty_list_times_view.dart`)
- **Clean Architecture layers**: `domain/` (entities + repository interfaces) → `aplication/` (use cases) → `infraestructure/` (ObjectBox implementations) → `presentation/` (UI)
- **ObjectBox reactive streams**: Use `watch()` streams for real-time UI updates on list queries
- **Localization via context.l10n**: All user-facing strings must use `context.l10n.stringKey` — never hardcode strings

### Testing Rules

- **Test framework**: `flutter_test` (widget), `bloc_test` (BLoC), `mocktail` (mocking)
- **Test helper infrastructure**: `test/helpers/pump_app.dart` provides `pumpApp(widget)` extension that wraps widgets with localization and required providers — always use it for widget tests
- **Mock with mocktail, not mockito**: Use `class MockTimesRepository extends Mock implements TimesRepository {}` pattern
- **BLoC test structure**: Use `blocTest<BlocType, StateType>()` with `build`, `act`, `expect` pattern from `bloc_test` package
- **Test command**: `flutter test --coverage --test-randomize-ordering-seed random`
- **Coverage report**: `genhtml coverage/lcov.info -o coverage/`
- **Test file naming**: Mirror source path — `lib/src/features/times/aplication/create_time_use_case.dart` → `test/src/features/times/aplication/create_time_use_case_test.dart`
- **Current state**: Test infrastructure exists but tests are not yet implemented — new tests should follow the patterns above
- **Test organization**: Unit tests for use cases, BLoC tests for state management, widget tests for presentation layer

### Code Quality & Style Rules

- **Linting**: `very_good_analysis` ^4.0.0 — strict rules enforced; `public_member_api_docs` is disabled
- **File naming**: snake_case for all files with type suffixes: `_bloc.dart`, `_cubit.dart`, `_use_case.dart`, `_repository.dart`, `_view.dart`, `_screen.dart`
- **Class naming**: PascalCase — repository implementations prefixed with `I` (e.g., `ITimesObjectboxRepository`), DB entities suffixed with `Box` (e.g., `TimeBox`)
- **Feature folder structure**: Each feature has exactly 3 layers: `domain/`, `aplication/`, `infraestructure/` (note: existing spelling convention — do not "fix" to `application`/`infrastructure`)
- **Barrel exports**: Features use barrel files to export public APIs (e.g., `times_blocs.dart` exports all time-related BLoCs)
- **Presentation organized by CRUD**: UI screens grouped as `create_*/`, `list_*/`, `update_*/`, `delete_*/` subdirectories
- **Shared code location**: Cross-cutting concerns in `lib/src/core/` (failures, services, extensions, unions) and `lib/src/shared/` (constants, injections)
- **Reusable widgets**: Shared UI components in `lib/src/presentation/widgets/` (e.g., `custom_card.dart`, `error_view.dart`, `catch_error_builder.dart`)
- **Material 3**: App uses `useMaterial3: true` in theme configuration

### Development Workflow Rules

- **Entry points per flavor**: `main_development.dart`, `main_staging.dart`, `main_production.dart` — each initializes ObjectBox with a different DB name
- **Bootstrap pattern**: All flavors call `bootstrap()` from `bootstrap.dart` which sets up `BlocObserver` and runs the app
- **ObjectBox initialization**: `ObjectBox.create(dbName)` is async and must complete before app starts — called in each `main_*.dart`
- **Code generation workflow**: After modifying Freezed/ObjectBox entities: `dart run build_runner build --delete-conflicting-outputs`
- **Localization workflow**: After modifying `.arb` files, run `flutter gen-l10n` to regenerate `app_localizations.dart`
- **Multi-platform support**: iOS, Android, Web, Windows — test changes across platforms when touching platform-specific code
- **Git conventions**: Commit prefixes — `features:`, `fix:`, `chore:`, `docs:` (based on existing history)

### Critical Don't-Miss Rules

**Anti-Patterns to Avoid:**
- NEVER throw exceptions from repository implementations — always catch and wrap in `GlobalFailure.fromException(e)` returning `left()`
- NEVER edit generated files (`*.g.dart`, `*.freezed.dart`, `objectbox.g.dart`, `objectbox-model.json`)
- NEVER use relative imports — the linter will reject them
- NEVER "fix" the spelling of `aplication/` or `infraestructure/` folders — this is the established convention and changing it would break imports project-wide
- NEVER hardcode user-facing strings — always add to `.arb` files and use `context.l10n`
- NEVER create a BLoC state without the 4-state pattern (initial/loading/error/success)
- NEVER skip `Consts.delayed` between BLoC state transitions — UI animations depend on it

**Edge Cases:**
- ObjectBox `put()` returns an `int` ID — domain models use `@Default(0) int id` for new entities
- `GlobalFailure.fromException()` handles `SocketException` → `notConnection` and `TimeoutException` → `timeOutExceeded` — add new exception mappings there, not in repositories
- `TimeBox` and `WageHourlyBox` are ObjectBox-specific entities separate from domain models — always map between them using `.toTimeBox` / `.toModelTime` extensions

**Performance:**
- Use ObjectBox `watch()` streams instead of polling for list updates
- BLoC `emit()` after async operations — never emit synchronously in constructors

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
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-03-16
