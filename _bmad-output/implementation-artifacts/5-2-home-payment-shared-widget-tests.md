# Story 5.2: Home, Payment & Shared Widget Tests

Status: done

## Story

As a developer,
I want comprehensive widget tests for the home page composition, payment feature, and shared widgets,
So that the cross-feature composition layer and reusable components are verified automatically (FR47).

## Acceptance Criteria

1. **HomePage widget test** — `test/src/features/home/presentation/pages/home_page_test.dart` verifies structural composition of FetchWagePage, ListTimesPage, action bar with addTime FAB, conditional CalculatePaymentButton rendering on PaymentReady, and locale toggle behavior.
2. **CalculatePaymentButton widget test** — `test/src/features/home/presentation/widgets/calculate_payment_button_test.dart` verifies FAB rendering, disabled on PaymentInitial, enabled on PaymentReady, tap calls `calculate()` on PaymentCubit, Right result opens PaymentResultPage dialog.
3. **PaymentResultPage widget test** — `test/src/features/payment/presentation/pages/payment_result_page_test.dart` verifies AlertDialog with 4 ListTile data fields (hours, minutes, hourly, workedDays), totalPayment as bold 28px Text inside Card (NOT a ListTile), formatted with currency prefix, close icon button pops, save button pops.
4. **ErrorView widget test** — `test/src/shared/widgets/error_view_test.dart` verifies all 4 GlobalFailure subtypes map to correct ShowInfoSection with appropriate icon and message; actionWidget passed through.
5. **ShowInfoSection widget test** — `test/src/shared/widgets/info_section_test.dart` verifies centered message rendering, optional image above message, optional action below message, null-safe for optional params.
6. **IconText and CatchErrorBuilder widget tests** — `test/src/shared/widgets/icon_text_test.dart` and `test/src/shared/widgets/catch_error_builder_test.dart` verify icon rendering with default/custom fontSize and all AsyncSnapshot state branches respectively.
7. **All widget tests pass** — `flutter test` runs clean with zero failures (existing 278 + new).
8. **Zero linter warnings** — `flutter analyze` remains clean on all new test files.

## Tasks / Subtasks

### Task 1: Shared Widget Tests — Pure Presentation (AC: 5, 6)

- [x] 1.1 `test/src/shared/widgets/icon_text_test.dart` — renders text content inside FittedBox; default fontSize creates 60x60 SizedBox; custom fontSize creates matching SizedBox; uses TextScaler.noScaling
- [x] 1.2 `test/src/shared/widgets/info_section_test.dart` — renders infoMessage text centered; renders infoImage when provided (with bottom 32px padding); hides image area when null; renders actionWidget when provided (inside 60-height SizedBox); hides action area when null; renders 2 Spacers when actionWidget is null, 3 Spacers when actionWidget is provided (third Spacer below action)
- [x] 1.3 `test/src/shared/widgets/catch_error_builder_test.dart` — snapshot.hasError → custom error widget or default "Something went wrong" text; snapshot.waiting → custom loading widget or default CircularProgressIndicator.adaptive; snapshot.hasData → calls builder(data); no data/not waiting/no error → custom loading widget or fallback "error" text

### Task 2: Shared Widget Tests — ErrorView (AC: 4)

- [x] 2.1 `test/src/shared/widgets/error_view_test.dart` — InternalError renders IconText('⚠️') + ShowInfoSection with message containing error string; TimeOutExceeded renders IconText('⏳') + timeout message; ServerError renders IconText('🚨') + server error message; NotConnection renders IconText('📡') + connection message; actionWidget renders when non-null; actionWidget absent when null. Note: error messages are hardcoded Spanish text (NOT localized) — verify via `tester.widget<ShowInfoSection>()` field inspection

### Task 3: Payment Feature — PaymentResultPage (AC: 3)

- [x] 3.1 `test/src/features/payment/presentation/pages/payment_result_page_test.dart` — renders AlertDialog with localized title (`resultInfoTitle`); renders 4 ListTile entries (totalHours, totalMinutes, wageHourly with dollarsLabel, workedDays); totalPayment rendered as bold 28px Text inside Card (NOT a ListTile), formatted as `${currencyPrefix}${totalPayment.toStringAsFixed(2)}`; Divider separates ListTiles from totalPayment Card; close IconButton (Icons.cancel) pops dialog; save FilledButton pops dialog. Pure presentation — no BLoC mocks needed, receives `PaymentResult` via constructor

