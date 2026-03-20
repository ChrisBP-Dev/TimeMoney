# Story 5.1: Times & Wage Feature Widget Tests

Status: review

## Story

As a developer,
I want comprehensive widget tests for the times and wage feature presentation layers,
So that UI rendering, user interactions, and state-driven display are verified for the two core data features (FR47).

## Acceptance Criteria

1. **Times feature widget tests** — `test/src/features/times/presentation/widgets/` contains tests for all times widgets: TimeCard, InfoTime, EditButton, CreateTimeCard, CreateHourField, CreateMinutesField, CreateTimeButton, UpdateTimeCard, UpdateHourField, UpdateMinutesField, UpdateTimeButton, DeleteTimeButton, and supporting widgets (CustomCreateField, CustomUpdateField, CustomInfo, ListTimesDataView, ShimmerListTimesView, EmptyListTimesView, ErrorListTimesView).
2. **Times feature page tests** — `test/src/features/times/presentation/pages/` contains tests for CreateTimePage, UpdateTimePage, and ListTimesPage with mocked BLoCs covering all state transitions.
3. **Wage feature widget tests** — `test/src/features/wage/presentation/widgets/` contains tests for all wage widgets: WageHourlyCard, WageHourlyInfo, WageHourlyField, SetWageButton, UpdateWageButton, ErrorFetchWageHourlyView, ShimmerWageHourlyView.
4. **Wage feature page tests** — `test/src/features/wage/presentation/pages/` contains tests for FetchWagePage and UpdateWagePage with mocked BLoCs covering all state transitions.
5. **All times and wage widget tests pass** — `flutter test` runs clean with zero failures.
6. **Zero linter warnings** — `flutter analyze` remains clean on all new test files.

## Tasks / Subtasks

### Task 1: Test Infrastructure — BLoC Mocks for Widget Tests (AC: 1-4)

- [x] 1.1 Add MockBloc classes to `test/helpers/mocks.dart` for all BLoCs needed by widget tests:
  - `MockCreateTimeBloc extends MockBloc<CreateTimeEvent, CreateTimeState> implements CreateTimeBloc {}`
  - `MockListTimesBloc extends MockBloc<ListTimesEvent, ListTimesState> implements ListTimesBloc {}`
  - `MockUpdateTimeBloc extends MockBloc<UpdateTimeEvent, UpdateTimeState> implements UpdateTimeBloc {}`
  - `MockDeleteTimeBloc extends MockBloc<DeleteTimeEvent, DeleteTimeState> implements DeleteTimeBloc {}`
  - `MockFetchWageBloc extends MockBloc<FetchWageEvent, FetchWageState> implements FetchWageBloc {}`
  - `MockUpdateWageBloc extends MockBloc<UpdateWageEvent, UpdateWageState> implements UpdateWageBloc {}`
  - `MockPaymentCubit extends MockCubit<PaymentState> implements PaymentCubit {}`
- [x] 1.2 Import `bloc_test` in mocks.dart for `MockBloc`/`MockCubit` base classes
- [x] 1.3 Verify `pump_app.dart` helper is sufficient for widget tests (already provides LocaleCubit + MaterialApp + l10n delegates)

### Task 2: Times Feature — Simple/Display Widget Tests (AC: 1)

- [x] 2.1 `test/src/features/times/presentation/widgets/custom_info_test.dart` — renders category label and value text
- [x] 2.2 `test/src/features/times/presentation/widgets/info_time_test.dart` — renders hour and minutes via CustomInfo using localized labels
- [x] 2.3 `test/src/features/times/presentation/widgets/time_card_test.dart` — renders InfoTime + EditButton with correct TimeEntry data
- [x] 2.4 `test/src/features/times/presentation/widgets/custom_create_field_test.dart` — renders title, text field responds to input, onChanged callback fires
- [x] 2.5 `test/src/features/times/presentation/widgets/custom_update_field_test.dart` — renders title, text field responds to input, onChanged callback fires
- [x] 2.6 `test/src/features/times/presentation/widgets/list_times_data_view_test.dart` — renders ListView with correct count of TimeCard widgets
- [x] 2.7 `test/src/features/times/presentation/widgets/list_times_other_view_test.dart` — ShimmerListTimesView shows progress indicator; EmptyListTimesView shows icon and localized empty message
- [x] 2.8 `test/src/features/times/presentation/widgets/error_list_times_view_test.dart` — renders ErrorView with GlobalFailure, optional actionWidget displayed

