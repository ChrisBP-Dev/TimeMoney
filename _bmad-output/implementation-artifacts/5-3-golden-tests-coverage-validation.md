# Story 5.3: Golden Tests & Coverage Validation

Status: ready-for-dev

## Story

As a developer,
I want golden tests for visual regression proof and validated overall test coverage,
So that the modernization is provably zero-regression visually and the test suite meets quality targets (FR48, FR49).

## Acceptance Criteria

1. **Golden test files in `test/goldens/`** — 4 test files generate 5 golden images: `home_page_with_data.png`, `home_page_empty.png`, `payment_result_page.png`, `create_time_dialog.png`, `update_time_dialog.png`.
2. **Golden baseline workflow** — `flutter test --update-goldens` generates baselines; subsequent `flutter test` matches against them using native `matchesGoldenFile`; no external golden test dependencies (FR48).
3. **Coverage thresholds met** — `flutter test --coverage` reports: use cases 100%, BLoCs/Cubits 100%, repositories 100%, presentation 80%+, overall non-generated code 85%+ (FR49).
4. **Coverage gaps closed** — any layer below target gets additional targeted tests; final report meets all thresholds.
5. **Zero linter warnings, all tests pass** — `flutter analyze` clean (NFR6), zero unused imports/dead code (NFR7), generated files excluded (NFR11), all tests pass with randomized ordering.

## Tasks / Subtasks

### Task 1: Golden Test Helper Infrastructure (AC: 1, 2)

- [ ] 1.1 Add `pumpGoldenApp` method to `test/helpers/pump_app.dart` — wraps widget with full Material 3 theme (`useMaterial3: true`, `colorSchemeSeed: Color.fromARGB(255, 6, 16, 31)`), localization delegates, `debugShowCheckedModeBanner: false`, fixed screen size + `devicePixelRatio=1.0`, with `addTearDown(view.reset)`
- [ ] 1.2 Dartdoc comment on `pumpGoldenApp` following `public_member_api_docs` rule

### Task 2: HomePage Golden Tests (AC: 1, 2)

- [ ] 2.1 `test/goldens/home_page_golden_test.dart` — `home_page_with_data.png`: MultiBlocProvider with MockPaymentCubit(`PaymentReady`), MockListTimesBloc(`ListTimesLoaded`), MockFetchWageBloc(`FetchWageLoaded`); captures full HomePage with populated time entries, wage card, and both FABs (calculate + addTime)
- [ ] 2.2 Same file — `home_page_empty.png`: MockPaymentCubit(`PaymentInitial`), MockListTimesBloc(`ListTimesEmpty`), MockFetchWageBloc(`FetchWageInitial`); captures HomePage with shimmer wage, empty times message, only addTime FAB

### Task 3: Dialog Golden Tests (AC: 1, 2)

- [ ] 3.1 `test/goldens/payment_result_page_golden_test.dart` → `payment_result_page.png`: direct render PaymentResultPage with test PaymentResult data; size 800x1200; pure presentation — no BLoC mocks
- [ ] 3.2 `test/goldens/create_time_dialog_golden_test.dart` → `create_time_dialog.png`: BlocProvider<CreateTimeBloc>.value with MockCreateTimeBloc(`CreateTimeInitial`); size 800x1200
- [ ] 3.3 `test/goldens/update_time_dialog_golden_test.dart` → `update_time_dialog.png`: MultiBlocProvider with MockUpdateTimeBloc(`UpdateTimeInitial(hour: 2, minutes: 30, time: testTime)`) + MockDeleteTimeBloc(`DeleteTimeInitial`); size 800x1200; passes `TimeEntry` via constructor

### Task 4: Generate & Verify Golden Baselines (AC: 2)

- [ ] 4.1 Run `flutter test --update-goldens test/goldens/` to generate baseline PNGs
- [ ] 4.2 Verify all 5 PNG files created in `test/goldens/`
- [ ] 4.3 Run `flutter test test/goldens/` (without `--update-goldens`) to verify comparison passes

