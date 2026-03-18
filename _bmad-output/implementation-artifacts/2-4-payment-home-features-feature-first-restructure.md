# Story 2.4: Payment & Home Features — Feature-First Restructure

Status: ready-for-dev

## Story

As a developer,
I want to create the payment feature (domain + presentation only) and home feature (presentation shell),
so that cross-feature composition follows Clean Architecture with proper boundaries and separation (FR33, FR37).

## Acceptance Criteria

1. **Given** payment calculation logic exists in the codebase
   **When** the payment feature is created at `lib/src/features/payment/`
   **Then** `payment/domain/use_cases/` contains CalculatePaymentUseCase
   **And** `payment/presentation/cubit/` contains PaymentCubit and PaymentState
   **And** `payment/presentation/pages/` contains PaymentResultPage
   **And** payment feature has NO data layer (calculation derives from times + wage data)

2. **Given** the home page composes times, wage, and payment features
   **When** the home feature is created at `lib/src/features/home/`
   **Then** `home/presentation/pages/` contains HomePage
   **And** `home/presentation/widgets/` contains CalculatePaymentButton
   **And** home feature has NO data or domain layers (pure composition shell)

3. **Given** cross-feature boundaries
   **When** examining payment feature imports
   **Then** payment imports only domain entities from times (and wage if needed) — never their data or presentation layers
   **And** home composes presentation widgets from all features but does not access their internals
   **Note:** Currently payment uses `double wageHourly` (primitive), so only `times/domain/entities/` is imported. Architecture allows `wage/domain/entities/` if future changes require the `WageHourly` entity.

4. **Given** the restructure is complete
   **When** the app is compiled and launched
   **Then** the home page displays wage info, time entries list, and action buttons
   **And** payment calculation works correctly from the home page
   **And** `flutter analyze` produces zero warnings on ALL project files
   **And** `flutter test` passes all existing tests (23 core tests)

## Tasks / Subtasks