### Task 3: Times Feature — BLoC-Dependent Widget Tests (AC: 1)

- [x] 3.1 `test/src/features/times/presentation/widgets/create_time_card_test.dart` — renders Row with CreateHourField, CreateMinutesField, CreateTimeButton (needs MockCreateTimeBloc provided)
- [x] 3.2 `test/src/features/times/presentation/widgets/create_hour_field_test.dart` — dispatches CreateTimeHourChanged on input; auto-clears when BLoC emits CreateTimeInitial with hour=0 & minutes=0
- [x] 3.3 `test/src/features/times/presentation/widgets/create_minutes_field_test.dart` — dispatches CreateTimeMinutesChanged on input; auto-clears on reset
- [x] 3.4 `test/src/features/times/presentation/widgets/create_time_button_test.dart` — shows localized create label on Initial, CircularProgressIndicator on Loading, success label on Success, error label on Error; button is ALWAYS enabled (no disabled states — differs from Update/Delete buttons); pops dialog on Success via BlocConsumer listener
- [x] 3.5 `test/src/features/times/presentation/widgets/edit_button_test.dart` — dispatches `UpdateTimeInit(time: testTime)` on tap; verify event dispatch only — do NOT test dialog content here (showDialog opens in Navigator overlay which cannot access BlocProviders placed below MaterialApp by pumpApp; dialog internals are tested in update_time_page_test.dart). Needs MockUpdateTimeBloc provided
- [x] 3.6 `test/src/features/times/presentation/widgets/update_time_card_test.dart` — renders Row with UpdateHourField, UpdateMinutesField (needs MockUpdateTimeBloc)
- [x] 3.7 `test/src/features/times/presentation/widgets/update_hour_field_test.dart` — pre-populates from BLoC state; dispatches UpdateTimeHourChanged on input
- [x] 3.8 `test/src/features/times/presentation/widgets/update_minutes_field_test.dart` — pre-populates from BLoC state; dispatches UpdateTimeMinutesChanged on input
- [x] 3.9 `test/src/features/times/presentation/widgets/update_time_button_test.dart` — shows localized update label on Initial (enabled), spinner on Loading (disabled), success label on Success (disabled + pops via `canPop()` guard), error label on Error (disabled); only enabled when `state is UpdateTimeInitial`; dispatches `UpdateTimeSubmitted()` on tap
- [x] 3.10 `test/src/features/times/presentation/widgets/delete_time_button_test.dart` — shows localized delete label on Initial (enabled), spinner on Loading (disabled), success label on Success (disabled + pops via `canPop()` guard), error label on Error (disabled); only enabled when `state is DeleteTimeInitial`; dispatches `DeleteTimeRequested(time: testTime)` on tap. Note: uses `Navigator.of(context).canPop()` before pop — differs from other buttons that pop directly

### Task 4: Times Feature — Page Tests (AC: 2)

- [x] 4.1 `test/src/features/times/presentation/pages/create_time_page_test.dart` — renders AlertDialog with close button and CreateTimeCard; close button pops dialog
- [x] 4.2 `test/src/features/times/presentation/pages/update_time_page_test.dart` — `UpdateTimePage({required this.time})` takes a TimeEntry parameter; renders AlertDialog with UpdateTimeCard, `DeleteTimeButton(time: time)`, UpdateTimeButton; close button pops. Needs MockUpdateTimeBloc + MockDeleteTimeBloc
- [x] 4.3 `test/src/features/times/presentation/pages/list_times_page_test.dart` — auto-dispatches `ListTimesRequested` on build via `bloc:` parameter (verify event is added immediately after pump). State-driven rendering: Initial→ShimmerView, Loading→ShimmerView, Empty→EmptyView, Error→ErrorView+retry, Loaded→DataView. Listener PaymentCubit sync: Loaded→`setTimes(times)`, Empty/Error→`setTimes([])`, Initial/Loading→no PaymentCubit call. Retry button dispatches `ListTimesRequested`. Needs MockListTimesBloc + MockPaymentCubit

