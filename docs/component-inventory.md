# Component Inventory - TimeMoney

> Generated: 2026-03-16 | Scan Level: Exhaustive

## Overview

TimeMoney uses Flutter's widget system with Material 3 design. Components are organized by feature domain following the BLoC pattern. The app uses `flutter_hooks` for form state management in input widgets.

## State Management Components

### BLoCs (Event-Driven)

| BLoC | Feature | Events | States | Use Case |
|------|---------|--------|--------|----------|
| `CreateTimeBloc` | times | changeHour, changeMinutes, create, reset | CreateTimeState (ActionState + hour + minutes) | CreateTimeUseCase |
| `DeleteTimeBloc` | times | delete(ModelTime) | initial, loading, success, error | DeleteTimeUseCase |
| `UpdateTimeBloc` | times | init, changeHour, changeMinutes, update | UpdateTimeState (ActionState + time?) | UpdateTimeUseCase |
| `ListTimesBloc` | times | getTimes | initial, loading, empty, error, hasDataStream | ListTimesUseCase |
| `FetchWageHourlyBloc` | wage | getWage | initial, loading, empty, error, hasDataStream | FetchWageHourlyUseCase |
| `UpdateWageHourlyBloc` | wage | changeHourly, update | UpdateWageHourlyState (ActionState + wageHourly) | UpdateWageHourlyUseCase |

### Cubits (State-Driven)

| Cubit | Feature | Methods | State |
|-------|---------|---------|-------|
| `ResultPaymentCubit` | result_payment | setList(times), setWage(wage) | ResultPaymentState (times list + wageHourly) |

## Page Components

### ControlHoursPage

**Location**: `lib/src/presentation/control_hours/control_hours_page.dart`
**Type**: StatelessWidget (Main Page)
**Description**: Primary application screen containing all features.

**Layout**:
```
Scaffold
├── AppBar: "Work Payment Controller"
└── Column
    ├── FetchWagePage            (wage display card)
    ├── Expanded: ListTimesPage  (scrollable time entries)
    └── SafeArea: Bottom Action Bar
        ├── CalculatePaymentButton (FAB)
        └── FloatingActionButton "Add Time" → CreateTimeCard dialog
```

## Feature: Time Entry CRUD

### Create Time

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `CreateTimeView` | StatelessWidget | create_time/ | AlertDialog wrapper with title and close button |
| `CreateTimeCard` | StatelessWidget | create_time/widgets/ | Card layout: hour field + minutes field + create button |
| `CreateHourField` | HookWidget | create_time/widgets/ | Numeric input for hours (useTextEditingController) |
| `CreateMinutesField` | HookWidget | create_time/widgets/ | Numeric input for minutes (useTextEditingController) |
| `CreateTimeButton` | StatelessWidget | create_time/widgets/ | Submit button with ActionState visual feedback |
| `CustomCreateField` | StatelessWidget | create_time/widgets/ | Reusable labeled numeric TextField |

### List Times

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `ListTimesPage` | StatelessWidget | list_times/ | State-based rendering: dispatches getTimes, renders appropriate view |
| `ListTimesDataView` | StatelessWidget | list_times/views/ | StreamBuilder → ListView.builder of TimeCards |
| `ErrorListTimesView` | StatelessWidget | list_times/views/ | Error display delegating to ErrorView |
| `ShimmerListTimesView` | StatelessWidget | list_times/views/ | CircularProgressIndicator loading state |
| `EmptyListTimesView` | StatelessWidget | list_times/views/ | ShowInfoSection with clock emoji |
| `TimeCard` | StatelessWidget | list_times/widgets/ | Card: InfoTime + EditButton |
| `InfoTime` | StatelessWidget | list_times/widgets/ | Row: hour CustomInfo + minutes CustomInfo |
| `CustomInfo` | StatelessWidget | list_times/widgets/ | Labeled value row (category + bold value) |
| `EditButton` | StatelessWidget | list_times/widgets/ | FilledButton with edit icon → opens UpdateTimeView |

