# Story 4.2: Times Feature — drift Datasource & Repository Implementation

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user on the web platform,
I want to create, view, edit, and delete time entries with the same experience as native platforms,
so that the web app is fully functional for time tracking (FR22, FR29, FR31).

## Acceptance Criteria

1. **TimesDriftDatasource implemented** — `lib/src/features/times/data/datasources/times_drift_datasource.dart` provides CRUD operations (insert, selectAll, update, delete) on `TimesTable` and a reactive `watchAll()` stream equivalent to ObjectBox's `watch()` (FR29); works with drift table row types only (`TimesTableData`, `TimesTableCompanion`), not domain entities

2. **DriftTimesRepository implemented** — `lib/src/features/times/data/repositories/drift_times_repository.dart` implements the abstract `TimesRepository` interface (FR32); maps between drift table rows (`TimesTableData`) and `TimeEntry` domain entities; all methods return `Either<GlobalFailure, T>` — never throw (NFR19); `fetchTimesStream()` returns `Either<GlobalFailure, Stream<List<TimeEntry>>>`

3. **Conversion extensions added** — `times_table.dart` gains `ConvertTimesTableData` (TimesTableData → TimeEntry) extension, mirroring the `ConvertTimeEntry` / `ConvertTimeBox` pattern in `time_box.dart`

4. **Both repositories conform to identical interface** — `DriftTimesRepository` and `ObjectboxTimesRepository` both implement `TimesRepository` with equivalent reactive stream behavior (FR29); no change to the abstract interface

5. **Barrel files updated** — `datasources.dart` exports `times_drift_datasource.dart`; `repositories.dart` exports `drift_times_repository.dart`

6. **Datasource tests complete** — `test/src/features/times/data/datasources/times_drift_datasource_test.dart` tests all CRUD operations and reactive stream behavior using real in-memory drift database

7. **Repository tests complete** — `test/src/features/times/data/repositories/drift_times_repository_test.dart` tests repository implementation with entity mapping and Either returns using mocked datasource (100% coverage)

8. **Zero warnings and all tests pass** — `flutter analyze` produces zero issues; `flutter test` passes all 131 existing tests plus new drift datasource and repository tests; no regressions

## Tasks / Subtasks

