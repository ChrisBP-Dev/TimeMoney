# Story 5.1: Times & Wage Feature Widget Tests

Status: ready-for-dev

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

- [ ] 1.1 Add MockBloc classes to `test/helpers/mocks.dart` for all BLoCs needed by widget tests:
  - `MockCreateTimeBloc extends MockBloc<CreateTimeEvent, CreateTimeState> implements CreateTimeBloc {}`
  - `MockListTimesBloc extends MockBloc<ListTimesEvent, ListTimesState> implements ListTimesBloc {}`
  - `MockUpdateTimeBloc extends MockBloc<UpdateTimeEvent, UpdateTimeState> implements UpdateTimeBloc {}`
  - `MockDeleteTimeBloc extends MockBloc<DeleteTimeEvent, DeleteTimeState> implements DeleteTimeBloc {}`
  - `MockFetchWageBloc extends MockBloc<FetchWageEvent, FetchWageState> implements FetchWageBloc {}`
  - `MockUpdateWageBloc extends MockBloc<UpdateWageEvent, UpdateWageState> implements UpdateWageBloc {}`
  - `MockPaymentCubit extends MockCubit<PaymentState> implements PaymentCubit {}`
- [ ] 1.2 Import `bloc_test` in mocks.dart for `MockBloc`/`MockCubit` base classes
- [ ] 1.3 Verify `pump_app.dart` helper is sufficient for widget tests (already provides LocaleCubit + MaterialApp + l10n delegates)

### Task 2: Times Feature — Simple/Display Widget Tests (AC: 1)

- [ ] 2.1 `test/src/features/times/presentation/widgets/custom_info_test.dart` — renders category label and value text
- [ ] 2.2 `test/src/features/times/presentation/widgets/info_time_test.dart` — renders hour and minutes via CustomInfo using localized labels
- [ ] 2.3 `test/src/features/times/presentation/widgets/time_card_test.dart` — renders InfoTime + EditButton with correct TimeEntry data
- [ ] 2.4 `test/src/features/times/presentation/widgets/custom_create_field_test.dart` — renders title, text field responds to input, onChanged callback fires
- [ ] 2.5 `test/src/features/times/presentation/widgets/custom_update_field_test.dart` — renders title, text field responds to input, onChanged callback fires
- [ ] 2.6 `test/src/features/times/presentation/widgets/list_times_data_view_test.dart` — renders ListView with correct count of TimeCard widgets
- [ ] 2.7 `test/src/features/times/presentation/widgets/list_times_other_view_test.dart` — ShimmerListTimesView shows progress indicator; EmptyListTimesView shows icon and localized empty message
- [ ] 2.8 `test/src/features/times/presentation/widgets/error_list_times_view_test.dart` — renders ErrorView with GlobalFailure, optional actionWidget displayed

### Task 3: Times Feature — BLoC-Dependent Widget Tests (AC: 1)

- [ ] 3.1 `test/src/features/times/presentation/widgets/create_time_card_test.dart` — renders Row with CreateHourField, CreateMinutesField, CreateTimeButton (needs MockCreateTimeBloc provided)
- [ ] 3.2 `test/src/features/times/presentation/widgets/create_hour_field_test.dart` — dispatches CreateTimeHourChanged on input; auto-clears when BLoC emits CreateTimeInitial with hour=0 & minutes=0
- [ ] 3.3 `test/src/features/times/presentation/widgets/create_minutes_field_test.dart` — dispatches CreateTimeMinutesChanged on input; auto-clears on reset
- [ ] 3.4 `test/src/features/times/presentation/widgets/create_time_button_test.dart` — shows "Create" text on Initial, CircularProgressIndicator on Loading, "Success" on Success, "Error" on Error; pops dialog on Success state
- [ ] 3.5 `test/src/features/times/presentation/widgets/edit_button_test.dart` — dispatches UpdateTimeInit(time) on tap; opens UpdateTimePage dialog (needs MockUpdateTimeBloc + MockDeleteTimeBloc)
- [ ] 3.6 `test/src/features/times/presentation/widgets/update_time_card_test.dart` — renders Row with UpdateHourField, UpdateMinutesField (needs MockUpdateTimeBloc)
- [ ] 3.7 `test/src/features/times/presentation/widgets/update_hour_field_test.dart` — pre-populates from BLoC state; dispatches UpdateTimeHourChanged on input
- [ ] 3.8 `test/src/features/times/presentation/widgets/update_minutes_field_test.dart` — pre-populates from BLoC state; dispatches UpdateTimeMinutesChanged on input
- [ ] 3.9 `test/src/features/times/presentation/widgets/update_time_button_test.dart` — shows "Update" on Initial (enabled), spinner on Loading (disabled), "Success" on Success (disabled + pops), "Error" on Error (disabled)
- [ ] 3.10 `test/src/features/times/presentation/widgets/delete_time_button_test.dart` — shows "Delete" on Initial (enabled), spinner on Loading (disabled), "Success" on Success (disabled + pops), "Error" on Error (disabled); dispatches DeleteTimeRequested(time) on tap

