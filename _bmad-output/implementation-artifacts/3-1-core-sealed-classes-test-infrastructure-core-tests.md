# Story 3.1: Core Sealed Classes, Test Infrastructure & Core Tests

Status: ready-for-dev

## Story

As a developer,
I want to migrate ActionState, GlobalFailure, and ValueFailure to sealed classes, and establish the test infrastructure with core unit tests,
So that all union types use native sealed classes consistently and the testing foundation is ready for all subsequent stories (FR40).

## Acceptance Criteria

1. **ActionState sealed class migration**
   - `sealed class ActionState<T>` in `core/ui/action_state.dart` with variants: `ActionInitial`, `ActionLoading`, `ActionSuccess<T>`, `ActionError`
   - All variants use `final class` keyword with `const` constructors
   - `action_state.freezed.dart` deleted — no Freezed dependency
   - All consumer files updated to use new API (direct constructors, `switch` expressions where `.when()` was used) — see Consumer Update Reference in Dev Notes for complete file list

2. **GlobalFailure & ValueFailure sealed class migration**
   - `sealed class GlobalFailure` (drop generic `<F>`) in `core/errors/failures.dart` with variants: `ServerError`, `NotConnection`, `TimeOutExceeded`, `InternalError`
   - `sealed class ValueFailure<T>` with variants: `CharacterLimitExceeded`, `ShortOrNullCharacters`, `InvalidFormat`
   - All variants use `final class` keyword with `const` constructors
   - `GlobalFailure.fromException()` preserved as static factory method
   - `GlobalDefaultFailure` typedef removed (no longer needed without generic)
   - `failures.freezed.dart` deleted
   - All consumer files updated

3. **AppDurations verification**
   - Already `abstract final class AppDurations` — verify unchanged, no action needed

4. **Test infrastructure creation**
   - `test/helpers/pump_app.dart` — already exists, verify adequate (localization + MaterialApp wrapping)
   - `test/helpers/mocks.dart` — NEW: shared mock classes via mocktail for `TimesRepository`, `WageRepository`, and all use cases
   - `test/helpers/helpers.dart` — update barrel to export `mocks.dart`
   - `flutter test` runs successfully with helpers available

5. **Core unit tests rewritten for sealed classes**
   - `test/src/core/ui/action_state_test.dart` — rewrite 11 tests to use `switch`/type checks instead of `.when()`
   - `test/src/core/errors/failures_test.dart` — rewrite 12 tests to use `switch`/type checks instead of `.when()`
   - All core tests pass via `flutter test`

6. **Zero lint compliance**
   - `flutter analyze` produces zero warnings on core and test files

## Tasks / Subtasks

