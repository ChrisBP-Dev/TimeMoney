# Story 3.6: Domain Entities & Naming Conventions Final Pass

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to verify Freezed 3.x domain entities and apply final naming conventions, code quality fixes, and accumulated deferred items across the codebase,
so that domain data classes support copyWith/equality/JSON, all code follows consistent naming patterns, and every item explicitly deferred from stories 3.1–3.5 is resolved before Epic 3 closes (FR41, NFR6, NFR7, NFR8).

## Acceptance Criteria

1. **Freezed 3.x entities verified** — `TimeEntry` and `WageHourly` already have `@freezed` with `copyWith`, equality, and JSON serialization via generated code (FR41); `.freezed.dart` and `.g.dart` files are present and current; Freezed is used ONLY for domain data classes — NOT for BLoC events, states, or failure types (all confirmed ✅ — no code changes required)

2. **GlobalFailure and ValueFailure equality** — All `GlobalFailure` variants (`InternalError`, `ServerError`, `NotConnection`, `TimeOutExceeded`) and all `ValueFailure` variants (`CharacterLimitExceeded<T>`, `ShortOrNullCharacters<T>`, `InvalidFormat<T>`) override `==` and `hashCode`; `InternalError` equality compares `error` field only (NOT `stackTrace` — debugging artifact); `NotConnection` and `TimeOutExceeded` equality based on `runtimeType`; existing `failures_test.dart` gains structural equality tests covering both const and non-const instances

3. **EmptyWageHourlyView deleted** — `EmptyWageHourlyView` class removed from `wage_hourly_other_view.dart`; `ShimmerWageHourlyView` remains (still used in `fetch_wage_page.dart`); `widgets.dart` barrel unchanged (still exports the file)

4. **StackTrace in error_view.dart resolved** — `GlobalFailure.fromException` already logs via `developer.log` in debug mode; no additional action required in `error_view.dart`; this deferred item is explicitly closed as "resolved by existing implementation"

5. **Loading guard on action buttons** — `UpdateTimeButton` and `DeleteTimeButton` disable `onPressed` when state is NOT `Initial` (covers `Loading`, `Success`, and `Error` states to prevent double-tap during the `AppDurations.actionFeedback` delay window); `UpdateWageButton` does NOT receive a loading guard — it is a dialog launcher (`showDialog` → `UpdateWagePage`); the guard lives in `SetWageButton` inside that dialog (same P-1 pattern as story 3.4); `Navigator.pop()` calls are guarded with `canPop()` to prevent FlutterError when no popable route exists

6. **Naming conventions final pass — screen → page rename** — `list_times_screen.dart` → `list_times_page.dart` (class `ListTimesScreen` → `ListTimesPage`); `fetch_wage_screen.dart` → `fetch_wage_page.dart` (class `FetchWageScreen` → `FetchWagePage`); all references updated (barrel exports, `home_page.dart` imports and widget usage); NFR8 satisfied

7. **Zero warnings and zero dead code** — `flutter analyze` produces zero issues on all modified and created files; `flutter test` passes all existing tests plus new equality tests (NFR6, NFR7)

## Tasks / Subtasks

