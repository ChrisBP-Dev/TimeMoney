# Story 3.3: Times Feature — Update & Delete BLoC Migration

Status: review

## Story

As a user,
I want to edit and delete existing time entries using modern reactive patterns,
so that correcting mistakes and removing entries remains fast with proper visual feedback (FR3, FR4, FR5, FR40, FR42).

## Acceptance Criteria

1. **UpdateTimeBloc migrated to sealed classes** — `sealed class UpdateTimeEvent` with variants `UpdateTimeInit`, `UpdateTimeHourChanged`, `UpdateTimeMinutesChanged`, `UpdateTimeSubmitted`; `sealed class UpdateTimeState` with form data on sealed base (hour, minutes, time) and variants `UpdateTimeInitial`, `UpdateTimeLoading`, `UpdateTimeSuccess`, `UpdateTimeError`; all variants use `final class` with `const` constructors; handler maps Either results to states via `result.fold()`; success triggers `AppDurations.actionFeedback` delay then auto-resets (FR42); update dialog pre-populates with current values (FR3)
2. **DeleteTimeBloc migrated to sealed classes** — `sealed class DeleteTimeEvent` with variant `DeleteTimeRequested`; `sealed class DeleteTimeState` with variants `DeleteTimeInitial`, `DeleteTimeLoading`, `DeleteTimeSuccess`, `DeleteTimeError`; all variants use `final class` with `const` constructors; delete provides ActionState feedback (FR4); success triggers `AppDurations.actionFeedback` delay then auto-resets (FR42)
3. **Presentation widgets use `switch` expressions** — `BlocBuilder`/`BlocConsumer` widgets for UpdateTimeBloc and DeleteTimeBloc use exhaustive pattern matching; state field destructuring used; zero `if/else` chains and zero `.when()` calls on state types remain
4. **Functional behavior preserved** — user can edit with pre-populated values (FR3), delete entries (FR4), visual feedback shows for update and delete actions (FR5)
5. **Tests written alongside implementation** — `update_time_use_case_test.dart`, `delete_time_use_case_test.dart`, `update_time_bloc_test.dart`, `delete_time_bloc_test.dart`, plus update/delete groups added to `objectbox_times_repository_test.dart` (deferred from 3.2) — all verify state transitions, 100% coverage, all passing
6. **Zero warnings** on `flutter analyze` for all modified and created files

## Tasks / Subtasks

