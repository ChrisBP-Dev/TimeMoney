# Story 2.3: Wage Feature — Feature-First Restructure

Status: ready-for-dev

## Story

As a developer,
I want to restructure the wage feature into a self-contained feature-first module with Data/Domain/Presentation layers,
so that all wage management code is organized following the same pattern as the times feature (FR33, FR35).

## Acceptance Criteria

1. **Given** wage-related code is spread across separate domain, infrastructure, and presentation trees
   **When** the code is restructured into `lib/src/features/wage/`
   **Then** `wage/domain/entities/` contains WageHourly entity and generated files
   **And** `wage/domain/repositories/` contains the abstract WageRepository interface
   **And** `wage/domain/use_cases/` contains FetchWageUseCase, SetWageUseCase, UpdateWageUseCase
   **And** `wage/data/repositories/` contains the ObjectBox repository implementation
   **And** `wage/data/datasources/` contains the ObjectBox datasource
   **And** `wage/data/models/` contains WageHourlyBox (ObjectBox entity)
   **And** `wage/presentation/bloc/` contains FetchWageBloc and UpdateWageBloc with events and states
   **And** `wage/presentation/pages/` contains FetchWageScreen and UpdateWagePage
   **And** `wage/presentation/widgets/` contains all wage-specific widgets

2. **Given** the wage domain layer
   **When** examining imports
   **Then** `wage/domain/` has zero external dependencies except fpdart (FR34)
   **And** use cases implement single-responsibility operations (FR35)

3. **Given** folder spellings in the original codebase (aplication, infraestructure)
   **When** the restructure is complete
   **Then** all folder names use correct English spelling (domain, data, presentation)
   **And** no references to old folder paths remain in the codebase

4. **Given** the wage feature restructure is complete
   **When** the app is compiled and launched
   **Then** wage management works identically: view current wage, set initial wage ($15.00 default), update wage with feedback
   **And** `flutter analyze` produces zero warnings on ALL project files
   **And** `flutter test` passes all existing tests (23 core tests)

## Tasks / Subtasks