### Task 4: Home Feature — CalculatePaymentButton (AC: 2)

- [x] 4.1 `test/src/features/home/presentation/widgets/calculate_payment_button_test.dart` — renders FloatingActionButton.extended with localized `calculatePayment` label; onPressed is null when PaymentInitial (disabled); onPressed is non-null when PaymentReady (enabled); tap calls `mockPaymentCubit.calculate()`; on Right(PaymentResult) → showDialog opens PaymentResultPage (verify find.byType(PaymentResultPage) after pumpAndSettle); on Left(GlobalFailure) → no dialog opens. Needs MockPaymentCubit with stubbed `state` and `calculate()`

### Task 5: Home Feature — HomePage Composition (AC: 1)

- [x] 5.1 `test/src/features/home/presentation/pages/home_page_test.dart` — renders Scaffold with AppBar showing localized homeTitle; renders FetchWagePage (find.byType); renders ListTimesPage (find.byType); renders addTime FAB (verify renders, do NOT tap — triggers CreateTimeCard dialog needing CreateTimeBloc not in scope); hides CalculatePaymentButton when PaymentInitial; shows CalculatePaymentButton when PaymentReady (use whenListen to transition); locale toggle OutlinedButton renders in AppBar actions showing next locale code; locale toggle tap cycles locale (verify button text changes from "ES" to "EN" after tap). Needs MultiBlocProvider with MockPaymentCubit, MockListTimesBloc, MockFetchWageBloc (all in initial/loading states to avoid deep widget tree dependencies)

### Task 6: Final Validation (AC: 7, 8)

- [x] 6.1 Run `flutter test --test-randomize-ordering-seed random` — all tests pass (existing 278 + new)
- [x] 6.2 Run `flutter analyze` — zero warnings on all files
- [x] 6.3 Verify dartdoc comments on all new test files (`///` file-level docs, `library;` directive, group/test comments)

## Dev Notes

### No New Mock Classes Needed

All required BLoC/Cubit mocks already exist in `test/helpers/mocks.dart`:
- `MockPaymentCubit` — for CalculatePaymentButton and HomePage tests
- `MockListTimesBloc` — for HomePage (ListTimesPage dispatches on build)
- `MockFetchWageBloc` — for HomePage (FetchWagePage dispatches on build)

`LocaleCubit` is provided by `pumpApp` as a real instance — do NOT mock it. The locale toggle test works by observing behavior changes (button text cycles) rather than verifying method calls.

### Widget Test Architecture (Continuation from Story 5.1)

Same patterns apply:
```dart
// MockCubit for PaymentCubit
late MockPaymentCubit mockPaymentCubit;
setUp(() {
  mockPaymentCubit = MockPaymentCubit();
  when(() => mockPaymentCubit.state).thenReturn(const PaymentInitial());
});

// Provide via BlocProvider.value
await tester.pumpApp(
  BlocProvider<PaymentCubit>.value(
    value: mockPaymentCubit,
    child: const CalculatePaymentButton(),
  ),
);
```

### HomePage MultiBlocProvider Pattern

HomePage composes multiple child pages that read BLoCs on build. Provide all needed mocks:
```dart
await tester.pumpApp(
  MultiBlocProvider(
    providers: [
      BlocProvider<PaymentCubit>.value(value: mockPaymentCubit),
      BlocProvider<ListTimesBloc>.value(value: mockListTimesBloc),
      BlocProvider<FetchWageBloc>.value(value: mockFetchWageBloc),
    ],
    child: const HomePage(),
  ),
);
```

**Child page behavior on build:**
- `ListTimesPage` dispatches `ListTimesRequested` via `bloc:` parameter — MockListTimesBloc handles `add()` silently
- `FetchWagePage` dispatches `FetchWageRequested` via `bloc:` parameter — MockFetchWageBloc handles `add()` silently
- Both show shimmer/loading views when in Initial state — no deep widget tree dependencies
- `context.getHeight * .13` in HomePage depends on `MediaQuery.of(context).size.height` — test environment defaults to 600px, action bar will be 78px height. No layout overflow expected