### Update Time

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `UpdateTimeView` | StatelessWidget | update_time/ | AlertDialog: UpdateTimeCard + DeleteTimeButton + UpdateTimeButton |
| `UpdateTimeCard` | StatelessWidget | update_time/widgets/ | Card layout: hour field + minutes field |
| `UpdateHourField` | HookWidget | update_time/widgets/ | Pre-populated numeric input for hours |
| `UpdateMinutesField` | HookWidget | update_time/widgets/ | Pre-populated numeric input for minutes |
| `UpdateTimeButton` | StatelessWidget | update_time/widgets/ | Green submit button with ActionState feedback |
| `CustomUpdateField` | StatelessWidget | update_time/widgets/ | Reusable labeled numeric TextField (no outside-tap) |

### Delete Time

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `DeleteTimeButton` | StatelessWidget | delete_time/widgets/ | Red button with ActionState feedback |

## Feature: Wage Hourly Management

### Fetch/Display Wage

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `FetchWagePage` | StatelessWidget | fetch_wage/ | State-based rendering: dispatches getWage |
| `WageHourlyDataView` | StatelessWidget | fetch_wage/views/ | StreamBuilder → WageHourlyCard |
| `ErrorFetchWageHourlyView` | StatelessWidget | fetch_wage/views/ | Error display delegating to ErrorView |
| `ShimmerWageHourlyView` | StatelessWidget | fetch_wage/views/ | CircularProgressIndicator loading state |
| `WageHourlyCard` | StatelessWidget | fetch_wage/widgets/ | Primary color card: WageHourlyInfo + UpdateWageButton |
| `WageHourlyInfo` | StatelessWidget | fetch_wage/widgets/ | Column: "hourly:" label + wage value |
| `UpdateWageButton` | StatelessWidget | fetch_wage/widgets/ | ElevatedButton "change" → opens WageHourlyView dialog |

### Update Wage

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `WageHourlyView` | StatelessWidget | update_wage/ | AlertDialog: WageHourlyField + SetWageButton |
| `WageHourlyField` | HookWidget | update_wage/widgets/ | Row: "hourly:" label + decimal numeric input |
| `SetWageButton` | StatelessWidget | update_wage/widgets/ | Green submit button with ActionState feedback |

## Feature: Payment Calculation

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `CalculatePaymentButton` | StatelessWidget | result_payment/ | FAB that observes ResultPaymentCubit, disables when empty |
| `ResultPaymentScreen` | StatelessWidget | result_payment/ | AlertDialog showing: total hours, minutes, rate, days, total payment |

## Shared/Reusable Widgets

| Component | Type | Location | Description |
|-----------|------|----------|-------------|
| `CatchErrorBuilder<T>` | StatelessWidget | widgets/ | Generic AsyncSnapshot error handler with loading/error/data states |
| `ShowInfoSection` | StatelessWidget | widgets/ | Centered info display: image + message + action button |
| `IconText` | StatelessWidget | widgets/ | Scalable text-based emoji/icon display |
| `ErrorView` | StatelessWidget | widgets/views/ | Pattern-matched GlobalFailure display with type-specific icons |
| `CustomCard` | StatelessWidget | widgets/ | Generic card template (appears unused) |

## Design System

- **Theme**: Material 3 with `colorSchemeSeed: Color(6, 16, 31)` (dark blue)
- **Color Conventions**:
  - Delete actions: Red `Color.fromARGB(255, 163, 70, 64)`
  - Update/Success actions: Green `Color.fromARGB(255, 32, 137, 86)`
  - Wage card: Primary color background with white text
- **Input Fields**: OutlineInputBorder with horizontal padding, number keyboard
- **Dialogs**: AlertDialog pattern for all CRUD operations
- **Loading States**: CircularProgressIndicator (adaptive variant in CatchErrorBuilder)
- **Empty States**: ShowInfoSection with emoji icons

## Widget Interaction Patterns

### ActionState Visual Feedback Pattern
All submit buttons follow the same pattern:
1. `initial` → Show action label ("Create", "Update", "Delete")
2. `loading` → Show CircularProgressIndicator
3. `success` → Show "Success" label
4. `error` → Show "Error" label
5. Auto-reset to initial after 500ms delay

### Stream-Based Data Pattern
Both ListTimes and FetchWage follow:
1. BLoC dispatches fetch event on build
2. BLoC returns `hasDataStream` state with `Stream<T>`
3. View uses `StreamBuilder` wrapped in `CatchErrorBuilder`
4. Data view also updates `ResultPaymentCubit` for cross-feature payment calculation