### Task 4: Times Feature — Page Tests (AC: 2)

- [ ] 4.1 `test/src/features/times/presentation/pages/create_time_page_test.dart` — renders AlertDialog with close button and CreateTimeCard; close button pops dialog
- [ ] 4.2 `test/src/features/times/presentation/pages/update_time_page_test.dart` — renders AlertDialog with UpdateTimeCard, DeleteTimeButton, UpdateTimeButton; close button pops
- [ ] 4.3 `test/src/features/times/presentation/pages/list_times_page_test.dart` — state-driven rendering: Initial→ShimmerView, Loading→ShimmerView, Empty→EmptyView, Error→ErrorView+retry, Loaded→DataView; listener syncs PaymentCubit.setTimes(); retry button dispatches ListTimesRequested

### Task 5: Wage Feature — Simple/Display Widget Tests (AC: 3)

- [ ] 5.1 `test/src/features/wage/presentation/widgets/wage_hourly_info_test.dart` — renders localized hourly label and wage value
- [ ] 5.2 `test/src/features/wage/presentation/widgets/wage_hourly_card_test.dart` — renders WageHourlyInfo + UpdateWageButton inside Card with primary color
- [ ] 5.3 `test/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view_test.dart` — renders ErrorView with GlobalFailure; optional actionWidget displayed
- [ ] 5.4 `test/src/features/wage/presentation/widgets/wage_hourly_other_view_test.dart` — ShimmerWageHourlyView shows progress indicator
- [ ] 5.5 `test/src/features/wage/presentation/widgets/update_wage_button_test.dart` — button tap opens UpdateWagePage dialog

### Task 6: Wage Feature — BLoC-Dependent Widget Tests (AC: 3)

- [ ] 6.1 `test/src/features/wage/presentation/widgets/wage_hourly_field_test.dart` — dispatches UpdateWageHourlyChanged on input; BlocBuilder rebuilds correctly
- [ ] 6.2 `test/src/features/wage/presentation/widgets/set_wage_button_test.dart` — shows "Update" on Initial, spinner on Loading (disabled), "Success" on Success (pops), "Error" on Error; dispatches UpdateWageSubmitted on tap

### Task 7: Wage Feature — Page Tests (AC: 4)

- [ ] 7.1 `test/src/features/wage/presentation/pages/update_wage_page_test.dart` — renders AlertDialog with WageHourlyField + SetWageButton; close button pops
- [ ] 7.2 `test/src/features/wage/presentation/pages/fetch_wage_page_test.dart` — state-driven: Initial→ShimmerView, Loading→ShimmerView, Loaded→WageHourlyCard, Error→ErrorView+retry; listener syncs PaymentCubit.setWage(); retry dispatches FetchWageRequested

### Task 8: Final Validation (AC: 5-6)

- [ ] 8.1 Run `flutter test --test-randomize-ordering-seed random` — all tests pass (existing + new)
- [ ] 8.2 Run `flutter analyze` — zero warnings on all files
- [ ] 8.3 Verify dartdoc comments on all new test files (`///` file-level docs, `library;` directive, group/test comments)

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

All CRUD buttons follow the same 4-state pattern. Test each state:

```dart
// Test loading state shows spinner
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
- **ListTimesPage PaymentCubit sync**: In listener, `ListTimesLoaded` calls `PaymentCubit.setTimes(times)`, other states call `setTimes([])` — verify with `verify(() => mockPaymentCubit.setTimes(any()))`
- **FetchWagePage PaymentCubit sync**: `FetchWageLoaded` calls `PaymentCubit.setWage(state.wage.value)` — same verification pattern
- **AppDurations.actionFeedback**: BLoCs insert 400ms delay between transitions. For tests that verify post-delay state, use `await tester.pump(const Duration(milliseconds: 400))` — but this typically happens inside BLoC, not in widget test layer

### Widgets That Need BLoC Providers (MockBloc)

| Widget | Required MockBlocs |
|---|---|
| CreateHourField | MockCreateTimeBloc |
| CreateMinutesField | MockCreateTimeBloc |
| CreateTimeButton | MockCreateTimeBloc |
| CreateTimeCard | MockCreateTimeBloc |
| EditButton | MockUpdateTimeBloc, MockDeleteTimeBloc |
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

### Test File Count Estimate

- Times widgets: ~14 test files
- Times pages: 3 test files
- Wage widgets: ~7 test files
- Wage pages: 2 test files
- **Total: ~26 new test files**

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
```

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

### Debug Log References

### Completion Notes List

### File List
