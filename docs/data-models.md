# Data Models - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Overview

TimeMoney uses a three-tier data model strategy:

1. **Domain Entities** (Freezed) — Platform-agnostic business objects
2. **ObjectBox Models** — Native persistence (iOS, Android, Windows)
3. **Drift Tables** — Web persistence (SQLite via WASM + OPFS)

Conversion between tiers is handled by extension methods on each data model class.

## Domain Entities

### TimeEntry

```dart
@freezed
class TimeEntry with _$TimeEntry {
  const TimeEntry._();
  const factory TimeEntry({
    @Default(0) int id,
    required int hour,
    required int minutes,
  }) = _TimeEntry;
}
```

**Location:** `lib/src/features/times/domain/entities/time_entry.dart`

**Extensions:**
- `toDuration` → converts to `Duration`
- `CalculatePay` on `List<TimeEntry>`:
  - `calculatePayment(double wageHourly)` → total payment
  - `totalHours` → sum of hours across all entries
  - `totalMinutes` → sum of minutes across all entries

### WageHourly

```dart
@freezed
class WageHourly with _$WageHourly {
  const factory WageHourly({
    @Default(0) int id,
    @Default(15.0) double value,
  }) = _WageHourly;
}
```

**Location:** `lib/src/features/wage/domain/entities/wage_hourly.dart`

### PaymentResult

```dart
@immutable
class PaymentResult {
  final int totalHours;
  final int totalMinutes;
  final double wageHourly;
  final double totalPayment;
  final int workedDays;
}
```

**Location:** `lib/src/features/payment/domain/entities/payment_result.dart`

Implements manual `operator ==` and `hashCode` (not Freezed — simple immutable class).

## ObjectBox Models (Native Persistence)

### TimeBox

```dart
@Entity()
class TimeBox {
  @Id()
  int id;
  int hour;
  int minutes;
}
```

**Location:** `lib/src/features/times/data/models/time_box.dart`

**Conversion Extensions:**
- `TimeBox.toTimeEntry` → `TimeEntry`
- `TimeEntry.toTimeBox` → `TimeBox`

### WageHourlyBox

```dart
@Entity()
class WageHourlyBox {
  @Id()
  int id;
  double value;
}
```

**Location:** `lib/src/features/wage/data/models/wage_hourly_box.dart`

**Conversion Extensions:**
- `WageHourlyBox.toWageHourly` → `WageHourly`
- `WageHourly.toWageHourlyBox` → `WageHourlyBox`

## Drift Tables (Web Persistence)

### TimesTable

```dart
class TimesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hour => integer()();
  IntColumn get minutes => integer()();
}
```

**Location:** `lib/src/features/times/data/models/times_table.dart`

**Generated Data Class:** `TimesTableData`

**Conversion Extensions:**
- `TimesTableData.toTimeEntry` → `TimeEntry`

### WageHourlyTable

```dart
class WageHourlyTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => realColumn()();
}
```

**Location:** `lib/src/features/wage/data/models/wage_hourly_table.dart`

**Generated Data Class:** `WageHourlyTableData`

**Conversion Extensions:**
- `WageHourlyTableData.toWageHourly` → `WageHourly`

## Database Configuration

### ObjectBox (Native)

- **Service:** `ObjectboxService` in `lib/src/core/services/objectbox_service.dart`
- **Schema:** `objectbox-model.json` at project root
- **Initialization:** `ObjectboxService.create()` (async factory)
- **Entities registered:** `TimeBox`, `WageHourlyBox`

### Drift (Web)

- **Database:** `AppDatabase` in `lib/src/core/services/app_database.dart`
- **Tables registered:** `TimesTable`, `WageHourlyTable` via `@DriftDatabase(tables: [TimesTable, WageHourlyTable])`
- **Connection:** `driftDatabase(name: dbName)` — WASM + OPFS on web, file system on native
- **Single database instance** aggregates all feature tables (no per-feature databases)

## Repository Layer

### TimesRepository (Interface)

```dart
abstract class TimesRepository {
  Stream<Either<GlobalFailure, List<TimeEntry>>> watchAll();
  Future<Either<GlobalFailure, TimeEntry>> insert(TimeEntry entry);
  Future<Either<GlobalFailure, TimeEntry>> update(TimeEntry entry);
  Future<Either<GlobalFailure, Unit>> remove(int id);
}
```

**Implementations:**
- `ObjectBoxTimesRepository` — wraps `TimesObjectBoxDatasource`
- `DriftTimesRepository` — wraps `TimesDriftDatasource`

### WageRepository (Interface)

```dart
abstract class WageRepository {
  Stream<Either<GlobalFailure, WageHourly>> watch();
  Future<Either<GlobalFailure, WageHourly>> set(WageHourly wage);
  Future<Either<GlobalFailure, WageHourly>> update(WageHourly wage);
}
```

**Implementations:**
- `ObjectBoxWageRepository` — wraps `WageObjectBoxDatasource`
- `DriftWageRepository` — wraps `WageDriftDatasource`

## Data Flow Diagram

```
Domain Entity (TimeEntry / WageHourly)
    ↕ Conversion Extensions
ObjectBox Model (TimeBox / WageHourlyBox)     Drift Data (TimesTableData / WageHourlyTableData)
    ↕                                              ↕
ObjectBox Datasource                          Drift Datasource
    ↕                                              ↕
ObjectBox Repository                          Drift Repository
    ↕                                              ↕
    └──────────── Repository Interface ────────────┘
                         ↕
                     Use Case
                         ↕
                    BLoC / Cubit
```

## Edge Cases

- ObjectBox `put()` returns `int` ID — domain models use `@Default(0) int id` for new entities
- Drift `insert()` returns `int` auto-increment ID — same `@Default(0)` convention
- Drift `update()`/`remove()` return affected row count — 0 rows = record not found = failure
- Drift wage repository: when `id == 0`, performs insert instead of update (mirrors ObjectBox `put()` behavior)