- [x] Task 1: Verify Freezed entities (AC: #1)
  - [x] 1.1 Confirm `time_entry.dart` uses `@freezed` with `.freezed.dart` and `.g.dart` present — READ ONLY, no code changes
  - [x] 1.2 Confirm `wage_hourly.dart` uses `@freezed` with `.freezed.dart` and `.g.dart` present — READ ONLY, no code changes
  - [x] 1.3 Confirm Freezed annotation is NOT used in any BLoC event, BLoC state, or failure type file — READ ONLY

- [x] Task 2: Fix GlobalFailure and ValueFailure equality (AC: #2, DEFERRED-1)
  - [x] 2.1 Add `==` and `hashCode` to `InternalError` — compare `error` only, NOT `stackTrace`
  - [x] 2.2 Add `==` and `hashCode` to `ServerError` — compare `failure` field
  - [x] 2.3 Add `==` and `hashCode` to `NotConnection` — no fields, runtimeType-based
  - [x] 2.4 Add `==` and `hashCode` to `TimeOutExceeded` — no fields, runtimeType-based
  - [x] 2.5 Add `==` and `hashCode` to `CharacterLimitExceeded<T>` — compare `failedValue`
  - [x] 2.6 Add `==` and `hashCode` to `ShortOrNullCharacters<T>` — compare `failedValue`
  - [x] 2.7 Add `==` and `hashCode` to `InvalidFormat<T>` — compare `failedValue`
  - [x] 2.8 Update `test/src/core/errors/failures_test.dart` — add structural equality tests (see Testing Requirements)

- [x] Task 3: Delete EmptyWageHourlyView (AC: #3, DEFERRED-2)
  - [x] 3.1 Remove `EmptyWageHourlyView` class from `wage_hourly_other_view.dart`; keep `ShimmerWageHourlyView`
  - [x] 3.2 Verify `fetch_wage_page.dart` still uses only `ShimmerWageHourlyView` — no breakage

- [x] Task 4: Confirm StackTrace resolution (AC: #4, DEFERRED-3)
  - [x] 4.1 READ `lib/src/core/errors/failures.dart` — confirm `GlobalFailure.fromException` logs via `developer.log` (already verified, line 33)
  - [x] 4.2 No code changes required — this deferred is resolved by existing debug logging

- [x] Task 5: Add loading guard to action buttons (AC: #5, DEFERRED-6)
  - [x] 5.1 Update `update_time_button.dart` — add `state is UpdateTimeLoading ? null :` guard on `onPressed`
  - [x] 5.2 Update `delete_time_button.dart` — add `state is DeleteTimeLoading ? null :` guard on `onPressed`
  - [x] 5.3 READ `lib/src/features/wage/presentation/widgets/update_wage_button.dart` — CONFIRM it is a dialog launcher (`showDialog` → `UpdateWagePage`), NOT a submit action; NO loading guard needed — the guard already lives in `SetWageButton` (set_wage_button.dart:18) inside `UpdateWagePage`; no code change required on `UpdateWageButton`

- [x] Task 6: Rename screen → page files (AC: #6, NFR8)
  - [x] 6.1 Rename `list_times_screen.dart` → `list_times_page.dart`; rename class `ListTimesScreen` → `ListTimesPage`
  - [x] 6.2 Update `lib/src/features/times/presentation/pages/pages.dart` barrel: `list_times_screen.dart` → `list_times_page.dart`
  - [x] 6.3 Update `lib/src/features/home/presentation/pages/home_page.dart`: update import path and widget usage (`ListTimesScreen()` → `ListTimesPage()`)
  - [x] 6.4 Rename `fetch_wage_screen.dart` → `fetch_wage_page.dart`; rename class `FetchWageScreen` → `FetchWagePage`
  - [x] 6.5 Update `lib/src/features/wage/presentation/pages/pages.dart` barrel: `fetch_wage_screen.dart` → `fetch_wage_page.dart`
  - [x] 6.6 Update `lib/src/features/home/presentation/pages/home_page.dart`: update import path and widget usage (`FetchWageScreen()` → `FetchWagePage()`)
  - [x] 6.7 Grep entire codebase (including `lib/`, `test/`, and root) for any remaining `ListTimesScreen`, `list_times_screen`, `FetchWageScreen`, `fetch_wage_screen` references — update all found

- [x] Task 7: Verification (AC: #7)
  - [x] 7.1 Run `flutter analyze` — zero issues
  - [x] 7.2 Run `flutter test` — all tests pass (existing 106 + new equality tests)

## Dev Notes

### State of the Codebase at Start of Story

**CONFIRMED AS-IS (no changes needed):**
- `time_entry.dart` — uses `@freezed` on abstract class, has `.freezed.dart` (with `copyWith`, `==`, `hashCode`) and `.g.dart` (JSON) ✅
- `wage_hourly.dart` — same as above ✅
- No Freezed annotation on BLoC events/states/failures (all sealed classes) ✅
- All imports use absolute `package:time_money/src/...` — no relative imports ✅
- `GlobalFailure.fromException` already logs StackTrace via `developer.log` in debug mode (line 33 of `failures.dart`) ✅

**CONFIRMED NEEDS FIXES:**
- `failures.dart` — no `==`/`hashCode` on any variant (DEFERRED-1)
- `wage_hourly_other_view.dart` — `EmptyWageHourlyView` is dead code (DEFERRED-2)
- `update_time_button.dart` — no loading guard (DEFERRED-6)
- `delete_time_button.dart` — no loading guard (DEFERRED-6)
- `list_times_screen.dart` / `ListTimesScreen` — wrong naming convention
- `fetch_wage_screen.dart` / `FetchWageScreen` — wrong naming convention

---

### Task 2: GlobalFailure and ValueFailure Equality — Exact Specifications

**Key design decision:** `InternalError.==` compares `error` field ONLY — `stackTrace` is excluded.
Rationale: Stack traces are debugging artifacts unique per call site. Two `InternalError` instances with
the same `error` message but different stack traces should be semantically equal for BLoC state comparison.
Tests that do `expect(state.failure, const InternalError('message'))` must work even when the actual
failure was created at runtime via `GlobalFailure.fromException(e, st)` with a StackTrace attached.

**`failures.dart` — after changes (complete rewrite of class bodies):**

```dart
// InternalError — compare error only
final class InternalError extends GlobalFailure {
  const InternalError(this.error, [this.stackTrace]);
  final dynamic error;
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternalError && error == other.error;

  @override
  int get hashCode => error.hashCode;
}

// ServerError — compare failure field
final class ServerError extends GlobalFailure {
  const ServerError(this.failure);
  final Object failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

// NotConnection — no fields, runtimeType equality
final class NotConnection extends GlobalFailure {
  const NotConnection();

  @override
  bool operator ==(Object other) => other is NotConnection;

  @override
  int get hashCode => runtimeType.hashCode;
}

// TimeOutExceeded — no fields, runtimeType equality
final class TimeOutExceeded extends GlobalFailure {
  const TimeOutExceeded();

  @override
  bool operator ==(Object other) => other is TimeOutExceeded;

  @override
  int get hashCode => runtimeType.hashCode;
}
```

**ValueFailure variants — full implementation for all three:**

```dart
final class CharacterLimitExceeded<T> extends ValueFailure<T> {
  const CharacterLimitExceeded({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterLimitExceeded<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

final class ShortOrNullCharacters<T> extends ValueFailure<T> {
  const ShortOrNullCharacters({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortOrNullCharacters<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}

final class InvalidFormat<T> extends ValueFailure<T> {
  const InvalidFormat({required this.failedValue});
  final T failedValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvalidFormat<T> && failedValue == other.failedValue;

  @override
  int get hashCode => failedValue.hashCode;
}
```

**CRITICAL:** `const` constructors with `==` overrides work in Dart — the `==` override coexists with
const canonicalization. For compile-time constants, `identical()` still returns true (fast path).
For runtime instances, structural equality is now used.

---

### Task 3: EmptyWageHourlyView Deletion — Exact Specifications

**Current file (`wage_hourly_other_view.dart`):** Contains both `ShimmerWageHourlyView` (used) and
`EmptyWageHourlyView` (unused — no `FetchWageEmpty` state exists after migration in story 3.4).

**After deletion:** File contains ONLY `ShimmerWageHourlyView`:

```dart
import 'package:flutter/material.dart';

class ShimmerWageHourlyView extends StatelessWidget {
  const ShimmerWageHourlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
```

**`widgets.dart` barrel — NO CHANGE needed.** It exports `wage_hourly_other_view.dart` by file,
not by class name. After deletion, the barrel still exports the file — which now only contains
`ShimmerWageHourlyView`. No update required.

---

### Task 5: Loading Guard Pattern — Exact Specifications

**Reference implementation (`set_wage_button.dart:18` — the P-1 pattern, CONFIRMED in current codebase):**

```dart
// set_wage_button.dart — BlocConsumer<UpdateWageBloc, UpdateWageState>
onPressed: state is UpdateWageLoading
    ? null
    : () => context.read<UpdateWageBloc>().add(
          const UpdateWageSubmitted(),
        ),
```

**IMPORTANT:** `UpdateWageButton` (`update_wage_button.dart`) is a **dialog launcher** — it opens `UpdateWagePage` via `showDialog` and needs NO loading guard. The P-1 pattern applies ONLY to `UpdateTimeButton` and `DeleteTimeButton`.

**`update_time_button.dart` — apply guard:**

```dart
// BEFORE:
onPressed: () {
  context.read<UpdateTimeBloc>().add(
        const UpdateTimeSubmitted(),
      );
},

// AFTER:
onPressed: state is UpdateTimeLoading
    ? null
    : () {
        context.read<UpdateTimeBloc>().add(
              const UpdateTimeSubmitted(),
            );
      },
```

**`delete_time_button.dart` — apply guard:**

```dart
// BEFORE:
onPressed: () {
  context.read<DeleteTimeBloc>().add(
        DeleteTimeRequested(time: time),
      );
},

// AFTER:
onPressed: state is DeleteTimeLoading
    ? null
    : () {
        context.read<DeleteTimeBloc>().add(
              DeleteTimeRequested(time: time),
            );
      },
```

**DO NOT** change the `BlocConsumer` to `BlocBuilder` — both buttons have a meaningful `listener`
that calls `Navigator.of(context).pop()` on success. Keep `BlocConsumer` as-is, only patch `onPressed`.

---

### Task 6: File Rename — Exact Specifications

**Rename #1:** `list_times_screen.dart` → `list_times_page.dart` + `ListTimesScreen` → `ListTimesPage`

**⚠️ CRITICAL PRESERVATION:** `list_times_screen.dart` contains a `BlocConsumer` listener added in story 3.5 (CR-3.5 Task 9.4) that calls `context.read<PaymentCubit>().setTimes(const [])` on `ListTimesEmpty` and `ListTimesError` states. This logic **MUST** be preserved verbatim in the renamed file — it prevents stale `PaymentReady` state when all times are deleted or an error occurs. Only rename — do NOT recreate the file from scratch.

Current file content of `list_times_screen.dart` (replace `Screen` → `Page` in class name only):

```dart
// list_times_page.dart — RENAME: ListTimesScreen → ListTimesPage
class ListTimesPage extends StatelessWidget {    // ← changed
  const ListTimesPage({super.key});              // ← changed
  // ... rest of build() unchanged — including BlocConsumer listener ...
}

class _ActionWidget extends StatelessWidget {
  // ... unchanged ...
}
```

**`pages.dart` barrel (times feature) — update one line:**
```dart
// BEFORE:
export 'list_times_screen.dart';
// AFTER:
export 'list_times_page.dart';
```

**`home_page.dart` — update import AND widget usage:**
```dart
// BEFORE (import):
import 'package:time_money/src/features/times/presentation/pages/list_times_screen.dart';
// AFTER (import):
import 'package:time_money/src/features/times/presentation/pages/list_times_page.dart';

// BEFORE (usage in body):
const Expanded(child: ListTimesScreen()),
// AFTER:
const Expanded(child: ListTimesPage()),
```

---

**Rename #2:** `fetch_wage_screen.dart` → `fetch_wage_page.dart` + `FetchWageScreen` → `FetchWagePage`

```dart
// fetch_wage_page.dart — RENAME: FetchWageScreen → FetchWagePage
class FetchWagePage extends StatelessWidget {    // ← changed
  const FetchWagePage({super.key});              // ← changed
  // ... rest of build() unchanged ...
}

class _ActionWidget extends StatelessWidget {
  // ... unchanged ...
}
```

**`pages.dart` barrel (wage feature) — update one line:**
```dart
// BEFORE:
export 'fetch_wage_screen.dart';
// AFTER:
export 'fetch_wage_page.dart';
```

**`home_page.dart` — update import AND widget usage:**
```dart
// BEFORE (import):
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_screen.dart';
// AFTER:
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_page.dart';

// BEFORE (usage in body):
const FetchWageScreen(),
// AFTER:
const FetchWagePage(),
```

**After both renames, `home_page.dart` imports section looks like:**
```dart
import 'package:time_money/src/features/times/presentation/pages/list_times_page.dart';
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_page.dart';
```

**Mandatory grep after renames:** Run a codebase-wide search for `ListTimesScreen`, `list_times_screen`,
`FetchWageScreen`, `fetch_wage_screen` to catch any remaining references not covered above.

---

### Testing Requirements

**`test/src/core/errors/failures_test.dart` — ADD these test groups (append to existing `main()`):**

```dart
group('GlobalFailure structural equality', () {
  test('InternalError equal when error is same (ignores stackTrace)', () {
    final st = StackTrace.current;
    expect(InternalError('msg'), InternalError('msg'));
    expect(InternalError('msg', st), InternalError('msg'));      // stackTrace ignored
    expect(InternalError('msg'), const InternalError('msg'));    // const vs runtime
  });

  test('InternalError not equal when error differs', () {
    expect(InternalError('a'), isNot(InternalError('b')));
  });

  test('InternalError hashCode stable across instances', () {
    expect(InternalError('msg').hashCode, InternalError('msg').hashCode);
  });

  test('ServerError equal when failure is same', () {
    expect(ServerError('500'), ServerError('500'));
    expect(const ServerError('500'), ServerError('500'));
  });

  test('NotConnection instances are equal', () {
    expect(NotConnection(), NotConnection());
    expect(const NotConnection(), NotConnection());
  });

  test('TimeOutExceeded instances are equal', () {
    expect(TimeOutExceeded(), TimeOutExceeded());
  });
});

group('ValueFailure structural equality', () {
  test('CharacterLimitExceeded equal when failedValue same', () {
    expect(
      CharacterLimitExceeded<String>(failedValue: 'x'),
      CharacterLimitExceeded<String>(failedValue: 'x'),
    );
    expect(
      const CharacterLimitExceeded<String>(failedValue: 'x'),
      CharacterLimitExceeded<String>(failedValue: 'x'),
    );
  });

  test('CharacterLimitExceeded not equal when failedValue differs', () {
    expect(
      const CharacterLimitExceeded<String>(failedValue: 'a'),
      isNot(const CharacterLimitExceeded<String>(failedValue: 'b')),
    );
  });

  test('ShortOrNullCharacters equal when failedValue same', () {
    expect(
      ShortOrNullCharacters<String>(failedValue: ''),
      ShortOrNullCharacters<String>(failedValue: ''),
    );
  });

  test('InvalidFormat equal when failedValue same', () {
    expect(
      InvalidFormat<String>(failedValue: 'bad'),
      InvalidFormat<String>(failedValue: 'bad'),
    );
  });
});
```

**No new test files required** for the loading guard changes or the file renames.
Widget tests for `UpdateTimeButton`/`DeleteTimeButton` (with loading state assertions) are
Epic 5 scope (Story 5.1) — not required in this story.

---

### Deferred Items Status — Explicit Resolution

| Item | Origin | Status in 3.6 |
|---|---|---|
| DEFERRED-1: GlobalFailure equality | 3.3/3.4 CR | ✅ FIXED — `==`/`hashCode` added to all variants |
| DEFERRED-2: EmptyWageHourlyView orphaned | 3.4 | ✅ FIXED — class deleted |
| DEFERRED-3: StackTrace in error_view.dart | 3.1 D-3 | ✅ CLOSED — existing `developer.log` in `fromException` is sufficient; no widget-layer logging needed |
| DEFERRED-4: `_ActionWidget` no-op buttons | 3.3/3.4 | ✅ ACCEPTED AS-IS — UI/UX out of scope per PRD |
| DEFERRED-5: Emit-after-close race | 3.3 CR | ✅ ACCEPTED AS-IS — BLoC 9.x handles via `addError()`, no `isClosed` guards |
| DEFERRED-6: Double-tap concurrency | 3.3/3.4 | ✅ FIXED — loading guard added to UpdateTimeButton and DeleteTimeButton |

---

### Anti-Patterns — NEVER Do

- Do NOT use Freezed on `GlobalFailure` or `ValueFailure` — they are sealed classes, not data classes
- Do NOT add `Freezed` to any BLoC events or states — Freezed is ONLY for domain entities (`TimeEntry`, `WageHourly`)
- Do NOT include `stackTrace` in `InternalError.==` — it's a debugging artifact, not semantic identity
- Do NOT change the `BlocConsumer` pattern in `UpdateTimeButton`/`DeleteTimeButton` to `BlocBuilder` — listeners are meaningful (pop on success)
- Do NOT delete `ShimmerWageHourlyView` from `wage_hourly_other_view.dart` — it is still used
- Do NOT add `isClosed` guards to BLoC async handlers — anti-pattern in BLoC 9.x (DEFERRED-5)
- Do NOT rename `list_times_page.dart` class to anything other than `ListTimesPage` — follow `{Name}Page` convention
- Do NOT change any logic in renamed screen→page files — class renames only, behavior unchanged
- Do NOT apply loading guard to `UpdateWageButton` — it is a dialog launcher (`showDialog` → `UpdateWagePage`), not a submit action; the loading guard lives in `SetWageButton` inside the dialog (set_wage_button.dart:18)

### Project Structure Notes

**Modified files:**
- `lib/src/core/errors/failures.dart` (add equality to all variants)
- `lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart` (delete EmptyWageHourlyView)
- `lib/src/features/times/presentation/widgets/update_time_button.dart` (loading guard)
- `lib/src/features/times/presentation/widgets/delete_time_button.dart` (loading guard)
- `lib/src/features/home/presentation/pages/home_page.dart` (update imports + widget names)
- `test/src/core/errors/failures_test.dart` (add equality tests)

**Renamed files (create new, delete old):**
- `list_times_screen.dart` → `list_times_page.dart` (class: ListTimesPage)
- `fetch_wage_screen.dart` → `fetch_wage_page.dart` (class: FetchWagePage)

**Barrel files updated:**
- `lib/src/features/times/presentation/pages/pages.dart`
- `lib/src/features/wage/presentation/pages/pages.dart`

**Unchanged files (verified correct):**
- `lib/src/features/times/domain/entities/time_entry.dart` + generated files ✅
- `lib/src/features/wage/domain/entities/wage_hourly.dart` + generated files ✅
- `lib/src/shared/widgets/error_view.dart` — StackTrace handling resolved by existing `fromException` logging
- `lib/src/features/wage/presentation/widgets/widgets.dart` barrel — exports file, no class-level changes needed
- All BLoC event/state files — no Freezed annotation ✅

### References

- [epics.md — Epic 3, Story 3.6, FR41, NFR6, NFR7, NFR8]
- [architecture.md — Naming Conventions table, Enforcement Guidelines]
- [3-5-payment-feature-cubit-modernization-cross-feature-composition.md — Accumulated Deferred Items section]
- [3-4-wage-feature-sealed-class-bloc-migration.md — P-1 pattern: SetWageButton loading guard]

## Dev Agent Record

### Agent Model Used

claude-opus-4-6

### Debug Log References

N/A

### Completion Notes List

- ✅ Task 1: Verified Freezed entities — `time_entry.dart` and `wage_hourly.dart` both have `@freezed` with `.freezed.dart` and `.g.dart` present. `@freezed` annotation is absent from all BLoC event/state/failure files (confirmed grep). No code changes required.
- ✅ Task 2: Added `==` and `hashCode` to all 7 failure variants in `failures.dart`. Added `@immutable` to all `final class` failure types to satisfy `avoid_equals_and_hash_code_on_mutable_classes` lint rule. `InternalError.==` compares `error` only, ignoring `stackTrace` per design decision. Added 10 new structural equality tests to `failures_test.dart`. Tests use genuinely non-const runtime instances (InternalError with StackTrace.current, fromException for NotConnection/TimeOutExceeded, StringBuffer().toString() for value types) to verify the == override is exercised, not Dart's const canonicalization (identical() fast path).
- ✅ Task 3: Deleted `EmptyWageHourlyView` from `wage_hourly_other_view.dart`. Also removed the now-unused `widgets.dart` import. `ShimmerWageHourlyView` remains and is used correctly by `fetch_wage_page.dart`.
- ✅ Task 4: Confirmed `GlobalFailure.fromException` already logs via `developer.log` in debug mode (line 33 of failures.dart). No code changes required. DEFERRED-3 closed.
- ✅ Task 5: Added `state is UpdateTimeLoading ? null :` guard to `UpdateTimeButton.onPressed`. Added `state is DeleteTimeLoading ? null :` guard to `DeleteTimeButton.onPressed`. `BlocConsumer` pattern preserved (listeners call `Navigator.of(context).pop()` on success). Confirmed `UpdateWageButton` is a dialog launcher — no guard needed.
- ✅ Task 6: Renamed `list_times_screen.dart` → `list_times_page.dart` (class `ListTimesPage`); renamed `fetch_wage_screen.dart` → `fetch_wage_page.dart` (class `FetchWagePage`). Updated both barrel files and `home_page.dart`. BlocConsumer listener that calls `context.read<PaymentCubit>().setTimes(const [])` preserved verbatim. Updated `docs/component-inventory.md` and `docs/source-tree-analysis.md`. Codebase-wide grep confirmed zero remaining references to old names in `lib/` and `test/`.
- ✅ Task 7: `flutter analyze` — zero issues. `flutter test` — 116 tests passed (106 existing + 10 new equality tests). Zero regressions.

### Code Review Record

**Reviewer model:** claude-sonnet-4-6
**Review date:** 2026-03-19
**Review layers:** Blind Hunter (adversarial) + Edge Case Hunter (boundary) + Acceptance Auditor (AC compliance)
**Raw findings:** 15 | **Rejected (noise/false positives):** 11 | **Bad spec (amended):** 1 | **Patched:** 2 | **Deferred:** 1

**CR patches applied:**
- ✅ CR-1 (D-1): `DeleteTimeButton` and `UpdateTimeButton` — expanded guard from `state is *Loading ? null :` to `state is *Initial ? action : null`; prevents double-tap during `AppDurations.actionFeedback` window in `Success` and `Error` states
- ✅ CR-2 (D-2): `DeleteTimeButton` and `UpdateTimeButton` listeners — wrapped `Navigator.of(context).pop()` with `if (Navigator.of(context).canPop())` guard; prevents `FlutterError` if widget ever renders outside a popable route
- ✅ BS-1: AC5 text amended — clarified that guard covers all non-Initial states and that `UpdateWageButton` explicitly does NOT receive a guard (dialog launcher)

**Deferred from this review:**
- DEFER-CR-1: `FetchWagePage._ActionWidget.onPressed` is a no-op `() {}` — retry button does nothing on error state. Pre-existing (DEFERRED-4). Out of scope per PRD. → Epic 4/5 scope.

### Change Log

- 2026-03-19: Implemented story 3.6 — added structural equality (`==`/`hashCode` + `@immutable`) to all 7 failure variants; deleted dead code `EmptyWageHourlyView`; added loading guards to `UpdateTimeButton` and `DeleteTimeButton`; renamed screen→page files (`ListTimesPage`, `FetchWagePage`) with all references updated; added 10 equality tests; flutter analyze zero issues, 116 tests green.
- 2026-03-19: Code review passed — 2 patches applied (expanded button guard to all non-Initial states; added canPop() to Navigator.pop() calls); AC5 amended; 1 defer documented (FetchWagePage no-op retry button → Epic 4/5).

### File List

**Modified files:**
- `lib/src/core/errors/failures.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart`
- `lib/src/features/times/presentation/widgets/update_time_button.dart`
- `lib/src/features/times/presentation/widgets/delete_time_button.dart`
- `lib/src/features/home/presentation/pages/home_page.dart`
- `lib/src/features/times/presentation/pages/pages.dart`
- `lib/src/features/wage/presentation/pages/pages.dart`
- `test/src/core/errors/failures_test.dart`

**Created files (rename output):**
- `lib/src/features/times/presentation/pages/list_times_page.dart`
- `lib/src/features/wage/presentation/pages/fetch_wage_page.dart`

**Deleted files (rename source):**
- `lib/src/features/times/presentation/pages/list_times_screen.dart`
- `lib/src/features/wage/presentation/pages/fetch_wage_screen.dart`
