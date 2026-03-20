# Story 4.3: Wage Feature — drift Datasource & Repository Implementation

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user on the web platform,
I want to view, set, and update my hourly wage with the same experience as native platforms,
so that wage management is fully functional on the web (FR22, FR29, FR31).

## Acceptance Criteria

1. **WageDriftDatasource implemented** — `lib/src/features/wage/data/datasources/wage_drift_datasource.dart` provides operations (insert, watchAll, update) on `WageHourlyTable` with a reactive `watchAll()` stream equivalent to ObjectBox's `watch()` (FR29); works with drift table row types only (`WageHourlyTableData`, `WageHourlyTableCompanion`), not domain entities

2. **DriftWageRepository implemented** — `lib/src/features/wage/data/repositories/drift_wage_repository.dart` implements the abstract `WageRepository` interface (FR32); maps between drift table rows (`WageHourlyTableData`) and `WageHourly` domain entities; all methods return `Either<GlobalFailure, T>` — never throw (NFR19); `fetchWageHourly()` maps the list stream to a single `WageHourly` (last entry, or `const WageHourly()` default when empty — FR8)

3. **Conversion extension added** — `wage_hourly_table.dart` gains `ConvertWageHourlyTableData` (WageHourlyTableData → WageHourly) extension, mirroring the `ConvertWageHourly` / `ConvertWageHourlyBox` pattern in `wage_hourly_box.dart`

4. **Both repositories conform to identical interface** — `DriftWageRepository` and `ObjectboxWageRepository` both implement `WageRepository` with equivalent reactive stream behavior (FR29); no change to the abstract interface

5. **Barrel files updated** — `datasources.dart` exports `wage_drift_datasource.dart`; `repositories.dart` exports `drift_wage_repository.dart`

6. **Datasource tests complete** — `test/src/features/wage/data/datasources/wage_drift_datasource_test.dart` tests all operations and reactive stream behavior using real in-memory drift database

7. **Repository tests complete** — `test/src/features/wage/data/repositories/drift_wage_repository_test.dart` tests repository implementation with entity mapping, default wage handling, and Either returns using mocked datasource (100% coverage)

8. **Zero warnings and all tests pass** — `flutter analyze` produces zero issues; `flutter test` passes all 145 existing tests plus 12 new tests (5 datasource + 7 repository = 157 total); no regressions

## Tasks / Subtasks

