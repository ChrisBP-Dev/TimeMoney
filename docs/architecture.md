# Architecture - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Architecture Overview

TimeMoney uses **Feature-First Clean Architecture** with a dual datasource persistence strategy. Each feature is self-contained with its own Data, Domain, and Presentation layers, enabling independent development and testing.

```
+---------------------------------------------------+
|              PRESENTATION LAYER                    |
|   BLoC/Cubit  |  Pages  |  Widgets                |
+---------------------------------------------------+
|               DOMAIN LAYER                         |
|   Entities (Freezed)  |  Repository Interfaces     |
|   Use Cases (single-responsibility)                |
+---------------------------------------------------+
|                DATA LAYER                          |
|   +--------------+  +------------------------+    |
|   |   ObjectBox   |  |       Drift            |    |
|   |  (iOS/Android |  |  (Web - SQLite via     |    |
|   |   /Windows)   |  |   WASM + OPFS)         |    |
|   +--------------+  +------------------------+    |
+---------------------------------------------------+
|                CORE LAYER                          |
|   Errors | Services | Extensions | Constants       |
+---------------------------------------------------+
```

## Layer Responsibilities

### Presentation Layer

- **BLoC (complex flows):** Event-driven state management for CRUD operations. Uses Dart 3 `sealed class` hierarchies for states and events.
- **Cubit (simple state):** For derived/computed state like `PaymentCubit` and `LocaleCubit`.
- **Pages:** Screen-level widgets that compose feature UI.
- **Widgets:** Reusable UI components within each feature.

**State Pattern:** All BLoCs follow the 4-state pattern: `Initial`, `Loading`, `Error(GlobalFailure)`, `Success(data)`. The `ActionState<T>` sealed class provides embedded CRUD tracking with boolean convenience getters (`isInitial`, `isLoading`, `isSuccess`, `isError`).

### Domain Layer

- **Entities:** Immutable data classes using Freezed (domain layer only — NOT for BLoC states/events).
- **Repository Interfaces:** Abstract contracts defining data access methods. Return `Either<GlobalFailure, T>` via fpdart.
- **Use Cases:** Single-responsibility classes encapsulating business logic. Each use case wraps a single repository call.

### Data Layer

- **Datasources:** Low-level persistence wrappers. `watchAll()` returns reactive streams, `insert()`/`update()`/`remove()` return metadata (ID or affected row count), never domain entities.
- **Models:** Platform-specific data models — `TimeBox`/`WageHourlyBox` (ObjectBox), `TimesTable`/`WageHourlyTable` (Drift).
- **Repository Implementations:** Concrete implementations that map between datasource and domain models.

### Core Layer

- **Errors:** `GlobalFailure` sealed class (ServerError, NotConnection, TimeOutExceeded, InternalError) and `ValueFailure` sealed class for domain validation.
- **Services:** Database initialization — `ObjectboxService` (native) and `AppDatabase` (Drift/web).
- **Extensions:** Context utilities (`isMobile`, `getWidth`), boolean helpers.
- **Constants:** `AppDurations` (animation timing), breakpoints for responsive design.
- **UI:** `ActionState<T>` reusable sealed class for embedded action tracking.
- **Locale:** `LocaleCubit` for runtime language switching (EN/ES).

## Dependency Injection

Three-tier DI wired in `app_bloc.dart`:

```
Repositories (MultiRepositoryProvider)
  → Use Cases (UseCasesInjection)
    → BLoCs (MultiBlocProvider via feature-grouped .list() methods)
```

### Platform-Aware DI

Platform selection happens at compile time via conditional imports:

```dart
// bootstrap.dart
import 'bootstrap_repositories_web.dart'
    if (dart.library.io) 'bootstrap_repositories_native.dart';
```

- `bootstrap_repositories_native.dart` → ObjectBox (iOS, Android, Windows)
- `bootstrap_repositories_web.dart` → Drift (Web — SQLite via WASM + OPFS)

Both return a `({TimesRepository, WageRepository, Future<void> Function() close})` record.

## Data Flow

### CRUD Operation (e.g., Create Time Entry)

```
User Input → Widget → BLoC Event
  → BLoC Handler → Use Case → Repository Interface
    → Repository Implementation → Datasource (ObjectBox or Drift)
      → Datasource returns ID/metadata
    → Repository wraps result in Either<GlobalFailure, TimeEntry>
  → BLoC emits Loading → Success/Error states (with ActionState feedback delay)
→ Widget rebuilds via BlocBuilder/BlocListener
```

### Reactive Streams (e.g., List Times)

```
BLoC receives ListTimesRequested event
  → emit.forEach(useCase.call()) subscribes to reactive stream
    → ObjectBox: store.box<TimeBox>().query().watch().map(...)
    → Drift: select(timesTable).watch().map(...)
  → Stream emits updated list whenever data changes
→ BLoC emits new ListTimesSuccess(entries) state
→ UI rebuilds automatically
```

## Error Handling

- Repositories catch all exceptions with `on Object catch (e)` and wrap in `GlobalFailure.fromException(e)`.
- `GlobalFailure.fromException()` maps: `TimeoutException` → `TimeOutExceeded`, everything else → `InternalError`.
- Use cases pass through `Either<GlobalFailure, T>` from repositories.
- BLoCs fold the Either: `left` → Error state, `right` → Success state.
- UI displays failures via `ErrorView` widget using localized messages.

## Database Lifecycle

The `createRepositories()` function returns a `close` callback registered with `WidgetsBindingObserver` in `bootstrap.dart`. The database is closed on `AppLifecycleState.detached`.

## Feature Structure Template

Each feature follows this structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_objectbox_datasource.dart
│   │   ├── feature_drift_datasource.dart
│   │   └── datasources.dart
│   ├── models/
│   │   ├── feature_box.dart        (ObjectBox)
│   │   ├── feature_table.dart      (Drift)
│   │   └── models.dart
│   └── repositories/
│       ├── objectbox_feature_repository.dart
│       ├── drift_feature_repository.dart
│       └── repositories.dart
├── domain/
│   ├── entities/
│   │   ├── feature_entity.dart     (Freezed)
│   │   └── entities.dart
│   ├── repositories/
│   │   ├── feature_repository.dart (Interface)
│   │   └── repositories.dart
│   └── use_cases/
│       ├── action_feature_use_case.dart
│       └── use_cases.dart
└── presentation/
    ├── bloc/
    │   ├── action_feature_bloc.dart
    │   ├── action_feature_event.dart
    │   ├── action_feature_state.dart
    │   ├── feature_blocs.dart      (injection helper)
    │   └── bloc.dart
    ├── pages/
    │   ├── feature_page.dart
    │   └── pages.dart
    └── widgets/
        ├── feature_widget.dart
        └── widgets.dart
```

## Cross-Feature Composition

Features can depend on other features' domain layer only. Example: `PaymentCubit` depends on `ListTimesUseCase` (times feature) and `FetchWageUseCase` (wage feature) to calculate payments.

## Multi-Platform Support

| Platform | Persistence | Build Command |
|---|---|---|
| iOS | ObjectBox (FFI) | `flutter build ios --flavor production --target lib/main_production.dart` |
| Android | ObjectBox (FFI) | `flutter build appbundle --flavor production --target lib/main_production.dart` |
| Web | Drift (SQLite WASM + OPFS) | `flutter build web --target lib/main_production.dart` |
| Windows | ObjectBox (FFI) | `flutter build windows --target lib/main_production.dart` |
