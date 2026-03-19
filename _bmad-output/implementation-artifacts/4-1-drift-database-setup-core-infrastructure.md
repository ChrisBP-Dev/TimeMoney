# Story 4.1: drift Database Setup & Core Infrastructure

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to set up the drift database with table definitions and web-compatible persistence,
so that the web platform has a fully functional local data layer using SQLite via WASM + OPFS (FR31).

## Acceptance Criteria

1. **drift dependencies added** — `drift: ^2.32.0`, `drift_flutter: ^0.3.0` in dependencies; `drift_dev: ^2.32.0` in dev_dependencies; `sqlite3_flutter_libs` is NOT added (drift 2.32 bundles SQLite via Dart build hooks automatically); `flutter pub get` resolves without conflicts

2. **AppDatabase extends GeneratedDatabase** — `lib/src/core/services/app_database.dart` replaces the current placeholder with a fully functional drift database class annotated with `@DriftDatabase(tables: [TimesTable, WageHourlyTable])`; `app_database.g.dart` generated via build_runner; `schemaVersion` is `1`

3. **TimesTable defined** — `lib/src/features/times/data/models/times_table.dart` defines a drift `Table` class with columns: `id` (autoIncrement integer PK), `hour` (integer), `minutes` (integer) — matching `TimeEntry` domain entity fields exactly

4. **WageHourlyTable defined** — `lib/src/features/wage/data/models/wage_hourly_table.dart` defines a drift `Table` class with columns: `id` (autoIncrement integer PK), `value` (real/double) — matching `WageHourly` domain entity fields exactly

5. **Web persistence configured** — `AppDatabase` uses `drift_flutter`'s `driftDatabase()` helper with `DriftWebOptions` specifying paths to `sqlite3.wasm` and `drift_worker.dart.js`; both WASM assets are downloaded from the correct GitHub releases (sqlite3 3.x for `sqlite3.wasm`, drift 2.32 for `drift_worker.dart.js`) and placed in the `web/` directory

6. **Environment-aware database naming** — `AppDatabase` accepts a `String dbName` parameter matching the ObjectBox pattern (`test-1`, `stg-1`, `prod-1`); each environment produces an isolated database instance (FR25, FR26, FR27)

7. **Zero warnings and all tests pass** — `flutter analyze` produces zero issues; `flutter test` passes all 116 existing tests plus new drift database tests (NFR6); generated files are excluded from static analysis (NFR11) — existing `*.g.dart` exclusion in analysis_options.yaml covers drift output

## Tasks / Subtasks