### Task 5: Coverage Validation & Gap Closure (AC: 3, 4)

- [ ] 5.1 Run `flutter test --coverage` to generate `coverage/lcov.info`
- [ ] 5.2 Analyze coverage per layer against targets (see Coverage Validation Approach below)
- [ ] 5.3 If any layer below target, write minimal targeted tests to close gaps
- [ ] 5.4 Re-run `flutter test --coverage` and confirm all thresholds met

### Task 6: Final Validation (AC: 5)

- [ ] 6.1 Run `flutter test --test-randomize-ordering-seed random` — all tests pass (existing 321 + new golden + any gap-closure tests)
- [ ] 6.2 Run `flutter analyze` — zero warnings on all files
- [ ] 6.3 Verify dartdoc comments on all new files (`///` file-level docs, `library;` directive, `group`/`test` comments)

## Dev Notes

### Golden Test Architecture

Native Flutter `matchesGoldenFile` — NO external dependencies (`golden_toolkit`, `alchemist`, etc.). The Ahem font (Flutter test default) renders text as rectangular blocks — standard for regression testing. Layout, colors, Material Icons, and spacing all render accurately.

**Golden test lifecycle:**
1. First run: `flutter test --update-goldens` generates baseline PNGs
2. Subsequent runs: `flutter test` compares rendered output against baselines
3. If UI changes are intentional: re-run with `--update-goldens` to update baselines
4. Golden PNGs are committed to git for CI regression checking

### pumpGoldenApp Helper

Add to existing `PumpApp` extension in `test/helpers/pump_app.dart`. Mirrors `pumpApp` but adds the full app theme for golden consistency:

```dart
/// Wraps [widget] inside a themed [MaterialApp] for golden test snapshots.
///
/// Sets a fixed [size] (default 412x892 for mobile viewport) and
/// `devicePixelRatio` of 1.0 for deterministic golden rendering.
/// Includes the full app theme (Material 3, color scheme seed) and
/// `debugShowCheckedModeBanner: false`.
Future<void> pumpGoldenApp(
  Widget widget, {
  Size size = const Size(412, 892),
}) {
  view.physicalSize = size;
  view.devicePixelRatio = 1.0;
  addTearDown(view.reset);

  return pumpWidget(
    BlocProvider<LocaleCubit>(
      create: (_) => LocaleCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 6, 16, 31),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    ),
  );
}
```

**Key differences from `pumpApp`:**
- Includes `ThemeData` with Material 3 and the app's navy blue color scheme seed
- Sets `debugShowCheckedModeBanner: false` (no debug banner in goldens)
- Fixed screen size + pixel ratio for deterministic rendering
- Resets view in tearDown to prevent cross-test contamination

### Golden Test File Pattern

```dart
/// Golden tests for [WidgetName] visual regression verification.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ... widget + state imports

import '../helpers/helpers.dart';

void main() {
  group('WidgetName Golden', () {
    late MockSomeBloc mockBloc;

    setUp(() {
      mockBloc = MockSomeBloc();
      when(() => mockBloc.state).thenReturn(const SomeInitial());
    });

    testWidgets('renders correctly in expected state', (tester) async {
      await tester.pumpGoldenApp(
        BlocProvider<SomeBloc>.value(
          value: mockBloc,
          child: const WidgetUnderTest(),
        ),
      );

      await expectLater(
        find.byType(WidgetUnderTest),
        matchesGoldenFile('golden_file_name.png'),
      );
    });
  });
}
```

### HomePage Golden Test — Mock Setup

**With data state** (`home_page_with_data.png`):
```dart
when(() => mockListTimesBloc.state).thenReturn(
  ListTimesLoaded(times: testTimes),
);
when(() => mockFetchWageBloc.state).thenReturn(
  FetchWageLoaded(wage: const WageHourly(id: 1, value: 15.0)),
);
when(() => mockPaymentCubit.state).thenReturn(
  PaymentReady(times: testTimes, wageHourly: 15.0),
);
```

