# Component Inventory - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Summary

| Component Type | Count |
|---|---|
| BLoCs | 6 |
| Cubits | 2 (PaymentCubit, LocaleCubit) |
| Use Cases | 8 |
| Repository Interfaces | 2 |
| Repository Implementations | 4 |
| Datasources | 4 |
| Pages | 8 |
| Feature Widgets | 30 |
| Shared Widgets | 4 |
| Domain Entities | 3 |

## BLoCs

### Times Feature (4 BLoCs)

#### CreateTimeBloc

- **File:** `lib/src/features/times/presentation/bloc/create_time_bloc.dart`
- **Events:** `CreateTimeHourChanged`, `CreateTimeMinutesChanged`, `CreateTimeSubmitted`, `CreateTimeReset`
- **States:** `CreateTimeInitial`, `CreateTimeLoading`, `CreateTimeSuccess`, `CreateTimeError` (sealed, with `ActionState`)
- **Use Case:** `CreateTimeUseCase`
- **State fields carried:** `hour`, `minutes`, `actionState`

#### ListTimesBloc

- **File:** `lib/src/features/times/presentation/bloc/list_times_bloc.dart`
- **Events:** `ListTimesRequested`
- **States:** `ListTimesInitial`, `ListTimesLoading`, `ListTimesEmpty`, `ListTimesError`, `ListTimesSuccess`
- **Use Case:** `ListTimesUseCase`
- **Pattern:** `emit.forEach` for reactive stream consumption

#### UpdateTimeBloc

- **File:** `lib/src/features/times/presentation/bloc/update_time_bloc.dart`
- **Events:** `UpdateTimeInitialized`, `UpdateTimeHourChanged`, `UpdateTimeMinutesChanged`, `UpdateTimeSubmitted`
- **States:** `UpdateTimeInitial`, `UpdateTimeLoading`, `UpdateTimeSuccess`, `UpdateTimeError` (sealed, with `ActionState`)
- **Use Case:** `UpdateTimeUseCase`
- **State fields carried:** `hour`, `minutes`, `id`, `actionState`

#### DeleteTimeBloc

- **File:** `lib/src/features/times/presentation/bloc/delete_time_bloc.dart`
- **Events:** `DeleteTimeSubmitted`
- **States:** `DeleteTimeInitial`, `DeleteTimeLoading`, `DeleteTimeSuccess`, `DeleteTimeError` (sealed, with `ActionState`)
- **Use Case:** `DeleteTimeUseCase`

### Wage Feature (2 BLoCs)

#### FetchWageBloc

- **File:** `lib/src/features/wage/presentation/bloc/fetch_wage_bloc.dart`
- **Events:** `FetchWageRequested`
- **States:** `FetchWageInitial`, `FetchWageLoading`, `FetchWageEmpty`, `FetchWageError`, `FetchWageSuccess`
- **Use Case:** `FetchWageUseCase`
- **Pattern:** `emit.forEach` for reactive stream consumption

#### UpdateWageBloc

- **File:** `lib/src/features/wage/presentation/bloc/update_wage_bloc.dart`
- **Events:** `UpdateWageHourlyChanged`, `UpdateWageSubmitted`
- **States:** `UpdateWageInitial`, `UpdateWageLoading`, `UpdateWageSuccess`, `UpdateWageError` (sealed, with `ActionState`)
- **Use Cases:** `UpdateWageUseCase`, `SetWageUseCase`

## Cubits

### PaymentCubit

- **File:** `lib/src/features/payment/presentation/cubit/payment_cubit.dart`
- **State:** `PaymentState` (holds `totalHours`, `totalMinutes`, `totalPayment`, `wageHourly`, `workedDays`)
- **Methods:** `setList(List<TimeEntry>)`, `setWage(WageHourly)`
- **Cross-feature:** Consumes data from times and wage features

### LocaleCubit

- **File:** `lib/src/core/locale/locale_cubit.dart`
- **State:** `LocaleState` (holds current `Locale`)
- **Methods:** `toggleLocale()`
- **Scope:** Core-level, app-wide locale management

## Use Cases

| Use Case | Feature | Description |
|---|---|---|
| `CreateTimeUseCase` | Times | Creates a new time entry |
| `ListTimesUseCase` | Times | Streams all time entries reactively |
| `UpdateTimeUseCase` | Times | Updates an existing time entry |
| `DeleteTimeUseCase` | Times | Deletes a time entry by ID |
| `FetchWageUseCase` | Wage | Streams current hourly wage |
| `SetWageUseCase` | Wage | Initializes/sets wage if not exists |
| `UpdateWageUseCase` | Wage | Updates existing wage record |
| `CalculatePaymentUseCase` | Payment | Computes payment from times list and wage |

## Datasources

| Datasource | Feature | Platform | Persistence |
|---|---|---|---|
| `TimesObjectBoxDatasource` | Times | Native (iOS/Android/Windows) | ObjectBox |
| `TimesDriftDatasource` | Times | Web | Drift/SQLite |
| `WageObjectBoxDatasource` | Wage | Native (iOS/Android/Windows) | ObjectBox |
| `WageDriftDatasource` | Wage | Web | Drift/SQLite |

