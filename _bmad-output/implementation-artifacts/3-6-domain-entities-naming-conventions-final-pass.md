# Story 3.6: Domain Entities & Naming Conventions Final Pass

Status: ready-for-dev

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

5. **Loading guard on action buttons** — `UpdateTimeButton` and `DeleteTimeButton` disable `onPressed` when state is `UpdateTimeLoading` / `DeleteTimeLoading` (same P-1 pattern as `SetWageButton` from story 3.4); verify `UpdateWageButton` also has or receives the same guard

6. **Naming conventions final pass — screen → page rename** — `list_times_screen.dart` → `list_times_page.dart` (class `ListTimesScreen` → `ListTimesPage`); `fetch_wage_screen.dart` → `fetch_wage_page.dart` (class `FetchWageScreen` → `FetchWagePage`); all references updated (barrel exports, `home_page.dart` imports and widget usage); NFR8 satisfied

7. **Zero warnings and zero dead code** — `flutter analyze` produces zero issues on all modified and created files; `flutter test` passes all existing tests plus new equality tests (NFR6, NFR7)

## Tasks / Subtasks

- [ ] Task 1: Verify Freezed entities (AC: #1)
  - [ ] 1.1 Confirm `time_entry.dart` uses `@freezed` with `.freezed.dart` and `.g.dart` present — READ ONLY, no code changes
  - [ ] 1.2 Confirm `wage_hourly.dart` uses `@freezed` with `.freezed.dart` and `.g.dart` present — READ ONLY, no code changes
  - [ ] 1.3 Confirm Freezed annotation is NOT used in any BLoC event, BLoC state, or failure type file — READ ONLY

- [ ] Task 2: Fix GlobalFailure and ValueFailure equality (AC: #2, DEFERRED-1)
  - [ ] 2.1 Add `==` and `hashCode` to `InternalError` — compare `error` only, NOT `stackTrace`
  - [ ] 2.2 Add `==` and `hashCode` to `ServerError` — compare `failure` field
  - [ ] 2.3 Add `==` and `hashCode` to `NotConnection` — no fields, runtimeType-based
  - [ ] 2.4 Add `==` and `hashCode` to `TimeOutExceeded` — no fields, runtimeType-based
  - [ ] 2.5 Add `==` and `hashCode` to `CharacterLimitExceeded<T>` — compare `failedValue`
  - [ ] 2.6 Add `==` and `hashCode` to `ShortOrNullCharacters<T>` — compare `failedValue`
  - [ ] 2.7 Add `==` and `hashCode` to `InvalidFormat<T>` — compare `failedValue`
  - [ ] 2.8 Update `test/src/core/errors/failures_test.dart` — add structural equality tests (see Testing Requirements)

- [ ] Task 3: Delete EmptyWageHourlyView (AC: #3, DEFERRED-2)
  - [ ] 3.1 Remove `EmptyWageHourlyView` class from `wage_hourly_other_view.dart`; keep `ShimmerWageHourlyView`
  - [ ] 3.2 Verify `fetch_wage_page.dart` still uses only `ShimmerWageHourlyView` — no breakage

- [ ] Task 4: Confirm StackTrace resolution (AC: #4, DEFERRED-3)
  - [ ] 4.1 READ `lib/src/core/errors/failures.dart` — confirm `GlobalFailure.fromException` logs via `developer.log` (already verified, line 33)
  - [ ] 4.2 No code changes required — this deferred is resolved by existing debug logging

- [ ] Task 5: Add loading guard to action buttons (AC: #5, DEFERRED-6)
  - [ ] 5.1 Update `update_time_button.dart` — add `state is UpdateTimeLoading ? null :` guard on `onPressed`
  - [ ] 5.2 Update `delete_time_button.dart` — add `state is DeleteTimeLoading ? null :` guard on `onPressed`
  - [ ] 5.3 READ `lib/src/features/wage/presentation/widgets/update_wage_button.dart` — verify if it already has loading guard; if not, apply same pattern

- [ ] Task 6: Rename screen → page files (AC: #6, NFR8)
  - [ ] 6.1 Rename `list_times_screen.dart` → `list_times_page.dart`; rename class `ListTimesScreen` → `ListTimesPage`
  - [ ] 6.2 Update `lib/src/features/times/presentation/pages/pages.dart` barrel: `list_times_screen.dart` → `list_times_page.dart`
  - [ ] 6.3 Update `lib/src/features/home/presentation/pages/home_page.dart`: update import path and widget usage (`ListTimesScreen()` → `ListTimesPage()`)
  - [ ] 6.4 Rename `fetch_wage_screen.dart` → `fetch_wage_page.dart`; rename class `FetchWageScreen` → `FetchWagePage`
  - [ ] 6.5 Update `lib/src/features/wage/presentation/pages/pages.dart` barrel: `fetch_wage_screen.dart` → `fetch_wage_page.dart`
  - [ ] 6.6 Update `lib/src/features/home/presentation/pages/home_page.dart`: update import path and widget usage (`FetchWageScreen()` → `FetchWagePage()`)
  - [ ] 6.7 Grep codebase for any remaining `ListTimesScreen` or `FetchWageScreen` references — update all

- [ ] Task 7: Verification (AC: #7)
  - [ ] 7.1 Run `flutter analyze` — zero issues
  - [ ] 7.2 Run `flutter test` — all tests pass (existing 106 + new equality tests)

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

**ValueFailure variants — same pattern (example for CharacterLimitExceeded):**

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
```

Apply the exact same pattern to `ShortOrNullCharacters<T>` and `InvalidFormat<T>`.

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

**Reference implementation (`set_wage_button.dart` — the P-1 pattern):**

```dart
onPressed: state is UpdateWageLoading
    ? null
    : () => context.read<UpdateWageBloc>().add(
          const UpdateWageSubmitted(),
        ),
```

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

Current file content of `list_times_screen.dart` (replace `Screen` → `Page` in class name only):

```dart
// list_times_page.dart — RENAME: ListTimesScreen → ListTimesPage
class ListTimesPage extends StatelessWidget {    // ← changed
  const ListTimesPage({super.key});              // ← changed
  // ... rest of build() unchanged ...
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

<!-- To be filled by dev agent -->

### Debug Log References

N/A

### Completion Notes List

<!-- To be filled by dev agent -->

### Change Log

<!-- To be filled by dev agent -->

### File List

<!-- To be filled by dev agent -->
