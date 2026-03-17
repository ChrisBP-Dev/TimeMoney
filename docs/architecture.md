# Architecture - TimeMoney

> Generated: 2026-03-16 | Scan Level: Exhaustive

## Executive Summary

TimeMoney follows **Clean Architecture** with a **feature-based organization** pattern. The app uses the **BLoC pattern** for state management, **ObjectBox** for local persistence, and **Dartz Either** for functional error handling. The architecture enforces clear separation between domain logic, data access, and presentation.

## Architecture Pattern

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │  Widgets  │  │  Views   │  │  BLoCs / Cubits  │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────┤
│                   APPLICATION                        │
│  ┌──────────────────────────────────────────────┐   │
│  │              Use Cases                        │   │
│  │  (CreateTimeUseCase, ListTimesUseCase, ...)   │   │
│  └──────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────┤
│                     DOMAIN                           │
│  ┌────────────┐  ┌──────────────────────────────┐   │
│  │   Entities  │  │  Repository Interfaces       │   │
│  │ (ModelTime, │  │ (TimesRepository,            │   │
│  │ WageHourly) │  │  WageHourlyRepository)       │   │
│  └────────────┘  └──────────────────────────────┘   │
├─────────────────────────────────────────────────────┤
│                 INFRASTRUCTURE                       │
│  ┌──────────────┐  ┌────────────────────────────┐   │
│  │  ObjectBox    │  │  Repository Implementations│   │
│  │  Entities     │  │  (ITimesObjectboxRepository,│  │
│  │ (TimeBox,     │  │  IWageHourlyObjectbox...)   │  │
│  │ WageHourlyBox)│  └────────────────────────────┘   │
│  └──────────────┘                                    │
├─────────────────────────────────────────────────────┤
│                    CORE                              │
│  ┌──────────┐  ┌──────────┐  ┌─────────────────┐   │
│  │ Failures │  │ Services │  │  ActionState<T>  │   │
│  │ (Freezed)│  │(ObjectBox)│  │  (Union Type)    │   │
│  └──────────┘  └──────────┘  └─────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Layer Details

### Domain Layer (`lib/src/features/*/domain/`)

The innermost layer with zero external dependencies. Contains:

- **Entities**: Immutable data classes using Freezed
  - `ModelTime` - Work time entry with `id`, `hour`, `minutes`
  - `WageHourly` - Hourly wage rate with `id`, `value`
- **Repository Interfaces**: Abstract contracts defining data operations
  - `TimesRepository` - CRUD operations for time entries
  - `WageHourlyRepository` - Fetch/set/update wage rate
- **Type Aliases**: Return types using `Either<GlobalFailure, T>` for explicit error handling

### Application Layer (`lib/src/features/*/aplication/`)

Use cases implementing single-responsibility operations:

| Use Case | Feature | Operation | Return Type |
|----------|---------|-----------|-------------|
| `CreateTimeUseCase` | times | Create entry | `Future<Either<GlobalFailure, ModelTime>>` |
| `DeleteTimeUseCase` | times | Delete entry | `Future<Either<GlobalFailure, Unit>>` |
| `ListTimesUseCase` | times | Stream list | `Either<GlobalFailure, Stream<List<ModelTime>>>` |
| `UpdateTimeUseCase` | times | Update entry | `Future<Either<GlobalFailure, ModelTime>>` |
| `FetchWageHourlyUseCase` | wage | Stream wage | `Either<GlobalFailure, Stream<WageHourly>>` |
| `SetWageHourlyUseCase` | wage | Set initial | `Future<Either<GlobalFailure, WageHourly>>` |
| `UpdateWageHourlyUseCase` | wage | Update wage | `Future<Either<GlobalFailure, WageHourly>>` |

### Infrastructure Layer (`lib/src/features/*/infraestructure/`)

Concrete implementations of domain interfaces:

- **Repository Implementations**: Use ObjectBox for persistence
  - `ITimesObjectboxRepository` implements `TimesRepository`
  - `IWageHourlyObjectboxRepository` extends `WageHourlyRepository`
- **ObjectBox Entities**: Database-specific models with bidirectional converters
  - `TimeBox` ↔ `ModelTime` (via extension methods)
  - `WageHourlyBox` ↔ `WageHourly` (via extension methods)

### Presentation Layer (`lib/src/presentation/`)

UI components organized by feature:

- **BLoCs**: Handle UI events and manage state transitions
  - Event-driven (Bloc): CreateTime, DeleteTime, UpdateTime, ListTimes, FetchWage, UpdateWage
  - State-driven (Cubit): ResultPayment
- **Views**: State-specific UI (data, error, loading, empty)
- **Widgets**: Reusable UI components (cards, fields, buttons)

### Core Layer (`lib/src/core/`)

Cross-cutting concerns shared across features:

- **Failures**: `GlobalFailure<F>` (serverError, notConnection, timeOutExceeded, internalError) and `ValueFailure<T>` for validation
- **ActionState\<T\>**: Generic union type for async operation states (initial → loading → success/error)
- **ObjectBox Service**: Database wrapper managing Store and Boxes with reactive streams
- **Responsive Utilities**: Breakpoints, ScreenType enum, context extensions

## Dependency Injection

Three-tier injection setup in `AppBloc`:

```
main_*.dart → Creates ObjectBox + Repository implementations
    ↓
AppBloc (MultiRepositoryProvider)
    ├── UseCasesInjection.list(repositories)
    │   ├── TimesUseCasesInjections (4 use cases)
    │   └── WageHourlyUseCasesInjections (3 use cases)
    ↓
AppBloc (MultiBlocProvider)
    └── BlocInjections.list()
        ├── TimesBlocs (4 blocs)
        ├── WageHourlyBlocs (2 blocs)
        └── ResultPaymentCubits (1 cubit)
```

## Data Flow

### Read Flow (Reactive)
```
ObjectBox Store → Stream<List<T>> → Repository → UseCase → BLoC → StreamBuilder → UI
```

### Write Flow (CRUD)
```
UI Event → BLoC → UseCase → Repository → ObjectBox Store → (triggers stream update)
```

### Payment Calculation Flow
```
ListTimesDataView → ResultPaymentCubit.setList(times)
WageHourlyDataView → ResultPaymentCubit.setWage(wage)
CalculatePaymentButton → reads cubit state → ResultPaymentScreen
    → times.calculatePayment(wageHourly) → displays total
```

## Error Handling Strategy

1. **Infrastructure**: Catches exceptions, wraps in `GlobalFailure` via `fromException()`
2. **Domain**: Returns `Either<GlobalFailure, T>` - no thrown exceptions
3. **Application**: Passes through Either without modification
4. **Presentation**: BLoC folds Either into success/error states
5. **UI**: Pattern-matched error display via `ErrorView` with type-specific icons and messages

## Multi-Environment Configuration

| Environment | Entry Point | Database | Purpose |
|-------------|-------------|----------|---------|
| Development | `main_development.dart` | `test-1` | Local development |
| Staging | `main_staging.dart` | `stg-1` | Pre-production testing |
| Production | `main_production.dart` | `prod-1` | Released builds |

Each environment uses a separate ObjectBox database name to isolate data.

## Testing Strategy

- **Framework**: flutter_test + bloc_test + mocktail
- **Linting**: very_good_analysis v4 (strict rules)
- **Helper Utilities**: `pumpApp()` extension for widget testing with localization
- **Current Coverage**: Minimal - only test helper infrastructure exists
- **CI/CD**: GitHub Actions with VGV reusable workflows (build, semantic PR, spell-check)