**Empty state** (`home_page_empty.png`):
```dart
when(() => mockListTimesBloc.state).thenReturn(const ListTimesEmpty());
when(() => mockFetchWageBloc.state).thenReturn(const FetchWageInitial());
when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());
```

**MultiBlocProvider wrapper** — same pattern as existing `home_page_test.dart`:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
    BlocProvider<ListTimesBloc>.value(value: mockListTimesBloc),
    BlocProvider<FetchWageBloc>.value(value: mockFetchWageBloc),
  ],
  child: const HomePage(),
)
```

**Screen size**: Default 412x892 (mobile viewport). No override needed.

**Auto-dispatch on build**: ListTimesPage dispatches `ListTimesRequested` and FetchWagePage dispatches `FetchWageRequested` via `bloc:` parameter on build. MockBlocs handle `add()` silently — no event stubbing needed.

**PaymentCubit side-effects in listeners**: When MockListTimesBloc/MockFetchWageBloc are in loaded states, BlocConsumer listeners call `mockPaymentCubit.setTimes()`/`mockPaymentCubit.setWage()`. These are void methods on MockCubit and are handled silently — no stubbing needed.

### Dialog Golden Test — Setup Details

**Screen size**: Dialogs need larger surface — use `size: const Size(800, 1200)` to prevent AlertDialog column overflow. Learned from Story 5.2.

**Direct rendering**: Render dialog widgets directly via `pumpGoldenApp` — AlertDialog self-centers via its internal `Dialog` widget (uses `Align` + `ConstrainedBox`). No need for the Scaffold+Builder+showDialog pattern used in widget tests.

**PaymentResultPage** — pure presentation, no mocks:
```dart
const testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15.0,
  totalPayment: 157.50,
  workedDays: 3,
);

await tester.pumpGoldenApp(
  const PaymentResultPage(result: testResult),
  size: const Size(800, 1200),
);

await expectLater(
  find.byType(PaymentResultPage),
  matchesGoldenFile('payment_result_page.png'),
);
```

**CreateTimePage** — needs MockCreateTimeBloc:
```dart
when(() => mockCreateTimeBloc.state).thenReturn(const CreateTimeInitial());

await tester.pumpGoldenApp(
  BlocProvider<CreateTimeBloc>.value(
    value: mockCreateTimeBloc,
    child: const CreateTimePage(),
  ),
  size: const Size(800, 1200),
);
```

**UpdateTimePage** — needs MockUpdateTimeBloc + MockDeleteTimeBloc:
```dart
const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);

when(() => mockUpdateBloc.state).thenReturn(
  const UpdateTimeInitial(hour: 2, minutes: 30, time: testTime),
);
when(() => mockDeleteBloc.state).thenReturn(const DeleteTimeInitial());