**PaymentReady conditional rendering:** To test CalculatePaymentButton appearing, use `whenListen` (from `bloc_test`) to transition from PaymentInitial to PaymentReady, then `pump()`:
```dart
whenListen(
  mockPaymentCubit,
  Stream.value(PaymentReady(times: testTimes, wageHourly: 15.0)),
  initialState: const PaymentInitial(),
);
await tester.pumpApp(buildSubject());
await tester.pump(); // process stream → PaymentReady
expect(find.byType(CalculatePaymentButton), findsOneWidget);
```

**Listener side-effects in loaded states:** When MockListTimesBloc or MockFetchWageBloc emit loaded states (via `whenListen`), the BlocConsumer listeners in `ListTimesPage` and `FetchWagePage` will call `mockPaymentCubit.setTimes()` and `mockPaymentCubit.setWage()`. These are void methods on MockCubit and are handled silently — no stubbing needed, but be aware if using `verifyNever` assertions.

### CalculatePaymentButton — Stubbing calculate()

`PaymentCubit.calculate()` returns synchronous `Either<GlobalFailure, PaymentResult>` (not Future). Stub on MockPaymentCubit:
```dart
// For Right path (success → dialog opens)
when(() => mockPaymentCubit.calculate()).thenReturn(
  right(const PaymentResult(
    totalHours: 10,
    totalMinutes: 30,
    wageHourly: 15.0,
    totalPayment: 157.50,
    workedDays: 3,
  )),
);

// For Left path (failure → no dialog)
when(() => mockPaymentCubit.calculate()).thenReturn(
  left(const InternalError('test error')),
);
```

**Dialog renders without BLoC mocks:** PaymentResultPage is pure presentation — only needs `context.l10n` (provided by MaterialApp localization from pumpApp). The dialog opens in Navigator overlay but inherits localization delegates. No provider scope issue here (unlike Story 5.1 BLoC-dependent dialogs).

**After tap, use `pumpAndSettle()`** to process dialog route and animation. This is safe because CalculatePaymentButton's BlocBuilder uses MockCubit (no infinite stream) and the dialog is pure.

### PaymentResultPage — Pure Presentation Testing

No BLoC providers needed. Pass `PaymentResult` directly:
```dart
const testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15.0,
  totalPayment: 157.50,
  workedDays: 3,
);

await tester.pumpApp(const PaymentResultPage(result: testResult));
```

**Localized strings:** Title and labels use `context.l10n.resultInfoTitle`, `context.l10n.hoursLabel`, etc. Use `find.byType(ListTile)` and `tester.widget<ListTile>()` to inspect subtitle text data. Data values (`${result.totalHours}`, `${result.wageHourly}`, etc.) are interpolated — verify via `find.textContaining('10')`, `find.textContaining('15.0')`, etc.

**Pop verification pattern (same as Story 5.1):**
```dart
await tester.pumpApp(
  Scaffold(
    body: Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const PaymentResultPage(result: testResult),
        ),
        child: const Text('open'),
      );
    }),
  ),
);
await tester.tap(find.text('open'));
await tester.pumpAndSettle();
// Now test close/save buttons pop
await tester.tap(find.byIcon(Icons.cancel));
await tester.pumpAndSettle();
expect(find.byType(PaymentResultPage), findsNothing);
```

### ErrorView — Pattern-Matched Failure Subtypes

ErrorView uses Dart 3 switch expression on `GlobalFailure` sealed class. Test each subtype:

| Failure Subtype | Icon | Message Contains |
|----------------|------|-----------------|
| `InternalError('test error')` | `IconText('⚠️')` | "Hubo un error interno" + "test error" |
| `TimeOutExceeded()` | `IconText('⏳')` | "Se agotó el tiempo de espera" |
| `ServerError('500')` | `IconText('🚨')` | "Hubo un error en el servidor" |
| `NotConnection()` | `IconText('📡')` | "Hubo un problema de conexión." (trailing period) |

**Verification approach:** Use `tester.widget<ShowInfoSection>()` to read `infoMessage` field and `tester.widget<IconText>()` to verify `iconText` field. Error messages are hardcoded Spanish — NOT localized, safe to assert specific strings. Use `contains` assertions, NOT exact equality.

**InternalError multiline format:** The `infoMessage` is a triple-quoted multiline string literal with leading newline, message text, space-prefixed error value, and trailing newline. Example for `InternalError('test error')`: `'\nHubo un error interno, por favor asegurese de tener la última versión de la App.\n test error\n'`. Use `contains('Hubo un error interno')` and `contains('test error')` rather than exact match.