- [ ] Task 1: Add conversion extension to wage_hourly_table.dart (AC: #3)
  - [ ] 1.1 Add two imports to `wage_hourly_table.dart`: `import 'package:time_money/src/core/services/app_database.dart';` (required — `WageHourlyTableData` is generated in `app_database.g.dart` which is `part of` `app_database.dart`) and `import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';`
  - [ ] 1.2 Add `ConvertWageHourlyTableData` extension on `WageHourlyTableData` with `WageHourly get toWageHourly` getter — maps `id`, `value` fields
  - [ ] 1.3 Add dartdoc comments on extension and getter
  - [ ] 1.4 Do NOT add a reverse extension (WageHourly → WageHourlyTableData) — the datasource API uses primitive parameters, not data classes (mirrors times pattern)

- [ ] Task 2: Create WageDriftDatasource (AC: #1)
  - [ ] 2.1 Create `lib/src/features/wage/data/datasources/wage_drift_datasource.dart`
  - [ ] 2.2 Import `package:drift/drift.dart` and `package:time_money/src/core/services/app_database.dart`
  - [ ] 2.3 Class receives `AppDatabase` via `const` constructor (matches TimesDriftDatasource pattern)
  - [ ] 2.4 Implement `Stream<List<WageHourlyTableData>> watchAll()` — uses `_db.select(_db.wageHourlyTable).watch()` — drift streams emit immediately on subscribe (matches ObjectBox `triggerImmediately: true`)
  - [ ] 2.5 Implement `Future<int> insert({required double value})` — uses `_db.into(_db.wageHourlyTable).insert(WageHourlyTableCompanion.insert(value: value))` — returns auto-generated id
  - [ ] 2.6 Implement `Future<void> update(int id, {required double value})` — uses `(_db.update(_db.wageHourlyTable)..where((t) => t.id.equals(id))).write(WageHourlyTableCompanion(value: Value(value)))` — uses default Companion constructor with `Value` wrapper for partial update
  - [ ] 2.7 Add dartdoc comments on class, constructor, and all methods
  - [ ] 2.8 Do NOT add try/catch — let exceptions propagate to repository layer (architecture pattern: datasources may throw)
  - [ ] 2.9 Do NOT add a `remove` method — wage feature has no delete operation (ObjectBox datasource also has no remove)

- [ ] Task 3: Create DriftWageRepository (AC: #2, #4)
  - [ ] 3.1 Create `lib/src/features/wage/data/repositories/drift_wage_repository.dart`
  - [ ] 3.2 Import fpdart, GlobalFailure, AppDatabase (`app_database.dart` — for `WageHourlyTableData` type resolution, matches `DriftTimesRepository` pattern), WageDriftDatasource, WageHourly, WageRepository, and the conversion extension from wage_hourly_table.dart
  - [ ] 3.3 Class receives `WageDriftDatasource` via `const` constructor (mirrors `ObjectboxWageRepository`)
  - [ ] 3.4 Implement `FetchWageResultStream fetchWageHourly()` — map `_datasource.watchAll()` stream converting `List<WageHourlyTableData>` to single `WageHourly`: map each row via `.toWageHourly`, if list is empty return `const WageHourly()` (default $15.00 — FR8), otherwise return `wages.last`; wrap stream in `right()`; catch with `on Object catch (e)` returning `left(GlobalFailure.fromException(e))`; this method is SYNCHRONOUS (returns Either directly, not Future)
  - [ ] 3.5 Implement `SetWageResult setWageHourly(WageHourly wageHourly)` — call `await _datasource.insert(value: wageHourly.value)`; return `right(wageHourly)`; wrap in try/catch
  - [ ] 3.6 Implement `UpdateWageResult update(WageHourly wageHourly)` — call `await _datasource.update(wageHourly.id, value: wageHourly.value)`; return `right(wageHourly)`; wrap in try/catch
  - [ ] 3.7 Add dartdoc comments on class, constructor, and all overridden methods
  - [ ] 3.8 Verify exact same public API shape as `ObjectboxWageRepository` — same method signatures, same return type aliases

- [ ] Task 4: Update barrel files (AC: #5)
  - [ ] 4.1 Add `export 'wage_drift_datasource.dart';` to `lib/src/features/wage/data/datasources/datasources.dart`
  - [ ] 4.2 Add `export 'drift_wage_repository.dart';` to `lib/src/features/wage/data/repositories/repositories.dart`

- [ ] Task 5: Write datasource tests (AC: #6)
  - [ ] 5.1 Create `test/src/features/wage/data/datasources/wage_drift_datasource_test.dart`
  - [ ] 5.2 Add file-level dartdoc, `library;` directive (project standard from 4.1 code review)
  - [ ] 5.3 Use REAL in-memory database (`AppDatabase(NativeDatabase.memory())`) — NOT mocks — to test drift operations end-to-end
  - [ ] 5.4 setUp creates fresh `AppDatabase` + `WageDriftDatasource`; tearDown closes database
  - [ ] 5.5 Test `insert` returns auto-generated id and row is persisted — verify with `db.select(db.wageHourlyTable).get()` (the datasource has no select method; use the raw `db` reference directly for verification)
  - [ ] 5.6 Test `watchAll` emits initial empty list, then updated list after insert (use `pumpEventQueue()` pattern from times_drift_datasource_test.dart)
  - [ ] 5.7 Test `update` modifies the correct row (insert → update → verify with `db.select(db.wageHourlyTable).get()` → assert changed value; datasource has no select method, use raw `db`)
  - [ ] 5.8 Test `watchAll` on empty table returns empty list (edge case)
  - [ ] 5.9 Test multiple inserts produce sequential auto-increment IDs
  - [ ] 5.10 Add why-comments on every group and test (project standard)
  - [ ] 5.11 Use `int` literals where the value is a whole number (e.g., `value: 25` not `value: 25.0`) — `prefer_int_literals` lint auto-promotes int to double for RealColumn (known from 4.1 debug log)

- [ ] Task 6: Write repository tests (AC: #7)
  - [ ] 6.1 Create `test/src/features/wage/data/repositories/drift_wage_repository_test.dart`
  - [ ] 6.2 Add file-level dartdoc, `library;` directive (project standard); imports MUST include `package:time_money/src/core/services/app_database.dart` (for `WageHourlyTableData` used in stubs)
  - [ ] 6.3 Use mocktail to create `MockWageDriftDatasource extends Mock implements WageDriftDatasource`
  - [ ] 6.4 setUp creates mock datasource + `DriftWageRepository`; no `setUpAll` needed (no ObjectBox fallback values to register — drift datasource methods use `double` primitives, not model classes)
  - [ ] 6.5 Test `fetchWageHourly` returns Right with correctly mapped WageHourly stream on success — stub `watchAll()` to return `Stream.value([WageHourlyTableData(id: 1, value: 25)])` and verify the stream emits `WageHourly(id: 1, value: 25)`
  - [ ] 6.6 Test `fetchWageHourly` returns Right with default WageHourly when stream emits empty list — stub `watchAll()` to return `Stream.value(<WageHourlyTableData>[])` and verify stream emits `const WageHourly()` (id: 0, value: 15.0)
  - [ ] 6.7 Test `fetchWageHourly` returns Left with GlobalFailure on exception
  - [ ] 6.8 Test `setWageHourly` returns Right with WageHourly on success — stub `insert()` to return `1` and verify call with named parameter matcher
  - [ ] 6.9 Test `setWageHourly` returns Left on exception
  - [ ] 6.10 Test `update` returns Right with WageHourly on success — stub `update()` to complete and verify call with named parameter matcher
  - [ ] 6.11 Test `update` returns Left on exception
  - [ ] 6.12 Add why-comments on every group and test (project standard)
  - [ ] 6.13 Use `verify(() => mockDatasource.insert(value: any(named: 'value'))).called(1)` for set verification; use `verify(() => mockDatasource.update(any(), value: any(named: 'value'))).called(1)` for update verification

- [ ] Task 7: Verification (AC: #8)
  - [ ] 7.1 Run `flutter analyze` — zero issues
  - [ ] 7.2 Run `flutter test` — all 145 existing tests pass + 12 new tests (5 datasource + 7 repository = 157 total), zero regressions
  - [ ] 7.3 Verify barrel exports are correct (datasources.dart, repositories.dart)

## Dev Notes

### State of the Codebase at Start of Story

**Stories 4.1 and 4.2 are done:** drift 2.32.0 infrastructure is in place. `AppDatabase` with `TimesTable` and `WageHourlyTable` is functional. Times drift datasource and repository are implemented and tested. 145 tests passing (131 from pre-4.1 + 15 from 4.1 + 14 from 4.2, minus 15 that were already counted).

**145 tests passing:** Full test suite from Epics 1-4.2 is green.

**Times drift implementation is the direct reference:** `TimesDriftDatasource` and `DriftTimesRepository` are the established drift patterns. The wage versions must mirror their structure, error handling, and test coverage — adapted for wage's simpler domain (no delete, single-entity stream, default value handling).

**ObjectBox implementation is the behavior reference:** `WageObjectboxDatasource` and `ObjectboxWageRepository` define the exact business logic (especially the `wages.isEmpty ? const WageHourly() : wages.last` default handling).

---

### Key Difference: Wage vs Times

| Aspect | Times Feature | Wage Feature |
|--------|--------------|--------------|
| **Entity count** | Multiple (list of TimeEntry) | Singleton (one active WageHourly) |
| **Stream return type** | `Stream<List<TimeEntry>>` | `Stream<WageHourly>` (single) |
| **Repository maps list** | Returns list directly | Returns `wages.last` or `const WageHourly()` default |
| **CRUD operations** | Create, Read, Update, Delete | Set (insert), Read, Update (NO delete) |
| **Default handling** | No default — empty list is valid | Default `const WageHourly()` when no records (FR8: $15.00) |
| **Datasource methods** | watchAll, insert, update, remove | watchAll, insert, update (NO remove) |
| **Value type** | int (hour, minutes) | double (value) |

---

### WageDriftDatasource Implementation Pattern

**Mirror of TimesDriftDatasource adapted for wage:**

```dart
import 'package:drift/drift.dart';
import 'package:time_money/src/core/services/app_database.dart';

/// Raw drift operations for wage entries.
///
/// Works exclusively with [WageHourlyTableData] and
/// [WageHourlyTableCompanion] DB models -- domain entity mapping is the
/// responsibility of the repository layer.
class WageDriftDatasource {
  /// Creates a datasource backed by the given [AppDatabase].
  const WageDriftDatasource(this._db);
  final AppDatabase _db;

  /// Watches all wage rows, emitting immediately and on every change.
  Stream<List<WageHourlyTableData>> watchAll() {
    return _db.select(_db.wageHourlyTable).watch();
  }

  /// Inserts a new wage record and returns its assigned id.
  Future<int> insert({required double value}) {
    return _db.into(_db.wageHourlyTable).insert(
          WageHourlyTableCompanion.insert(value: value),
        );
  }

  /// Updates the wage record identified by [id].
  Future<void> update(int id, {required double value}) {
    return (_db.update(_db.wageHourlyTable)..where((t) => t.id.equals(id)))
        .write(
      WageHourlyTableCompanion(value: Value(value)),
    );
  }
}
```

---

### DriftWageRepository Implementation Pattern

**Mirror of ObjectboxWageRepository with drift datasource:**

```dart
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_table.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

/// Drift-backed implementation of [WageRepository].
///
/// Each method delegates to [WageDriftDatasource], maps between
/// [WageHourlyTableData] rows and [WageHourly] domain entities, and wraps
/// results in [Either] to surface [GlobalFailure] on errors.
class DriftWageRepository implements WageRepository {
  /// Creates the repository with the given drift datasource.
  const DriftWageRepository(this._datasource);
  final WageDriftDatasource _datasource;

  @override
  FetchWageResultStream fetchWageHourly() {
    try {
      final stream = _datasource.watchAll().map(
            (rows) {
              final wages = rows.map((row) => row.toWageHourly).toList();
              return wages.isEmpty ? const WageHourly() : wages.last;
            },
          );
      return right(stream);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  SetWageResult setWageHourly(WageHourly wageHourly) async {
    try {
      await _datasource.insert(value: wageHourly.value);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateWageResult update(WageHourly wageHourly) async {
    try {
      await _datasource.update(wageHourly.id, value: wageHourly.value);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
```

**CRITICAL:** The `fetchWageHourly()` logic is identical to `ObjectboxWageRepository` — empty list returns `const WageHourly()` (default $15.00, FR8), non-empty list returns `wages.last`. This ensures behavioral parity across datasources.

---

### ObjectBox vs Drift — Wage Comparison Table

| Aspect | ObjectBox | Drift |
|--------|-----------|-------|
| **Datasource dependency** | `Box<WageHourlyBox>` | `AppDatabase` |
| **Datasource methods** | `watchAll()`, `put(WageHourlyBox)` | `watchAll()`, `insert(value:)`, `update(id, value:)` |
| **Insert/Update API** | Same `put()` for both (upsert) | Separate `insert()` and `update()` |
| **watchAll return type** | `Stream<List<WageHourlyBox>>` | `Stream<List<WageHourlyTableData>>` |
| **Stream behavior** | `triggerImmediately: true` | Immediate by default |
| **Repository maps from** | `WageHourlyBox` via `.toWageHourly` | `WageHourlyTableData` via `.toWageHourly` |
| **Repository setWageHourly** | `_datasource.put(wageHourly.toWageHourlyBox)` | `_datasource.insert(value: wageHourly.value)` |
| **Repository update** | `_datasource.put(wageHourly.toWageHourlyBox)` | `_datasource.update(wageHourly.id, value: wageHourly.value)` |
| **Repository extra import** | `wage_hourly_box.dart` for `ConvertWageHourlyBox` | `wage_hourly_table.dart` for `ConvertWageHourlyTableData` |
| **Mock verification** | `verify(() => mock.put(any()))` — positional | `verify(() => mock.insert(value: any(named: 'value')))` — named |
| **Error handling** | No try/catch in datasource | No try/catch in datasource |
| **Default value** | `wages.isEmpty ? const WageHourly() : wages.last` | Same logic |

---

### Conversion Extension — wage_hourly_table.dart

Add to `lib/src/features/wage/data/models/wage_hourly_table.dart` (mirrors `ConvertWageHourly` in `wage_hourly_box.dart`):

```dart
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Maps a [WageHourlyTableData] drift row to a [WageHourly] domain entity.
extension ConvertWageHourlyTableData on WageHourlyTableData {
  /// Converts this drift row into a [WageHourly].
  WageHourly get toWageHourly => WageHourly(
        id: id,
        value: value,
      );
}
```

**Note:** `WageHourlyTableData` is a generated class from `app_database.g.dart` (which is `part of` `app_database.dart`). The import of `app_database.dart` is REQUIRED for `WageHourlyTableData` to be in scope. This is the same pattern as `ConvertTimesTableData` in `times_table.dart`.

**CRITICAL:** Do NOT add a reverse extension (WageHourly → WageHourlyTableData). The datasource API uses primitive `double` parameter, not data classes. The repository calls `_datasource.insert(value: wageHourly.value)` directly.

---

### Drift API Quick Reference for Wage (v2.32.0)

| Operation | API | Returns |
|-----------|-----|---------|
| Insert | `db.into(db.wageHourlyTable).insert(WageHourlyTableCompanion.insert(value: ...))` | `Future<int>` (id) |
| Select all | `db.select(db.wageHourlyTable).get()` | `Future<List<WageHourlyTableData>>` |
| Watch all | `db.select(db.wageHourlyTable).watch()` | `Stream<List<WageHourlyTableData>>` |
| Update by id | `(db.update(db.wageHourlyTable)..where((t) => t.id.equals(id))).write(WageHourlyTableCompanion(value: Value(...)))` | `Future<int>` (affected rows) |

**Companion constructors:**
- `WageHourlyTableCompanion.insert(value: 25.0)` — for INSERTs (required field unwrapped; id is autoIncrement so omitted)
- `WageHourlyTableCompanion(value: Value(25.0))` — for UPDATEs (field wrapped in `Value`)

**`prefer_int_literals` warning:** When the double value is a whole number (e.g., `25`), use `int` literal — Dart auto-promotes. Use `25` not `25.0` in companions and test fixtures. Use `15.5` when fractional. Known from 4.1 debug log.

**Stream behavior:** `watch()` emits initial value immediately on subscribe, then re-emits on any write to the table. No manual `triggerImmediately` flag needed.

---

### Testing Patterns

**Datasource tests — real in-memory database (mirrors times_drift_datasource_test.dart):**

```dart
/// Tests for [WageDriftDatasource].
///
/// Verifies that the drift datasource correctly performs insert, update,
/// and watch operations on wage records using a real in-memory drift
/// database. Each test exercises the datasource API and verifies
/// persistence via raw database queries.
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';

void main() {
  late AppDatabase db;
  late WageDriftDatasource datasource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    datasource = WageDriftDatasource(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WageDriftDatasource', () {
    test('insert returns auto-generated id and row is persisted', () async {
      final id = await datasource.insert(value: 25);
      expect(id, isPositive);
      final rows = await db.select(db.wageHourlyTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, id);
      expect(rows.first.value, 25);
    });
    // ...
  });
}
```

**Repository tests — mocked datasource (mirrors objectbox_wage_repository_test.dart + drift_times_repository_test.dart):**

```dart
/// Tests for [DriftWageRepository].
///
/// Verifies that the repository correctly delegates to
/// [WageDriftDatasource], maps [WageHourlyTableData] rows to [WageHourly]
/// domain entities, returns a default [WageHourly] when the stream is empty,
/// and wraps results in `Right` on success or `Left` with a `GlobalFailure`
/// on exception for fetch, set, and update operations.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

class MockWageDriftDatasource extends Mock implements WageDriftDatasource {}

void main() {
  late MockWageDriftDatasource mockDatasource;
  late DriftWageRepository repository;

  setUp(() {
    mockDatasource = MockWageDriftDatasource();
    repository = DriftWageRepository(mockDatasource);
  });
  // ...
}
```

**CRITICAL test documentation standard (from 4.1 code review lesson):**
- File-level `///` dartdoc comment describing what the test file covers
- `library;` directive after the dartdoc
- Why-comments on every `group()` and `test()` explaining the purpose
- See `times_drift_datasource_test.dart`, `drift_times_repository_test.dart`, and `objectbox_wage_repository_test.dart` for reference patterns

**WageHourlyTableData in repository tests:** When stubbing `watchAll()`, create `WageHourlyTableData` instances. `WageHourlyTableData` is a generated class — constructor: `WageHourlyTableData(id: 1, value: 25)`. Use `const` if the generated class supports it.

**Import for `WageHourlyTableData`:** Repository test MUST import `package:time_money/src/core/services/app_database.dart` — `WageHourlyTableData` is generated in `app_database.g.dart` which is `part of` `app_database.dart`.

---

### Previous Story Intelligence (Story 4.2)

**Learnings from 4.2 directly relevant to this story:**
- `pumpEventQueue()` required for watchAll stream tests — initial empty emission races with inserts
- `prefer_int_literals` lint triggers on double values — use int literals for whole numbers (e.g., `25` not `25.0`)
- Test documentation pattern is mandatory: file-level dartdoc, `library;`, group/test why-comments
- `WageHourlyTableCompanion.insert()` uses named required parameter for non-autoIncrement column (`value`)
- `WageHourlyTableCompanion()` default constructor wraps field in `Value` — for updates
- `WageHourlyTableData` is the generated row data class (same pattern as `TimesTableData`)
- Drift `watch()` emits initial value immediately — no `triggerImmediately` flag needed
- `const` constructor on `TimesTableData` in test stubs — verify same for `WageHourlyTableData`
- No `setUpAll` / `registerFallbackValue` needed for drift repo tests (drift datasource methods use primitives, not model classes)
- Named parameter matchers for verify: `any(named: 'value')` not `any()`

**Code review learnings from 4.2:**
- AC text must precisely name the methods implemented — "CRUD" shorthand caused ambiguity; wage has watchAll/insert/update, NOT remove
- Pre-existing patterns (like returning original entity ignoring DB-assigned ID) propagate symmetrically — both ObjectBox and drift wage repos will return the input entity, not a reconstructed one

**Git patterns from 4.1/4.2:**
- Commit: `feat: wage drift datasource & repository (story 4.3)`
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
- Return type aliases from `wage_repository.dart` — `FetchWageResultStream`, `SetWageResult`, `UpdateWageResult`
- `import 'package:drift/native.dart'` ONLY in test files, never production code

**NEVER do (anti-patterns):**
- Do NOT add try/catch in the datasource — repository handles all error wrapping
- Do NOT import domain entities in the datasource — datasource works with drift types only
- Do NOT create a reverse conversion extension (WageHourly → WageHourlyTableData) — the datasource API uses primitives
- Do NOT modify the `WageRepository` abstract interface — both implementations must conform to the existing contract
- Do NOT modify ObjectBox datasource, repository, or any existing ObjectBox code
- Do NOT modify AppDatabase or table definitions — Story 4.1 scope (done)
- Do NOT modify bootstrap.dart, main_*.dart, or app_bloc.dart — Story 4.4 scope
- Do NOT modify any existing tests — only add new test files
- Do NOT add a `remove`/`delete` method on the datasource — wage has no delete (ObjectBox `WageObjectboxDatasource` also has no remove)
- Do NOT omit `where` clause on update — that would affect ALL rows
- Do NOT use `25.0` when `25` works — `prefer_int_literals` lint

**Out of scope:** Platform-aware DI (4.4), modifying main_*.dart/bootstrap.dart (4.4), multi-platform verification (4.5)

---

### Project Structure Notes

**Files to CREATE:**
- `lib/src/features/wage/data/datasources/wage_drift_datasource.dart` — drift datasource
- `lib/src/features/wage/data/repositories/drift_wage_repository.dart` — drift repository
- `test/src/features/wage/data/datasources/wage_drift_datasource_test.dart` — datasource tests
- `test/src/features/wage/data/repositories/drift_wage_repository_test.dart` — repository tests

**Files to MODIFY:**
- `lib/src/features/wage/data/models/wage_hourly_table.dart` — add ConvertWageHourlyTableData extension + `app_database.dart` import (for `WageHourlyTableData`) + `wage_hourly.dart` import
- `lib/src/features/wage/data/datasources/datasources.dart` — add `export 'wage_drift_datasource.dart';`
- `lib/src/features/wage/data/repositories/repositories.dart` — add `export 'drift_wage_repository.dart';`

**Files NOT to touch:**
- `lib/src/core/services/app_database.dart` — Story 4.1 (done)
- `lib/src/features/wage/data/datasources/wage_objectbox_datasource.dart` — existing ObjectBox
- `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` — existing ObjectBox
- `lib/src/features/wage/domain/repositories/wage_repository.dart` — shared interface (no changes)
- `lib/src/features/wage/domain/entities/wage_hourly.dart` — domain entity (no changes)
- `lib/src/features/wage/data/models/wage_hourly_box.dart` — ObjectBox model (no changes)
- `lib/bootstrap.dart` — Story 4.4 scope
- `lib/main_*.dart` — Story 4.4 scope
- `lib/app/view/app_bloc.dart` — Story 4.4 scope
- Any BLoC, use case, or presentation files
- Any existing test files
- Any times feature files

### References

- [epics.md — Epic 4, Story 4.3, FR8, FR22, FR29, FR31, FR32, NFR17, NFR19]
- [architecture.md — Datasource Pattern, Repository Interface Pattern, DI Registration Pattern, Entity Naming Conventions]
- [architecture.md — Naming: WageDriftDatasource, DriftWageRepository, WageHourlyTable, WageHourlyTableData]
- [architecture.md — Error Handling: datasources throw, repositories catch + wrap in GlobalFailure]
- [project-context.md — Critical Implementation Rules, Testing Rules, Anti-Patterns]
- [4-1-drift-database-setup-core-infrastructure.md — drift setup, WageHourlyTable definition, test patterns, lessons learned]
- [4-2-times-feature-drift-datasource-repository-implementation.md — Direct pattern reference: TimesDriftDatasource, DriftTimesRepository, conversion extension, test patterns]
- [objectbox_wage_repository_test.dart — Wage repository test pattern reference (default WageHourly handling)]
- [times_drift_datasource_test.dart — Drift datasource test pattern reference (pumpEventQueue usage)]
- [drift_times_repository_test.dart — Drift repository test pattern reference (named parameter matchers)]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