await tester.pumpGoldenApp(
  MultiBlocProvider(
    providers: [
      BlocProvider<UpdateTimeBloc>.value(value: mockUpdateBloc),
      BlocProvider<DeleteTimeBloc>.value(value: mockDeleteBloc),
    ],
    child: const UpdateTimePage(time: testTime),
  ),
  size: const Size(800, 1200),
);
```

### matchesGoldenFile Path Resolution

`matchesGoldenFile('filename.png')` resolves RELATIVE to the test file. Since test files are in `test/goldens/`, the PNG files are generated in `test/goldens/`:

```
test/goldens/
├── home_page_golden_test.dart         (test file)
├── payment_result_page_golden_test.dart
├── create_time_dialog_golden_test.dart
├── update_time_dialog_golden_test.dart
├── home_page_with_data.png            (generated baseline)
├── home_page_empty.png                (generated baseline)
├── payment_result_page.png            (generated baseline)
├── create_time_dialog.png             (generated baseline)
└── update_time_dialog.png             (generated baseline)
```

### Coverage Validation Approach

**Step 1: Generate coverage**
```bash
flutter test --coverage
# Output: coverage/lcov.info
```

**Step 2: Analyze per-layer** — read `coverage/lcov.info` and compute coverage by source path:

| Layer | Path Pattern | Target |
|-------|-------------|--------|
| Use Cases | `lib/src/features/*/domain/use_cases/*` | 100% |
| BLoCs/Cubits | `lib/src/features/*/presentation/bloc/*` + `*/cubit/*` | 100% |
| Repository Impls | `lib/src/features/*/data/repositories/*` | 100% |
| Presentation | `lib/src/features/*/presentation/{pages,widgets}/*` | 80%+ |
| Overall | All `lib/src/` excluding `*.g.dart`, `*.freezed.dart` | 85%+ |

**lcov.info format** — each source file block:
```
SF:<file_path>
DA:<line_number>,<execution_count>
...
LF:<total_lines>
LH:<hit_lines>
end_of_record
```
Coverage per file = `LH / LF * 100`. Aggregate per layer by summing LF and LH across matching files.

**Step 3: Gap closure** — if any layer below target:
- Identify specific uncovered lines from `DA:<line>,0` entries
- Write minimal targeted tests for uncovered code paths
- Do NOT write redundant tests for already-covered code

**Step 4: Validate** — re-run `flutter test --coverage` and confirm all thresholds met

### Test Fixture Data (Shared Across Golden Tests)

```dart
const testTimes = [
  TimeEntry(id: 1, hour: 5, minutes: 15),
  TimeEntry(id: 2, hour: 3, minutes: 45),
  TimeEntry(id: 3, hour: 1, minutes: 30),
];

const testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15.0,
  totalPayment: 157.50,
  workedDays: 3,
);

const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
```

### No New Mock Classes Needed

All required BLoC/Cubit mocks already exist in `test/helpers/mocks.dart`:
- `MockPaymentCubit` — HomePage golden tests
- `MockListTimesBloc` — HomePage golden tests
- `MockFetchWageBloc` — HomePage golden tests
- `MockCreateTimeBloc` — CreateTimePage golden test
- `MockUpdateTimeBloc` — UpdateTimePage golden test
- `MockDeleteTimeBloc` — UpdateTimePage golden test

### Required Import Paths

```dart
// Golden test standard imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Widgets under test
import 'package:time_money/src/features/home/presentation/pages/home_page.dart';
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';
import 'package:time_money/src/features/times/presentation/pages/create_time_page.dart';
import 'package:time_money/src/features/times/presentation/pages/update_time_page.dart';

// BLoC states for mock setup
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';

// Domain entities for test data
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';

// Test helpers (relative — from test/goldens/ to test/helpers/)
import '../helpers/helpers.dart';
```

### Test File Count

- Golden test files: 4 new (home_page, payment_result_page, create_time_dialog, update_time_dialog)
- Golden image files: 5 generated PNGs (committed to git)
- Modified files: 1 (`test/helpers/pump_app.dart` — add `pumpGoldenApp`)
- Gap-closure test files: 0-? (depends on coverage analysis in Task 5)
- **Total new test files: 4 + gap-closure**

### Existing Test Infrastructure (Reuse)

- `test/helpers/mocks.dart` — all needed mocks present (no additions)
- `test/helpers/pump_app.dart` — add `pumpGoldenApp` method (Task 1)
- `test/helpers/helpers.dart` — barrel export, no changes needed
- Existing test count: 321 tests (must NOT regress)

### Recommended Execution Order

1. **Task 1** — pumpGoldenApp infrastructure (required by all golden tests)
2. **Task 2** — HomePage golden tests (most complex: 3 mock BLoCs, 2 states)
3. **Task 3** — Dialog golden tests (simpler: 0-2 mocks each)
4. **Task 4** — Generate and verify baselines (validates Tasks 2-3)
5. **Task 5** — Coverage analysis and gap closure
6. **Task 6** — Final validation

### Project Structure Notes

- Golden test files: `test/goldens/*.dart` (new directory)
- Golden images: `test/goldens/*.png` (generated, committed to git)
- Helper modification: `test/helpers/pump_app.dart` (add method to existing extension)
- Architecture alignment: matches `test/goldens/` in architecture.md project structure tree

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.3] — acceptance criteria and BDD specs
- [Source: _bmad-output/planning-artifacts/architecture.md#Testing] — golden test strategy, coverage targets per layer, project structure tree
- [Source: _bmad-output/planning-artifacts/prd.md#FR48] — golden tests for zero visual regression
- [Source: _bmad-output/planning-artifacts/prd.md#FR49] — all tests runnable with coverage reporting
- [Source: _bmad-output/project-context.md#Testing Rules] — test framework, patterns, documentation standard
- [Source: _bmad-output/project-context.md#Code Quality] — public_member_api_docs, zero warnings policy
- [Source: _bmad-output/implementation-artifacts/5-2-home-payment-shared-widget-tests.md] — Story 5.2 patterns: dialog overflow fix (800x1200), MockPaymentCubit setup, pumpAndSettle safety, locale toggle, PaymentCubit listener behavior
- [Source: _bmad-output/implementation-artifacts/5-1-times-wage-feature-widget-tests.md] — Story 5.1 patterns: MockBloc infrastructure, state-driven button testing, dialog provider scope, BlocConsumer stream handling
- [Source: test/helpers/pump_app.dart] — existing PumpApp extension (to be extended with pumpGoldenApp)
- [Source: test/helpers/mocks.dart] — all required MockBloc/MockCubit classes present
- [Source: lib/src/features/home/presentation/pages/home_page.dart] — HomePage: Scaffold with AppBar, FetchWagePage + ListTimesPage composition, conditional CalculatePaymentButton, addTime FAB, _LocaleToggle
- [Source: lib/src/features/payment/presentation/pages/payment_result_page.dart] — pure AlertDialog: 4 ListTiles, totalPayment Card, close/save buttons
- [Source: lib/src/features/times/presentation/pages/create_time_page.dart] — AlertDialog with CreateTimeCard form, close button
- [Source: lib/src/features/times/presentation/pages/update_time_page.dart] — AlertDialog with UpdateTimeCard + DeleteTimeButton/UpdateTimeButton actions
- [Source: lib/app/view/app.dart] — App theme: Material 3, colorSchemeSeed `Color.fromARGB(255, 6, 16, 31)`

### Previous Story Intelligence (Stories 5.1 & 5.2)

- **Dialogs need enlarged test surface (800x1200)** — AlertDialog column overflow in default 600px (Story 5.2 debug log)
- **pumpAndSettle IS safe for pure dialogs** — PaymentResultPage has no BLoC streams; use `pump()` only for BlocConsumer-based widgets (Story 5.1 debug log)
- **MockBlocs handle `add()` silently** — ListTimesPage/FetchWagePage auto-dispatch on build doesn't cause issues
- **Locale toggle uses real LocaleCubit from pumpApp** — no mocking needed
- **PaymentCubit void methods on MockCubit handled silently** — setTimes/setWage in BlocConsumer listeners don't need stubbing
- **Story spec import depths can be wrong** — Story 5.2 debug log noted incorrect relative import depths; verify actual depths match directory structure
- **verify event payloads with captureAny** — use captureAny pattern for event verification (Story 5.1 code review)
- **Stub state BEFORE pumping** — UpdateTimeBloc states with time field must be stubbed before pumpApp call

### Git Intelligence

Recent commits:
- `2dce255` — Story 5.2 code review: 1 bad_spec, 5 patches applied, status done
- `6ced1a9` — Story 5.2 implemented: 43 new widget tests
- `9aa75ad` — Story 5.2 validated
- `ad67928` — Story 5.2 created
- `ea98d0b` — D1 resolved: wage 0.0 boundary tests added

The codebase has 321 passing tests, zero linter warnings, and mature widget test infrastructure established in Stories 5.1-5.2 that golden tests directly build upon. All mock classes needed for golden tests already exist.

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