- [ ] Task 1: Restructure domain layer (AC: #1, #2, #3)
  - [ ] 1.1 Create `domain/entities/` — move `wage_hourly.dart` (class `WageHourly` stays — NO entity rename)
  - [ ] 1.2 Verify `part` directives remain: `wage_hourly.freezed.dart`, `wage_hourly.g.dart`
  - [ ] 1.3 Create `domain/repositories/` — move+rename `wage_hourly_repository.dart` → `wage_repository.dart`, rename class `WageHourlyRepository` → `WageRepository`
  - [ ] 1.4 Rename typedefs: `FetchTimesResultStream` → `FetchWageResultStream`, `SetWageHourlyResult` → `SetWageResult`, `UpdateWageHourlyResult` → `UpdateWageResult`
  - [ ] 1.5 Create `domain/use_cases/` — move+rename all 3 use case files: `FetchWageHourlyUseCase` → `FetchWageUseCase`, `SetWageHourlyUseCase` → `SetWageUseCase`, `UpdateWageHourlyUseCase` → `UpdateWageUseCase`. **PRESERVE:** `SetWageUseCase.call()` takes NO parameters — it internally creates `const defaultWageHourly = WageHourly()` (default $15.00) and passes it to `_repository.setWageHourly(defaultWageHourly)`. This embedded default-creation behavior must be preserved exactly.
  - [ ] 1.6 Delete `aplication/` folder

- [ ] Task 2: Create data layer (AC: #1, #3)
  - [ ] 2.1 Create `data/models/` — move `infraestructure/wage_hourly_box.dart`; preserve `@Entity()` annotation, `@Id()` field, and `toString()` override
  - [ ] 2.2 Rename extension getter `toFreezedWageHourly` → `toWageHourly`
  - [ ] 2.3 Create `data/datasources/wage_objectbox_datasource.dart` (NEW — see Dev Notes)
  - [ ] 2.4 Create `data/repositories/` — refactor `i_wage_hourly_objectbox_repository.dart` → `objectbox_wage_repository.dart` (see Dev Notes)
  - [ ] 2.5 Delete `infraestructure/` folder

- [ ] Task 3: Move+rename presentation into feature (AC: #1)
  - [ ] 3.1 Create `presentation/bloc/` — move+rename all 7 BLoC source files (see Rename Table below)
  - [ ] 3.2 Create `presentation/pages/` — move `fetch_wage_screen.dart` (keep name); move+rename `wage_hourly_view.dart` → `update_wage_page.dart` (class `WageHourlyView` → `UpdateWagePage`)
  - [ ] 3.3 Create `presentation/widgets/` — flatten ALL widget files from fetch_wage/widgets/ and update_wage/widgets/ PLUS view files from fetch_wage/views/ into single widgets/ folder; delete the 2 old `widgets.dart` barrels and the `views/views.dart` barrel
  - [ ] 3.4 Delete `presentation/control_hours/wage_hourly/` folder (entire tree)

- [ ] Task 4: Update ObjectBox service (AC: #1)
  - [ ] 4.1 Remove `getWageHourlyStream()` method from `objectbox_service.dart`
  - [ ] 4.2 Remove `late final Box<WageHourlyBox> wageHourly;` field and its initialization in constructor
  - [ ] 4.3 Remove imports for `wage_hourly.dart` and `wage_hourly_box.dart`

- [ ] Task 5: Update DI/injection and entry point files (AC: #4)
  - [ ] 5.1 Update ALL 3 entry points (`main_development.dart`, `main_staging.dart`, `main_production.dart`) — replace `IWageHourlyObjectboxRepository(objectbox)` → `ObjectboxWageRepository(WageObjectboxDatasource(objectbox.store.box<WageHourlyBox>()))` and update imports
  - [ ] 5.2 Update `shared/injections/injection_repositories.dart` — new import path for `WageRepository` (field name stays `wageHourlyRepository`)
  - [ ] 5.3 Move `wage_hourly_use_cases_injections.dart` → `wage_injection.dart` at feature root, rename class `WageHourlyUseCasesInjections` → `WageUseCasesInjections`
  - [ ] 5.4 Update `shared/injections/bloc_injections.dart` — new import path, `WageHourlyBlocs.list()` → `WageBlocs.list()`
  - [ ] 5.5 Update `shared/injections/use_cases_injection.dart` — new import path, `WageHourlyUseCasesInjections.list()` → `WageUseCasesInjections.list()`

- [ ] Task 6: Update ALL cross-codebase imports (AC: #3, #4)
  - [ ] 6.1 Apply class renames across all files (see Complete Rename Table)
  - [ ] 6.2 Update `control_hours_page.dart` — import FetchWageScreen from new path
  - [ ] 6.3 Update internal widget imports to reference new BLoC/page class names
  - [ ] 6.4 Verify zero references to old paths: `features/wage_hourly/`, `presentation/control_hours/wage_hourly/`

- [ ] Task 7: Create barrel exports (AC: #1)
  - [ ] 7.1 `domain/entities/entities.dart`, `domain/repositories/repositories.dart`, `domain/use_cases/use_cases.dart`
  - [ ] 7.2 `data/models/models.dart`, `data/datasources/datasources.dart`, `data/repositories/repositories.dart`
  - [ ] 7.3 `presentation/bloc/bloc.dart`, `presentation/pages/pages.dart`, `presentation/widgets/widgets.dart`

- [ ] Task 8: Build & verify (AC: #4)
  - [ ] 8.1 Run `dart run build_runner build --delete-conflicting-outputs` — regenerate all .freezed.dart, .g.dart, objectbox.g.dart
  - [ ] 8.2 Run `flutter analyze` — zero issues on ALL project files
  - [ ] 8.3 Run `flutter test` — all 23 existing tests pass
  - [ ] 8.4 Run `flutter build apk --debug --flavor development -t lib/main_development.dart` — app compiles

## Dev Notes

### Critical: Scope Boundaries

**IN SCOPE (Story 2.3):**
- Restructure wage feature from `features/wage_hourly/` to `features/wage/` with feature-first layout (domain/data/presentation)
- Rename feature folder: `wage_hourly` → `wage`
- Rename repository: `WageHourlyRepository` → `WageRepository`, `IWageHourlyObjectboxRepository` → `ObjectboxWageRepository`
- Rename use cases: drop `Hourly` suffix (see Rename Table)
- Rename BLoCs: drop `Hourly` suffix (see Rename Table)
- Rename page: `WageHourlyView` → `UpdateWagePage`
- Rename typedefs: fix the `FetchTimesResultStream` collision → `FetchWageResultStream`
- Create `WageObjectboxDatasource` (extract from ObjectBox service)
- Correct folder spellings: `aplication` → `domain/use_cases`, `infraestructure` → `data`
- Flatten fetch_wage/views/ and update_wage/widgets/ and fetch_wage/widgets/ into single `presentation/widgets/`
- Remove ALL wage-specific code from `ObjectBox` service (leaves only Store wrapper)
- Update ALL imports across entire codebase
- Zero `flutter analyze` warnings

**OUT OF SCOPE (do NOT do these):**
- Do NOT restructure payment or home — that's Story 2.4
- Do NOT remove flutter_hooks — that's Story 2.5
- Do NOT restructure DI (shared/injections/) beyond updating import paths and class references — Story 2.5
- Do NOT rename `InjectionRepositories.wageHourlyRepository` field name — only change the type to `WageRepository`
- Do NOT convert Freezed to sealed classes — that's Epic 3
- Do NOT modify BLoC logic or state management patterns
- Do NOT add drift datasource — that's Epic 4
- Do NOT write new tests — restructure doesn't change behavior; tests come in Epic 3/5
- Do NOT rename the `WageHourly` entity class — stays as-is
- Do NOT rename the `WageHourlyBox` model class — stays as-is
- Do NOT rename widget files/classes (wage_hourly_card, wage_hourly_info, etc.) — these describe the entity, not the old folder
- Do NOT modify any times or payment presentation files beyond updating their imports to point at new wage paths

### project-context.md Override

The project-context.md rule "NEVER fix the spelling of `aplication/` or `infraestructure/` folders" was overridden in Story 2.2. This story continues the same pattern: replacing those folders with correct Clean Architecture layer names (`domain/use_cases`, `data`) for the wage feature.

### Complete Rename Table

| Before | After | Scope |
|--------|-------|-------|
| `WageHourlyRepository` (class) | `WageRepository` | interface + all references |
| `IWageHourlyObjectboxRepository` (class) | `ObjectboxWageRepository` | impl + all references |
| `FetchWageHourlyUseCase` (class+file) | `FetchWageUseCase` / `fetch_wage_use_case.dart` | class + file |
| `SetWageHourlyUseCase` (class+file) | `SetWageUseCase` / `set_wage_use_case.dart` | class + file |
| `UpdateWageHourlyUseCase` (class+file) | `UpdateWageUseCase` / `update_wage_use_case.dart` | class + file |
| `FetchWageHourlyBloc` (class+file) | `FetchWageBloc` / `fetch_wage_bloc.dart` | class + file + part directives |
| `FetchWageHourlyEvent` (class+file) | `FetchWageEvent` / `fetch_wage_event.dart` | class + file + part of |
| `FetchWageHourlyState` (class+file) | `FetchWageState` / `fetch_wage_state.dart` | class + file + part of |
| `UpdateWageHourlyBloc` (class+file) | `UpdateWageBloc` / `update_wage_bloc.dart` | class + file + part directives |
| `UpdateWageHourlyEvent` (class+file) | `UpdateWageEvent` / `update_wage_event.dart` | class + file + part of |
| `UpdateWageHourlyState` (class+file) | `UpdateWageState` / `update_wage_state.dart` | class + file + part of |
| `WageHourlyBlocs` (class+file) | `WageBlocs` / `wage_blocs.dart` | class + file |
| `WageHourlyUseCasesInjections` (class+file) | `WageUseCasesInjections` / `wage_injection.dart` | class + file |
| `WageHourlyView` (class+file) | `UpdateWagePage` / `update_wage_page.dart` | class + file |
| `FetchTimesResultStream` (typedef in wage) | `FetchWageResultStream` | typedef in wage_repository + use case |
| `SetWageHourlyResult` (typedef) | `SetWageResult` | typedef in wage_repository + use case |
| `UpdateWageHourlyResult` (typedef) | `UpdateWageResult` | typedef in wage_repository + use case |
| `toFreezedWageHourly` (getter) | `toWageHourly` | extension getter on WageHourlyBox |

**NOT renamed:**
- `WageHourly` entity class — stays
- `WageHourlyBox` model class — stays
- `toWageHourlyBox` getter — stays (named after target type)
- `ConvertWageHourly` extension name — stays
- `ConvertWageHourlyBox` extension name — stays
- `FetchWageScreen` class — stays (screen naming, same as times `ListTimesScreen`)
- Widget files/classes (`WageHourlyCard`, `WageHourlyInfo`, `WageHourlyField`, etc.) — stay

### Target Feature Structure

```
lib/src/features/wage/
├── data/
│   ├── datasources/
│   │   ├── datasources.dart                     ← barrel
│   │   └── wage_objectbox_datasource.dart       ← NEW
│   ├── models/
│   │   ├── models.dart                          ← barrel
│   │   └── wage_hourly_box.dart                 ← was infraestructure/wage_hourly_box.dart
│   └── repositories/
│       ├── repositories.dart                    ← barrel
│       └── objectbox_wage_repository.dart       ← refactored from i_wage_hourly_objectbox_repository.dart
├── domain/
│   ├── entities/
│   │   ├── entities.dart                        ← barrel
│   │   ├── wage_hourly.dart                     ← moved from domain/ (class NOT renamed)
│   │   ├── wage_hourly.freezed.dart             ← regenerated
│   │   └── wage_hourly.g.dart                   ← regenerated
│   ├── repositories/
│   │   ├── repositories.dart                    ← barrel
│   │   └── wage_repository.dart                 ← was domain/wage_hourly_repository.dart (class renamed)
│   └── use_cases/
│       ├── use_cases.dart                       ← barrel
│       ├── fetch_wage_use_case.dart             ← renamed from aplication/fetch_wage_hourly_use_case.dart
│       ├── set_wage_use_case.dart               ← renamed from aplication/set_wage_hourly_use_case.dart
│       └── update_wage_use_case.dart            ← renamed from aplication/update_wage_hourly_use_case.dart
├── presentation/
│   ├── bloc/
│   │   ├── bloc.dart                            ← barrel
│   │   ├── wage_blocs.dart                      ← renamed from wage_hourly_blocs.dart
│   │   ├── fetch_wage_bloc.dart                 ← + fetch_wage_event.dart, fetch_wage_state.dart, .freezed.dart
│   │   └── update_wage_bloc.dart                ← + update_wage_event.dart, update_wage_state.dart, .freezed.dart
│   ├── pages/
│   │   ├── pages.dart                           ← barrel
│   │   ├── fetch_wage_screen.dart               ← was fetch_wage/fetch_wage_screen.dart (class NOT renamed)
│   │   └── update_wage_page.dart                ← was update_wage/wage_hourly_view.dart (class renamed)
│   └── widgets/
│       ├── widgets.dart                         ← barrel (single, replaces 2 old barrels + 1 views barrel)
│       ├── wage_hourly_card.dart
│       ├── wage_hourly_info.dart
│       ├── update_wage_button.dart
│       ├── wage_hourly_data_view.dart           ← was fetch_wage/views/
│       ├── wage_hourly_other_view.dart          ← was fetch_wage/views/
│       ├── error_fetch_wage_hourly_view.dart    ← was fetch_wage/views/
│       ├── set_wage_button.dart
│       └── wage_hourly_field.dart
└── wage_injection.dart                          ← renamed from aplication/wage_hourly_use_cases_injections.dart
```

### WageBlocs Implementation (Renamed from WageHourlyBlocs)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/wage/domain/use_cases/fetch_wage_use_case.dart';
import 'package:time_money/src/features/wage/domain/use_cases/update_wage_use_case.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';

class WageBlocs {
  static List<BlocProvider> list() => [
        BlocProvider<FetchWageBloc>(
          create: (context) => FetchWageBloc(
            context.read<FetchWageUseCase>(),
          ),
        ),
        BlocProvider<UpdateWageBloc>(
          create: (context) => UpdateWageBloc(
            context.read<UpdateWageUseCase>(),
          ),
        ),
      ];
}
```

Note: The `context.read<>()` type parameters change from `FetchWageHourlyUseCase` → `FetchWageUseCase` and `UpdateWageHourlyUseCase` → `UpdateWageUseCase`.

### WageObjectboxDatasource Implementation (NEW)

```dart
import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';

/// Raw ObjectBox operations for wage entries.
/// Works with DB models only — no domain entity mapping here.
class WageObjectboxDatasource {
  const WageObjectboxDatasource(this._box);
  final Box<WageHourlyBox> _box;

  Stream<List<WageHourlyBox>> watchAll() {
    return _box.query().watch(triggerImmediately: true).map(
          (query) => query.find(),
        );
  }

  int put(WageHourlyBox wageBox) => _box.put(wageBox);
}
```

No `remove()` method — there is no delete wage use case.

### ObjectboxWageRepository Refactor

**Before** (IWageHourlyObjectboxRepository):
- Received `ObjectBox` service directly
- Called `_objectbox.wageHourly.put()`, `_objectbox.getWageHourlyStream()`
- Stream mapping and "empty → default" logic was inside `ObjectBox.getWageHourlyStream()`

**After** (ObjectboxWageRepository):
- Receives `WageObjectboxDatasource` only
- Calls `_datasource.put()`, `_datasource.watchAll()`
- Handles ALL `WageHourlyBox` ↔ `WageHourly` mapping in the repository layer
- Repository owns the "empty → default WageHourly()" fallback logic (moved from ObjectBox service)
- Error handling pattern unchanged: try/catch wrapping with `GlobalFailure.fromException(e)`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/wage/domain/repositories/wage_repository.dart';

class ObjectboxWageRepository implements WageRepository {
  const ObjectboxWageRepository(this._datasource);
  final WageObjectboxDatasource _datasource;

  @override
  FetchWageResultStream fetchWageHourly() {
    try {
      final stream = _datasource.watchAll().map(
            (boxes) {
              final wages = boxes.map((box) => box.toWageHourly).toList();
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
      _datasource.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }

  @override
  UpdateWageResult update(WageHourly wageHourly) async {
    try {
      _datasource.put(wageHourly.toWageHourlyBox);
      return right(wageHourly);
    } on Object catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
```

**Behavioral notes:**
- `setWageHourly()` and `update()` both call `put()` (ObjectBox upsert) and return the original entity — they do NOT capture the ID returned by `put()`. This matches existing behavior exactly.
- `fetchWageHourly()` returns `FetchWageResultStream` (which is `Either<...>`) — it is NOT `async`, NOT `Future`. The other two methods ARE `async`.
- The "empty → default `WageHourly()`" fallback was previously inside `ObjectBox.getWageHourlyStream()`. Now the repository owns this logic.

### Extension Rename in wage_hourly_box.dart

```dart
// BEFORE:
extension ConvertWageHourly on WageHourlyBox {
  WageHourly get toFreezedWageHourly => WageHourly(id: id, value: value);
}

// AFTER:
extension ConvertWageHourly on WageHourlyBox {
  WageHourly get toWageHourly => WageHourly(id: id, value: value);
}
```

Only the getter name changes: `toFreezedWageHourly` → `toWageHourly`. Extension names and `ConvertWageHourlyBox` / `toWageHourlyBox` stay unchanged.

**Ripple effect:** The getter `toFreezedWageHourly` is referenced in ONE place outside the wage feature: `objectbox_service.dart:19` — but that entire method (`getWageHourlyStream()`) is being removed in Task 4. So the only consumer of the renamed getter is the new `ObjectboxWageRepository`.

### Repository Typedef Updates

In `wage_repository.dart` (was `wage_hourly_repository.dart`):
```dart
// BEFORE:
typedef FetchTimesResultStream = Either<GlobalDefaultFailure, Stream<WageHourly>>;
typedef SetWageHourlyResult = Future<Either<GlobalDefaultFailure, WageHourly>>;
typedef UpdateWageHourlyResult = Future<Either<GlobalDefaultFailure, WageHourly>>;

// AFTER:
typedef FetchWageResultStream = Either<GlobalDefaultFailure, Stream<WageHourly>>;
typedef SetWageResult = Future<Either<GlobalDefaultFailure, WageHourly>>;
typedef UpdateWageResult = Future<Either<GlobalDefaultFailure, WageHourly>>;
```

**CRITICAL: The `FetchTimesResultStream` name in wage was a pre-existing naming collision with the times feature's typedef of the same name.** Renaming to `FetchWageResultStream` resolves this. This was flagged as W1 in Story 2.2.

**Note:** The typedefs use `GlobalDefaultFailure` (which is `GlobalFailure<dynamic>`). This is equivalent to the times feature's explicit `GlobalFailure<dynamic>`. Do NOT change the typedef type — keep `GlobalDefaultFailure` as-is. The `GlobalFailure.fromException(e)` call in `ObjectboxWageRepository` is compatible because `GlobalDefaultFailure` is a typedef alias for `GlobalFailure<dynamic>`.

### ObjectBox Service Modification

Remove ALL wage-specific code from `core/services/objectbox_service.dart`:

```dart
// REMOVE these imports:
import 'package:time_money/src/features/wage_hourly/domain/wage_hourly.dart';
import 'package:time_money/src/features/wage_hourly/infraestructure/wage_hourly_box.dart';

// REMOVE field:
late final Box<WageHourlyBox> wageHourly;

// In constructor, REMOVE:
wageHourly = Box<WageHourlyBox>(store);

// REMOVE entire method:
Stream<WageHourly> getWageHourlyStream() { ... }
```

**After removal, ObjectBox service contains ONLY:**
```dart
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_money/objectbox.g.dart';

class ObjectBox {
  ObjectBox._create(this.store);
  late final Store store;

  static Future<ObjectBox> create(String path) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, path),
    );
    return ObjectBox._create(store);
  }

  Future<void> close() async {
    store.close();
  }
}
```

This is the final state of the ObjectBox service — a thin Store wrapper. Both features now access their Boxes through their own datasources.

### DI Wiring Update — Entry Point Files (CRITICAL)

**All 3 main files follow identical pattern:**

```dart
// BEFORE:
import 'package:time_money/src/features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart';
// ...
wageHourlyRepository: IWageHourlyObjectboxRepository(objectbox),

// AFTER:
import 'package:objectbox/objectbox.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
// ...
wageHourlyRepository: ObjectboxWageRepository(
  WageObjectboxDatasource(objectbox.store.box<WageHourlyBox>()),
),
```

Note: The `objectbox` import is already present from Story 2.2's times wiring (`objectbox.store.box<TimeBox>()`), but the `Box` import from `package:objectbox/objectbox.dart` may already be there too. Verify before adding duplicates.

### Cross-Feature Import: WageHourlyDataView → ResultPaymentCubit

`wage_hourly_data_view.dart` calls `ResultPaymentCubit.setWage(wage.value)` — this is a known cross-feature dependency. For Story 2.3, keep this import working by updating the path. Story 2.4 will properly restructure payment as its own feature.

### CRITICAL WARNINGS

**W1: `toFreezedWageHourly` getter referenced in ObjectBox service.**
The getter `toFreezedWageHourly` is used in `objectbox_service.dart:19` inside `getWageHourlyStream()`. Since that entire method is being removed (Task 4), the rename to `toWageHourly` is safe — no external consumers exist after the removal. Do NOT rename the getter before removing the service method, or the service will break before Task 4 completes.

**W2: Part file `part of` directives must match new filenames.**
All BLoC event/state part files contain `part of 'fetch_wage_hourly_bloc.dart'` or `part of 'update_wage_hourly_bloc.dart'`. These MUST be updated to `part of 'fetch_wage_bloc.dart'` and `part of 'update_wage_bloc.dart'` respectively. Similarly, the parent BLoC files' `part` directives must match the new event/state filenames. Missing this causes `build_runner` to fail silently or generate incorrect code.

**W3: `DataWage` extension in state file references old class name.**
`fetch_wage_hourly_state.dart` contains `extension DataWage on FetchWageHourlyState`. After renaming the state class to `FetchWageState`, this must become `extension DataWage on FetchWageState`. The extension name `DataWage` itself stays unchanged.

**W4: `_ActionWidget` in FetchWageScreen is dead code.**
The `_ActionWidget` class in `fetch_wage_screen.dart` is a placeholder (`ElevatedButton(onPressed: () {}, child: const Text('error'))`) with commented-out BLoC code. Do NOT fix or remove — this is pre-existing technical debt for Epic 3.

**W5: Entity name `WageHourly` is NOT being renamed.**
Unlike Story 2.2 (which renamed `ModelTime` → `TimeEntry`), this story does NOT rename the `WageHourly` entity. The architecture target name IS `WageHourly`. This means there is NO global class search-replace needed for the entity — only for the items in the Rename Table.

### Exhaustive Import Update Checklist

All paths relative to `lib/src/`. Generated files (`.freezed.dart`, `.g.dart`) excluded — handled by `build_runner`.

**Pattern 1: `features/wage_hourly/domain/wage_hourly.dart` → `features/wage/domain/entities/wage_hourly.dart` (11 files):**

*Within wage feature (will be moved, need new internal imports):*
1. `features/wage_hourly/domain/wage_hourly_repository.dart`
2. `features/wage_hourly/infraestructure/wage_hourly_box.dart`
3. `features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`
4. `features/wage_hourly/aplication/set_wage_hourly_use_case.dart`
5. `features/wage_hourly/aplication/update_wage_hourly_use_case.dart`

*Core service (REMOVE import entirely):*
6. `core/services/objectbox_service.dart`

*Presentation (will be moved into feature):*
7. `presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart`
8. `presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart`
9. `presentation/control_hours/wage_hourly/fetch_wage/views/wage_hourly_data_view.dart`
10. `presentation/control_hours/wage_hourly/fetch_wage/widgets/wage_hourly_card.dart`
11. `presentation/control_hours/wage_hourly/fetch_wage/widgets/wage_hourly_info.dart`

**Pattern 2: `features/wage_hourly/domain/wage_hourly_repository.dart` → `features/wage/domain/repositories/wage_repository.dart` (5 files):**
1. `features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart`
2. `features/wage_hourly/aplication/fetch_wage_hourly_use_case.dart`
3. `features/wage_hourly/aplication/set_wage_hourly_use_case.dart`
4. `features/wage_hourly/aplication/update_wage_hourly_use_case.dart`
5. `shared/injections/injection_repositories.dart`

**Pattern 3: `features/wage_hourly/aplication/` use case imports (5 files):**
1. `features/wage_hourly/aplication/wage_hourly_use_cases_injections.dart` (imports all 3 use cases)
2. `presentation/control_hours/wage_hourly/wage_hourly_blocs.dart` (imports fetch + update use cases)
3. `presentation/control_hours/wage_hourly/fetch_wage/bloc/fetch_wage_hourly_bloc.dart`
4. `presentation/control_hours/wage_hourly/update_wage/bloc/update_wage_hourly_bloc.dart`
5. `shared/injections/use_cases_injection.dart`

**Pattern 4: `features/wage_hourly/infraestructure/` imports (4 files):**
1. `features/wage_hourly/infraestructure/i_wage_hourly_objectbox_repository.dart` (imports wage_hourly_box)
2. `core/services/objectbox_service.dart` — REMOVE import entirely
3. `main_development.dart` — replace with new imports + construction
4. `main_staging.dart` — same
5. `main_production.dart` — same

**Pattern 5: `presentation/control_hours/wage_hourly/` paths (external consumers only):**
1. `presentation/control_hours/control_hours_page.dart` — imports `fetch_wage_screen.dart`
2. `shared/injections/bloc_injections.dart` — imports `wage_hourly_blocs.dart`

**Pattern 5b: Internal barrel imports (update during move):**
1. `fetch_wage_screen.dart` — replace `fetch_wage/views/views.dart` import with new `widgets/widgets.dart` barrel
2. `wage_hourly_data_view.dart` — replace `fetch_wage/widgets/widgets.dart` import with new `widgets/widgets.dart` barrel (self-barrel)
3. `wage_hourly_card.dart` — replace `fetch_wage/widgets/widgets.dart` import with new `widgets/widgets.dart` barrel
4. `update_wage_button.dart` — replace `update_wage/wage_hourly_view.dart` import with new `pages/update_wage_page.dart`

**Pattern 6: Class renames in BLoC consumer widgets (all moving files):**
1. `fetch_wage_screen.dart` — `FetchWageHourlyBloc` → `FetchWageBloc`, `FetchWageHourlyState` → `FetchWageState`, `FetchWageHourlyEvent` → `FetchWageEvent`
2. `wage_hourly_field.dart` — `UpdateWageHourlyBloc` → `UpdateWageBloc`, `UpdateWageHourlyState` → `UpdateWageState`, `UpdateWageHourlyEvent` → `UpdateWageEvent`
3. `set_wage_button.dart` — `UpdateWageHourlyBloc` → `UpdateWageBloc`, `UpdateWageHourlyState` → `UpdateWageState`, `UpdateWageHourlyEvent` → `UpdateWageEvent`

### Key Difference from Story 2.2

Story 2.2 had a massive entity rename (`ModelTime` → `TimeEntry`) that rippled through ~20 files including part files. Story 2.3 does NOT rename the entity (`WageHourly` stays). The renames here are for infrastructure/use-case/BLoC classes only, and are contained within the files being moved. This makes the import update significantly simpler — no global `WageHourly` search-replace needed.

### Barrel Export Rules

- Each subfolder with files gets a barrel: `{folder_name}.dart`
- ONLY re-export source `.dart` files — never `.freezed.dart` or `.g.dart`
- No `library` directive, no logic, no classes
- Pattern: `export 'file_name.dart';`

### Execution Order

**Recommended sequence to minimize broken state:**
1. Create all new folders first (empty)
2. Move+rename domain files (entity, repository, use cases)
3. Create datasource (new file)
4. Move+refactor data files (models, repository)
5. Move+rename presentation files (blocs, pages, widgets)
6. Update ObjectBox service (remove wage code)
7. Update DI/injection files
8. Apply class renames across all files
9. Update all remaining import paths
10. Create barrel exports
11. Delete old empty folders (`features/wage_hourly/`, `presentation/control_hours/wage_hourly/`)
12. Run build_runner
13. Run flutter analyze, fix any issues
14. Run flutter test
15. Run flutter build apk

### Project Structure Notes

- `shared/injections/` folder stays as-is structurally — only import paths and class references change. The field `InjectionRepositories.wageHourlyRepository` keeps its name. Full DI restructuring is Story 2.5.
- `presentation/control_hours/` folder will still contain `result_payment/`, `control_hours_page.dart` after this story. Those move in Story 2.4.
- After this story, `features/` contains two restructured features: `times/` and `wage/`. Both follow identical Data/Domain/Presentation layout.
- ObjectBox service becomes a thin Store wrapper after Task 4. Both features now access their Boxes through their own datasources via `objectbox.store.box<T>()` in the entry points.

### Architecture Compliance

Same rules as Story 2.2. Key reminders: absolute imports only (`package:time_money/src/...`), VGA 10.x import order, `on Object catch (e)` pattern, const constructors, barrel files with re-exports only.

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 2, Story 2.3]
- [Source: _bmad-output/planning-artifacts/architecture.md — Section 3: Frontend Architecture, Section 4: Implementation Patterns]
- [Source: _bmad-output/planning-artifacts/prd.md — FR33, FR34, FR35]
- [Source: _bmad-output/implementation-artifacts/2-2-times-feature-feature-first-restructure.md — Story 2.2 learnings]
- [Source: _bmad-output/project-context.md — Rules 1-43]

### Previous Story Intelligence

**From Story 2.2 (most recent):**
- Feature-first restructure pattern fully validated: data/domain/presentation layout with barrel exports works
- Datasource extraction pattern: new `{Feature}ObjectboxDatasource` receives `Box<T>` via constructor → follow exactly
- Repository refactor pattern: receives datasource, handles mapping + error wrapping → follow exactly
- ObjectBox service simplification: remove feature-specific Boxes and streams, leave only Store → this story completes the simplification
- Barrel exports: re-exports only, no `.freezed.dart` in barrels — pattern confirmed
- Part file `part of` directives: MUST match renamed parent filenames — Story 2.2 validated this
- build_runner: 11 outputs in 10s — expect similar or slightly faster since fewer files changing
- Zero-issue linting maintained: Story 2.2 achieved "No issues found!" — maintain this
- 23 core tests: `failures_test.dart` (12 tests), `action_state_test.dart` (11 tests) — must still pass
- Freezed 3.x with backward-compat config in `build.yaml` — when/map still enabled
- Entry point DI wiring: `ObjectboxTimesRepository(TimesObjectboxDatasource(objectbox.store.box<TimeBox>()))` pattern → replicate for wage

**Pre-Existing Technical Debt (do NOT fix, just be aware):**
- D-1: TextEditingController not synced with bloc state in WageHourlyField (Epic 2-3)
- D-2: BlocConsumer listener is no-op in FetchWageScreen, WageHourlyField, SetWageButton (Epic 2-3)
- D-3: _ActionWidget in FetchWageScreen is dead code placeholder (Epic 3)
- D-4: DeleteTimeBloc `.fold()` result not emitted — CRITICAL LOGIC BUG (Epic 3 Story 3.3)
- D-5: CreateTimeEvent `_Reset` missing handler (Epic 3 Story 3.2)

### Git Intelligence

**Recent Commits:**
```
6d1acd8 chore: code review passed for story 2.2
69a75dd refactor: restructure times feature to feature-first clean architecture layout
4cc6351 docs: validate story 2.2
80e830d docs: create story 2.2
b0301d1 chore: code review passed for story 2.1
```

**Commit message convention:** `type: description` — use `refactor:` for this story since it's architecture restructuring.

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### Change Log

### File List