- [ ] Task 1: Create payment domain layer (AC: #1)
  - [ ] 1.1 Create `features/payment/domain/use_cases/calculate_payment_use_case.dart` — NEW use case wrapping `CalculatePay` extension
  - [ ] 1.2 Create `features/payment/domain/use_cases/use_cases.dart` — barrel export

- [ ] Task 2: Move+rename payment presentation layer (AC: #1, #3)
  - [ ] 2.1 Create `features/payment/presentation/cubit/payment_cubit.dart` — move+rename from `result_payment_cubit.dart`
  - [ ] 2.2 Create `features/payment/presentation/cubit/payment_state.dart` — move+rename from `result_payment_state.dart`
  - [ ] 2.3 Update `part` directives: `part 'payment_state.dart'`, `part 'payment_cubit.freezed.dart'` in cubit; `part of 'payment_cubit.dart'` in state
  - [ ] 2.4 Create `features/payment/presentation/cubit/payment_cubits.dart` — move+rename from `result_payment_cubits.dart`
  - [ ] 2.5 Create `features/payment/presentation/pages/payment_result_page.dart` — move+rename from `result_screen.dart`
  - [ ] 2.6 Create barrel exports: `cubit/cubit.dart`, `pages/pages.dart`

- [ ] Task 3: Move+rename home feature (AC: #2)
  - [ ] 3.1 Create `features/home/presentation/pages/home_page.dart` — move+rename from `control_hours_page.dart`
  - [ ] 3.2 Create `features/home/presentation/widgets/calculate_payment_button.dart` — moved from `result_payment/`
  - [ ] 3.3 Create barrel exports: `pages/pages.dart`, `widgets/widgets.dart`

- [ ] Task 4: Update all cross-codebase imports (AC: #3, #4)
  - [ ] 4.1 Update `app/view/app.dart` — `ControlHoursPage` → `HomePage`, import from `features/home/`
  - [ ] 4.2 Update `shared/injections/bloc_injections.dart` — `ResultPaymentCubits` → `PaymentCubits`, import from `features/payment/`
  - [ ] 4.3 Update `features/times/presentation/widgets/list_times_data_view.dart` — `ResultPaymentCubit` → `PaymentCubit`, import from `features/payment/`
  - [ ] 4.4 Update `features/wage/presentation/widgets/wage_hourly_data_view.dart` — `ResultPaymentCubit` → `PaymentCubit`, import from `features/payment/`
  - [ ] 4.5 Verify zero references to old paths: `presentation/control_hours/`, `result_payment_cubit`, `ResultPaymentCubit`, `ResultPaymentScreen`, `ResultPaymentCubits`

- [ ] Task 5: Delete old folders (AC: #4)
  - [ ] 5.1 Delete `lib/src/presentation/control_hours/` (entire folder tree including result_payment/)
  - [ ] 5.2 Verify `lib/src/presentation/` only contains `widgets/` folder after deletion

- [ ] Task 6: Build & verify (AC: #4)
  - [ ] 6.1 Run `dart run build_runner build --delete-conflicting-outputs` — regenerate `payment_cubit.freezed.dart`
  - [ ] 6.2 Run `flutter analyze` — zero issues on ALL project files
  - [ ] 6.3 Run `flutter test` — all 23 existing tests pass
  - [ ] 6.4 Run `flutter build apk --debug --flavor development -t lib/main_development.dart` — app compiles

## Dev Notes

### Critical: Scope Boundaries

**IN SCOPE (Story 2.4):**
- Create payment feature at `lib/src/features/payment/` (domain/use_cases + presentation/cubit + presentation/pages)
- Create home feature at `lib/src/features/home/` (presentation/pages + presentation/widgets)
- Move `result_payment/` code → payment feature
- Move `control_hours_page.dart` → home feature pages
- Move `calculate_payment_button.dart` → home feature widgets
- Create `CalculatePaymentUseCase` (NEW domain-layer use case)
- Rename all `ResultPayment*` classes → `Payment*` (see Rename Table)
- Rename `ControlHoursPage` → `HomePage`
- Rename `ResultPaymentScreen` → `PaymentResultPage`
- Update ALL imports across entire codebase
- Create barrel exports for all new subdirectories
- Delete `presentation/control_hours/` folder
- Zero `flutter analyze` warnings

**OUT OF SCOPE (do NOT do these):**
- Do NOT extract shared widgets to `shared/widgets/` — that's Story 2.5
- Do NOT restructure DI (shared/injections/) beyond updating import paths and class references — Story 2.5
- Do NOT remove flutter_hooks — that's Story 2.5
- Do NOT convert Freezed to sealed classes — that's Epic 3
- Do NOT modify BLoC/Cubit logic or state management patterns
- Do NOT add drift datasource — that's Epic 4
- Do NOT write new tests — tests come in Epic 3/5
- Do NOT resolve the cross-feature dependency where times/wage data views call `PaymentCubit.setList()`/`setWage()` — the clean resolution requires stream → direct state migration in Epic 3 (see W1 below)
- Do NOT modify the `CalculatePay` extension in `time_entry.dart` — it stays in times domain
- Do NOT rename or move `lib/src/presentation/widgets/` (CatchErrorBuilder, CustomCard, InfoSection, ErrorView) — that's Story 2.5
- Do NOT modify entry point files (`main_*.dart`) — payment has no repository dependencies

### Complete Rename Table

| Before | After | Scope |
|--------|-------|-------|
| `ControlHoursPage` (class+file) | `HomePage` / `home_page.dart` | class + file + app.dart reference |
| `ResultPaymentCubit` (class+file) | `PaymentCubit` / `payment_cubit.dart` | class + file + all references |
| `ResultPaymentState` (class+file) | `PaymentState` / `payment_state.dart` | class + file + part of directive |
| `ResultPaymentScreen` (class+file) | `PaymentResultPage` / `payment_result_page.dart` | class + file + button reference |
| `ResultPaymentCubits` (class+file) | `PaymentCubits` / `payment_cubits.dart` | class + file + bloc_injections reference |

**NOT renamed:**
- `CalculatePaymentButton` — stays (moves to home feature)
- `CalculatePay` extension — stays in `time_entry.dart` (times domain)
- `CatchErrorBuilder`, `CustomCard`, `InfoSection`, `ErrorView` — stay at `presentation/widgets/`

### Target Feature Structures

```
lib/src/features/payment/
├── domain/
│   └── use_cases/
│       ├── use_cases.dart                          ← barrel
│       └── calculate_payment_use_case.dart         ← NEW
└── presentation/
    ├── cubit/
    │   ├── cubit.dart                              ← barrel
    │   ├── payment_cubit.dart                      ← was result_payment/cubit/result_payment_cubit.dart
    │   ├── payment_state.dart                      ← was result_payment/cubit/result_payment_state.dart
    │   ├── payment_cubit.freezed.dart              ← regenerated
    │   └── payment_cubits.dart                     ← was result_payment/result_payment_cubits.dart
    └── pages/
        ├── pages.dart                              ← barrel
        └── payment_result_page.dart                ← was result_payment/result_screen.dart

lib/src/features/home/
└── presentation/
    ├── pages/
    │   ├── pages.dart                              ← barrel
    │   └── home_page.dart                          ← was control_hours/control_hours_page.dart
    └── widgets/
        ├── widgets.dart                            ← barrel
        └── calculate_payment_button.dart           ← was result_payment/calculate_payment_button.dart
```

### Remaining `lib/src/presentation/` After Story 2.4

```
lib/src/presentation/
└── widgets/
    ├── widgets.dart                    ← barrel (unchanged)
    ├── catch_error_builder.dart        ← shared widget (moves to shared/ in Story 2.5)
    ├── custom_card.dart                ← shared widget (moves to shared/ in Story 2.5)
    ├── info_section.dart               ← shared widget (moves to shared/ in Story 2.5)
    └── views/
        └── error_view.dart             ← shared widget (moves to shared/ in Story 2.5)
```

The `control_hours/` folder is completely deleted. Only `widgets/` remains.

### CalculatePaymentUseCase Implementation (NEW)

```dart
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Calculates total payment from time entries and hourly wage.
/// Uses the CalculatePay extension on List<TimeEntry>.
/// No repository dependencies — pure domain calculation.
class CalculatePaymentUseCase {
  const CalculatePaymentUseCase();

  double call(List<TimeEntry> times, double wageHourly) {
    return times.calculatePayment(wageHourly);
  }
}
```

**Key notes:**
- Imports ONLY `TimeEntry` from times domain (complies with import boundary: payment → times/domain/entities/)
- No repository dependency — const-constructible
- Wraps the existing `CalculatePay.calculatePayment()` extension
- No DI registration needed (no deps). Const-construct where needed.
- The `CalculatePay` extension stays in `time_entry.dart` — do NOT move it

### PaymentCubit Implementation (Renamed from ResultPaymentCubit)

```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

part 'payment_state.dart';
part 'payment_cubit.freezed.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentState.initial());

  void setList(List<TimeEntry> list) {
    emit(state.copyWith(times: list));
  }

  void setWage(double wageHourly) {
    emit(state.copyWith(wageHourly: wageHourly));
  }
}
```

Changes from original:
- Class: `ResultPaymentCubit` → `PaymentCubit`
- Part directives updated to new filenames
- Import path for `TimeEntry` stays the same (already uses feature-first path from Story 2.2)

### PaymentState Implementation (Renamed from ResultPaymentState)

```dart
part of 'payment_cubit.dart';

@freezed
abstract class PaymentState with _$PaymentState {
  const factory PaymentState({
    @Default([]) List<TimeEntry> times,
    @Default(0.0) double wageHourly,
  }) = _PaymentState;

  factory PaymentState.initial() => const PaymentState();
}
```

Changes from original:
- Class: `ResultPaymentState` → `PaymentState`
- `part of` updated to `'payment_cubit.dart'`
- Generated class: `_ResultPaymentState` → `_PaymentState`

### PaymentCubits Implementation (Renamed from ResultPaymentCubits)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';

class PaymentCubits {
  static List<BlocProvider> list() => [
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(),
        ),
      ];
}
```

Changes from original:
- Class: `ResultPaymentCubits` → `PaymentCubits`
- Import path updated to new location
- `BlocProvider<ResultPaymentCubit>` → `BlocProvider<PaymentCubit>`

### PaymentResultPage Implementation (Renamed from ResultPaymentScreen)

```dart
import 'package:flutter/material.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({
    required this.times,
    required this.wageHourly,
    super.key,
  });

  final List<TimeEntry> times;
  final double wageHourly;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Result Info:'),
      iconPadding: const EdgeInsets.all(7),
      icon: Align(
        alignment: Alignment.topRight,
        child: Card(
          child: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Hours:'),
            subtitle: Text('${times.totalHours}'),
          ),
          ListTile(
            title: const Text('Minutes:'),
            subtitle: Text('${times.totalMinutes}'),
          ),
          ListTile(
            title: const Text('Hourly:'),
            subtitle: Text('$wageHourly Dolars'),
          ),
          ListTile(
            title: const Text('Worked days:'),
            subtitle: Text('${times.length}'),
          ),
          const Divider(),
          Card(
            child: Center(
              child: Text(
                '\$/. ${times.calculatePayment(wageHourly).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
```

Changes from original:
- Class: `ResultPaymentScreen` → `PaymentResultPage`
- Import for `TimeEntry` stays same (already correct path)
- `calculatePayment()` extension still called directly — use case exists as domain abstraction, page behavior unchanged
- `'Dolars'` typo preserved — pre-existing, not this story's scope

### HomePage Implementation (Renamed from ControlHoursPage)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_money/src/core/extensions/screen_size.dart';
import 'package:time_money/src/features/home/presentation/widgets/widgets.dart';
import 'package:time_money/src/features/times/presentation/pages/list_times_screen.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Work Payment Controller',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          const FetchWageScreen(),
          const Expanded(child: ListTimesScreen()),
          SafeArea(
            child: Container(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: .2),
              height: context.getHeight * .13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CalculatePaymentButton(),
                  FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      unawaited(showDialog<void>(
                        context: context,
                        builder: (context) => const CreateTimeCard(),
                      ));
                    },
                    label: const Text(
                      'Add Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
```

Changes from original:
- Class: `ControlHoursPage` → `HomePage`
- Import for `CalculatePaymentButton` changes from `presentation/control_hours/result_payment/` → `features/home/presentation/widgets/widgets.dart` (local barrel)
- All other imports stay (times/wage features already at correct paths)

### CalculatePaymentButton Updated Imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';

class CalculatePaymentButton extends StatelessWidget {
  const CalculatePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) => state,
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state.times.isEmpty
              ? null
              : () {
                  unawaited(showDialog<void>(
                    context: context,
                    builder: (_) => PaymentResultPage(
                      times: state.times,
                      wageHourly: state.wageHourly,
                    ),
                  ));
                },
          label: const Text(
            'Calculate Payment',
          ),
        );
      },
    );
  }
}
```

Changes from original:
- `ResultPaymentCubit` → `PaymentCubit` (import + BlocConsumer type)
- `ResultPaymentState` → `PaymentState` (BlocConsumer type)
- `ResultPaymentScreen` → `PaymentResultPage` (import + constructor)

### Import Boundary Compliance

| Feature | Can Import From | Cannot Import From |
|---------|----------------|-------------------|
| `payment` | `core/`, `shared/`, `times/domain/entities/`, `wage/domain/entities/` | `times/data/`, `times/presentation/`, `wage/data/`, `wage/presentation/`, `home/` |
| `home` | `core/`, `shared/`, all features' `presentation/` | any feature's `data/` or `domain/` directly |
| `times` | `core/`, `shared/` | `wage/`, `payment/`, `home/` |
| `wage` | `core/`, `shared/` | `times/`, `payment/`, `home/` |

**Compliance check after Story 2.4:**
- `PaymentCubit` imports `TimeEntry` from `times/domain/entities/` ✅
- `PaymentResultPage` imports `TimeEntry` from `times/domain/entities/` ✅
- `HomePage` imports from `times/presentation/`, `wage/presentation/`, `home/presentation/widgets/` ✅
- `CalculatePaymentButton` imports from `payment/presentation/` ✅
- `CalculatePaymentUseCase` imports `TimeEntry` from `times/domain/entities/` ✅

**Known remaining violation (see W1):**
- `times/presentation/widgets/list_times_data_view.dart` imports `PaymentCubit` from `payment/presentation/` ✗
- `wage/presentation/widgets/wage_hourly_data_view.dart` imports `PaymentCubit` from `payment/presentation/` ✗

### Exhaustive Import Update Checklist

**Pattern 1: `presentation/control_hours/result_payment/cubit/result_payment_cubit.dart` → `features/payment/presentation/cubit/payment_cubit.dart` (4 files):**

1. `features/times/presentation/widgets/list_times_data_view.dart` — update import + `ResultPaymentCubit` → `PaymentCubit`. Only the cubit import changes; the `presentation/widgets/widgets.dart` import (for `CatchErrorBuilder`) stays unchanged.
2. `features/wage/presentation/widgets/wage_hourly_data_view.dart` — update import + `ResultPaymentCubit` → `PaymentCubit`. Only the cubit import changes; the `presentation/widgets/widgets.dart` import (for `CatchErrorBuilder`) stays unchanged.
3. `calculate_payment_button.dart` (moving file) — update import + all class refs
4. `result_payment_cubits.dart` (moving file) — update import + all class refs

**Pattern 2: `presentation/control_hours/result_payment/result_screen.dart` → `features/payment/presentation/pages/payment_result_page.dart` (1 file):**

1. `calculate_payment_button.dart` (moving file) — update import + `ResultPaymentScreen` → `PaymentResultPage`

**Pattern 3: `presentation/control_hours/result_payment/result_payment_cubits.dart` → `features/payment/presentation/cubit/payment_cubits.dart` (1 file):**

1. `shared/injections/bloc_injections.dart` — update import + `ResultPaymentCubits` → `PaymentCubits`

**Pattern 4: `presentation/control_hours/control_hours_page.dart` → `features/home/presentation/pages/home_page.dart` (1 file):**

1. `app/view/app.dart` — update import + `ControlHoursPage` → `HomePage`

**Pattern 5: `calculate_payment_button.dart` internal import in ControlHoursPage (moving file):**

1. `home_page.dart` (moving file) — replace `presentation/control_hours/result_payment/calculate_payment_button.dart` with `features/home/presentation/widgets/widgets.dart`

### CRITICAL WARNINGS

**W1: Cross-feature dependency `times/wage → payment` is a known remaining violation.**
`list_times_data_view.dart` calls `context.read<PaymentCubit>().setList(times)` and `wage_hourly_data_view.dart` calls `context.read<PaymentCubit>().setWage(wage.value)`. This crosses the import boundary (times/wage should NOT import from payment). This violation exists because the current BLoC pattern uses streams-in-state — the actual data is only available inside `StreamBuilder` callbacks in the data view widgets. The clean resolution requires Epic 3's migration to `emit.forEach` which puts data directly in BLoC states, allowing the home page to compose via `BlocListener`. For Story 2.4: update the import paths to the new `PaymentCubit` location, document as deferred.

**W2: Part file `part of` directive must match new filename.**
`payment_state.dart` must have `part of 'payment_cubit.dart'` (not the old `part of 'result_payment_cubit.dart'`). The cubit file's `part` directives must reference `'payment_state.dart'` and `'payment_cubit.freezed.dart'`. Missing this causes `build_runner` to fail.

**W3: `PaymentState` Freezed generated class suffix changes.**
The generated factory `_ResultPaymentState` → `_PaymentState`. The `= _ResultPaymentState` in the factory constructor must become `= _PaymentState`. This is part of the class rename — Freezed uses the class name to generate the private implementation class.

**W4: `BlocConsumer` listener is no-op in `CalculatePaymentButton`.**
`listener: (context, state) => state` does nothing — pre-existing technical debt from the original code. Do NOT fix — Epic 3 scope.

**W5: `'Dolars'` typo in `PaymentResultPage`.**
The string `'$wageHourly Dolars'` has a typo. Pre-existing, not this story's scope. Will be resolved when localization strings are moved to ARB files.

**W6: `CalculatePaymentUseCase` exists as domain abstraction but is not wired or called yet.**
The use case has no repository dependencies (const-constructible, no DI needed) and satisfies AC #1 by existing in `payment/domain/use_cases/`. The `PaymentResultPage` continues calling the `CalculatePay` extension directly (`times.calculatePayment(wageHourly)`) — behavior unchanged from the original. The architecture's intended flow (use case called before navigation, result passed to page) is an Epic 3 modernization concern, not a restructure concern.

**W7: No test files reference any of the moving files — no test modifications required.**
Verified: no files under `test/` import `result_payment`, `control_hours`, `ResultPaymentCubit`, `ResultPaymentScreen`, or `ControlHoursPage`. The 23 existing tests are in `core/` and don't touch payment/home code.

### Key Differences from Stories 2.2/2.3

| Aspect | Story 2.2/2.3 | Story 2.4 |
|--------|--------------|-----------|
| Feature layers | Data + Domain + Presentation (3 layers) | Payment: Domain + Presentation (2 layers). Home: Presentation only (1 layer) |
| Datasource | New ObjectBox datasource created | No datasources — payment has no persistence |
| Repository | Refactored repository implementation | No repository — payment derives from other features |
| Entity rename | ModelTime → TimeEntry (2.2) | No entity changes |
| ObjectBox service | Modified to remove feature code | No changes |
| Entry points | Updated DI wiring | No changes — no new repos |
| File count | ~35 new files (2.2), ~35 new files (2.3) | ~12 new files (simpler) |

### Barrel Export Contents

**Payment feature barrels:**
```dart
// features/payment/domain/use_cases/use_cases.dart
export 'calculate_payment_use_case.dart';
```
```dart
// features/payment/presentation/cubit/cubit.dart
export 'payment_cubit.dart';
export 'payment_cubits.dart';
// NOTE: Do NOT export payment_state.dart (part file) or payment_cubit.freezed.dart (generated)
```
```dart
// features/payment/presentation/pages/pages.dart
export 'payment_result_page.dart';
```

**Home feature barrels:**
```dart
// features/home/presentation/pages/pages.dart
export 'home_page.dart';
```
```dart
// features/home/presentation/widgets/widgets.dart
export 'calculate_payment_button.dart';
```

### Barrel Export Rules

Same as Stories 2.2/2.3:
- Each subfolder with files gets a barrel: `{folder_name}.dart`
- ONLY re-export source `.dart` files — never `.freezed.dart` or `.g.dart`
- No `library` directive, no logic, no classes
- Pattern: `export 'file_name.dart';`

### Execution Order

**Recommended sequence to minimize broken state:**
1. Create all new folders first (empty)
2. Create `CalculatePaymentUseCase` (new file, no dependencies)
3. Move+rename cubit files (payment_cubit.dart, payment_state.dart)
4. Move+rename payment_cubits.dart
5. Move+rename payment_result_page.dart
6. Move+rename home_page.dart (from control_hours_page.dart)
7. Move+rename calculate_payment_button.dart (to home feature)
8. Apply class renames across all moved files
9. Update all remaining import paths in existing files
10. Create barrel exports
11. Delete old empty folders (`presentation/control_hours/`)
12. Run build_runner
13. Run flutter analyze, fix any issues
14. Run flutter test
15. Run flutter build apk

### Architecture Compliance

Same rules as Stories 2.2/2.3:
- Absolute imports only (`package:time_money/src/...`)
- VGA 10.x import order (dart:, package:, project)
- `const` constructors wherever possible
- Barrel files with re-exports only
- No `.freezed.dart` in barrel files

### Project Structure Notes

- After this story, `features/` contains FOUR features: `times/`, `wage/`, `payment/`, `home/`
- `times/` and `wage/` are full 3-layer features (data/domain/presentation)
- `payment/` is a 2-layer feature (domain/presentation) — no data layer because calculation derives from other features
- `home/` is a 1-layer feature (presentation only) — pure composition shell
- `presentation/` directory still exists with `widgets/` (shared widgets) — moves to `shared/` in Story 2.5
- `shared/injections/` stays structurally unchanged — only import paths and class references update
- DI restructuring to BLoC-native pattern is Story 2.5

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 2, Story 2.4]
- [Source: _bmad-output/planning-artifacts/architecture.md — Section 3: Frontend Architecture, Section 5: Feature Import Boundaries]
- [Source: _bmad-output/planning-artifacts/prd.md — FR33, FR34, FR37]
- [Source: _bmad-output/implementation-artifacts/2-3-wage-feature-feature-first-restructure.md — Story 2.3 learnings]
- [Source: _bmad-output/project-context.md — Rules 1-43]

### Previous Story Intelligence

**From Story 2.3 (most recent):**
- Feature-first restructure pattern fully validated: data/domain/presentation layout with barrel exports works
- Part file `part of` directives: MUST match renamed parent filenames — confirmed in Stories 2.2 and 2.3
- build_runner: 7 outputs in 9s for Story 2.3 — expect fewer since only 1 Freezed class (PaymentState) regenerates
- Zero-issue linting maintained: Stories 2.2 and 2.3 both achieved "No issues found!" — maintain this
- 23 core tests: `failures_test.dart` (12 tests), `action_state_test.dart` (11 tests) — must still pass
- Freezed 3.x with backward-compat config in `build.yaml` — when/map still enabled
- Barrel export pattern: re-exports only, no `.freezed.dart` — confirmed
- Cross-feature dependency acknowledged: Story 2.3 explicitly noted "`wage_hourly_data_view.dart` calls `ResultPaymentCubit.setWage(wage.value)` — this is a known cross-feature dependency. Story 2.4 will properly restructure payment as its own feature."

**From Story 2.3 Code Review (deferred issues relevant to this story):**
- D10: `WageHourlyDataView` cross-feature dependency on `result_payment_cubit` — this story updates the import path but does not remove the dependency (deferred to Epic 3)
- D8: `BlocConsumer` listeners are no-ops — pre-existing, same pattern in `CalculatePaymentButton`

**Pre-Existing Technical Debt (do NOT fix, just be aware):**
- D-1: TextEditingController not synced with bloc state in WageHourlyField (Epic 3)
- D-2: BlocConsumer listener is no-op in multiple widgets (Epic 3)
- D-3: _ActionWidget in FetchWageScreen/ListTimesScreen is dead code placeholder (Epic 3)
- D-4: DeleteTimeBloc `.fold()` result not emitted — CRITICAL LOGIC BUG (Epic 3 Story 3.3)
- D-5: CreateTimeEvent `_Reset` missing handler (Epic 3 Story 3.2)

### Git Intelligence

**Recent Commits:**
```
849124b chore: code review passed for story 2.3
5811bff refactor: restructure wage feature to feature-first clean architecture layout
06e7ffa docs: validate story 2.3
f578c5b docs: create story 2.3
6d1acd8 chore: code review passed for story 2.2
```

**Commit message convention:** `type: description` — use `refactor:` for this story since it's architecture restructuring.

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