- [x] Task 1: Migrate UpdateTimeBloc to sealed classes (AC: #1)
  - [x] 1.1 Create standalone `update_time_event.dart` with sealed class (remove `part of`)
  - [x] 1.2 Create standalone `update_time_state.dart` with sealed class and form data on base (remove `part of`)
  - [x] 1.3 Rewrite `update_time_bloc.dart` — remove Freezed imports/parts, use standalone imports/exports, explicit state construction
  - [x] 1.4 Delete `update_time_bloc.freezed.dart`
- [x] Task 2: Migrate DeleteTimeBloc to sealed classes (AC: #2)
  - [x] 2.1 Create standalone `delete_time_event.dart` with sealed class (remove `part of`)
  - [x] 2.2 Create standalone `delete_time_state.dart` with sealed class (remove `part of`)
  - [x] 2.3 Rewrite `delete_time_bloc.dart` — remove Freezed imports/parts, use standalone imports/exports, fix the missing emit bug, explicit state construction
  - [x] 2.4 Delete `delete_time_bloc.freezed.dart`
- [x] Task 3: Update presentation widgets (AC: #3)
  - [x] 3.1 Update `update_time_button.dart` — use `BlocConsumer` with `listenWhen` for success → `Navigator.pop()`, `switch` expression on sealed state
  - [x] 3.2 Update `delete_time_button.dart` — replace `.when()` with `switch` expression, use `BlocConsumer` with `listenWhen` for success → `Navigator.pop()`
  - [x] 3.3 Update `update_hour_field.dart` — replace `BlocConsumer` no-op listener with `BlocBuilder`, update event syntax
  - [x] 3.4 Update `update_minutes_field.dart` — same pattern as hour field
  - [x] 3.5 Update `edit_button.dart` — change `UpdateTimeEvent.init(time: time)` to `UpdateTimeInit(time: time)`
- [x] Task 4: Write use case and repository tests (AC: #5)
  - [x] 4.1 Create `test/src/features/times/domain/use_cases/update_time_use_case_test.dart`
  - [x] 4.2 Create `test/src/features/times/domain/use_cases/delete_time_use_case_test.dart`
  - [x] 4.3 Add update/delete test groups to existing `test/src/features/times/data/repositories/objectbox_times_repository_test.dart` (deferred from Story 3.2)
- [x] Task 5: Write BLoC tests (AC: #5)
  - [x] 5.1 Create `test/src/features/times/presentation/bloc/update_time_bloc_test.dart`
  - [x] 5.2 Create `test/src/features/times/presentation/bloc/delete_time_bloc_test.dart`
- [x] Task 6: Verification (AC: #4, #6)
  - [x] 6.1 Run `flutter analyze` — zero warnings on non-generated code
  - [x] 6.2 Run `flutter test` — all tests pass (68/68)
  - [x] 6.3 Verify app launches and update/delete features work with pre-populated values and visual feedback

## Dev Notes

### Critical Architecture Patterns

Follow the exact sealed class patterns established in Story 3.2. The reference implementations are:
- **Event pattern:** `lib/src/features/times/presentation/bloc/create_time_event.dart`
- **State pattern (form data on base):** `lib/src/features/times/presentation/bloc/create_time_state.dart`
- **BLoC pattern:** `lib/src/features/times/presentation/bloc/create_time_bloc.dart`
- **Simple state pattern (no form data):** `lib/src/features/times/presentation/bloc/list_times_state.dart`

### UpdateTimeBloc Migration — Exact Specifications

**Current state (Freezed):** Uses `part of`, `@freezed`, `copyWith()`, `ActionState<TimeEntry>` wrapper for currentState field.

**Target state (Sealed):** Standalone files with own imports. Form data (`hour`, `minutes`, `time`) on sealed base class. No `ActionState` wrapper — states themselves represent the action lifecycle.

**Event sealed class** (`update_time_event.dart`):
```dart
sealed class UpdateTimeEvent {
  const UpdateTimeEvent();
}

final class UpdateTimeInit extends UpdateTimeEvent {
  const UpdateTimeInit({required this.time});
  final TimeEntry time;
}

final class UpdateTimeHourChanged extends UpdateTimeEvent {
  const UpdateTimeHourChanged({required this.value});
  final String value;
}

final class UpdateTimeMinutesChanged extends UpdateTimeEvent {
  const UpdateTimeMinutesChanged({required this.value});
  final String value;
}

final class UpdateTimeSubmitted extends UpdateTimeEvent {
  const UpdateTimeSubmitted();
}
```

**State sealed class** (`update_time_state.dart`):
- Sealed base carries `hour`, `minutes`, `time` (nullable `TimeEntry?`) fields — form data persists across transitions
- `@immutable` annotation on sealed base
- Variants: `UpdateTimeInitial`, `UpdateTimeLoading`, `UpdateTimeSuccess`, `UpdateTimeError`
- `UpdateTimeSuccess` carries `TimeEntry timeEntry` result field
- `UpdateTimeError` carries `GlobalFailure failure` field
- **ALL variants override `==` and `hashCode`** — every variant inherits `hour`, `minutes`, `time` from the base, making them ALL data-carrying; `UpdateTimeInitial` compares `hour`, `minutes`, `time`; `UpdateTimeLoading` compares `hour`, `minutes`, `time`; `UpdateTimeSuccess` compares `timeEntry`, `hour`, `minutes`, `time`; `UpdateTimeError` compares `failure`, `hour`, `minutes`, `time`; use `Object.hash(...)` for `hashCode`
- Import `flutter/foundation.dart` for `@immutable`
- **Follow CreateTimeState pattern exactly** — use `super.hour`, `super.minutes`, `super.time` in variant constructors

**BLoC rewrite** (`update_time_bloc.dart`):
- Remove ALL: `part` directives, `freezed_annotation` import, `.freezed.dart` part
- Add: standalone imports for event/state files + `export` both
- Constructor calls `super(const UpdateTimeInitial())` not `UpdateTimeState.initial()`
- `on<UpdateTimeInit>`: emit `UpdateTimeInitial` with `time`, `hour: time.hour`, `minutes: time.minutes`
- `on<UpdateTimeHourChanged>`: parse int, emit `UpdateTimeInitial` with updated hour, preserved minutes and time with `time?.copyWith(hour: hour)`
- `on<UpdateTimeMinutesChanged>`: same pattern with minutes
- `on<UpdateTimeSubmitted>`: capture locals before async → emit Loading → call use case → fold to Success/Error → delay → auto-reset to Initial
- `_emitError`: capture locals → emit Error → delay → emit Initial (restoring form values)
- **Race condition prevention:** always capture `state.hour`, `state.minutes`, `state.time` into local variables before any `await`

### DeleteTimeBloc Migration — Exact Specifications

**Current state (Freezed):** Uses `part of`, `@freezed`, `.when()`. **CRITICAL BUG:** current `_onDelete` handler does `result.fold(...)` but NEVER emits the fold result — it folds without using the value. The success/error states are lost.

**Target state (Sealed):** Standalone files. Simple state pattern (no form data on base — matches ListTimesState pattern).

**Event sealed class** (`delete_time_event.dart`):
```dart
sealed class DeleteTimeEvent {
  const DeleteTimeEvent();
}

final class DeleteTimeRequested extends DeleteTimeEvent {
  const DeleteTimeRequested({required this.time});
  final TimeEntry time;
}
```
- Rename from `_Delete` to `DeleteTimeRequested` (past-tense naming convention)

**State sealed class** (`delete_time_state.dart`):
```dart
@immutable
sealed class DeleteTimeState {
  const DeleteTimeState();
}

final class DeleteTimeInitial extends DeleteTimeState {
  const DeleteTimeInitial();
}

final class DeleteTimeLoading extends DeleteTimeState {
  const DeleteTimeLoading();
}

final class DeleteTimeSuccess extends DeleteTimeState {
  const DeleteTimeSuccess();
}

final class DeleteTimeError extends DeleteTimeState {
  const DeleteTimeError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTimeError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
```

**BLoC rewrite** (`delete_time_bloc.dart`):
- Remove ALL: `part` directives, `freezed_annotation` import, `.freezed.dart` part
- Add: standalone imports + `export` both event/state files
- Constructor: `super(const DeleteTimeInitial())`
- Handler `_onDelete`:
  1. `emit(const DeleteTimeLoading())`
  2. `final result = await _deleteTimeUseCase.call(event.time)`
  3. `result.fold((f) => emit(DeleteTimeError(f)), (_) => emit(const DeleteTimeSuccess()))` — **FIX THE BUG: actually emit the fold result**
  4. `await Future.delayed(AppDurations.actionFeedback)`
  5. `emit(const DeleteTimeInitial())`
- **Move the delay AFTER the fold emit, not before** (current code delays before the use case call — wrong pattern)

### Presentation Widget Updates

**`update_time_button.dart`:**
- Currently: `BlocConsumer` with no-op listener, renders `switch (state.currentState)` on `ActionState`
- Target: `BlocConsumer` with `listenWhen: (prev, curr) => curr is UpdateTimeSuccess`, listener does `Navigator.pop(context)`. Builder renders `switch (state)` on `UpdateTimeState` sealed class:
  ```dart
  child: switch (state) {
    UpdateTimeInitial() => const Text('Update'),
    UpdateTimeLoading() => const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
    UpdateTimeSuccess() => const Text('Success'),
    UpdateTimeError() => const Text('Error'),
  },
  ```
- Remove manual `await Future.delayed` + `Navigator.pop()` from `onPressed` — let BlocConsumer listener handle navigation on success state
- `onPressed` just adds `const UpdateTimeSubmitted()` event

**`delete_time_button.dart`:**
- Currently: uses `.when()` (Freezed method)
- Target: `BlocConsumer` with `listenWhen: (prev, curr) => curr is DeleteTimeSuccess`, listener does `Navigator.pop(context)`. Builder renders `switch (state)`:
  ```dart
  child: switch (state) {
    DeleteTimeInitial() => const Text('Delete'),
    DeleteTimeLoading() => const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
    DeleteTimeSuccess() => const Text('Success'),
    DeleteTimeError() => const Text('Error'),
  },
  ```
- Remove manual `await Future.delayed` + `Navigator.pop()` from `onPressed`
- `onPressed` just adds `DeleteTimeRequested(time: time)` event

**`update_hour_field.dart`:**
- Replace `BlocConsumer` with no-op listener → `BlocBuilder`
- Update event: `UpdateTimeHourChanged(value: value)` instead of `UpdateTimeEvent.changeHour(value: value)`

**`update_minutes_field.dart`:**
- Same pattern as hour field
- Update event: `UpdateTimeMinutesChanged(value: value)` instead of `UpdateTimeEvent.changeMinutes(value: value)`

**`edit_button.dart`:**
- Change `UpdateTimeEvent.init(time: time)` → `UpdateTimeInit(time: time)` (Freezed factory → sealed class constructor)
- No other changes needed — widget structure is correct

### Testing Requirements

**Use case tests** — follow patterns from Story 3.2 (`create_time_use_case_test.dart`, `list_times_use_case_test.dart`):

`update_time_use_case_test.dart`:
- Mock `TimesRepository` using `MockTimesRepository` from `test/helpers/mocks.dart`
- Register fallback: `registerFallbackValue(TimeEntry(...))` in `setUpAll`
- Test success: mock returns `Right(timeEntry)`, verify result is `Right` with exact value
- Test error: mock returns `Left(GlobalFailure)`, verify result is `Left` with exact failure
- Verify repository called once

`delete_time_use_case_test.dart`:
- Same pattern but `DeleteTimeResult` returns `Either<GlobalFailure, Unit>`
- Test success: mock returns `Right(unit)`
- Test error: mock returns `Left(GlobalFailure)`

**Repository tests** — add to existing `objectbox_times_repository_test.dart` (deferred from Story 3.2):

Existing test file structure (must match):
- Mock: `class MockTimesObjectboxDatasource extends Mock implements TimesObjectboxDatasource {}` (already defined in the file, NOT in `test/helpers/mocks.dart`)
- `setUpAll`: `registerFallbackValue(TimeBox(hour: 0, minutes: 0))` (already registered)
- `setUp`: creates fresh `mockDatasource` and `repository = ObjectboxTimesRepository(mockDatasource)` per test
- Existing groups: `fetchTimesStream` (2 tests), `create` (2 tests)
- Assertion pattern: `expect(result, const Right<dynamic, TimeEntry>(testTime))` for success, `expect(result.isLeft(), true)` for error
- Uses `const testTime = TimeEntry(hour: 1, minutes: 30)` (already declared in `create` group — declare equivalent in new groups or share)

`update` test group — add after `create` group:
- Test success: `when(() => mockDatasource.put(any())).thenReturn(1)`, call `repository.update(testTime)`, verify `Right(timeEntry)` returned
- Test error: `when(() => mockDatasource.put(any())).thenThrow(Exception('fail'))`, verify `Left(GlobalFailure)` returned
- Verify `mockDatasource.put(any())` called once

`delete` test group — add after `update` group:
- Test success: `when(() => mockDatasource.remove(any())).thenReturn(true)`, call `repository.delete(testTime)`, verify `Right(unit)` returned
- Test error: `when(() => mockDatasource.remove(any())).thenThrow(Exception('fail'))`, verify `Left(GlobalFailure)` returned
- Verify `mockDatasource.remove(any())` called once

**BLoC tests** — follow patterns from Story 3.2 (`create_time_bloc_test.dart`, `list_times_bloc_test.dart`):

`update_time_bloc_test.dart`:
- Use `bloc_test` package with `blocTest<UpdateTimeBloc, UpdateTimeState>`
- Mock `UpdateTimeUseCase` using `MockUpdateTimeUseCase` from `test/helpers/mocks.dart`
- **`setUpAll`:** `registerFallbackValue(const TimeEntry(hour: 0, minutes: 0))` — required for `any()` matcher on `TimeEntry` parameter in mocktail
- **`wait` parameter:** ALL `blocTest` calls involving async operations (submit, validation errors with delay) MUST use `wait: const Duration(seconds: 2)` — without it, assertions fail because delay-driven transitions haven't completed
- **`seed` parameter:** Tests for `UpdateTimeSubmitted` and field changes MUST use `seed: () => UpdateTimeInitial(hour: X, minutes: Y, time: testTime)` to simulate pre-populated edit form
- Tests required:
  - Initial state is `UpdateTimeInitial` (hour: 0, minutes: 0, time: null)
  - `UpdateTimeInit` → emits `UpdateTimeInitial` with time, hour: time.hour, minutes: time.minutes
  - `UpdateTimeHourChanged` valid → emits `UpdateTimeInitial` with updated hour, preserved minutes and time
  - `UpdateTimeHourChanged` invalid → emits Error → delays → emits Initial (restoring values) — needs `wait`
  - `UpdateTimeMinutesChanged` valid/invalid — same patterns
  - `UpdateTimeSubmitted` success → Loading → Success → delay → Initial — needs `wait` and `seed`
  - `UpdateTimeSubmitted` error → Loading → Error → delay → Initial (preserving form values) — needs `wait` and `seed`
  - `UpdateTimeSubmitted` with null time → Error → delay → Initial — needs `wait`

`delete_time_bloc_test.dart`:
- Mock `DeleteTimeUseCase` using `MockDeleteTimeUseCase` from `test/helpers/mocks.dart`
- **`setUpAll`:** `registerFallbackValue(const TimeEntry(hour: 0, minutes: 0))` — required for `any()` matcher on `TimeEntry` parameter in mocktail
- **`wait` parameter:** ALL `blocTest` calls MUST use `wait: const Duration(seconds: 2)` — the handler has `AppDurations.actionFeedback` delay before auto-reset
- Tests required:
  - Initial state is `DeleteTimeInitial`
  - `DeleteTimeRequested` success → Loading → Success → delay → Initial — needs `wait`
  - `DeleteTimeRequested` error → Loading → Error → delay → Initial — needs `wait`

### Existing Mocks Available

All mocks already exist in `test/helpers/mocks.dart`:
- `MockTimesRepository`
- `MockUpdateTimeUseCase`
- `MockDeleteTimeUseCase`

No new mocks needed.

### Bug Fixes Included

1. **DeleteTimeBloc missing emit:** Current `delete_time_bloc.dart:23` does `result.fold(DeleteTimeState.error, (r) => const _Success())` but NEVER emits the result. The fold creates a state value that is discarded. Fix: properly emit inside fold callbacks.
2. **DeleteTimeBloc wrong delay placement:** Current code delays BEFORE calling the use case (line 19), then delays again AFTER (line 25). Should be: emit Loading → call use case → emit result → delay → reset.
3. **UpdateTimeButton/DeleteTimeButton manual navigation:** Current widgets manually delay and pop navigator in `onPressed`. This races with BLoC state. Fix: use `BlocConsumer` `listenWhen` for success → pop.
4. **UpdateHourField/UpdateMinutesField no-op listeners:** Current widgets use `BlocConsumer` with `listener: (context, state) => state` (no-op). Fix: replace with `BlocBuilder`.

### Anti-Patterns — NEVER Do

- Use `.when()` or `.map()` pattern matching (Freezed methods) — use native `switch` expressions
- Use `if/else` chains on sealed types — always exhaustive `switch`
- Use `copyWith()` on Freezed state — construct new sealed variants explicitly (note: `copyWith()` on domain entities like `TimeEntry` IS fine — they remain Freezed)
- Use `part of`/`part` for event/state files — standalone with own imports
- Use `ActionState<T>` wrapper for update BLoC states — sealed states ARE the action lifecycle
- Skip `AppDurations.actionFeedback` delay between transitions
- Use relative imports — always `package:time_money/src/...`
- Manually edit generated `.freezed.dart` or `.g.dart` files
- Skip `==` and `hashCode` overrides on ANY state variant that inherits or carries data fields
- Access `state.field` after an `await` without first capturing into a local variable (race condition)
- Omit `wait: const Duration(seconds: 2)` in `blocTest` calls that involve async delays — assertions will fail silently
- Use `BlocConsumer` with no-op listener — use `BlocBuilder` unless listener does meaningful work (3.2 review patch P-2)
- Emit a fold result without actually calling `emit()` inside the fold callback (the DeleteTimeBloc bug being fixed)

### Project Structure Notes

All source files already exist in correct locations. This story modifies existing files, deletes Freezed generated files, and creates test files.

**Modified source files (11):**
- `lib/src/features/times/presentation/bloc/update_time_event.dart`
- `lib/src/features/times/presentation/bloc/update_time_state.dart`
- `lib/src/features/times/presentation/bloc/update_time_bloc.dart`
- `lib/src/features/times/presentation/bloc/delete_time_event.dart`
- `lib/src/features/times/presentation/bloc/delete_time_state.dart`
- `lib/src/features/times/presentation/bloc/delete_time_bloc.dart`
- `lib/src/features/times/presentation/widgets/update_time_button.dart`
- `lib/src/features/times/presentation/widgets/delete_time_button.dart`
- `lib/src/features/times/presentation/widgets/update_hour_field.dart`
- `lib/src/features/times/presentation/widgets/update_minutes_field.dart`
- `lib/src/features/times/presentation/widgets/edit_button.dart`

**Deleted files (2):**
- `lib/src/features/times/presentation/bloc/update_time_bloc.freezed.dart`
- `lib/src/features/times/presentation/bloc/delete_time_bloc.freezed.dart`

**Created test files (4):**
- `test/src/features/times/domain/use_cases/update_time_use_case_test.dart`
- `test/src/features/times/domain/use_cases/delete_time_use_case_test.dart`
- `test/src/features/times/presentation/bloc/update_time_bloc_test.dart`
- `test/src/features/times/presentation/bloc/delete_time_bloc_test.dart`

**Modified test files (1):**
- `test/src/features/times/data/repositories/objectbox_times_repository_test.dart` — add update/delete test groups (deferred from Story 3.2)

**Unchanged files (verified — NO modification needed):**
- `lib/src/features/times/presentation/bloc/bloc.dart` — barrel exports BLoC files which already re-export their events/states via `export` directives; no changes required
- `lib/src/features/times/presentation/bloc/times_blocs.dart` — BLoC provider configurations use `context.read<UseCase>()` injection; constructor signatures for UpdateTimeBloc and DeleteTimeBloc remain `(UseCase)`, so no changes needed

### Story 3.2 Code Review Warnings (Validated Error Patterns to Avoid)

The 3.2 code review found 7 patches across 14 findings. These are the most relevant to 3.3:
- **P-1 (Stale-state reads):** Capture `state.hour`, `state.minutes`, `state.time` into local variables BEFORE the first `await` in any handler — after `await`, `state` may have changed due to concurrent events
- **P-2 (listenWhen guards):** `BlocConsumer` listeners MUST use `listenWhen` to prevent false-positive triggers — e.g., `listenWhen: (prev, curr) => curr is UpdateTimeSuccess` prevents the listener from firing on every state change
- **BS-1 (BlocConsumer vs BlocBuilder):** Use `BlocBuilder` when only rendering UI from state; use `BlocConsumer` only when the listener performs side effects (navigation, snackbar, controller sync)
- **BS-3 (Form data retention):** On error, emit Error with preserved form values (`hour`, `minutes`, `time`); on success, reset to defaults. Never lose user input on transient errors

### Approach Order

1. Migrate `UpdateTimeBloc` — event, state, bloc files (Task 1)
2. Migrate `DeleteTimeBloc` — event, state, bloc files (Task 2)
3. Update presentation widgets (Task 3)
4. Delete `.freezed.dart` files
5. Run `dart run build_runner build --delete-conflicting-outputs` (regenerate remaining Freezed files — domain entities only)
6. Write use case tests (Task 4)
7. Write BLoC tests (Task 5)
8. Run `flutter analyze` — zero warnings
9. Run `flutter test` — all pass

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 3, Story 3.3]
- [Source: _bmad-output/planning-artifacts/architecture.md — State Management, Testing Standards, Code Structure]
- [Source: _bmad-output/implementation-artifacts/3-2-times-feature-list-create-bloc-migration.md — Previous story patterns]
- [Source: _bmad-output/implementation-artifacts/3-1-core-sealed-classes-test-infrastructure-core-tests.md — Core sealed classes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

- No issues encountered during implementation

### Completion Notes List

- Migrated UpdateTimeBloc from Freezed `part of` pattern to standalone sealed classes (event, state, bloc)
- Migrated DeleteTimeBloc from Freezed to standalone sealed classes
- Fixed critical bug in DeleteTimeBloc: `result.fold()` was discarding the state value — now properly emits via fold callbacks
- Fixed wrong delay placement in DeleteTimeBloc: moved delay AFTER fold emit, removed pre-use-case delay
- Updated 5 presentation widgets: UpdateTimeButton and DeleteTimeButton now use `BlocConsumer` with `listenWhen` for success-driven navigation; UpdateHourField and UpdateMinutesField replaced `BlocConsumer` no-op listener with `BlocBuilder`; EditButton updated to sealed class constructor syntax
- All state variants implement `==` and `hashCode` with `Object.hash()` including inherited form fields
- Race condition prevention: all async handlers capture `state.hour`, `state.minutes`, `state.time` into local variables before `await`
- 26 new tests added (4 use case, 4 repository, 8 update BLoC, 3 delete BLoC — plus existing 42 pass)
- Total: 68/68 tests passing, 0 flutter analyze warnings

### Change Log

- 2026-03-18: Story 3.3 implementation complete — UpdateTimeBloc and DeleteTimeBloc migrated to sealed classes, 5 widgets updated, 26 new tests, 3 bugs fixed

### File List

**Modified (11):**
- lib/src/features/times/presentation/bloc/update_time_event.dart
- lib/src/features/times/presentation/bloc/update_time_state.dart
- lib/src/features/times/presentation/bloc/update_time_bloc.dart
- lib/src/features/times/presentation/bloc/delete_time_event.dart
- lib/src/features/times/presentation/bloc/delete_time_state.dart
- lib/src/features/times/presentation/bloc/delete_time_bloc.dart
- lib/src/features/times/presentation/widgets/update_time_button.dart
- lib/src/features/times/presentation/widgets/delete_time_button.dart
- lib/src/features/times/presentation/widgets/update_hour_field.dart
- lib/src/features/times/presentation/widgets/update_minutes_field.dart
- lib/src/features/times/presentation/widgets/edit_button.dart

**Deleted (2):**
- lib/src/features/times/presentation/bloc/update_time_bloc.freezed.dart
- lib/src/features/times/presentation/bloc/delete_time_bloc.freezed.dart

**Created (4):**
- test/src/features/times/domain/use_cases/update_time_use_case_test.dart
- test/src/features/times/domain/use_cases/delete_time_use_case_test.dart
- test/src/features/times/presentation/bloc/update_time_bloc_test.dart
- test/src/features/times/presentation/bloc/delete_time_bloc_test.dart

**Modified test (1):**
- test/src/features/times/data/repositories/objectbox_times_repository_test.dart