- [x] Task 1: Add conversion extensions to times_table.dart (AC: #3)
  - [x] 1.1 Add two imports to `times_table.dart`: `import 'package:time_money/src/core/services/app_database.dart';` (required — `TimesTableData` is generated in `app_database.g.dart` which is `part of` `app_database.dart`) and `import 'package:time_money/src/features/times/domain/entities/time_entry.dart';`
  - [x] 1.2 Add `ConvertTimesTableData` extension on `TimesTableData` with `TimeEntry get toTimeEntry` getter — maps `id`, `hour`, `minutes` fields
  - [x] 1.3 Add dartdoc comments on extension and getter
  - [x] 1.4 Do NOT add a reverse extension (TimeEntry → TimesTableData) — the datasource API uses primitive parameters, not data classes

- [x] Task 2: Create TimesDriftDatasource (AC: #1)
  - [x] 2.1 Create `lib/src/features/times/data/datasources/times_drift_datasource.dart`
  - [x] 2.2 Import `package:drift/drift.dart` and `package:time_money/src/core/services/app_database.dart`
  - [x] 2.3 Class receives `AppDatabase` via `const` constructor (matches ObjectBox pattern of receiving `Box` via constructor)
  - [x] 2.4 Implement `Stream<List<TimesTableData>> watchAll()` — uses `_db.select(_db.timesTable).watch()` — drift streams emit immediately on subscribe (matches ObjectBox `triggerImmediately: true`)
  - [x] 2.5 Implement `Future<int> insert({required int hour, required int minutes})` — uses `_db.into(_db.timesTable).insert(TimesTableCompanion.insert(hour: hour, minutes: minutes))` — returns auto-generated id
  - [x] 2.6 Implement `Future<void> update(int id, {required int hour, required int minutes})` — uses `(_db.update(_db.timesTable)..where((t) => t.id.equals(id))).write(TimesTableCompanion(hour: Value(hour), minutes: Value(minutes)))` — uses default Companion constructor with `Value` wrappers for partial updates
  - [x] 2.7 Implement `Future<int> remove(int id)` — uses `(_db.delete(_db.timesTable)..where((t) => t.id.equals(id))).go()` — returns number of deleted rows
  - [x] 2.8 Add dartdoc comments on class, constructor, and all methods
  - [x] 2.9 Do NOT add try/catch — let exceptions propagate to repository layer (architecture pattern: datasources may throw)

- [x] Task 3: Create DriftTimesRepository (AC: #2, #4)
  - [x] 3.1 Create `lib/src/features/times/data/repositories/drift_times_repository.dart`
  - [x] 3.2 Import fpdart, GlobalFailure, TimesDriftDatasource, TimeEntry, TimesRepository, and the conversion extension from times_table.dart
  - [x] 3.3 Class receives `TimesDriftDatasource` via `const` constructor (mirrors `ObjectboxTimesRepository`)
  - [x] 3.4 Implement `FetchTimesResultStream fetchTimesStream()` — map `_datasource.watchAll()` stream converting `TimesTableData` rows to `TimeEntry` via `.toTimeEntry`; wrap stream in `right()`; catch with `on Object catch (e)` returning `left(GlobalFailure.fromException(e))`; this method is SYNCHRONOUS (returns Either directly, not Future)
  - [x] 3.5 Implement `CreateTimeResult create(TimeEntry time)` — call `await _datasource.insert(hour: time.hour, minutes: time.minutes)`; return `right(time)`; wrap in try/catch
  - [x] 3.6 Implement `UpdateTimeResult update(TimeEntry time)` — call `await _datasource.update(time.id, hour: time.hour, minutes: time.minutes)`; return `right(time)`; wrap in try/catch
  - [x] 3.7 Implement `DeleteTimeResult delete(TimeEntry time)` — call `await _datasource.remove(time.id)`; return `right(unit)`; wrap in try/catch
  - [x] 3.8 Add dartdoc comments on class, constructor, and all overridden methods
  - [x] 3.9 Verify exact same public API shape as `ObjectboxTimesRepository` — same method signatures, same return type aliases

- [x] Task 4: Update barrel files (AC: #5)
  - [x] 4.1 Add `export 'times_drift_datasource.dart';` to `lib/src/features/times/data/datasources/datasources.dart`
  - [x] 4.2 Add `export 'drift_times_repository.dart';` to `lib/src/features/times/data/repositories/repositories.dart`

- [x] Task 5: Write datasource tests (AC: #6)
  - [x] 5.1 Create `test/src/features/times/data/datasources/times_drift_datasource_test.dart`
  - [x] 5.2 Add file-level dartdoc, `library;` directive (project standard from 4.1 code review)
  - [x] 5.3 Use REAL in-memory database (`AppDatabase(NativeDatabase.memory())`) — NOT mocks — to test drift operations end-to-end
  - [x] 5.4 setUp creates fresh `AppDatabase` + `TimesDriftDatasource`; tearDown closes database
  - [x] 5.5 Test `insert` returns auto-generated id and row is persisted — verify with `db.select(db.timesTable).get()` (the datasource has no select method; use the raw `db` reference directly for verification)
  - [x] 5.6 Test `watchAll` emits initial empty list, then updated list after insert (use `pumpEventQueue()` pattern from app_database_test.dart)
  - [x] 5.7 Test `update` modifies the correct row (insert → update → verify with `db.select(db.timesTable).get()` → assert changed values; datasource has no select method, use raw `db`)
  - [x] 5.8 Test `remove` deletes the row (insert → remove → verify with `db.select(db.timesTable).get()` → assert empty)
  - [x] 5.9 Test `watchAll` on empty table returns empty list (edge case)
  - [x] 5.10 Test multiple inserts produce sequential auto-increment IDs
  - [x] 5.11 Add why-comments on every group and test (project standard)

- [x] Task 6: Write repository tests (AC: #7)
  - [x] 6.1 Create `test/src/features/times/data/repositories/drift_times_repository_test.dart`
  - [x] 6.2 Add file-level dartdoc, `library;` directive (project standard); imports MUST include `package:time_money/src/core/services/app_database.dart` (for `TimesTableData` used in stubs)
  - [x] 6.3 Use mocktail to create `MockTimesDriftDatasource extends Mock implements TimesDriftDatasource`
  - [x] 6.4 setUp creates mock datasource + `DriftTimesRepository`; no `setUpAll` needed (no ObjectBox fallback values to register — drift datasource methods use `int` primitives, not model classes)
  - [x] 6.5 Test `fetchTimesStream` returns Right with correctly mapped TimeEntry stream on success — stub `watchAll()` to return `Stream.value([TimesTableData(id: 1, hour: 1, minutes: 30)])` and verify the stream emits `[TimeEntry(id: 1, hour: 1, minutes: 30)]`
  - [x] 6.6 Test `fetchTimesStream` returns Left with GlobalFailure on exception
  - [x] 6.7 Test `create` returns Right with TimeEntry on success — stub `insert()` to return `1` and verify call
  - [x] 6.8 Test `create` returns Left on exception
  - [x] 6.9 Test `update` returns Right with TimeEntry on success — stub `update()` to complete and verify call
  - [x] 6.10 Test `update` returns Left on exception
  - [x] 6.11 Test `delete` returns Right with unit on success — stub `remove()` to return `1` and verify call
  - [x] 6.12 Test `delete` returns Left on exception
  - [x] 6.13 Add why-comments on every group and test (project standard)
  - [x] 6.14 Use `verify(() => mockDatasource.method(args)).called(1)` after assertions — drift datasource methods use named parameters, so use `any(named: 'paramName')` matchers: e.g. `verify(() => mockDatasource.insert(hour: any(named: 'hour'), minutes: any(named: 'minutes'))).called(1)` (differs from ObjectBox's positional `put(any())`)

- [x] Task 7: Verification (AC: #8)
  - [x] 7.1 Run `flutter analyze` — zero issues
  - [x] 7.2 Run `flutter test` — all 131 existing tests pass + new tests pass, zero regressions
  - [x] 7.3 Verify barrel exports are correct (datasources.dart, repositories.dart)

## Dev Notes

### State of the Codebase at Start of Story

**Story 4.1 is done:** drift 2.32.0 infrastructure is in place. `AppDatabase` with `TimesTable` and `WageHourlyTable` is functional. 15 database tests passing (CRUD + watch + edge cases for both tables). Web assets (`sqlite3.wasm`, `drift_worker.dart.js`) in `web/`.

**131 tests passing:** Full test suite from Epics 1-4.1 is green. No datasource-level tests exist for either ObjectBox or drift — only repository-level tests.

**ObjectBox implementation is the reference:** `TimesObjectboxDatasource` and `ObjectboxTimesRepository` are the established patterns. The drift versions must mirror their API shape, error handling, and test coverage exactly.

---

### TimesDriftDatasource Implementation Pattern

**Mirror of TimesObjectboxDatasource but for drift:**

```dart
import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';

/// Raw drift operations for time entries.
///
/// Works exclusively with [TimesTableData] and [TimesTableCompanion]
/// DB models -- domain entity mapping is the responsibility of the
/// repository layer.
class TimesDriftDatasource {
  /// Creates a datasource backed by the given [AppDatabase].
  const TimesDriftDatasource(this._db);
  final AppDatabase _db;

  /// Watches all time entry rows, emitting immediately and on every change.
  Stream<List<TimesTableData>> watchAll() {
    return _db.select(_db.timesTable).watch();
  }

  /// Inserts a new time entry and returns its assigned id.
  Future<int> insert({required int hour, required int minutes}) {
    return _db.into(_db.timesTable).insert(
          TimesTableCompanion.insert(hour: hour, minutes: minutes),
        );
  }

  /// Updates the time entry identified by [id].
  Future<void> update(int id, {required int hour, required int minutes}) {
    return (_db.update(_db.timesTable)..where((t) => t.id.equals(id))).write(
          TimesTableCompanion(hour: Value(hour), minutes: Value(minutes)),
        );
  }

  /// Removes the row identified by [id]; returns the number of deleted rows.
  Future<int> remove(int id) {
    return (_db.delete(_db.timesTable)..where((t) => t.id.equals(id))).go();
  }
}
```

---

### DriftTimesRepository Implementation Pattern

**Mirror of ObjectboxTimesRepository:**

```dart
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/models/times_table.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/repositories/times_repository.dart';

/// Drift-backed implementation of [TimesRepository].
///
/// Each method delegates to [TimesDriftDatasource], maps between
/// [TimesTableData] rows and [TimeEntry] domain entities, and wraps results
/// in [Either] to surface [GlobalFailure] on errors.
class DriftTimesRepository implements TimesRepository {
  /// Creates the repository with the given drift datasource.
  const DriftTimesRepository(this._datasource);
  final TimesDriftDatasource _datasource;

  @override
  FetchTimesResultStream fetchTimesStream() {
    try {
      final stream = _datasource.watchAll().map(
            (rows) => rows.map((row) => row.toTimeEntry).toList(),
          );
      return right(stream);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  CreateTimeResult create(TimeEntry time) async {
    try {
      await _datasource.insert(hour: time.hour, minutes: time.minutes);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  DeleteTimeResult delete(TimeEntry time) async {
    try {
      await _datasource.remove(time.id);
      return right(unit);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateTimeResult update(TimeEntry time) async {
    try {
      await _datasource.update(time.id, hour: time.hour, minutes: time.minutes);
      return right(time);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
```

### ObjectBox vs Drift — Comparison Table

| Aspect | ObjectBox | Drift |
|--------|-----------|-------|
| **Datasource dependency** | `Box<TimeBox>` | `AppDatabase` |
| **Datasource method sync** | Sync (`int`, `bool`) | Async (`Future<int>`, `Future<void>`) |
| **Insert API** | `put(TimeBox)` — model class | `insert(hour:, minutes:)` — primitives (Companions internally) |
| **Update API** | `put(TimeBox)` — same as insert | `update(id, hour:, minutes:)` — id + primitives (`Value` wrappers) |
| **Delete return** | `bool` (was deleted) | `int` (affected row count) |
| **Stream source** | `query().watch(triggerImmediately: true).map(find)` | `select(table).watch()` (immediate by default) |
| **Repository maps from** | `TimeBox` via `.toTimeEntry` | `TimesTableData` via `.toTimeEntry` |
| **Repository create calls** | `_datasource.put(time.toTimeBox)` | `_datasource.insert(hour: time.hour, minutes: time.minutes)` |
| **Repository update calls** | `_datasource.put(time.toTimeBox)` | `_datasource.update(time.id, hour: time.hour, minutes: time.minutes)` |
| **Repository extra import** | `time_box.dart` for `ConvertTimeBox` | `times_table.dart` for `ConvertTimesTableData` |
| **Mock verification style** | `verify(() => mock.put(any()))` — positional | `verify(() => mock.insert(hour: any(named: 'hour'), minutes: any(named: 'minutes')))` — named |
| **Error handling** | No try/catch in datasource | No try/catch in datasource |

---

### Conversion Extension — times_table.dart

Add to `lib/src/features/times/data/models/times_table.dart` (mirrors `ConvertTimeEntry` in `time_box.dart`):

```dart
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Maps a [TimesTableData] drift row to a [TimeEntry] domain entity.
extension ConvertTimesTableData on TimesTableData {
  /// Converts this drift row into a [TimeEntry].
  TimeEntry get toTimeEntry => TimeEntry(
        id: id,
        hour: hour,
        minutes: minutes,
      );
}
```

**Note:** `TimesTableData` is a generated class from `app_database.g.dart` (which is `part of` `app_database.dart`). The import of `app_database.dart` is REQUIRED for `TimesTableData` to be in scope — it is NOT available through `package:drift/drift.dart` alone.

**CRITICAL:** The generated class name is `TimesTableData` (verified in `app_database_test.dart` line 57 where `TimesTableCompanion.insert()` is used and rows are `TimesTableData`). Do NOT guess other names.

---

### Drift API Quick Reference (v2.32.0)

| Operation | API | Returns |
|-----------|-----|---------|
| Insert | `db.into(db.timesTable).insert(TimesTableCompanion.insert(...))` | `Future<int>` (id) |
| Select all | `db.select(db.timesTable).get()` | `Future<List<TimesTableData>>` |
| Watch all | `db.select(db.timesTable).watch()` | `Stream<List<TimesTableData>>` |
| Update by id | `(db.update(db.timesTable)..where((t) => t.id.equals(id))).write(TimesTableCompanion(...))` | `Future<int>` (affected rows) |
| Delete by id | `(db.delete(db.timesTable)..where((t) => t.id.equals(id))).go()` | `Future<int>` (affected rows) |

**Companion constructors:**
- `TimesTableCompanion.insert(hour: 2, minutes: 30)` — for INSERTs (required fields unwrapped)
- `TimesTableCompanion(hour: Value(2), minutes: Value(30))` — for UPDATEs (fields wrapped in `Value`)
- `Value.absent()` — means "don't change this column" (default for omitted fields in updates)

**Stream behavior:** `watch()` emits initial value immediately on subscribe, then re-emits on any write to the table. No manual `triggerImmediately` flag needed (always immediate).

---

### Testing Patterns

**Datasource tests — real in-memory database:**

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';

void main() {
  late AppDatabase db;
  late TimesDriftDatasource datasource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    datasource = TimesDriftDatasource(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TimesDriftDatasource', () {
    test('insert returns auto-generated id', () async {
      final id = await datasource.insert(hour: 2, minutes: 30);
      expect(id, isPositive);
    });
    // ...
  });
}
```

**Repository tests — mocked datasource (mirrors objectbox_times_repository_test.dart):**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/repositories/drift_times_repository.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

class MockTimesDriftDatasource extends Mock implements TimesDriftDatasource {}

void main() {
  late MockTimesDriftDatasource mockDatasource;
  late DriftTimesRepository repository;

  setUp(() {
    mockDatasource = MockTimesDriftDatasource();
    repository = DriftTimesRepository(mockDatasource);
  });
  // ...
}
```

**CRITICAL test documentation standard (from 4.1 code review lesson):**
- File-level `///` dartdoc comment describing what the test file covers
- `library;` directive after the dartdoc
- Why-comments on every `group()` and `test()` explaining the purpose
- See `app_database_test.dart` and `objectbox_times_repository_test.dart` for reference patterns

**TimesTableData in repository tests:** When stubbing `watchAll()`, create `TimesTableData` instances. `TimesTableData` is a generated class with a default constructor: `TimesTableData(id: 1, hour: 2, minutes: 30)`. Verify the constructor shape after checking `app_database.g.dart`.

---

### Previous Story Intelligence (Story 4.1)

**Learnings from 4.1 directly relevant to this story:**
- `pumpEventQueue()` required for watch stream tests — initial empty emission races with inserts
- `prefer_int_literals` lint triggers on `double` values in companion inserts — not relevant for TimesTable (all int columns) but watch for it
- Test documentation pattern is mandatory: file-level dartdoc, `library;`, group/test why-comments
- `TimesTableCompanion.insert()` uses named required parameters for non-autoIncrement columns
- `TimesTableCompanion()` default constructor wraps all fields in `Value` — for updates
- `TimesTableData` is the generated row data class (verified in existing tests)
- Drift `watch()` emits initial value immediately — no `triggerImmediately` flag needed

**Git patterns from 4.1:**
- Commit: `feat: drift database setup & core infrastructure (story 4.1)` — use `feat: times drift datasource & repository (story 4.2)`
- `flutter analyze` + `flutter test` must pass before marking complete
- Generated files are committed

---

### Developer Rules

**Mandatory patterns:**
- `const` constructors on datasource and repository classes
- Absolute imports only — `package:time_money/...`
- Dartdoc `///` on every public class, method, and field
- Zero linter warnings — non-negotiable
- `on Object catch (e)` in repository (not `catch (e)` or `on Exception catch (e)`)
- Return type aliases from `times_repository.dart` — `FetchTimesResultStream`, `CreateTimeResult`, etc.
- `import 'package:drift/native.dart'` ONLY in test files, never production code

**NEVER do (anti-patterns):**
- Do NOT add try/catch in the datasource — repository handles all error wrapping
- Do NOT import domain entities in the datasource — datasource works with drift types only
- Do NOT create a reverse conversion extension (TimeEntry → TimesTableData) — the datasource API uses primitives
- Do NOT modify the `TimesRepository` abstract interface — both implementations must conform to the existing contract
- Do NOT modify ObjectBox datasource, repository, or any existing ObjectBox code
- Do NOT modify AppDatabase or table definitions — Story 4.1 scope (done)
- Do NOT modify bootstrap.dart, main_*.dart, or app_bloc.dart — Story 4.4 scope
- Do NOT modify any existing tests — only add new test files
- Do NOT use `insertReturning` — the repository returns the original `TimeEntry` parameter, not a reconstructed one from the database (matches ObjectBox pattern)
- Do NOT omit `where` clauses on update/delete — that would affect ALL rows

**Out of scope:** Wage drift datasource/repository (4.3), platform-aware DI (4.4), modifying main_*.dart/bootstrap.dart (4.4), multi-platform verification (4.5)

---

### Project Structure Notes

**Files to CREATE:**
- `lib/src/features/times/data/datasources/times_drift_datasource.dart` — drift datasource
- `lib/src/features/times/data/repositories/drift_times_repository.dart` — drift repository
- `test/src/features/times/data/datasources/times_drift_datasource_test.dart` — datasource tests
- `test/src/features/times/data/repositories/drift_times_repository_test.dart` — repository tests

**Files to MODIFY:**
- `lib/src/features/times/data/models/times_table.dart` — add ConvertTimesTableData extension + `app_database.dart` import (for `TimesTableData`) + `time_entry.dart` import
- `lib/src/features/times/data/datasources/datasources.dart` — add `export 'times_drift_datasource.dart';`
- `lib/src/features/times/data/repositories/repositories.dart` — add `export 'drift_times_repository.dart';`

**Files NOT to touch:**
- `lib/src/core/services/app_database.dart` — Story 4.1 (done)
- `lib/src/features/times/data/datasources/times_objectbox_datasource.dart` — existing ObjectBox
- `lib/src/features/times/data/repositories/objectbox_times_repository.dart` — existing ObjectBox
- `lib/src/features/times/domain/repositories/times_repository.dart` — shared interface (no changes)
- `lib/src/features/times/domain/entities/time_entry.dart` — domain entity (no changes)
- `lib/src/features/times/data/models/time_box.dart` — ObjectBox model (no changes)
- `lib/bootstrap.dart` — Story 4.4 scope
- `lib/main_*.dart` — Story 4.4 scope
- `lib/app/view/app_bloc.dart` — Story 4.4 scope
- Any BLoC, use case, or presentation files
- Any existing test files

### References

- [epics.md — Epic 4, Story 4.2, FR22, FR29, FR31, FR32, NFR17, NFR19]
- [architecture.md — Datasource Pattern, Repository Interface Pattern, DI Registration Pattern, Entity Naming Conventions]
- [architecture.md — Naming: TimesDriftDatasource, DriftTimesRepository, TimesTable, TimesTableData]
- [architecture.md — Error Handling: datasources throw, repositories catch + wrap in GlobalFailure]
- [project-context.md — Critical Implementation Rules, Testing Rules, Anti-Patterns]
- [4-1-drift-database-setup-core-infrastructure.md — Previous story: drift setup, test patterns, lessons learned]
- [objectbox_times_repository_test.dart — Repository test pattern reference]
- [app_database_test.dart — Drift CRUD/watch test pattern reference, pumpEventQueue usage]
- [drift docs — https://drift.simonbinder.eu/dart_api/writes/]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

None — clean implementation, no blockers encountered.

### Completion Notes List

- Task 1: Added `ConvertTimesTableData` extension to `times_table.dart` with `toTimeEntry` getter, mirroring `ConvertTimeEntry` on `TimeBox`. No reverse extension added (datasource uses primitives).
- Task 2: Created `TimesDriftDatasource` with `watchAll()`, `insert()`, `update()`, `remove()` — all delegating to drift `AppDatabase`. No try/catch (architecture: datasources throw, repositories catch).
- Task 3: Created `DriftTimesRepository` implementing `TimesRepository` with identical API shape to `ObjectboxTimesRepository`. All methods wrap in `Either<GlobalFailure, T>`. Added `app_database.dart` import for `TimesTableData` dartdoc visibility.
- Task 4: Updated barrel files — `datasources.dart` exports `times_drift_datasource.dart`, `repositories.dart` exports `drift_times_repository.dart`.
- Task 5: 6 datasource tests using real in-memory database — insert, watchAll (reactive + empty), update, remove, sequential IDs.
- Task 6: 8 repository tests with mocked datasource — fetchTimesStream (success/failure), create (success/failure), update (success/failure), delete (success/failure). Named parameter matchers used for verify.
- Task 7: `flutter analyze` = 0 issues, `flutter test` = 145 tests passing (131 existing + 14 new), zero regressions.
- One lint fix applied: `const` constructor on `TimesTableData` in repository test stub.

### Change Log

- 2026-03-19: Story 4.2 implemented — drift datasource, repository, conversion extension, barrel exports, 14 new tests.

### File List

- `lib/src/features/times/data/models/times_table.dart` (modified — added ConvertTimesTableData extension + imports)
- `lib/src/features/times/data/datasources/times_drift_datasource.dart` (new)
- `lib/src/features/times/data/repositories/drift_times_repository.dart` (new)
- `lib/src/features/times/data/datasources/datasources.dart` (modified — added export)
- `lib/src/features/times/data/repositories/repositories.dart` (modified — added export)
- `test/src/features/times/data/datasources/times_drift_datasource_test.dart` (new)
- `test/src/features/times/data/repositories/drift_times_repository_test.dart` (new)