**actionWidget passthrough:** Test with both `actionWidget: ElevatedButton(...)` (verify present) and `actionWidget: null` (verify absent).

### CatchErrorBuilder — AsyncSnapshot State Branches

Create AsyncSnapshot instances for each branch:
```dart
// Error state
const errorSnapshot = AsyncSnapshot<String>.withError(
  ConnectionState.done, 'test error',
);

// Waiting state
const waitingSnapshot = AsyncSnapshot<String>.waiting();

// Data state
const dataSnapshot = AsyncSnapshot<String>.withData(
  ConnectionState.done, 'test data',
);

// No data, not waiting, no error (initial/none)
const nothingSnapshot = AsyncSnapshot<String>.nothing();
```

Test both with custom widgets provided and with defaults (null parameters).

**Behavioral asymmetry:** In the waiting branch, if `loading` is provided it's returned directly (no wrapper). In the fallback branch (no data/not waiting/no error), the `loading` widget is wrapped in `Center(child: loading)`. The default `_Loading` widget has its own `Center` wrapper internally. To assert this difference, use `find.ancestor(of: find.byType(CustomWidget), matching: find.byType(Center))` — it will find a Center ancestor in the fallback branch but NOT in the waiting branch when a custom loading is provided.

### Locale Toggle Testing (Inside HomePage)

`_LocaleToggle` is private — tested via HomePage integration. Real `LocaleCubit` from pumpApp works.

**`AppLocalizations.supportedLocales` order:** `[Locale('en'), Locale('es')]` — English first, Spanish second. This order drives the cycling logic below.

1. Initial state: `LocaleSystem()` → `Localizations.localeOf(context)` returns 'en' (test default) → currentIndex=0, nextIndex=1 → button shows "ES"
2. Tap → `setLocale(Locale('es'))` → state becomes `LocaleSelected(Locale('es'))` → currentIndex=1, nextIndex=0 → button shows "EN"
3. Verify text change via `find.text('ES')` before tap, `find.text('EN')` after tap

**Note:** pumpApp's MaterialApp does NOT listen to LocaleCubit for locale switching (no `locale:` parameter). The toggle's `BlocBuilder` rebuilds correctly based on cubit state, but `context.l10n` locale doesn't change. Test verifies the toggle cycling logic, not full app locale switch.

### Dialog Provider Scope — No Issue for This Story

Unlike Story 5.1, the dialogs in this story (PaymentResultPage) are **pure presentation** with no BLoC dependencies. They only need `context.l10n` (inherited from MaterialApp localization). The Navigator overlay dialog context CAN access localization delegates. No provider scope workaround needed.

