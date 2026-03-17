# Data Models - TimeMoney

> Generated: 2026-03-16 | Scan Level: Exhaustive

## Overview

TimeMoney uses **ObjectBox** as its local NoSQL database. The app has two main entities stored in separate ObjectBox Boxes. Domain models are implemented with **Freezed** for immutability, and bidirectional converters bridge domain and database layers.

## Database: ObjectBox

- **Type**: Local embedded NoSQL database
- **Reactive**: Provides `Stream` watchers for real-time UI updates
- **Environments**: Separate database names per flavor (test-1, stg-1, prod-1)

## Entity Relationship Diagram

```
┌──────────────────────┐     ┌──────────────────────────┐
│      TimeBox         │     │     WageHourlyBox         │
│ (ObjectBox Entity)   │     │  (ObjectBox Entity)       │
├──────────────────────┤     ├──────────────────────────┤
│ @Id int id           │     │ @Id int id               │
│ int hour             │     │ double value              │
│ int minutes          │     │                           │
└──────────┬───────────┘     └──────────┬───────────────┘
           │ toFreezedModelTime          │ toFreezedWageHourly
           │ ↕ toTimeBox                 │ ↕ toWageHourlyBox
┌──────────┴───────────┐     ┌──────────┴───────────────┐
│     ModelTime        │     │       WageHourly          │
│  (Domain Entity)     │     │    (Domain Entity)        │
├──────────────────────┤     ├──────────────────────────┤
│ int id (default: 0)  │     │ int id (default: 0)      │
│ int hour             │     │ double value (default: 15)│
│ int minutes          │     │                           │
├──────────────────────┤     └──────────────────────────┘
│ Duration toDuration  │
│ fromJson()           │
└──────────────────────┘
```

**Note**: No explicit relationship between TimeBox and WageHourlyBox. They are independent entities. The relationship is implicit at the presentation layer where both are combined for payment calculation.

## Domain Models

### ModelTime

**Location**: `lib/src/features/times/domain/model_time.dart`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `id` | `int` | `0` | ObjectBox primary key (auto-assigned) |
| `hour` | `int` | required | Hours worked |
| `minutes` | `int` | required | Minutes worked |

**Computed Properties**:
- `toDuration` → `Duration` - Converts hour + minutes to Duration

**Extension Methods** (`CalculatePay` on `List<ModelTime>`):
- `calculatePayment(double wageHourly)` → `double` - Total payment for all entries
- `totalHours` → `int` - Sum of all hours across entries
- `totalMinutes` → `int` - Remaining minutes after hour calculation

**Payment Formula**:
```
totalDuration = sum of all (hour + minutes) as Duration
totalPayment = (totalDuration.inMinutes / 60) * wageHourly
```

### WageHourly

**Location**: `lib/src/features/wage_hourly/domain/wage_hourly.dart`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `id` | `int` | `0` | ObjectBox primary key (auto-assigned) |
| `value` | `double` | `15.0` | Hourly wage rate |

## ObjectBox Entities

### TimeBox

**Location**: `lib/src/features/times/infraestructure/timebox.dart`

| Field | Type | Annotation | Description |
|-------|------|------------|-------------|
| `id` | `int` | `@Id` | ObjectBox auto-generated ID |
| `hour` | `int` | - | Hours worked |
| `minutes` | `int` | - | Minutes worked |

**Converter Extensions**:
- `TimeBox.toFreezedModelTime` → `ModelTime`
- `ModelTime.toTimeBox` → `TimeBox`

### WageHourlyBox

**Location**: `lib/src/features/wage_hourly/infraestructure/wage_hourly_box.dart`

| Field | Type | Annotation | Description |
|-------|------|------------|-------------|
| `id` | `int` | `@Id` | ObjectBox auto-generated ID |
| `value` | `double` | - | Hourly wage rate |

**Converter Extensions**:
- `WageHourlyBox.toFreezedWageHourly` → `WageHourly`
- `WageHourly.toWageHourlyBox` → `WageHourlyBox`

## Repository Interfaces

### TimesRepository

**Location**: `lib/src/features/times/domain/times_repository.dart`

| Method | Parameters | Return Type | Description |
|--------|-----------|-------------|-------------|
| `fetchTimesStream()` | none | `Either<GlobalFailure, Stream<List<ModelTime>>>` | Reactive stream of all time entries |
| `create(ModelTime time)` | `ModelTime` | `Future<Either<GlobalFailure, ModelTime>>` | Create new time entry |
| `delete(ModelTime time)` | `ModelTime` | `Future<Either<GlobalFailure, Unit>>` | Delete time entry by ID |
| `update(ModelTime time)` | `ModelTime` | `Future<Either<GlobalFailure, ModelTime>>` | Update existing time entry |

### WageHourlyRepository

**Location**: `lib/src/features/wage_hourly/domain/wage_hourly_repository.dart`

| Method | Parameters | Return Type | Description |
|--------|-----------|-------------|-------------|
| `fetchWageHourly()` | none | `Either<GlobalFailure, Stream<WageHourly>>` | Reactive stream of current wage |
| `setWageHourly(WageHourly)` | `WageHourly` | `Future<Either<GlobalFailure, WageHourly>>` | Set initial wage value |
| `update(WageHourly)` | `WageHourly` | `Future<Either<GlobalFailure, WageHourly>>` | Update wage value |

## ObjectBox Service

**Location**: `lib/src/core/services/objectbox.dart`

The `ObjectBox` class wraps the ObjectBox Store and provides:

| Property/Method | Type | Description |
|----------------|------|-------------|
| `store` | `Store` | ObjectBox store instance |
| `time` | `Box<TimeBox>` | Box for time entries |
| `wageHourly` | `Box<WageHourlyBox>` | Box for wage data |
| `getTimesStream()` | `Stream<List<ModelTime>>` | Watches time box, maps to domain models |
| `getWageHourlyStream()` | `Stream<WageHourly>` | Watches wage box, maps to domain model |
| `create(String path)` | `static Future<ObjectBox>` | Factory: initializes with app directory |
| `close()` | `void` | Closes the store |

## Error Types

### GlobalFailure\<F\>

**Location**: `lib/src/core/failures/failures.dart`

| Variant | Parameters | Description |
|---------|-----------|-------------|
| `serverError` | `F` | Server-side error |
| `notConnection` | none | No network connectivity |
| `timeOutExceeded` | none | Request timeout |
| `internalError` | `dynamic, StackTrace?` | Local/internal error |

### ValueFailure\<T\>

| Variant | Parameters | Description |
|---------|-----------|-------------|
| `characterLimitExceeded` | `T failedValue` | Input too long |
| `shortOrNullCharacters` | `T failedValue` | Input too short or null |
| `invalidFormat` | `T failedValue` | Invalid format |

## Migration Strategy

ObjectBox handles schema migrations automatically. No manual migration files exist. The database name differs per environment to isolate data.
