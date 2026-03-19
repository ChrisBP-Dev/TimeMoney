# Story 3.4: Wage Feature — Sealed Class BLoC Migration

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want wage management to use modern reactive patterns internally,
so that viewing and updating my hourly wage remains fast with real-time feedback (FR7-FR11, FR40, FR42, FR43).

## Acceptance Criteria

1. **FetchWageBloc migrated to sealed classes with emit.forEach** — `sealed class FetchWageEvent` with variant `FetchWageRequested`; `sealed class FetchWageState` with variants `FetchWageInitial`, `FetchWageLoading`, `FetchWageLoaded(WageHourly)`, `FetchWageError(GlobalFailure)`; stream consumption uses `emit.forEach` internally — no `StreamBuilder` in UI (FR10, FR43); wage value updates in real time without manual refresh (FR10); all variants use `final class` with `const` constructors
2. **UpdateWageBloc migrated to sealed classes** — `sealed class UpdateWageEvent` with variants `UpdateWageHourlyChanged`, `UpdateWageSubmitted`; `sealed class UpdateWageState` with form data on sealed base (`wageHourly`) and variants `UpdateWageInitial`, `UpdateWageLoading`, `UpdateWageSuccess`, `UpdateWageError`; all variants use `final class` with `const` constructors; no `ActionState<T>` wrapper — states themselves represent the action lifecycle; handler maps Either results to states; success triggers `AppDurations.actionFeedback` delay then auto-resets (FR42); visual feedback for wage update (FR11)
3. **Presentation widgets use `switch` expressions** — `FetchWageScreen` uses `BlocConsumer` with `listenWhen` for PaymentCubit sync, `switch` expression on `FetchWageState`; `SetWageButton` uses `BlocConsumer` with `listenWhen` for success → `Navigator.pop()`, `switch` expression on `UpdateWageState`; `WageHourlyField` uses `BlocBuilder` (not `BlocConsumer` with no-op listener); zero `.when()` calls and zero `if/else` chains on state types remain
4. **StreamBuilder eliminated** — `WageHourlyDataView` (StreamBuilder wrapper) deleted; `FetchWageBloc` handles stream internally via `emit.forEach`; `FetchWageScreen` renders `WageHourlyCard` directly from `FetchWageLoaded` state; `DataWage` extension removed
5. **Functional behavior preserved** — user can view current wage (FR7), initial wage defaults to $15.00 (FR8), update wage (FR9), real-time wage update (FR10), visual feedback for update actions (FR11)
6. **Tests written alongside implementation** — `fetch_wage_use_case_test.dart`, `set_wage_use_case_test.dart`, `update_wage_use_case_test.dart`, `objectbox_wage_repository_test.dart`, `fetch_wage_bloc_test.dart`, `update_wage_bloc_test.dart` — all verify state transitions, 100% coverage, all passing
7. **Zero warnings** on `flutter analyze` for all modified and created files

## Tasks / Subtasks