- [ ] Task 1: Migrate GlobalFailure & ValueFailure to sealed classes (AC: #2)
  - [ ] 1.1 Replace Freezed `GlobalFailure<F>` with `sealed class GlobalFailure` (no generic) in `lib/src/core/errors/failures.dart`
  - [ ] 1.2 Define `final class` variants: `ServerError`, `NotConnection`, `TimeOutExceeded`, `InternalError` — all with `const` constructors
  - [ ] 1.3 Preserve `GlobalFailure.fromException()` as static factory method (same logic: SocketException → NotConnection, TimeoutException → TimeOutExceeded, else → InternalError)
  - [ ] 1.4 Replace Freezed `ValueFailure<T>` with `sealed class ValueFailure<T>` and `final class` variants
  - [ ] 1.5 Remove `GlobalDefaultFailure` typedef — update all references to use `GlobalFailure` directly
  - [ ] 1.6 Delete `lib/src/core/errors/failures.freezed.dart`
  - [ ] 1.7 Remove `freezed_annotation` import and `part` directive from `failures.dart`

- [ ] Task 2: Migrate ActionState to sealed class (AC: #1)
  - [ ] 2.1 Replace Freezed `ActionState<T>` with `sealed class ActionState<T>` in `lib/src/core/ui/action_state.dart`
  - [ ] 2.2 Define `final class` variants: `ActionInitial<T>`, `ActionLoading<T>`, `ActionSuccess<T>`, `ActionError<T>` — all with `const` constructors
  - [ ] 2.3 Remove `ActionInfo` extension — replace with type-check getters directly on sealed class (e.g., `bool get isInitial => this is ActionInitial<T>;`)
  - [ ] 2.4 Delete `lib/src/core/ui/action_state.freezed.dart`
  - [ ] 2.5 Remove `freezed_annotation` import and `part` directive

- [ ] Task 3: Update all consumer files (AC: #1, #2) — see Consumer Update Reference groups B-F
  - [ ] 3.1 Group B: Update `error_view.dart` — `GlobalDefaultFailure` → `GlobalFailure`, `.when()` → `switch` expression
  - [ ] 3.2 Group C: Update widget files that call `.when()` on ActionState — `create_time_button.dart`, `update_time_button.dart`, `set_wage_button.dart` — change `state.currentState.when(` → `switch (state.currentState) {`
  - [ ] 3.3 Group D: Update BLoC files with ActionState constructors — change `ActionState.initial()` → `ActionInitial()`, etc. **Watch for tear-offs:** `result.fold(ActionState.error, ActionState.success)` → `result.fold(ActionError.new, ActionSuccess.new)`
  - [ ] 3.4 Group E: Update all files using `GlobalDefaultFailure` typedef → `GlobalFailure` (BLoC states, error view widgets)
  - [ ] 3.5 Group F: Update repository files — remove generic from `GlobalFailure<dynamic>` → `GlobalFailure`
  - [ ] 3.6 Group G: Delete `action_state.freezed.dart` and `failures.freezed.dart` (core only)
  - [ ] 3.7 Run `flutter analyze` — zero warnings
  - [ ] 3.8 Run `flutter test` (tests will fail until Task 5 rewrites them)

- [ ] Task 4: Create test infrastructure (AC: #4)
  - [ ] 4.1 Create `test/helpers/mocks.dart` with shared mocktail mocks:
    - `class MockTimesRepository extends Mock implements TimesRepository {}`
    - `class MockWageRepository extends Mock implements WageRepository {}`
    - `class MockCreateTimeUseCase extends Mock implements CreateTimeUseCase {}`
    - `class MockDeleteTimeUseCase extends Mock implements DeleteTimeUseCase {}`
    - `class MockListTimesUseCase extends Mock implements ListTimesUseCase {}`
    - `class MockUpdateTimeUseCase extends Mock implements UpdateTimeUseCase {}`
    - `class MockFetchWageUseCase extends Mock implements FetchWageUseCase {}`
    - `class MockSetWageUseCase extends Mock implements SetWageUseCase {}`
    - `class MockUpdateWageUseCase extends Mock implements UpdateWageUseCase {}`
    - `class MockCalculatePaymentUseCase extends Mock implements CalculatePaymentUseCase {}`
  - [ ] 4.2 Update `test/helpers/helpers.dart` barrel to export both `pump_app.dart` and `mocks.dart`
  - [ ] 4.3 Verify `pump_app.dart` is adequate (already has localization + MaterialApp)

- [ ] Task 5: Rewrite core unit tests (AC: #5)
  - [ ] 5.1 Rewrite `test/src/core/ui/action_state_test.dart` — use type checks (`is ActionInitial`) and `switch` expressions instead of `.when()`
  - [ ] 5.2 Rewrite `test/src/core/errors/failures_test.dart` — use type checks and `switch` expressions instead of `.when()`
  - [ ] 5.3 All 23 tests pass via `flutter test`

- [ ] Task 6: Final verification (AC: #6)
  - [ ] 6.1 `flutter analyze` — zero warnings
  - [ ] 6.2 `flutter test` — all tests pass
  - [ ] 6.3 App compiles and runs correctly

## Dev Notes

### Critical Migration Details

**ActionState — FROM (Freezed):**
```dart
@freezed
abstract class ActionState<T> with _$ActionState<T> {
  const factory ActionState.initial() = _Initial<T>;
  const factory ActionState.loading() = _Loading<T>;
  const factory ActionState.error(GlobalDefaultFailure err) = _Error<T>;
  const factory ActionState.success(T value) = _Success<T>;
}
```

**ActionState — TO (Sealed Class):**
```dart
sealed class ActionState<T> {
  const ActionState();
}

final class ActionInitial<T> extends ActionState<T> {
  const ActionInitial();
}

final class ActionLoading<T> extends ActionState<T> {
  const ActionLoading();
}

final class ActionSuccess<T> extends ActionState<T> {
  const ActionSuccess(this.data);
  final T data;
}

final class ActionError<T> extends ActionState<T> {
  const ActionError(this.failure);
  final GlobalFailure failure;
}
```

**ActionInfo extension — remove entirely.** The convenience getters (`isInitial`, `isLoading`, etc.) can move as getters on the sealed class base if needed, but prefer `switch` expressions in consumers. If BLoCs still need boolean checks, add them as:
```dart
sealed class ActionState<T> {
  const ActionState();
  bool get isInitial => this is ActionInitial<T>;
  bool get isLoading => this is ActionLoading<T>;
  bool get isSuccess => this is ActionSuccess<T>;
  bool get isError => this is ActionError<T>;
}
```

**GlobalFailure — FROM (Freezed with generic):**
```dart
@freezed
abstract class GlobalFailure<F> with _$GlobalFailure<F> {
  const factory GlobalFailure.serverError(F failure) = ServerError<F>;
  const factory GlobalFailure.notConnection() = NotConnection<F>;
  const factory GlobalFailure.timeOutExceeded() = TimeOutExceeded<F>;
  const factory GlobalFailure.internalError(dynamic err, [StackTrace? st]) = LocalError<F>;
  factory GlobalFailure.fromException(Object err, [StackTrace? st]) { ... }
}
typedef GlobalDefaultFailure = GlobalFailure<dynamic>;
```

**GlobalFailure — TO (Sealed Class, no generic):**
```dart
sealed class GlobalFailure {
  const GlobalFailure();

  factory GlobalFailure.fromException(Object err, [StackTrace? st]) {
    if (err is SocketException) return const NotConnection();
    if (err is TimeoutException) return const TimeOutExceeded();
    if (kDebugMode) {
      developer.log('Exception Failure', error: err, stackTrace: st);
    }
    return InternalError(err, st);
  }
}

final class ServerError extends GlobalFailure {
  const ServerError(this.failure);
  final Object failure;
}

final class NotConnection extends GlobalFailure {
  const NotConnection();
}

final class TimeOutExceeded extends GlobalFailure {
  const TimeOutExceeded();
}

final class InternalError extends GlobalFailure {
  const InternalError(this.error, [this.stackTrace]);
  final dynamic error;
  final StackTrace? stackTrace;
}
```

**Key API changes:**
- `ServerError` field: was `F failure` (generic) → now `Object failure` (concrete). Simplification — the generic was always `dynamic` in practice.
- `LocalError` renamed → `InternalError` (matches the named constructor pattern)
- `GlobalDefaultFailure` typedef removed — all references become just `GlobalFailure`

**ValueFailure — TO (Sealed Class):**
```dart
sealed class ValueFailure<T> {
  const ValueFailure();
}

final class CharacterLimitExceeded<T> extends ValueFailure<T> {
  const CharacterLimitExceeded({required this.failedValue});
  final T failedValue;
}

final class ShortOrNullCharacters<T> extends ValueFailure<T> {
  const ShortOrNullCharacters({required this.failedValue});
  final T failedValue;
}

final class InvalidFormat<T> extends ValueFailure<T> {
  const InvalidFormat({required this.failedValue});
  final T failedValue;
}
```

### Consumer Update Reference

**Group A — Core type definitions (sealed class migration):**
- `lib/src/core/errors/failures.dart` — Freezed → sealed class (GlobalFailure + ValueFailure)
- `lib/src/core/ui/action_state.dart` — Freezed → sealed class (ActionState)

**Group B — Files using `.when()` on GlobalFailure (must change to `switch`):**
- `lib/src/shared/widgets/error_view.dart` — `failure.when(...)` → `switch (failure) { ... }`, also `GlobalDefaultFailure` → `GlobalFailure` parameter type

**Group C — Files using `.when()` on ActionState (must change to `switch`):**
- `lib/src/features/times/presentation/widgets/create_time_button.dart` — `state.currentState.when(` → `switch (state.currentState) {`
- `lib/src/features/times/presentation/widgets/update_time_button.dart` — `state.currentState.when(` → `switch (state.currentState) {`
- `lib/src/features/wage/presentation/widgets/set_wage_button.dart` — `state.currentState.when(` → `switch (state.currentState) {`

**Group D — Files using `ActionState` constructors (must change to variant classes):**
- `lib/src/features/times/presentation/bloc/create_time_bloc.dart` — `ActionState.initial()` → `ActionInitial()`, `ActionState.loading()` → `ActionLoading()`, `ActionState.error(f)` → `ActionError(f)`, `ActionState.success(v)` → `ActionSuccess(v)`. **Tear-off warning:** `result.fold(ActionState.error, ActionState.success)` → `result.fold(ActionError.new, ActionSuccess.new)`
- `lib/src/features/times/presentation/bloc/create_time_state.dart` — `ActionState<TimeEntry>` field type stays, `ActionState<TimeEntry>.initial()` → `ActionInitial<TimeEntry>()`
- `lib/src/features/times/presentation/bloc/update_time_bloc.dart` — same constructor changes as create_time_bloc. **Tear-off warning:** same `result.fold()` pattern
- `lib/src/features/times/presentation/bloc/update_time_state.dart` — constructor calls change
- `lib/src/features/times/presentation/bloc/delete_time_state.dart` — constructor calls change
- `lib/src/features/wage/presentation/bloc/update_wage_state.dart` — constructor calls change
- `lib/src/features/wage/presentation/bloc/update_wage_bloc.dart` — constructor calls change

**Group E — Files using `GlobalDefaultFailure` typedef (must change to `GlobalFailure`):**
- `lib/src/features/times/presentation/bloc/create_time_state.dart` — if uses `GlobalDefaultFailure`
- `lib/src/features/times/presentation/bloc/delete_time_state.dart` — uses `GlobalFailure<dynamic>`
- `lib/src/features/times/presentation/bloc/list_times_state.dart` — uses `GlobalDefaultFailure`
- `lib/src/features/wage/presentation/bloc/fetch_wage_state.dart` — uses `GlobalDefaultFailure`
- `lib/src/features/wage/presentation/bloc/update_wage_state.dart` — uses `GlobalDefaultFailure`
- `lib/src/features/times/presentation/widgets/error_list_times_view.dart` — `GlobalDefaultFailure` parameter type → `GlobalFailure`
- `lib/src/features/wage/presentation/widgets/error_fetch_wage_hourly_view.dart` — `GlobalDefaultFailure` parameter type → `GlobalFailure`

**Group F — Repository files (constructor syntax stays same, remove generic):**
- `lib/src/features/times/data/repositories/objectbox_times_repository.dart` — `GlobalFailure.internalError()` unchanged, verify `GlobalFailure<dynamic>` → `GlobalFailure`
- `lib/src/features/wage/data/repositories/objectbox_wage_repository.dart` — same
- `lib/src/features/times/domain/repositories/times_repository.dart` — `Either<GlobalFailure<dynamic>, T>` → `Either<GlobalFailure, T>`
- `lib/src/features/wage/domain/repositories/wage_repository.dart` — `GlobalDefaultFailure` / `GlobalFailure<dynamic>` → `GlobalFailure`

**Group G — Generated files to DELETE (core only):**
- `lib/src/core/ui/action_state.freezed.dart` — DELETE
- `lib/src/core/errors/failures.freezed.dart` — DELETE

**DO NOT touch `.freezed.dart` files in BLoC folders** — those belong to BLoC events/states and will be migrated in Stories 3.2-3.5.

### Approach Order

**Recommended execution order to minimize broken state:**
1. Migrate `failures.dart` first (GlobalFailure + ValueFailure) — foundation type
2. Migrate `action_state.dart` second — depends on GlobalFailure
3. Update consumer files batch by batch (repositories → BLoC states → BLoC blocs → widgets)
4. Delete `.freezed.dart` files for core only
5. Run `flutter analyze` + `flutter test` (tests will fail until step 6)
6. Create test infrastructure (mocks.dart)
7. Rewrite core tests
8. Final verification

### Technical Debt Awareness (from Epic 2 Retrospective)

These are documented pre-existing issues. **DO NOT fix them in this story** — they are scoped to later stories:

| ID | Description | Resolution Story |
|----|-------------|-----------------|
| D-1 | TextEditingController not synced with bloc state | 3.2 / 3.3 |
| D-2 | BlocConsumer listener is no-op in 5 widget files | 3.2 / 3.3 |
| D-3 | StackTrace captured but discarded in error_view.dart | 3.x |
| D-4 | DeleteTimeBloc `.fold()` result not emitted | 3.3 |
| D-5 | CreateTimeEvent `_Reset` has no registered `on<_Reset>` handler | 3.2 |
| W1 | times/wage data views import PaymentCubit (cross-feature) | 3.5 |

### Anti-Patterns — NEVER Do

- **NEVER** use Freezed for ActionState, GlobalFailure, or ValueFailure after this story
- **NEVER** use `.when()` pattern matching — use native `switch` expressions
- **NEVER** use `if/else` chains on sealed class types — always exhaustive `switch`
- **NEVER** edit `.freezed.dart` files in BLoC folders — those are Epic 3 Stories 3.2-3.5 scope
- **NEVER** throw exceptions from repository implementations — always `left(GlobalFailure.xxx)`
- **NEVER** use relative imports — always `package:time_money/src/...`

### Project Structure Notes

- All core files stay in existing locations: `lib/src/core/ui/`, `lib/src/core/errors/`, `lib/src/core/constants/`
- Test files mirror source: `test/src/core/ui/`, `test/src/core/errors/`
- New file: `test/helpers/mocks.dart` only
- Deleted files: `lib/src/core/ui/action_state.freezed.dart`, `lib/src/core/errors/failures.freezed.dart`
- Barrel exports (`core/ui/ui.dart`, `core/errors/errors.dart`) — no changes needed (they export `action_state.dart` and `failures.dart` which keep same names)

### Testing Standards

- **Test framework:** `flutter_test`, `bloc_test` ^10.0.0, `mocktail` ^1.0.0
- **Mock pattern:** `class MockX extends Mock implements X {}` (mocktail, NOT mockito)
- **BLoC test pattern:** `blocTest<BlocType, StateType>()` with `build`, `act`, `expect`
- **Test file naming:** Mirror source path exactly
- **Coverage target:** 100% on use cases, BLoCs, repositories; 85%+ overall
- **Test command:** `flutter test --coverage --test-randomize-ordering-seed random`
- **Every test uses `pumpApp()` for widget tests** — wraps with localization + MaterialApp

### Dependencies — Verify Before Starting

Confirm these are in `pubspec.yaml` dev_dependencies (they should already be):
- `mocktail: ^1.0.0`
- `bloc_test: ^10.0.0`
- `very_good_analysis: ^10.2.0`

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 3, Story 3.1 acceptance criteria]
- [Source: _bmad-output/planning-artifacts/architecture.md — Sealed class patterns, testing standards, code structure]
- [Source: _bmad-output/planning-artifacts/prd.md — FR40, FR45-FR49, NFR6]
- [Source: _bmad-output/implementation-artifacts/epic-2-retro-2026-03-18.md — Tech debt D-1 through D-5, team agreements]
- [Source: _bmad-output/implementation-artifacts/2-5-flutter-hooks-removal-shared-widgets-extraction.md — DI patterns, shared widgets, previous story learnings]
- [Source: _bmad-output/project-context.md — Current tech stack, test configuration, conventions]

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### Change Log

### File List