For the addTime button in HomePage (opens CreateTimeCard dialog): **do NOT tap the addTime button in HomePage tests** — tapping triggers `showDialog(builder: (_) => CreateTimeCard())` which requires `CreateTimeBloc` from context. Since no `MockCreateTimeBloc` is provided in the MultiBlocProvider setup (and the dialog context in the Navigator overlay can't find it anyway), tapping will throw `ProviderNotFoundException`. CreateTimeCard dialogs are already tested in Story 5.1.

**Disambiguating addTime FAB from CalculatePaymentButton:** When `PaymentReady`, the action bar contains **two** `FloatingActionButton.extended` widgets. Do NOT use `find.byType(FloatingActionButton)` alone — it matches both. Instead use `find.widgetWithText(FloatingActionButton, addTimeLabel)` or locate by localized text: `find.text(l10n.addTime)`. For the initial-state test (only addTime visible), `find.byType(FloatingActionButton)` is safe (only one FAB present).

### registerFallbackValue for Widget Tests

For tests that use `verify(() => mockCubit.calculate())` or `verify(() => mockCubit.setTimes(any()))`:
```dart
setUpAll(() {
  registerFallbackValue(const PaymentResult(
    totalHours: 0, totalMinutes: 0, wageHourly: 0,
    totalPayment: 0, workedDays: 0,
  ));
  registerFallbackValue(<TimeEntry>[]);
});
```

### Test Fixture Data

```dart
const testResult = PaymentResult(
  totalHours: 10,
  totalMinutes: 30,
  wageHourly: 15.0,
  totalPayment: 157.50,
  workedDays: 3,
);

const testTimes = [
  TimeEntry(id: 1, hour: 5, minutes: 15),
  TimeEntry(id: 2, hour: 3, minutes: 45),
  TimeEntry(id: 3, hour: 1, minutes: 30),
];

const testFailure = InternalError('test error');

// PaymentReady state for mock stubbing (requires times + wageHourly)
final testPaymentReady = PaymentReady(
  times: testTimes,
  wageHourly: 15.0,
);
```

### Test File Count

- Shared widgets (Task 1 + Task 2): 4 test files (IconText, ShowInfoSection, CatchErrorBuilder, ErrorView)
- Payment page (Task 3): 1 test file (PaymentResultPage)
- Home widgets (Task 4): 1 test file (CalculatePaymentButton)
- Home pages (Task 5): 1 test file (HomePage)
- **Total: 7 new test files**

### Existing Test Infrastructure (Reuse)

- `test/helpers/mocks.dart` — all needed mocks already present (no additions required)
- `test/helpers/pump_app.dart` — use `tester.pumpApp(widget)` for all widget tests
- `test/helpers/helpers.dart` — barrel export, no changes needed
- Existing test count: 278 tests (must NOT regress)

### Required Import Paths

```dart
// Payment feature
import 'package:time_money/src/features/payment/presentation/pages/payment_result_page.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';

// Home feature
import 'package:time_money/src/features/home/presentation/pages/home_page.dart';
import 'package:time_money/src/features/home/presentation/widgets/calculate_payment_button.dart';

// Shared widgets
import 'package:time_money/src/shared/widgets/error_view.dart';
import 'package:time_money/src/shared/widgets/info_section.dart';
import 'package:time_money/src/shared/widgets/icon_text.dart';
import 'package:time_money/src/shared/widgets/catch_error_builder.dart';

// Domain/Core
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';

// Testing
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

// Test helpers (relative — adjust depth per test file location)
// Shared widgets (4 levels): import '../../../../helpers/helpers.dart';
// Home/Payment pages (6 levels): import '../../../../../../helpers/helpers.dart';
// Home widgets (6 levels): import '../../../../../../helpers/helpers.dart';
```

### Recommended Execution Order

Execute tasks by complexity to reduce debugging time:
1. **Task 1** — Pure shared widgets (no mocks, simplest)
2. **Task 2** — ErrorView (no BLoC mocks, tests sealed class pattern matching)
3. **Task 3** — PaymentResultPage (pure presentation, no BLoC mocks)
4. **Task 4** — CalculatePaymentButton (MockPaymentCubit, calculate() stub)
5. **Task 5** — HomePage (most complex: MultiBlocProvider, composition, locale toggle)
6. **Task 6** — Final validation run

### Project Structure Notes

- Widget test files mirror source path: `lib/src/shared/widgets/error_view.dart` → `test/src/shared/widgets/error_view_test.dart`
- Home tests: `lib/src/features/home/presentation/pages/` → `test/src/features/home/presentation/pages/`
- Payment page tests: `lib/src/features/payment/presentation/pages/` → `test/src/features/payment/presentation/pages/`
- No barrel files needed for test directories

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.2] — acceptance criteria and BDD specs
- [Source: _bmad-output/project-context.md#Testing Rules] — test framework, patterns, documentation standard
- [Source: _bmad-output/project-context.md#Flutter & BLoC Framework Rules] — PaymentCubit, 4-state pattern
- [Source: _bmad-output/implementation-artifacts/5-1-times-wage-feature-widget-tests.md] — Story 5.1 widget test patterns, BLoC mock infrastructure, dialog scope learnings
- [Source: test/helpers/pump_app.dart] — PumpApp extension providing LocaleCubit + MaterialApp + l10n
- [Source: test/helpers/mocks.dart] — all required MockBloc/MockCubit classes already present
- [Source: lib/src/features/home/presentation/pages/home_page.dart] — HomePage source with composition, _LocaleToggle, conditional rendering
- [Source: lib/src/features/home/presentation/widgets/calculate_payment_button.dart] — FAB with PaymentCubit.calculate() fold
- [Source: lib/src/features/payment/presentation/pages/payment_result_page.dart] — pure AlertDialog with PaymentResult data
- [Source: lib/src/shared/widgets/error_view.dart] — switch expression on GlobalFailure sealed class
- [Source: lib/src/shared/widgets/info_section.dart] — image-message-action layout
- [Source: lib/src/shared/widgets/icon_text.dart] — emoji icon with FittedBox scaling
- [Source: lib/src/shared/widgets/catch_error_builder.dart] — generic AsyncSnapshot handler

### Previous Story Intelligence (Story 5.1)

Key learnings not covered elsewhere in this story:
- **Story 5.1 code review learnings**: verify event payloads with captureAny, test pop-on-success via dialog wrapper pattern, always stub state BEFORE pumping
- **pumpAndSettle IS safe** in this story — PaymentResultPage dialogs are pure (no BlocConsumer streams), unlike Story 5.1 BLoC-dependent dialogs

### Git Intelligence

Recent commits show:
- `ea98d0b` — D1 resolved: wage 0.0 boundary tests added
- `52f3779` — Story 5.1 code review: 14 patches, 2 bad_spec amended
- `89ff912` — Story 5.1 implemented: 96 new widget tests for times & wage
- `72a7617` — Story 5.1 validated: 8 critical gaps fixed
- `f2f4845` — Story 5.1 created

The codebase has 278 passing tests, zero linter warnings, and a mature widget test infrastructure established in Story 5.1 that this story directly builds upon.

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- PaymentResultPage required increased test surface (800x1200) to avoid AlertDialog column overflow in default 600px height
- Story spec had incorrect relative import depths (stated 4 levels for shared widgets, actual is 3)

### Completion Notes List

- Task 1 (AC 5, 6): Implemented 3 shared widget test files — IconText (4 tests), ShowInfoSection (6 tests), CatchErrorBuilder (7 tests)
- Task 2 (AC 4): ErrorView test file with all 4 GlobalFailure subtypes verified (6 tests) — used field inspection on ShowInfoSection/IconText
- Task 3 (AC 3): PaymentResultPage pure presentation tests (6 tests) — dialog wrapper pattern for pop verification, enlarged test surface
- Task 4 (AC 2): CalculatePaymentButton tests (6 tests) — MockPaymentCubit with calculate() stub, Right/Left fold paths verified
- Task 5 (AC 1): HomePage composition tests (8 tests) — MultiBlocProvider with 3 mocks, whenListen for PaymentReady transition, locale toggle cycling
- Task 6 (AC 7, 8): Full suite 321 tests (278 existing + 43 new), zero linter warnings, all dartdoc/library directives present
- Total new tests: 43 across 7 test files

### Code Review Record

- **Reviewer model:** Claude Opus 4.6 (1M context)
- **Review method:** 3-layer adversarial (Blind Hunter, Edge Case Hunter, Acceptance Auditor)
- **Findings raised:** 27 total
- **Triage result:** 1 bad_spec, 5 patch, 1 defer, 20 reject
- **Bad Spec (BS-1):** Dev notes recommended `find.textContaining` assertion strategy which fails for ambiguous values like '3'. **Amended:** replaced with direct `ListTile` subtitle field inspection.
- **Patches applied (5):**
  - P-1: `home_page_test.dart` — added localized `homeTitle` text assertion ("Work Payment Controller")
  - P-2: `payment_result_page_test.dart` — added localized `resultInfoTitle` text assertion ("Result Info:")
  - P-3: `payment_result_page_test.dart` — added currency prefix verification (`$/. 157.50`)
  - P-4: `payment_result_page_test.dart` — added negative assertion: totalPayment NOT inside ListTile
  - P-5: `calculate_payment_button_test.dart` — added `verify(calculate()).called(1)` on Left path
- **Deferred (D-1):** `_LocaleToggle` unsupported-system-locale branch (`indexWhere` returns -1) untested — pre-existing, out of story scope
- **Post-CR validation:** 321 tests pass, zero linter warnings

### Change Log

- 2026-03-20: Implemented story 5.2 — 7 new test files, 43 widget tests for home, payment, and shared widgets
- 2026-03-20: Code review story 5.2 — CR record, 1 bad_spec amended, 5 patches applied, status done

### File List

- test/src/shared/widgets/icon_text_test.dart (new)
- test/src/shared/widgets/info_section_test.dart (new)
- test/src/shared/widgets/catch_error_builder_test.dart (new)
- test/src/shared/widgets/error_view_test.dart (new)
- test/src/features/payment/presentation/pages/payment_result_page_test.dart (new)
- test/src/features/home/presentation/widgets/calculate_payment_button_test.dart (new)
- test/src/features/home/presentation/pages/home_page_test.dart (new)