- [ ] Task 1: Add drift dependencies to pubspec.yaml (AC: #1)
  - [ ] 1.1 Add `drift: ^2.32.0` to dependencies section
  - [ ] 1.2 Add `drift_flutter: ^0.3.0` to dependencies section
  - [ ] 1.3 Add `drift_dev: ^2.32.0` to dev_dependencies section
  - [ ] 1.4 Run `flutter pub get` — verify zero conflicts; check `pubspec.lock` to confirm objectbox 5.2.0, freezed 3.2.5, bloc 9.2.0 versions remain unchanged
  - [ ] 1.5 Do NOT add `sqlite3_flutter_libs` — drift 2.32+ uses Dart build hooks to bundle SQLite automatically

- [ ] Task 2: Create TimesTable drift definition (AC: #3)
  - [ ] 2.1 Create `lib/src/features/times/data/models/times_table.dart`
  - [ ] 2.2 Define `class TimesTable extends Table` with `id` (autoIncrement integer), `hour` (integer), `minutes` (integer)
  - [ ] 2.3 Add dartdoc comments on class and all column getters
  - [ ] 2.4 Add `export 'times_table.dart';` to `lib/src/features/times/data/models/models.dart` barrel (file exists, currently exports only `time_box.dart`)

- [ ] Task 3: Create WageHourlyTable drift definition (AC: #4)
  - [ ] 3.1 Create `lib/src/features/wage/data/models/wage_hourly_table.dart`
  - [ ] 3.2 Define `class WageHourlyTable extends Table` with `id` (autoIncrement integer), `value` (real)
  - [ ] 3.3 Add dartdoc comments on class and all column getters
  - [ ] 3.4 Add `export 'wage_hourly_table.dart';` to `lib/src/features/wage/data/models/models.dart` barrel (file exists, currently exports only `wage_hourly_box.dart`)

- [ ] Task 4: Implement AppDatabase (AC: #2, #6)
  - [ ] 4.1 Replace placeholder in `lib/src/core/services/app_database.dart` with full drift implementation
  - [ ] 4.2 Add `import 'package:drift/drift.dart'` and `import 'package:drift_flutter/drift_flutter.dart'`
  - [ ] 4.3 Import `TimesTable` and `WageHourlyTable` from feature model files
  - [ ] 4.4 Add `part 'app_database.g.dart';`
  - [ ] 4.5 Annotate with `@DriftDatabase(tables: [TimesTable, WageHourlyTable])`
  - [ ] 4.6 Class extends `_$AppDatabase` (generated superclass)
  - [ ] 4.7 Constructor: `AppDatabase(super.e);` (takes `QueryExecutor`)
  - [ ] 4.8 Add named factory constructor or static method for creating connection with db name and web options
  - [ ] 4.9 Override `int get schemaVersion => 1;`
  - [ ] 4.10 Do NOT override `close()` — drift's `GeneratedDatabase` already provides it via `_$AppDatabase` superclass
  - [ ] 4.11 Add professional dartdoc comments on all public members
  - [ ] 4.12 Update `services.dart` barrel if needed (already exports `app_database.dart`)

- [ ] Task 5: Run code generation (AC: #2)
  - [ ] 5.1 Run `dart run build_runner build --delete-conflicting-outputs` — the flag avoids conflicts with existing ObjectBox/Freezed generated files
  - [ ] 5.2 Verify `app_database.g.dart` is generated in `lib/src/core/services/`
  - [ ] 5.3 Verify existing ObjectBox and Freezed generated files are NOT corrupted by the run

- [ ] Task 6: Download and place web assets (AC: #5)
  - [ ] 6.1 Check `pubspec.lock` for resolved `sqlite3` transitive dependency version (e.g., `3.1.5`)
  - [ ] 6.2 Download `sqlite3.wasm` from `https://github.com/simolus3/sqlite3.dart/releases` — find the tag matching the resolved version, download the `sqlite3.wasm` asset
  - [ ] 6.3 Download `drift_worker.dart.js` from `https://github.com/simolus3/drift/releases` — find the tag matching drift 2.32.x, download the `drift_worker.dart.js` asset
  - [ ] 6.4 Place both files in `web/` directory (alongside existing `index.html`, `favicon.png`, `manifest.json`)
  - [ ] 6.5 Verify files are accessible (not gitignored, correct permissions)
  - [ ] 6.6 Alternative: if `drift_dev` provides a CLI command (e.g., `dart run drift_dev make-web`), use it to auto-download both assets

- [ ] Task 7: Write tests (AC: #7)
  - [ ] 7.1 Create `test/src/core/services/app_database_test.dart`
  - [ ] 7.2 Test AppDatabase opens successfully with in-memory executor
  - [ ] 7.3 Test schemaVersion equals 1
  - [ ] 7.4 Test TimesTable insert + select roundtrip (verify column types work); verify autoIncrement produces sequential IDs across multiple inserts
  - [ ] 7.5 Test WageHourlyTable insert + select roundtrip; verify autoIncrement produces sequential IDs across multiple inserts
  - [ ] 7.6 Test TimesTable watch() emits updated list after insert
  - [ ] 7.7 Test WageHourlyTable watch() emits updated record after insert
  - [ ] 7.8 Test AppDatabase.close() completes without error (inherited from GeneratedDatabase)
  - [ ] 7.9 Test update operations on both tables (modify existing row, verify change persisted)
  - [ ] 7.10 Test delete operations on both tables (remove row, verify empty result)
  - [ ] 7.11 Test select on empty table returns empty list for both TimesTable and WageHourlyTable (edge case)

- [ ] Task 8: Verification (AC: #7)
  - [ ] 8.1 Run `flutter analyze` — zero issues
  - [ ] 8.2 Run `flutter test` — all 116 existing tests pass + new drift tests pass
  - [ ] 8.3 Verify generated files are excluded from analysis (existing `*.g.dart` pattern covers drift)

## Dev Notes

### State of the Codebase at Start of Story

**AppDatabase placeholder exists:** `lib/src/core/services/app_database.dart` currently contains a placeholder `class AppDatabase { const AppDatabase(); }` with dartdoc noting "Will be fully implemented in Epic 4." The barrel `services.dart` already exports it.

**ObjectBox is the only persistence layer:** ObjectBox 5.2.0 is fully functional for native platforms. ObjectBox and drift will coexist — ObjectBox for native (iOS, Android, Windows), drift for web. Both use build_runner for code generation without conflicts.

**116 tests passing:** Full test suite from Epics 1-3 is green. All BLoC, use case, repository, and core tests intact.

**Dartdoc is mandatory:** `public_member_api_docs` linter rule is enabled. All new public classes, methods, and fields require `///` dartdoc comments.

---

### drift 2.32.0 Technical Specifics

**Packages and versions:**

| Package | Version | Section | Purpose |
|---------|---------|---------|---------|
| `drift` | ^2.32.0 | dependencies | Core ORM — table definitions, queries, reactive streams |
| `drift_flutter` | ^0.3.0 | dependencies | Cross-platform helper — `driftDatabase()` handles native/web |
| `drift_dev` | ^2.32.0 | dev_dependencies | Code generator — produces `_$AppDatabase` superclass |

**CRITICAL: `sqlite3_flutter_libs` is OBSOLETE** — drift 2.32 depends on `sqlite3: ^3.1.5` which uses Dart build hooks to automatically bundle SQLite with the app. Do NOT add `sqlite3_flutter_libs` or `sqlcipher_flutter_libs`.

**VERSION NOTE:** The architecture planning document shows `drift_flutter: ^2.0.0` in a code sample — that value is outdated. The correct verified version is `drift_flutter: ^0.3.0` as specified in this story. Always use the versions in the table above, not the architecture doc.

**Code generation:** Drift generates `*.g.dart` files (same as Freezed/ObjectBox). The existing `analysis_options.yaml` exclusion `"**/**.g.dart"` already covers drift output. No changes needed.

**Web persistence — WASM + OPFS:**
- drift uses SQLite compiled to WebAssembly for web
- OPFS (Origin Private File System) provides file-system-like persistence in browsers
- Required browser versions: Chrome 86+, Firefox 111+, Safari 15.2+ (NFR14)
- Two web assets must be placed in `web/` (alongside existing `index.html`, `favicon.png`, `manifest.json`):
  - `sqlite3.wasm` — from `https://github.com/simolus3/sqlite3.dart/releases` (tag matching resolved sqlite3 version in `pubspec.lock`)
  - `drift_worker.dart.js` — from `https://github.com/simolus3/drift/releases` (tag matching drift 2.32.x)
- For OPFS performance, web server needs COOP/COEP headers:
  - `Cross-Origin-Opener-Policy: same-origin`
  - `Cross-Origin-Embedder-Policy: require-corp`
  - For flutter run: `flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp`
- Without headers, drift falls back to IndexedDB (slower but functional)

**drift_flutter `driftDatabase()` helper:** Handles platform detection automatically — native uses file system SQLite, web uses WASM+OPFS. The `name` parameter maps to the database file name on all platforms. See full implementation in the **AppDatabase Implementation Pattern** section below.

---

### AppDatabase Implementation Pattern

**Full implementation replacing placeholder:**

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:time_money/src/features/times/data/models/times_table.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_table.dart';

part 'app_database.g.dart';

/// Central drift database for the web platform.
///
/// Aggregates [TimesTable] and [WageHourlyTable] into a single SQLite
/// database. On web, uses WASM + OPFS for persistence. On native platforms,
/// uses the file system (though ObjectBox is the primary native datasource).
@DriftDatabase(tables: [TimesTable, WageHourlyTable])
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the provided [QueryExecutor].
  ///
  /// Use [createConnection] to obtain a platform-aware executor.
  AppDatabase(super.e);

  /// Creates an [AppDatabase] with a named, platform-aware connection.
  ///
  /// [dbName] is the environment-specific database name
  /// (`test-1`, `stg-1`, or `prod-1`).
  AppDatabase.named(String dbName) : super(_openConnection(dbName));

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection(String name) {
  return driftDatabase(
    name: name,
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
```

**Key points:**
- Two constructors: `AppDatabase(QueryExecutor)` for testing (in-memory), `AppDatabase.named(String)` for production
- `_openConnection` is a top-level private function (drift convention — keeps generated code clean)
- The `name` parameter follows the ObjectBox pattern: `test-1`, `stg-1`, `prod-1`

---

### Table Definitions — Exact Specifications

**TimesTable** (`lib/src/features/times/data/models/times_table.dart`):

```dart
import 'package:drift/drift.dart';

/// Drift table definition for time entries.
///
/// Maps to the [TimeEntry] domain entity. Columns match the ObjectBox
/// [TimeBox] model fields for data consistency across datasources.
class TimesTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Number of full hours tracked.
  IntColumn get hour => integer()();

  /// Additional minutes beyond full hours.
  IntColumn get minutes => integer()();
}
```

**WageHourlyTable** (`lib/src/features/wage/data/models/wage_hourly_table.dart`):

```dart
import 'package:drift/drift.dart';

/// Drift table definition for hourly wage records.
///
/// Maps to the [WageHourly] domain entity. Columns match the ObjectBox
/// [WageHourlyBox] model fields for data consistency across datasources.
class WageHourlyTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Hourly wage amount stored as a real (double) value.
  RealColumn get value => real()();
}
```

**Import rule:** Table files (`times_table.dart`, `wage_hourly_table.dart`) import ONLY `package:drift/drift.dart`. The `package:drift_flutter/drift_flutter.dart` import is ONLY in `app_database.dart` — never in table files.

**Existing ObjectBox models for reference:** Study `lib/src/features/times/data/models/time_box.dart` and `lib/src/features/wage/data/models/wage_hourly_box.dart` for field names and types. These files include conversion extensions (`.toTimeEntry`, `.toTimeBox`) — drift table files do NOT need conversion extensions; those come in Stories 4.2/4.3 with the drift repositories.

**Column-to-entity field mapping:**

| Domain Entity | Field | Type | Drift Column | ObjectBox Field |
|--------------|-------|------|-------------|----------------|
| TimeEntry | id | int | `integer().autoIncrement()` | `@Id() int id` |
| TimeEntry | hour | int | `integer()` | `int hour` |
| TimeEntry | minutes | int | `integer()` | `int minutes` |
| WageHourly | id | int | `integer().autoIncrement()` | `@Id() int id` |
| WageHourly | value | double | `real()` | `double value` |

---

### Testing Pattern for drift

**In-memory database for tests** — drift supports `NativeDatabase.memory()` from `package:drift/native.dart`:

```dart
import 'package:drift/native.dart';
import 'package:time_money/src/core/services/app_database.dart';

AppDatabase createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
```

**Test structure:**

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/services/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase', () {
    test('schema version is 1', () {
      expect(db.schemaVersion, 1);
    });

    group('TimesTable', () {
      test('insert and select roundtrip', () async {
        final id = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 2, minutes: 30),
            );
        final rows = await db.select(db.timesTable).get();

        expect(rows, hasLength(1));
        expect(rows.first.id, id);
        expect(rows.first.hour, 2);
        expect(rows.first.minutes, 30);
      });

      test('watch emits updated list after insert', () async {
        final stream = db.select(db.timesTable).watch();
        // ... expectLater with emitsInOrder
      });
    });
  });
}
```

**IMPORTANT:** Drift generates `Companion` classes for inserts (e.g., `TimesTableCompanion.insert(hour: 2, minutes: 30)`) and row data classes (e.g., `TimesTableData`). Use the generated companion for inserts, not raw maps. The exact generated class names depend on the table class name — verify after running `build_runner`.

**Note on generated names:** Drift derives data class names from the table class name. For `class TimesTable extends Table`, drift generates `TimesTableData` and `TimesTableCompanion`. Verify after generation and adjust test code accordingly.

---

### Previous Story Intelligence (Epic 3 Summary)

**Epic 3 quantitative results:** 6/6 stories completed, tests grew 23 → 116 (+93), 18 CR patches across all stories, 15 pre-existing bugs fixed, zero-lint on all 6 stories, zero hard blockers.

**Learnings directly relevant to this story:**
- **Dartdoc is mandatory** — `public_member_api_docs` enabled; every public class/method/field needs `///` comments
- **Zero lint tolerance** — `flutter analyze` must be clean before completion
- **Barrel exports** — update them when adding files to folders with existing barrels
- **Tests alongside implementation** — BMad aligned; never defer
- **`==`/`hashCode` on data-carrying types** — drift's generated data classes already have equality, so no extra work needed here
- **Edge case test coverage** — don't just test happy path; test empty tables, multiple inserts, updates to non-existent rows (flagged in 4/6 stories)
- **Verify build_runner doesn't corrupt other generated files** — ObjectBox and Freezed files must remain intact (check after every generation)

**Git patterns:**
- Commit format: `feat: description (story X.Y)` for implementation, `docs:` for documentation
- `flutter analyze` + `flutter test` must pass before marking complete
- Generated files are committed (Freezed, ObjectBox) — drift generated files should also be committed

---

### Developer Rules

**Mandatory patterns:**
- `const` constructors wherever possible
- Capture state fields into locals before `await`
- Absolute imports only — `package:time_money/...`
- Dartdoc `///` on every public class, method, and field
- Zero linter warnings — non-negotiable

**NEVER do (anti-patterns):**
- Do NOT add `sqlite3_flutter_libs` — obsolete with drift 2.32+ (Dart build hooks bundle SQLite)
- Do NOT define tables inside `app_database.dart` — separate files in feature's `data/models/`
- Do NOT use `import 'package:drift/native.dart'` in production code — only in tests
- Do NOT change ObjectBox service or any existing ObjectBox code
- Do NOT create drift datasources or repositories — Story 4.2/4.3 scope
- Do NOT modify bootstrap.dart or main_*.dart — Story 4.4 scope
- Do NOT edit generated files (`*.g.dart`)

**Out of scope:** drift datasources/repositories (4.2/4.3), platform-aware DI with kIsWeb (4.4), modifying main_*.dart/bootstrap.dart (4.4), multi-platform verification/localization (4.5)

---

### Project Structure Notes

**Files to CREATE:**
- `lib/src/features/times/data/models/times_table.dart` — drift Table definition
- `lib/src/features/wage/data/models/wage_hourly_table.dart` — drift Table definition
- `lib/src/core/services/app_database.g.dart` — generated by build_runner
- `web/sqlite3.wasm` — WASM binary for web SQLite
- `web/drift_worker.dart.js` — drift web worker script
- `test/src/core/services/app_database_test.dart` — database tests

**Files to MODIFY:**
- `pubspec.yaml` — add drift, drift_flutter, drift_dev dependencies
- `lib/src/core/services/app_database.dart` — replace placeholder with full drift implementation

**Files to VERIFY (no changes expected):**
- `analysis_options.yaml` — `*.g.dart` exclusion already covers drift generated files
- `lib/src/core/services/services.dart` — barrel already exports `app_database.dart`
- All existing ObjectBox and Freezed generated files — must remain intact after build_runner

**Files NOT to touch:**
- `lib/bootstrap.dart` — Story 4.4 scope
- `lib/main_development.dart` — Story 4.4 scope
- `lib/main_staging.dart` — Story 4.4 scope
- `lib/main_production.dart` — Story 4.4 scope
- `lib/app/view/app_bloc.dart` — Story 4.4 scope
- Any ObjectBox-related files
- Any existing BLoC, use case, or repository files

### Barrel Export Checklist

Check these folders for existing barrel files that may need updates:
- `lib/src/features/times/data/models/` — if `models.dart` barrel exists, add `times_table.dart` export
- `lib/src/features/wage/data/models/` — if `models.dart` barrel exists, add `wage_hourly_table.dart` export
- `lib/src/core/services/` — `services.dart` already exports `app_database.dart` ✅

### References

- [epics.md — Epic 4, Story 4.1, FR25-FR27, FR31, NFR11, NFR14]
- [architecture.md — Data Architecture: drift Configuration, Entity Naming Conventions, Project Structure]
- [architecture.md — Implementation Patterns: Datasource Pattern, DI Registration Pattern]
- [project-context.md — Technology Stack, Critical Implementation Rules]
- [3-6-domain-entities-naming-conventions-final-pass.md — Previous story (last in Epic 3)]
- [epic-3-retro-2026-03-19.md — Action items and team agreements]
- [drift documentation — https://drift.simonbinder.eu/]
- [drift_flutter pub.dev — https://pub.dev/packages/drift_flutter]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