## Repository Implementations

| Repository | Feature | Datasource |
|---|---|---|
| `ObjectBoxTimesRepository` | Times | `TimesObjectBoxDatasource` |
| `DriftTimesRepository` | Times | `TimesDriftDatasource` |
| `ObjectBoxWageRepository` | Wage | `WageObjectBoxDatasource` |
| `DriftWageRepository` | Wage | `WageDriftDatasource` |

## Pages

| Page | Feature | Description |
|---|---|---|
| `HomePage` | Home | Main app screen integrating all features |
| `CreateTimePage` | Times | Dialog-based time entry creation |
| `ListTimesPage` | Times | Displays list of tracked time entries |
| `UpdateTimePage` | Times | Dialog-based time entry modification |
| `FetchWagePage` | Wage | Displays current hourly wage |
| `UpdateWagePage` | Wage | Dialog-based wage update |
| `PaymentResultPage` | Payment | Displays calculated payment summary |

## Widgets by Feature

### Home Widgets

| Widget | Description |
|---|---|
| `CalculatePaymentButton` | Triggers payment calculation |

### Times Widgets (21)

| Widget | Category | Description |
|---|---|---|
| `CreateHourField` | Input | Hour input for create dialog |
| `CreateMinutesField` | Input | Minutes input for create dialog |
| `UpdateHourField` | Input | Hour input for update dialog |
| `UpdateMinutesField` | Input | Minutes input for update dialog |
| `CustomCreateField` | Input | Reusable styled field for create forms |
| `CustomUpdateField` | Input | Reusable styled field for update forms |
| `CreateTimeButton` | Action | Submit button for create dialog |
| `UpdateTimeButton` | Action | Submit button for update dialog |
| `DeleteTimeButton` | Action | Delete action with confirmation |
| `EditButton` | Action | Opens update dialog for a time entry |
| `CreateTimeCard` | Composite | Card composing create form fields |
| `UpdateTimeCard` | Composite | Card composing update form fields |
| `TimeCard` | Display | Single time entry display card |
| `InfoTime` | Display | Time entry detail view |
| `CustomInfo` | Display | Formatted info display |
| `ListTimesDataView` | View | Renders list of time cards |
| `ListTimesOtherView` | View | Empty/loading state for times list |
| `ErrorListTimesView` | View | Error state for times list |
| `DeleteTimeConfirmationDialog` | Dialog | Confirmation before deletion |

### Wage Widgets (8)

| Widget | Category | Description |
|---|---|---|
| `WageHourlyField` | Input | Wage amount input field |
| `SetWageButton` | Action | Initial wage setup button |
| `UpdateWageButton` | Action | Submit button for wage update |
| `WageHourlyCard` | Display | Wage display card |
| `WageHourlyInfo` | Display | Wage detail information |
| `WageHourlyOtherView` | View | Empty/loading state for wage |
| `ErrorFetchWageHourlyView` | View | Error state for wage fetch |

### Shared Widgets (4)

| Widget | Description |
|---|---|
| `CatchErrorBuilder` | AsyncSnapshot error catching wrapper |
| `ErrorView` | Reusable GlobalFailure display component |
| `IconText` | Icon + text combination widget |
| `ShowInfoSection` | Information section layout with spacers |

## Injection Components

| Component | File | Description |
|---|---|---|
| `BlocInjections` | `lib/src/shared/injections/bloc_injections.dart` | Aggregates all feature BLoCs for MultiBlocProvider |
| `UseCasesInjection` | `lib/src/shared/injections/use_cases_injection.dart` | Aggregates all use cases for MultiRepositoryProvider |
| `TimesBlocs` | `lib/src/features/times/presentation/bloc/times_blocs.dart` | Static `list()` for times BLoC registration |
| `WageBlocs` | `lib/src/features/wage/presentation/bloc/wage_blocs.dart` | Static `list()` for wage BLoC registration |
| `PaymentCubits` | `lib/src/features/payment/presentation/cubit/payment_cubits.dart` | Static `list()` for payment Cubit registration |
| `TimesInjection` | `lib/src/features/times/times_injection.dart` | Times use case provider registration |
| `WageInjection` | `lib/src/features/wage/wage_injection.dart` | Wage use case provider registration |

## Design Patterns

- **4-State BLoC Pattern:** Initial → Loading → Success/Error for all BLoCs
- **ActionState<T>:** Generic sealed class for embedded CRUD action tracking
- **AppDurations.actionFeedback:** 400ms delay between loading→result and result→initial emissions
- **Sealed Classes:** Native Dart 3 sealed + final classes for all BLoC states/events
- **Freezed:** Reserved exclusively for domain entities (TimeEntry, WageHourly)
- **Either Monad:** All repository methods return `Either<GlobalFailure, T>` via fpdart
- **Reactive Streams:** `emit.forEach` for ObjectBox `watch()` and Drift `watchAll()`
- **buildSubject():** Widget tests centralize widget composition in local function
- **canPop Guard:** Dialog buttons check `Navigator.of(context).canPop` before `pop()`