### Task 5: Wage Feature — Simple/Display Widget Tests (AC: 3)

- [x] 5.1 `test/src/features/wage/presentation/widgets/wage_hourly_info_test.dart` — renders localized hourly label and wage value
- [x] 5.2 `test/src/features/wage/presentation/widgets/wage_hourly_card_test.dart` — renders WageHourlyInfo + UpdateWageButton inside Card with primary color
- [x] 5.3 `test/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view_test.dart` — renders ErrorView with GlobalFailure; optional actionWidget displayed
- [x] 5.4 `test/src/features/wage/presentation/widgets/wage_hourly_other_view_test.dart` — ShimmerWageHourlyView shows progress indicator
- [x] 5.5 `test/src/features/wage/presentation/widgets/update_wage_button_test.dart` — button tap calls `showDialog` with UpdateWagePage; verify button renders and is tappable. Do NOT test dialog content here (same dialog provider scope limitation as EditButton — test dialog internals in update_wage_page_test.dart)

### Task 6: Wage Feature — BLoC-Dependent Widget Tests (AC: 3)

- [x] 6.1 `test/src/features/wage/presentation/widgets/wage_hourly_field_test.dart` — dispatches UpdateWageHourlyChanged on input; BlocBuilder rebuilds correctly
- [x] 6.2 `test/src/features/wage/presentation/widgets/set_wage_button_test.dart` — shows localized update label on Initial (enabled), spinner on Loading (disabled), success label on Success (enabled + pops), error label on Error (enabled). DIFFERS from Update/Delete time buttons: disabled ONLY when `state is UpdateWageLoading` (enabled on Initial, Success, Error). Dispatches `UpdateWageSubmitted()` on tap

### Task 7: Wage Feature — Page Tests (AC: 4)

- [x] 7.1 `test/src/features/wage/presentation/pages/update_wage_page_test.dart` — renders AlertDialog with WageHourlyField + SetWageButton; close button pops
- [x] 7.2 `test/src/features/wage/presentation/pages/fetch_wage_page_test.dart` — auto-dispatches `FetchWageRequested` on build via `bloc:` parameter (verify event is added immediately after pump). State-driven: Initial→ShimmerView, Loading→ShimmerView, Loaded→`WageHourlyCard(wageHourly: wage)`, Error→ErrorView+retry. Listener: `listenWhen` only fires on `FetchWageLoaded` — calls `PaymentCubit.setWage(state.wage.value)`; Initial/Loading/Error do NOT trigger listener. Retry dispatches `FetchWageRequested`. Needs MockFetchWageBloc + MockPaymentCubit

### Task 8: Final Validation (AC: 5-6)

- [x] 8.1 Run `flutter test --test-randomize-ordering-seed random` — all tests pass (existing + new)
- [x] 8.2 Run `flutter analyze` — zero warnings on all files
- [x] 8.3 Verify dartdoc comments on all new test files (`///` file-level docs, `library;` directive, group/test comments)

## Dev Notes

### Widget Test Architecture Pattern

Widget tests in this project mock BLoCs (not use cases). Use `MockBloc`/`MockCubit` from `bloc_test` package:

```dart
// In test file or mocks.dart
class MockCreateTimeBloc extends MockBloc<CreateTimeEvent, CreateTimeState>
    implements CreateTimeBloc {}

// In test setUp
late MockCreateTimeBloc mockBloc;
setUp(() {
  mockBloc = MockCreateTimeBloc();
  when(() => mockBloc.state).thenReturn(const CreateTimeInitial());
});

// In test body — provide BLoC via BlocProvider
await tester.pumpApp(
  BlocProvider<CreateTimeBloc>.value(
    value: mockBloc,
    child: const CreateTimeButton(),
  ),
);
```

For widgets needing multiple BLoCs, nest `BlocProvider.value` or use `MultiBlocProvider`.

### State-Driven Button Testing Pattern

All CRUD buttons show 4-state UI but have DIFFERENT enabled/disabled logic:

| Button | Disabled Logic | Enabled States | Pop Guard |
|--------|---------------|----------------|-----------|
| CreateTimeButton | NEVER disabled | All | direct pop |
| UpdateTimeButton | `state is UpdateTimeInitial ? cb : null` | Initial only | `canPop()` then pop |
| DeleteTimeButton | `state is DeleteTimeInitial ? cb : null` | Initial only | `canPop()` then pop |
| SetWageButton | `state is UpdateWageLoading ? null : cb` | Initial, Success, Error | direct pop |

Use `when(() => state)` for initial state (BlocBuilder), `whenListen` for stream transitions (BlocListener/BlocConsumer):

```dart
// when(() => state) — sets initial state for BlocBuilder rendering
when(() => mockBloc.state).thenReturn(const CreateTimeInitial());

// whenListen — simulates state transitions for BlocConsumer listener
whenListen(mockBloc, Stream.value(CreateTimeLoading(hour: 1, minutes: 30)),
  initialState: const CreateTimeInitial());
await tester.pumpApp(BlocProvider.value(value: mockBloc, child: widget));
await tester.pump(); // process stream
expect(find.byType(CircularProgressIndicator), findsOneWidget);
```

### Dialog Pop Verification

Buttons that auto-dismiss on success need a navigation context. Wrap in `Scaffold` + `Navigator`:

```dart
await tester.pumpApp(
  Scaffold(
    body: Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => BlocProvider.value(
            value: mockBloc,
            child: const CreateTimePage(),
          ),
        ),
        child: const Text('open'),
      );
    }),
  ),
);
await tester.tap(find.text('open'));
await tester.pumpAndSettle();
// Now test dialog content...
```

### Critical Implementation Details

- **pumpApp already provides**: `LocaleCubit`, `MaterialApp`, l10n delegates, supported locales — do NOT duplicate
- **Localization in tests**: All user-facing text is localized via `context.l10n`. Use `find.byType(Text)` or `find.textContaining()` rather than `find.text('hardcoded')` — or get the `AppLocalizations` instance in tests
- **No `find.text()` with hardcoded strings**: Existing test suite avoids this pattern. Widget tests should use `find.byType()`, `find.byKey()`, or `tester.widget<Text>()` to verify content
- **Sealed class states carry fields**: All times BLoC states carry `hour` and `minutes`; update states also carry `TimeEntry? time`. When stubbing, always provide these fields
- **UpdateTimeBloc.initState pre-population**: `UpdateHourField` and `UpdateMinutesField` read BLoC state in `initState()` to pre-fill controllers — stub state BEFORE pumping
- **Page auto-dispatch on build**: Both `ListTimesPage` and `FetchWagePage` dispatch their fetch event in the `bloc:` parameter (`..add(const ListTimesRequested())` / `..add(const FetchWageRequested())`). Mock state BEFORE pumping — the event fires immediately
- **PaymentCubit sync truth table**:

| Page | State | PaymentCubit Call |
|------|-------|------------------|
| ListTimesPage | `ListTimesLoaded(times)` | `setTimes(times)` |
| ListTimesPage | `ListTimesEmpty` | `setTimes([])` |
| ListTimesPage | `ListTimesError` | `setTimes([])` |
| ListTimesPage | `ListTimesInitial` / `ListTimesLoading` | **(none)** |
| FetchWagePage | `FetchWageLoaded(wage)` | `setWage(wage.value)` |
| FetchWagePage | `FetchWageInitial` / `FetchWageLoading` / `FetchWageError` | **(none — listenWhen filters)** |
- **AppDurations.actionFeedback**: BLoCs insert 400ms delay between transitions. For tests that verify post-delay state, use `await tester.pump(const Duration(milliseconds: 400))` — but this typically happens inside BLoC, not in widget test layer

### Widgets That Need BLoC Providers (MockBloc)