- [x] Task 1: Migrate FetchWageBloc to sealed classes with emit.forEach (AC: #1, #4)
  - [x] 1.1 Rewrite `fetch_wage_event.dart` as standalone sealed class (remove `part of`)
  - [x] 1.2 Rewrite `fetch_wage_state.dart` as standalone sealed class (remove `part of`, remove `DataWage` extension)
  - [x] 1.3 Rewrite `fetch_wage_bloc.dart` — remove Freezed imports/parts, add standalone imports/exports, use `emit.forEach` for stream consumption
  - [x] 1.4 Delete `fetch_wage_bloc.freezed.dart`
- [x] Task 2: Migrate UpdateWageBloc to sealed classes (AC: #2)
  - [x] 2.1 Rewrite `update_wage_event.dart` as standalone sealed class (remove `part of`)
  - [x] 2.2 Rewrite `update_wage_state.dart` as standalone sealed class with form data on base (remove `part of`)
  - [x] 2.3 Rewrite `update_wage_bloc.dart` — remove Freezed imports/parts, add standalone imports/exports, fix bugs, explicit state construction
  - [x] 2.4 Delete `update_wage_bloc.freezed.dart`
- [x] Task 3: Update presentation widgets (AC: #3, #4)
  - [x] 3.1 Rewrite `fetch_wage_screen.dart` — BlocConsumer with `listenWhen` for PaymentCubit sync, `switch` expression, use `FetchWageRequested` event, render `WageHourlyCard` directly from `FetchWageLoaded`
  - [x] 3.2 Delete `wage_hourly_data_view.dart` (StreamBuilder eliminated)
  - [x] 3.3 Update `widgets.dart` barrel — remove `wage_hourly_data_view.dart` export
  - [x] 3.4 Update `set_wage_button.dart` — BlocConsumer with `listenWhen` for success → `Navigator.pop()`, `switch` on sealed state, remove manual delay/pop
  - [x] 3.5 Update `wage_hourly_field.dart` — replace `BlocConsumer` no-op listener with `BlocBuilder`, update event syntax
- [x] Task 4: Write use case and repository tests (AC: #6)
  - [x] 4.1 Create `test/src/features/wage/domain/use_cases/fetch_wage_use_case_test.dart`
  - [x] 4.2 Create `test/src/features/wage/domain/use_cases/set_wage_use_case_test.dart`
  - [x] 4.3 Create `test/src/features/wage/domain/use_cases/update_wage_use_case_test.dart`
  - [x] 4.4 Create `test/src/features/wage/data/repositories/objectbox_wage_repository_test.dart`
- [x] Task 5: Write BLoC tests (AC: #6)
  - [x] 5.1 Create `test/src/features/wage/presentation/bloc/fetch_wage_bloc_test.dart`
  - [x] 5.2 Create `test/src/features/wage/presentation/bloc/update_wage_bloc_test.dart`
- [x] Task 6: Verification (AC: #5, #7)
  - [x] 6.1 Run `flutter analyze` — zero warnings on non-generated code
  - [x] 6.2 Run `flutter test` — all tests pass
  - [x] 6.3 Verify app launches and wage features work: view wage, update wage with visual feedback, real-time updates

## Dev Notes

### Critical Architecture Patterns

Follow the exact sealed class patterns established in Stories 3.2 and 3.3. The reference implementations are:
- **Stream BLoC pattern (FetchWageBloc follows this):** `lib/src/features/times/presentation/bloc/list_times_bloc.dart`, `list_times_event.dart`, `list_times_state.dart`
- **Action BLoC pattern (UpdateWageBloc follows this):** `lib/src/features/times/presentation/bloc/create_time_bloc.dart`, `create_time_event.dart`, `create_time_state.dart`
- **Simple state (no form data):** `lib/src/features/times/presentation/bloc/list_times_state.dart`
- **State with form data on base:** `lib/src/features/times/presentation/bloc/create_time_state.dart`

### FetchWageBloc Migration — Exact Specifications

**Current state (Freezed):** Uses `part of`, `@freezed`, `.when()`. State has `hasDataStream(Stream<WageHourly>)` variant that exposes raw stream to UI via `WageHourlyDataView` + `StreamBuilder`. Loading state commented out. `DataWage` extension extracts wage from state.

**Target state (Sealed + emit.forEach):** Follows `ListTimesBloc` pattern exactly. BLoC consumes stream internally via `emit.forEach`. UI receives `FetchWageLoaded(wage)` with the actual `WageHourly` data — no stream exposed.

**Event sealed class** (`fetch_wage_event.dart`):
```dart
sealed class FetchWageEvent {
  const FetchWageEvent();
}

final class FetchWageRequested extends FetchWageEvent {
  const FetchWageRequested();
}
```
- Rename from `_GetWage` to `FetchWageRequested` (past-tense naming convention)
- No `@immutable` needed — no data fields

**State sealed class** (`fetch_wage_state.dart`):
```dart
@immutable
sealed class FetchWageState {
  const FetchWageState();
}

final class FetchWageInitial extends FetchWageState {
  const FetchWageInitial();
}

final class FetchWageLoading extends FetchWageState {
  const FetchWageLoading();
}

final class FetchWageLoaded extends FetchWageState {
  const FetchWageLoaded(this.wage);
  final WageHourly wage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchWageLoaded && wage == other.wage;

  @override
  int get hashCode => wage.hashCode;
}

final class FetchWageError extends FetchWageState {
  const FetchWageError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchWageError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
```
- Import `flutter/foundation.dart` for `@immutable`
- Import `wage_hourly.dart` for entity, `failures.dart` for GlobalFailure
- **No `empty` variant** — the repository always returns a default `WageHourly()` when no data exists
- **No `hasDataStream` variant** — BLoC processes stream internally
- **Remove `DataWage` extension entirely** — no longer needed
- `FetchWageLoaded` and `FetchWageError` override `==` and `hashCode` (data-carrying)
- `FetchWageInitial` and `FetchWageLoading` have NO data fields — no overrides needed

**BLoC rewrite** (`fetch_wage_bloc.dart`):
- Remove ALL: `part` directives, `freezed_annotation` import, `.freezed.dart` part
- Add: standalone imports for event/state files + `export` both
- Constructor calls `super(const FetchWageInitial())`
- Handler `_onFetchWageRequested` follows `ListTimesBloc._onListTimesRequested` exactly:
  1. `emit(const FetchWageLoading())`
  2. `final result = _fetchWageUseCase.call()` — synchronous, returns `Either<GlobalFailure, Stream<WageHourly>>`
  3. `await result.fold(...)` — **MUST await** because right branch returns `Future<void>` from `emit.forEach`
  4. Left branch: `(failure) async => emit(FetchWageError(failure))`
  5. Right branch: `(stream) => emit.forEach<WageHourly>(stream, onData: FetchWageLoaded.new, onError: (error, _) => FetchWageError(GlobalFailure.fromException(error)))`

**Reference — exact ListTimesBloc handler pattern to copy:**
```dart
Future<void> _onFetchWageRequested(
  FetchWageRequested event,
  Emitter<FetchWageState> emit,
) async {
  emit(const FetchWageLoading());

  final result = _fetchWageUseCase.call();

  await result.fold(
    (failure) async => emit(FetchWageError(failure)),
    (stream) => emit.forEach<WageHourly>(
      stream,
      onData: FetchWageLoaded.new,
      onError: (error, _) => FetchWageError(
        GlobalFailure.fromException(error),
      ),
    ),
  );
}
```

### UpdateWageBloc Migration — Exact Specifications

**Current state (Freezed):** Uses `part of`, `@freezed`, `state.copyWith()`. Single Freezed state class with `wageHourly: WageHourly` + `currentState: ActionState<WageHourly>`. `_emitError` has `FutureOr<void>` return type bug. Delay placement wrong in `_Update` handler.

**Target state (Sealed):** Follows `CreateTimeBloc`/`UpdateTimeBloc` pattern. Form data (`wageHourly`) on sealed base class. No `ActionState` wrapper — states themselves represent the action lifecycle.

**Event sealed class** (`update_wage_event.dart`):
```dart
sealed class UpdateWageEvent {
  const UpdateWageEvent();
}

final class UpdateWageHourlyChanged extends UpdateWageEvent {
  const UpdateWageHourlyChanged({required this.value});
  final String value;
}

final class UpdateWageSubmitted extends UpdateWageEvent {
  const UpdateWageSubmitted();
}
```
- Rename `_ChangeHourly` → `UpdateWageHourlyChanged` (past-tense naming)
- Rename `_Update` → `UpdateWageSubmitted` (imperative naming)

**State sealed class** (`update_wage_state.dart`):
- Sealed base carries `wageHourly: WageHourly` field (default `const WageHourly()`) — form data persists across transitions
- `@immutable` annotation on sealed base
- Variants: `UpdateWageInitial`, `UpdateWageLoading`, `UpdateWageSuccess`, `UpdateWageError`
- `UpdateWageSuccess` carries `WageHourly result` field
- `UpdateWageError` carries `GlobalFailure failure` field
- **ALL variants override `==` and `hashCode`** — every variant inherits `wageHourly` from the base, making them ALL data-carrying:
  - `UpdateWageInitial` compares `wageHourly`
  - `UpdateWageLoading` compares `wageHourly`
  - `UpdateWageSuccess` compares `result`, `wageHourly`
  - `UpdateWageError` compares `failure`, `wageHourly`
- Use `Object.hash(...)` for multi-field `hashCode`
- Import `flutter/foundation.dart` for `@immutable`
- Use `super.wageHourly` in variant constructors

```dart
@immutable
sealed class UpdateWageState {
  const UpdateWageState({this.wageHourly = const WageHourly()});
  final WageHourly wageHourly;
}

final class UpdateWageInitial extends UpdateWageState {
  const UpdateWageInitial({super.wageHourly});
  // == compares wageHourly, hashCode = wageHourly.hashCode
}

final class UpdateWageLoading extends UpdateWageState {
  const UpdateWageLoading({super.wageHourly});
  // == compares wageHourly
}

final class UpdateWageSuccess extends UpdateWageState {
  const UpdateWageSuccess({required this.result, super.wageHourly});
  final WageHourly result;
  // == compares result, wageHourly; hashCode = Object.hash(result, wageHourly)
}

final class UpdateWageError extends UpdateWageState {
  const UpdateWageError(this.failure, {super.wageHourly});
  final GlobalFailure failure;
  // == compares failure, wageHourly; hashCode = Object.hash(failure, wageHourly)
}
```

**BLoC rewrite** (`update_wage_bloc.dart`):
- Remove ALL: `part` directives, `freezed_annotation` import, `.freezed.dart` part, `dart:async` import (no longer needed), `action_state.dart` import
- Add: standalone imports for event/state files + `export` both
- Constructor calls `super(const UpdateWageInitial())`
- `on<UpdateWageHourlyChanged>` and `on<UpdateWageSubmitted>` handlers

**Handler `_onHourlyChanged`:**
```dart
Future<void> _onHourlyChanged(
  UpdateWageHourlyChanged event,
  Emitter<UpdateWageState> emit,
) async {
  final hourly = double.tryParse(event.value);

  if (hourly == null) return _emitError(emit);

  final currentWage = state.wageHourly;
  emit(UpdateWageInitial(
    wageHourly: currentWage.copyWith(value: hourly),
  ));
}
```
- Note: `WageHourly.copyWith()` is fine — it's a Freezed domain entity, not a BLoC state
- Capture `state.wageHourly` into local before using (race condition prevention)
- Note: Handler uses `Future<void> async` (not `FutureOr<void>` non-async like CreateTimeBloc from 3.2). This follows the post-P-1 pattern applied to UpdateTimeBloc in Story 3.3 — all handlers use `Future<void>` for consistency. The `async` keyword ensures `return _emitError(emit)` is properly awaited before the handler completes.

**Handler `_onSubmitted`:**
```dart
Future<void> _onSubmitted(
  UpdateWageSubmitted event,
  Emitter<UpdateWageState> emit,
) async {
  final currentWage = state.wageHourly;

  emit(UpdateWageLoading(wageHourly: currentWage));

  final result = await _updateWageUseCase.call(currentWage);

  result.fold(
    (failure) => emit(UpdateWageError(failure, wageHourly: currentWage)),
    (wage) => emit(UpdateWageSuccess(result: wage, wageHourly: currentWage)),
  );

  await Future<void>.delayed(AppDurations.actionFeedback);

  emit(const UpdateWageInitial());
}
```
- **FIX: Remove first delay** (current code delays AFTER use case call but BEFORE fold — wrong)
- Delay only AFTER emitting Success/Error, before auto-reset to Initial
- On auto-reset: `const UpdateWageInitial()` resets form to default WageHourly (15.0)

**Helper `_emitError`:**
```dart
Future<void> _emitError(Emitter<UpdateWageState> emit) async {
  final currentWage = state.wageHourly;

  emit(UpdateWageError(
    const InternalError('invalid number'),
    wageHourly: currentWage,
  ));

  await Future<void>.delayed(AppDurations.actionFeedback);

  emit(UpdateWageInitial(wageHourly: currentWage));
}
```
- **FIX: Return type `Future<void>`** (not `FutureOr<void>`) — Story 3.3 review patch P-1
- Capture `state.wageHourly` before any await
- On error recovery, preserve `wageHourly` (don't reset to default)

### Presentation Widget Updates

**`fetch_wage_screen.dart` — MAJOR REWRITE:**
- Currently: `BlocConsumer` with no-op listener, `..add(const FetchWageEvent.getWage())`, renders via `.when()` with 5 branches including `hasDataStream` → `WageHourlyDataView(StreamBuilder)`
- Target: `BlocConsumer` with `listenWhen: (prev, curr) => curr is FetchWageLoaded`, listener calls `context.read<PaymentCubit>().setWage(state.wage.value)` to sync payment calculations. Builder uses `switch` expression on 4 sealed states.
- **Import migration:** PaymentCubit import moves here from deleted `WageHourlyDataView`. `CatchErrorBuilder` and `shared/widgets` imports are NO longer needed — stream error handling is now covered by `emit.forEach`'s `onError` callback in FetchWageBloc.
- **Required imports for rewritten file:**
  - `package:flutter/material.dart`
  - `package:flutter_bloc/flutter_bloc.dart`
  - `package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart` (moved from deleted WageHourlyDataView)
  - `package:time_money/src/features/wage/presentation/bloc/fetch_wage_bloc.dart`
  - `package:time_money/src/features/wage/presentation/widgets/widgets.dart` (provides `ShimmerWageHourlyView`, `WageHourlyCard`, `ErrorFetchWageHourlyView`)
- Code:
  ```dart
  BlocConsumer<FetchWageBloc, FetchWageState>(
    listenWhen: (prev, curr) => curr is FetchWageLoaded,
    listener: (context, state) {
      if (state is FetchWageLoaded) {
        context.read<PaymentCubit>().setWage(state.wage.value);
      }
    },
    bloc: context.read<FetchWageBloc>()
      ..add(const FetchWageRequested()),
    builder: (context, state) => switch (state) {
      FetchWageInitial() => const ShimmerWageHourlyView(),
      FetchWageLoading() => const ShimmerWageHourlyView(),
      FetchWageLoaded(:final wage) => WageHourlyCard(wageHourly: wage),
      FetchWageError(:final failure) => ErrorFetchWageHourlyView(
          failure,
          actionWidget: const _ActionWidget(),
        ),
    },
  )
  ```
- Remove `WageHourlyDataView` usage — render `WageHourlyCard` directly
- Remove `empty` branch — no `FetchWageEmpty` state variant
- Keep `_ActionWidget` as-is (pre-existing stub, not in scope)
- `ShimmerWageHourlyView` comes from `widgets.dart` barrel (via `wage_hourly_other_view.dart` export) — remains available after removing `wage_hourly_data_view.dart` export

**`wage_hourly_data_view.dart` — DELETE:**
- StreamBuilder is eliminated. FetchWageBloc now handles stream internally via `emit.forEach`
- PaymentCubit sync moved to FetchWageScreen listener
- WageHourlyCard rendering moved to FetchWageScreen builder
- `CatchErrorBuilder` stream error handling replaced by `emit.forEach`'s `onError` callback in FetchWageBloc — no widget-level error catching needed

**`widgets.dart` barrel — UPDATE:**
- Remove `export 'wage_hourly_data_view.dart';` line

**`set_wage_button.dart` — REWRITE:**
- Currently: `BlocConsumer` with no-op listener, switches on `state.currentState` (ActionState variants), manually delays and pops in `onPressed`
- Target: `BlocConsumer` with `listenWhen: (prev, curr) => curr is UpdateWageSuccess`, listener does `Navigator.pop(context)`. Builder renders `switch (state)` on `UpdateWageState` sealed class:
  ```dart
  BlocConsumer<UpdateWageBloc, UpdateWageState>(
    listenWhen: (prev, curr) => curr is UpdateWageSuccess,
    listener: (context, state) => Navigator.of(context).pop(),
    builder: (_, state) {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 32, 137, 86),
        ),
        onPressed: () => context.read<UpdateWageBloc>().add(
              const UpdateWageSubmitted(),
            ),
        child: switch (state) {
          UpdateWageInitial() => const Text('Update'),
          UpdateWageLoading() => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          UpdateWageSuccess() => const Text('Success'),
          UpdateWageError() => const Text('Error'),
        },
      );
    },
  )
  ```
- Remove `ActionState` import (no longer needed)
- Remove `AppDurations` import (delay managed by BLoC, not widget)
- Remove manual `await Future<void>.delayed` + `Navigator.pop()` from `onPressed` — let BlocConsumer listener handle navigation on success state
- `onPressed` just adds `const UpdateWageSubmitted()` event

**`wage_hourly_field.dart` — UPDATE:**
- Replace `BlocConsumer` with no-op listener → `BlocBuilder` (BS-1 pattern from 3.2 review)
- Update event: `UpdateWageEvent.changeHourly(value: value)` → `UpdateWageHourlyChanged(value: value)`
- No other changes — widget structure is correct

### Testing Requirements

**Use case tests** — follow patterns from Story 3.2 (`create_time_use_case_test.dart`, `list_times_use_case_test.dart`):

`fetch_wage_use_case_test.dart`:
- Mock `WageRepository` using `MockWageRepository` from `test/helpers/mocks.dart`
- Test success: mock `fetchWageHourly()` returns `Right(Stream.value(testWage))`, verify result is `Right` containing a stream
- Test error: mock returns `Left(testFailure)`, verify result is `Left` with exact failure
- Verify repository called once
- Note: `FetchWageUseCase.call()` is synchronous (returns `Either` directly, not `Future<Either>`)

`set_wage_use_case_test.dart`:
- Mock `WageRepository` using `MockWageRepository` from `test/helpers/mocks.dart`
- `setUpAll`: `registerFallbackValue(const WageHourly())` — required for `any()` matcher on `WageHourly` parameter in mocktail
- Test success: mock `setWageHourly(any())` returns `Right(testWage)`, verify result is `Right`
- Test error: mock returns `Left(testFailure)`, verify result is `Left`
- Verify repository called once with `any()` matcher
- Note: `SetWageUseCase.call()` takes NO parameters — it creates `const WageHourly()` internally

`update_wage_use_case_test.dart`:
- Mock `WageRepository` using `MockWageRepository` from `test/helpers/mocks.dart`
- `setUpAll`: `registerFallbackValue(const WageHourly())` — required for `any()` matcher
- Test success: mock `update(any())` returns `Right(testWage)`, verify result is `Right` with exact value
- Test error: mock returns `Left(testFailure)`, verify result is `Left` with exact failure
- Verify repository called once

**Repository test** — follow patterns from times repo test (`objectbox_times_repository_test.dart`):

`objectbox_wage_repository_test.dart`:
- Define local mock: `class MockWageObjectboxDatasource extends Mock implements WageObjectboxDatasource {}` (in the test file, NOT in mocks.dart — follows times pattern)
- `setUpAll`: `registerFallbackValue(WageHourlyBox(value: 0))` — required for `any()` matcher on `WageHourlyBox`
- `setUp`: creates fresh `mockDatasource` and `repository = ObjectboxWageRepository(mockDatasource)` per test
- Uses `const testWage = WageHourly(id: 1, value: 25.0)` as test data

`fetchWageHourly` test group:
- Test success with data: `when(() => mockDatasource.watchAll()).thenAnswer((_) => Stream.value([WageHourlyBox(id: 1, value: 25.0)]))`, call `repository.fetchWageHourly()`, verify `result.isRight()`, get stream and verify first emission maps to correct `WageHourly`
- Test success empty: mock returns `Stream.value([])`, verify stream emits default `const WageHourly()` (id: 0, value: 15.0)
- Test error: `when(() => mockDatasource.watchAll()).thenThrow(Exception('fail'))`, verify `result.isLeft()`

`setWageHourly` test group:
- Test success: `when(() => mockDatasource.put(any())).thenReturn(1)`, call `repository.setWageHourly(testWage)`, verify `Right(testWage)` returned
- Test error: `when(() => mockDatasource.put(any())).thenThrow(Exception('fail'))`, verify `Left(GlobalFailure)` returned

`update` test group:
- Test success: `when(() => mockDatasource.put(any())).thenReturn(1)`, call `repository.update(testWage)`, verify `Right(testWage)` returned
- Test error: `when(() => mockDatasource.put(any())).thenThrow(Exception('fail'))`, verify `Left(GlobalFailure)` returned

**BLoC tests** — follow patterns from Story 3.2/3.3 BLoC tests:

`fetch_wage_bloc_test.dart`:
- Use `bloc_test` package with `blocTest<FetchWageBloc, FetchWageState>`
- Mock `FetchWageUseCase` using `MockFetchWageUseCase` from `test/helpers/mocks.dart`
- Tests required:
  - Initial state is `FetchWageInitial`
  - `FetchWageRequested` with successful stream → emits `[FetchWageLoading(), FetchWageLoaded(testWage)]`
    - Mock: `when(() => mockUseCase.call()).thenReturn(Right(Stream.value(testWage)))`
  - `FetchWageRequested` with Either error → emits `[FetchWageLoading(), FetchWageError(testFailure)]`
    - Mock: `when(() => mockUseCase.call()).thenReturn(Left(testFailure))`
  - `FetchWageRequested` with stream error → emits `[FetchWageLoading(), FetchWageError(...)]`
    - Mock: `when(() => mockUseCase.call()).thenReturn(Right(Stream.error(Exception('fail'))))`
- **Note:** No `wait` parameter needed — emit.forEach completes when stream closes (Stream.value emits one value then closes)

`update_wage_bloc_test.dart`:
- Use `bloc_test` package with `blocTest<UpdateWageBloc, UpdateWageState>`
- Mock `UpdateWageUseCase` using `MockUpdateWageUseCase` from `test/helpers/mocks.dart`
- **`setUpAll`:** `registerFallbackValue(const WageHourly())` — required for `any()` matcher on `WageHourly` parameter in mocktail
- **`wait` parameter:** ALL `blocTest` calls involving async operations (submit, validation errors with delay) MUST use `wait: const Duration(seconds: 2)` — without it, assertions fail because delay-driven transitions haven't completed
- Tests required:
  - Initial state is `UpdateWageInitial` with `wageHourly: const WageHourly()` (default 15.0)
  - `UpdateWageHourlyChanged` valid → emits `UpdateWageInitial(wageHourly: WageHourly(value: 25.0))`
  - `UpdateWageHourlyChanged` invalid → emits `[UpdateWageError, UpdateWageInitial]` (preserving wageHourly) — needs `wait`
  - `UpdateWageSubmitted` success → `[UpdateWageLoading, UpdateWageSuccess, UpdateWageInitial]` — needs `wait`
    - Mock: `when(() => mockUseCase.call(any())).thenAnswer((_) async => Right(testWage))`
    - Verify: Loading preserves form data, Success contains result, Initial resets to default
  - `UpdateWageSubmitted` error → `[UpdateWageLoading, UpdateWageError, UpdateWageInitial]` — needs `wait`
    - Mock: `when(() => mockUseCase.call(any())).thenAnswer((_) async => Left(testFailure))`
    - Verify: Error preserves form data, Initial resets to default

### Existing Mocks Available

All mocks already exist in `test/helpers/mocks.dart`:
- `MockWageRepository`
- `MockFetchWageUseCase`
- `MockSetWageUseCase`
- `MockUpdateWageUseCase`

No new mocks needed in `test/helpers/mocks.dart`. The datasource mock (`MockWageObjectboxDatasource`) is defined locally in `objectbox_wage_repository_test.dart` (follows times pattern).

### Bug Fixes Included

1. **FetchWageBloc stream exposure:** Current code emits `FetchWageState.hasDataStream(stream)` which exposes the raw stream to UI, requiring `StreamBuilder` in `WageHourlyDataView`. Fix: use `emit.forEach` to consume stream internally, emit `FetchWageLoaded(wage)` with actual data.
2. **FetchWageBloc missing Loading state:** Current code has Loading emission commented out (lines 16-18 of `fetch_wage_bloc.dart`). Fix: properly emit `FetchWageLoading()` before processing.
3. **UpdateWageBloc `_emitError` return type:** `FutureOr<void>` should be `Future<void>` — the function is always async. Using `FutureOr` masks the fact that it's called without await in synchronous `_ChangeHourly` handler.
4. **UpdateWageBloc `_ChangeHourly` handler not async:** Calls `_emitError(emit)` without await, causing the error→delay→reset chain to run detached. Fix: make handler async, handler signature returns `Future<void>`.
5. **UpdateWageBloc `_Update` handler wrong delay placement:** Current code delays AFTER use case call but BEFORE fold result emission. Fix: emit result immediately after fold, delay only before auto-reset.
6. **UpdateWageBloc `_Update` error path:** Calls `_emitError(emit)` inside fold left callback without await, then continues to explicit delay + Initial emit — two competing resets. Fix: emit Error directly in fold, single delay, single Initial reset.
7. **SetWageButton manual navigation race:** Current `onPressed` adds event, delays, then pops — racing with BLoC state transitions. Fix: use `BlocConsumer` `listenWhen` for success → pop (same fix as Story 3.3 for UpdateTimeButton/DeleteTimeButton).
8. **FetchWageScreen/WageHourlyField no-op listeners:** `BlocConsumer` with `listener: (context, state) => state` (no-op). Fix: FetchWageScreen uses meaningful `listenWhen` listener for PaymentCubit sync; WageHourlyField uses `BlocBuilder`.

### Anti-Patterns — NEVER Do

- Use `.when()` or `.map()` pattern matching (Freezed methods) — use native `switch` expressions
- Use `if/else` chains on sealed types — always exhaustive `switch`
- Use `copyWith()` on Freezed state — construct new sealed variants explicitly (note: `copyWith()` on domain entities like `WageHourly` IS fine — they remain Freezed)
- Use `part of`/`part` for event/state files — standalone with own imports
- Use `ActionState<T>` wrapper for UpdateWageBloc states — sealed states ARE the action lifecycle
- Use `StreamBuilder` in UI for stream consumption — BLoC handles via `emit.forEach`
- Skip `AppDurations.actionFeedback` delay between transitions
- Use relative imports — always `package:time_money/src/...`
- Manually edit generated `.freezed.dart` or `.g.dart` files
- Skip `==` and `hashCode` overrides on ANY state variant that inherits or carries data fields
- Access `state.field` after an `await` without first capturing into a local variable (race condition)
- Omit `wait: const Duration(seconds: 2)` in `blocTest` calls that involve async delays
- Use `BlocConsumer` with no-op listener — use `BlocBuilder` unless listener does meaningful work (3.2 review patch BS-1)
- Use `FutureOr<void>` for async helpers — use `Future<void>` (3.3 review patch P-1)

### Story 3.3 Code Review Warnings (Validated Error Patterns to Avoid)

From the 3.2 and 3.3 code reviews — these patterns are MANDATORY:
- **P-1 (Stale-state reads):** Capture `state.wageHourly` into local variables BEFORE the first `await` in any handler
- **P-1 (FutureOr→Future):** Use `Future<void>` return type for `_emitError` — never `FutureOr<void>`
- **P-2 (listenWhen guards):** `BlocConsumer` listeners MUST use `listenWhen` to prevent false-positive triggers
- **BS-1 (BlocConsumer vs BlocBuilder):** Use `BlocBuilder` when only rendering UI from state; `BlocConsumer` only when the listener performs side effects (navigation, PaymentCubit sync)
- **BS-3 (Form data retention):** On error, emit Error with preserved `wageHourly`; on success auto-reset, can reset to default

### Project Structure Notes

**Modified source files (10):**
- `lib/src/features/wage/presentation/bloc/fetch_wage_event.dart`
- `lib/src/features/wage/presentation/bloc/fetch_wage_state.dart`
- `lib/src/features/wage/presentation/bloc/fetch_wage_bloc.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_event.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_state.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_bloc.dart`
- `lib/src/features/wage/presentation/pages/fetch_wage_screen.dart`
- `lib/src/features/wage/presentation/widgets/set_wage_button.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_field.dart`
- `lib/src/features/wage/presentation/widgets/widgets.dart` (barrel — remove wage_hourly_data_view export)

**Deleted files (3):**
- `lib/src/features/wage/presentation/bloc/fetch_wage_bloc.freezed.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_bloc.freezed.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_data_view.dart`

**Created test files (6):**
- `test/src/features/wage/domain/use_cases/fetch_wage_use_case_test.dart`
- `test/src/features/wage/domain/use_cases/set_wage_use_case_test.dart`
- `test/src/features/wage/domain/use_cases/update_wage_use_case_test.dart`
- `test/src/features/wage/data/repositories/objectbox_wage_repository_test.dart`
- `test/src/features/wage/presentation/bloc/fetch_wage_bloc_test.dart`
- `test/src/features/wage/presentation/bloc/update_wage_bloc_test.dart`

**Unchanged files (verified — NO modification needed):**
- `lib/src/features/wage/presentation/bloc/bloc.dart` — barrel exports BLoC files which already re-export their events/states via `export` directives; no changes required
- `lib/src/features/wage/presentation/bloc/wage_blocs.dart` — BLoC provider configurations use `context.read<UseCase>()` injection; constructor signatures for FetchWageBloc and UpdateWageBloc remain `(UseCase)`, so no changes needed
- `lib/src/features/wage/presentation/widgets/wage_hourly_card.dart` — already takes `WageHourly wageHourly` parameter
- `lib/src/features/wage/presentation/widgets/wage_hourly_info.dart` — already takes `WageHourly wageHourly` parameter
- `lib/src/features/wage/presentation/widgets/update_wage_button.dart` — just opens dialog, no BLoC interaction
- `lib/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart` — wraps ErrorView, unchanged
- `lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart` — `EmptyWageHourlyView` becomes orphaned (no `empty` state in new sealed class) — defer cleanup to Story 3.6 naming pass
- `lib/src/features/wage/presentation/pages/update_wage_page.dart` — contains WageHourlyField and SetWageButton, no BLoC state references
- `lib/src/features/wage/domain/` — entire domain layer unchanged (entities, repository interface, use cases)
- `lib/src/features/wage/data/` — entire data layer unchanged (datasource, repository implementation, models)

### Approach Order

1. Migrate FetchWageBloc — event, state, bloc files (Task 1)
2. Migrate UpdateWageBloc — event, state, bloc files (Task 2)
3. Update presentation widgets: FetchWageScreen, delete WageHourlyDataView, update widgets barrel, SetWageButton, WageHourlyField (Task 3)
4. Delete `.freezed.dart` files
5. Run `dart run build_runner build --delete-conflicting-outputs` (regenerate remaining Freezed files — domain entities only)
6. Write use case tests (Task 4.1-4.3)
7. Write repository test (Task 4.4)
8. Write BLoC tests (Task 5)
9. Run `flutter analyze` — zero warnings
10. Run `flutter test` — all pass

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 3, Story 3.4]
- [Source: _bmad-output/planning-artifacts/architecture.md — State Management, Testing Standards, Code Structure, BLoC Patterns]
- [Source: _bmad-output/implementation-artifacts/3-3-times-feature-update-delete-bloc-migration.md — Previous story patterns, bug fixes, review warnings]
- [Source: lib/src/features/times/presentation/bloc/list_times_bloc.dart — emit.forEach reference pattern]
- [Source: lib/src/features/times/presentation/bloc/create_time_bloc.dart — Action BLoC reference pattern]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

N/A — no blocking issues encountered.

### Completion Notes List

- Migrated FetchWageBloc from Freezed `part of` pattern to standalone sealed classes with `emit.forEach` for internal stream consumption. Eliminated `StreamBuilder` in UI.
- Migrated UpdateWageBloc from Freezed with `ActionState<T>` wrapper to standalone sealed classes with form data (`wageHourly`) on sealed base.
- Fixed 8 bugs documented in story Dev Notes: stream exposure to UI, missing Loading state, `FutureOr<void>` return type, non-async handler, wrong delay placement, competing resets, manual navigation race, no-op listeners.
- Updated FetchWageScreen with `BlocConsumer` + `listenWhen` for PaymentCubit sync, exhaustive `switch` expression on 4 sealed states.
- Deleted `WageHourlyDataView` (StreamBuilder wrapper) — FetchWageBloc now handles stream internally.
- Updated SetWageButton with `BlocConsumer` + `listenWhen` for success → `Navigator.pop()`, exhaustive `switch` on sealed states.
- Updated WageHourlyField from `BlocConsumer` with no-op listener to `BlocBuilder`.
- Created 6 test files: 3 use case tests, 1 repository test, 2 BLoC tests — all 90 tests passing.
- Zero warnings on `flutter analyze`.

### Change Log

- 2026-03-18: Story 3.4 implemented — wage feature sealed class BLoC migration complete.
- 2026-03-18: Code review passed — 3-layer adversarial review (Blind Hunter, Edge Case Hunter, Acceptance Auditor). 19 findings raised, 1 patch applied (P-1: disable `SetWageButton.onPressed` during `UpdateWageLoading` to prevent double-submit race), 1 bad-spec documented (BS-1: pop-before-success-feedback accepted as established pattern — same design as Story 3.3 `UpdateTimeButton`/`DeleteTimeButton`, UX feedback is provided by loading spinner), 5 deferred as pre-existing (_ActionWidget no-op, Future.delayed closed-emitter, zero/negative wage validation, rebuild dispatch, GlobalFailure equality), 8 rejected as noise. 90/90 tests passing, 0 warnings. Story done.

### File List

**Modified (7):**
- `lib/src/features/wage/presentation/bloc/fetch_wage_event.dart`
- `lib/src/features/wage/presentation/bloc/fetch_wage_state.dart`
- `lib/src/features/wage/presentation/bloc/fetch_wage_bloc.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_event.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_state.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_bloc.dart`
- `lib/src/features/wage/presentation/pages/fetch_wage_screen.dart`
- `lib/src/features/wage/presentation/widgets/set_wage_button.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_field.dart`
- `lib/src/features/wage/presentation/widgets/widgets.dart`

**Deleted (3):**
- `lib/src/features/wage/presentation/bloc/fetch_wage_bloc.freezed.dart`
- `lib/src/features/wage/presentation/bloc/update_wage_bloc.freezed.dart`
- `lib/src/features/wage/presentation/widgets/wage_hourly_data_view.dart`

**Created (6):**
- `test/src/features/wage/domain/use_cases/fetch_wage_use_case_test.dart`
- `test/src/features/wage/domain/use_cases/set_wage_use_case_test.dart`
- `test/src/features/wage/domain/use_cases/update_wage_use_case_test.dart`
- `test/src/features/wage/data/repositories/objectbox_wage_repository_test.dart`
- `test/src/features/wage/presentation/bloc/fetch_wage_bloc_test.dart`
- `test/src/features/wage/presentation/bloc/update_wage_bloc_test.dart`