| Widget | Required MockBlocs |
|---|---|
| CreateHourField | MockCreateTimeBloc |
| CreateMinutesField | MockCreateTimeBloc |
| CreateTimeButton | MockCreateTimeBloc |
| CreateTimeCard | MockCreateTimeBloc |
| EditButton | MockUpdateTimeBloc (only — dialog not tested here; see Dialog Provider Scope Warning) |
| UpdateHourField | MockUpdateTimeBloc |
| UpdateMinutesField | MockUpdateTimeBloc |
| UpdateTimeButton | MockUpdateTimeBloc |
| UpdateTimeCard | MockUpdateTimeBloc |
| DeleteTimeButton | MockDeleteTimeBloc |
| CreateTimePage | MockCreateTimeBloc |
| UpdateTimePage | MockUpdateTimeBloc, MockDeleteTimeBloc |
| ListTimesPage | MockListTimesBloc, MockPaymentCubit |
| WageHourlyField | MockUpdateWageBloc |
| SetWageButton | MockUpdateWageBloc |
| UpdateWagePage | MockUpdateWageBloc |
| FetchWagePage | MockFetchWageBloc, MockPaymentCubit |

### Widgets That Are Pure Presentation (No MockBloc needed)

CustomInfo, InfoTime, TimeCard (needs EditButton providers though), CustomCreateField, CustomUpdateField, ListTimesDataView, ShimmerListTimesView, EmptyListTimesView, ErrorListTimesView, WageHourlyInfo, WageHourlyCard, ErrorFetchWageHourlyView, ShimmerWageHourlyView, UpdateWageButton.

**Note on TimeCard**: Although TimeCard itself is pure, it contains EditButton which needs MockUpdateTimeBloc + MockDeleteTimeBloc. Either provide mocks in time_card_test or test TimeCard layout independently and EditButton separately.

### Test File Count

- Times widgets (Task 2 + Task 3): 18 test files
- Times pages (Task 4): 3 test files
- Wage widgets (Task 5 + Task 6): 7 test files
- Wage pages (Task 7): 2 test files
- **Total: 30 new test files**

### Existing Test Infrastructure (Reuse)

- `test/helpers/mocks.dart` — add MockBloc/MockCubit classes here (Task 1)
- `test/helpers/pump_app.dart` — use `tester.pumpApp(widget)` for all widget tests
- `test/helpers/helpers.dart` — barrel export, no changes needed
- Existing test count: 165 tests (must NOT regress)

### Test Fixture Data

Reuse domain entity constructors for test data:
```dart
const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
const testWage = WageHourly(id: 1, value: 15.5);
const testTimes = [
  TimeEntry(id: 1, hour: 1, minutes: 0),
  TimeEntry(id: 2, hour: 2, minutes: 30),
];
const testFailure = InternalError(error: 'test error');
```

### registerFallbackValue for Widget Tests

Widget tests that use `verify(() => mockBloc.add(any()))` require `registerFallbackValue` in `setUpAll` for custom event types. Without this, mocktail throws `MissingStubError`:

```dart
setUpAll(() {
  registerFallbackValue(const CreateTimeSubmitted());       // CreateTimeBloc events
  registerFallbackValue(const TimeEntry(hour: 0, minutes: 0)); // TimeEntry for DeleteTimeRequested
  registerFallbackValue(const UpdateWageSubmitted());       // UpdateWageBloc events
  registerFallbackValue(const ListTimesRequested());        // ListTimesBloc events
  registerFallbackValue(const FetchWageRequested());        // FetchWageBloc events
});
```

### Required Import Paths

Each test file needs specific imports. Key BLoC imports (each exports Bloc + Events + States):
```dart
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart';
import 'package:time_money/src/features/wage/presentation/bloc/update_wage_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';
import 'package:time_money/src/core/errors/failures.dart'; // GlobalFailure, InternalError, etc.
```

### ErrorView Shared Widget

`ErrorView` is used by `ErrorListTimesView` and `ErrorFetchWageHourlyView`. Constructor:
```dart
const ErrorView(this.failure, {required this.actionWidget, super.key});
// failure: GlobalFailure (sealed class)
// actionWidget: Widget? (nullable — e.g., retry button)
```
Renders `ShowInfoSection` with icon + message. Note: error messages are hardcoded Spanish text (NOT localized via l10n). Tests should verify ErrorView presence via `find.byType(ErrorView)`, not text content.

### Dialog Provider Scope Warning

`showDialog` opens routes in the Navigator overlay. BlocProviders placed INSIDE pumpApp's child tree are BELOW the Navigator — the dialog CANNOT access them:

```
pumpApp wraps: BlocProvider<LocaleCubit> → MaterialApp → Navigator
                                                          ├── [child: BlocProvider<X> → Widget]
                                                          └── Overlay → [dialog] ← CANNOT see BlocProvider<X>
```

For widgets that call `showDialog` (EditButton, UpdateWageButton): test event dispatch and rendering separately. Test dialog content in the corresponding page test files (update_time_page_test, update_wage_page_test) using the Dialog Pop Verification pattern above.

### Recommended Execution Order

Execute tasks by complexity to reduce debugging time:
1. **Task 1** — Mock infrastructure (required by all subsequent tasks)
2. **Task 2, Task 5** — Pure/display widgets (no BLoC mocking, fastest to write)
3. **Task 3, Task 6** — BLoC-dependent widgets (require mock setup)
4. **Task 4, Task 7** — Page tests (most complex: multi-provider, listener verification, dialog patterns)
5. **Task 8** — Final validation run

### Project Structure Notes

- Widget test files mirror source path: `lib/src/features/times/presentation/widgets/time_card.dart` → `test/src/features/times/presentation/widgets/time_card_test.dart`
- Pages tests: `lib/src/features/times/presentation/pages/` → `test/src/features/times/presentation/pages/`
- No barrel files needed for test directories

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.1] — acceptance criteria and BDD specs
- [Source: _bmad-output/project-context.md#Testing Rules] — test framework, patterns, documentation standard
- [Source: _bmad-output/project-context.md#Flutter & BLoC Framework Rules] — 4-state pattern, ActionState, BLoC naming
- [Source: _bmad-output/implementation-artifacts/4-5-multi-platform-verification-localization-validation.md] — localization implementation details, pump_app already supports l10n, no `find.text()` with hardcoded strings in test suite
- [Source: test/helpers/pump_app.dart] — PumpApp extension providing LocaleCubit + MaterialApp + l10n
- [Source: test/helpers/mocks.dart] — existing Mock classes (use cases + repositories), needs MockBloc additions

### Previous Story Intelligence (Story 4.5)

- All 48 hardcoded strings replaced with `context.l10n` calls — widget tests must NOT assert hardcoded English strings
- `pump_app.dart` already wraps with localization delegates — no modifications needed
- Test count is 165 (157 original + 7 locale cubit + 1 drift wage bugfix) — must not regress
- Pre-existing issues documented: placeholder error buttons render non-functional "Error" text in `_ActionWidget` (ListTimesPage, FetchWagePage) — test the retry button behavior as specified, not the placeholder styling
- Wage ID not propagated issue: UpdateWageBloc starts with `WageHourly(id: 0)` — test with id=0 is valid current behavior

### Git Intelligence

Recent commits show:
- `16b3c47` — project-context updated to 101 rules (current)
- `8fcd813` — error handling impurities fixed (clean architecture)
- `fc209bc` — all deferred tech debt resolved before Epic 5
- `0c51eff` — Epic 4 retrospective completed
- `b304a3e` — pre-existing UI/UX layout issues resolved

The codebase is clean and stable — Epic 5 starts on solid foundations with zero known tech debt.

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- Widget tests requiring `TextField` need `Scaffold` wrapper for `Material` ancestor
- `BlocConsumer`-based widgets cannot use `pumpAndSettle()` — must use `pump()` to avoid timeout on never-closing stream subscriptions
- Events without `==` override require `any(that: isA<EventType>())` or `captureAny()` for verify assertions instead of `const` equality matching
- Dialog provider scope: `showDialog` creates routes in Navigator overlay — BlocProviders placed below MaterialApp are invisible to dialogs; dialog content tested separately in page tests

### Completion Notes List

- **Task 1**: Added 7 MockBloc/MockCubit classes to `test/helpers/mocks.dart` — MockCreateTimeBloc, MockListTimesBloc, MockUpdateTimeBloc, MockDeleteTimeBloc, MockFetchWageBloc, MockUpdateWageBloc, MockPaymentCubit. Imported `bloc_test` for base classes. Verified `pump_app.dart` sufficient (no changes needed).
- **Task 2**: Created 8 times display widget tests — CustomInfo, InfoTime, TimeCard, CustomCreateField, CustomUpdateField, ListTimesDataView, ShimmerListTimesView/EmptyListTimesView, ErrorListTimesView.
- **Task 3**: Created 10 times BLoC-dependent widget tests — CreateTimeCard, CreateHourField, CreateMinutesField, CreateTimeButton, EditButton, UpdateTimeCard, UpdateHourField, UpdateMinutesField, UpdateTimeButton, DeleteTimeButton. Verified 4-state button rendering and enabled/disabled logic per specification.
- **Task 4**: Created 3 times page tests — CreateTimePage, UpdateTimePage, ListTimesPage. ListTimesPage verifies auto-dispatch, all 5 state renderings, retry, and PaymentCubit sync.
- **Task 5**: Created 5 wage display widget tests — WageHourlyInfo, WageHourlyCard, ErrorFetchWageHourlyView, ShimmerWageHourlyView, UpdateWageButton.
- **Task 6**: Created 2 wage BLoC-dependent widget tests — WageHourlyField, SetWageButton. Verified SetWageButton-specific enabled logic (disabled only on Loading).
- **Task 7**: Created 2 wage page tests — UpdateWagePage, FetchWagePage. FetchWagePage verifies auto-dispatch, all 4 state renderings, listenWhen filter, retry.
- **Task 8**: Final validation — 261 tests pass (165 existing + 96 new), zero `flutter analyze` warnings, all test files have `///` dartdoc, `library;` directive, and `group`/`test` comments.

### File List

- test/helpers/mocks.dart (modified — added 7 MockBloc/MockCubit classes)
- test/src/features/times/presentation/widgets/custom_info_test.dart (new)
- test/src/features/times/presentation/widgets/info_time_test.dart (new)
- test/src/features/times/presentation/widgets/time_card_test.dart (new)
- test/src/features/times/presentation/widgets/custom_create_field_test.dart (new)
- test/src/features/times/presentation/widgets/custom_update_field_test.dart (new)
- test/src/features/times/presentation/widgets/list_times_data_view_test.dart (new)
- test/src/features/times/presentation/widgets/list_times_other_view_test.dart (new)
- test/src/features/times/presentation/widgets/error_list_times_view_test.dart (new)
- test/src/features/times/presentation/widgets/create_time_card_test.dart (new)
- test/src/features/times/presentation/widgets/create_hour_field_test.dart (new)
- test/src/features/times/presentation/widgets/create_minutes_field_test.dart (new)
- test/src/features/times/presentation/widgets/create_time_button_test.dart (new)
- test/src/features/times/presentation/widgets/edit_button_test.dart (new)
- test/src/features/times/presentation/widgets/update_time_card_test.dart (new)
- test/src/features/times/presentation/widgets/update_hour_field_test.dart (new)
- test/src/features/times/presentation/widgets/update_minutes_field_test.dart (new)
- test/src/features/times/presentation/widgets/update_time_button_test.dart (new)
- test/src/features/times/presentation/widgets/delete_time_button_test.dart (new)
- test/src/features/times/presentation/pages/create_time_page_test.dart (new)
- test/src/features/times/presentation/pages/update_time_page_test.dart (new)
- test/src/features/times/presentation/pages/list_times_page_test.dart (new)
- test/src/features/wage/presentation/widgets/wage_hourly_info_test.dart (new)
- test/src/features/wage/presentation/widgets/wage_hourly_card_test.dart (new)
- test/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view_test.dart (new)
- test/src/features/wage/presentation/widgets/wage_hourly_other_view_test.dart (new)
- test/src/features/wage/presentation/widgets/update_wage_button_test.dart (new)
- test/src/features/wage/presentation/widgets/wage_hourly_field_test.dart (new)
- test/src/features/wage/presentation/widgets/set_wage_button_test.dart (new)
- test/src/features/wage/presentation/pages/update_wage_page_test.dart (new)
- test/src/features/wage/presentation/pages/fetch_wage_page_test.dart (new)
