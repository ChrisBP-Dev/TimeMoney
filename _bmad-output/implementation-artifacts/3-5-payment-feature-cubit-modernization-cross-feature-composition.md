# Story 3.5: Payment Feature — Cubit Modernization & Cross-Feature Composition

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to calculate my total payment based on recorded time entries and current hourly wage,
so that I can see an accurate payment summary with total hours, minutes, rate, and payment amount (FR12-FR14, FR44).

## Acceptance Criteria

1. **PaymentState migrated to sealed class** — `sealed class PaymentState` with variants `PaymentInitial` (no data/button disabled) and `PaymentReady(List<TimeEntry> times, double wageHourly)` (both data sets available/button enabled); all variants use `final class`; data-carrying variant overrides `==` and `hashCode` using `const ListEquality<TimeEntry>()` from `package:collection`; state file is standalone (no `part of`); `payment_cubit.freezed.dart` deleted

2. **PaymentCubit modernized** — removes Freezed dependency; receives `CalculatePaymentUseCase` via constructor (`PaymentCubit(this._calculatePaymentUseCase)`); has internal `_times: List<TimeEntry>` and `_wageHourly: double` fields; `setTimes(List<TimeEntry>)` and `setWage(double)` update internal fields and call `_tryEmitReady()`; `_tryEmitReady()` emits `PaymentReady` when `_times.isNotEmpty && _wageHourly > 0`, otherwise emits `PaymentInitial` (BLoC deduplicates if same state); `calculate()` is synchronous and returns `Either<GlobalFailure, PaymentResult>` via exhaustive `switch` on current state; payment calculation derives from already-available data — no user-initiated data fetch (FR44)

3. **PaymentResult value object created** — `lib/src/features/payment/domain/entities/payment_result.dart` defines `PaymentResult` with `const` constructor and fields: `totalHours: int`, `totalMinutes: int`, `wageHourly: double`, `totalPayment: double`, `workedDays: int`; manual `==` and `hashCode` via `Object.hash`; NOT Freezed (no copyWith/JSON needed — computed result, not persisted entity)

4. **CalculatePaymentUseCase moved and updated** — moved from `lib/src/features/payment/aplication/calculate_payment_use_case.dart` to `lib/src/features/payment/domain/use_cases/calculate_payment_use_case.dart`; return type changes from `double` to `Either<GlobalFailure, PaymentResult>`; uses existing extension methods from `time_entry.dart` (`times.totalHours`, `times.totalMinutes`, `times.calculatePayment(wageHourly)`, `times.length`); wrapped in `try/catch` that returns `left(GlobalFailure.fromException(e))` on error; old `aplication/` files deleted

5. **PaymentResultPage updated** — receives `PaymentResult result` instead of raw `(List<TimeEntry> times, double wageHourly)`; reads `result.totalHours`, `result.totalMinutes`, `result.wageHourly`, `result.totalPayment.toStringAsFixed(2)`, `result.workedDays`; no behavior change — visual output identical to pre-migration

6. **CalculatePaymentButton modernized** — replaces `BlocConsumer` with no-op listener → `BlocBuilder` (BS-1 pattern); `onPressed` is `null` when `state is PaymentInitial`, active when `state is PaymentReady`; on tap: `context.read<PaymentCubit>().calculate()` → `result.fold((failure) {}, (paymentResult) => unawaited(showDialog(...PaymentResultPage(result: paymentResult))))` ; no longer accesses `state.times` or `state.wageHourly` directly — state pattern matching only

7. **Cross-feature integrations updated** — `list_times_screen.dart` renames `PaymentCubit.setList(times)` → `PaymentCubit.setTimes(times)`; `test/helpers/mocks.dart` updates import path of `MockCalculatePaymentUseCase` to `domain/use_cases/`; `payment_cubits.dart` passes `const CalculatePaymentUseCase()` to cubit constructor

8. **Tests written alongside implementation** — `calculate_payment_use_case_test.dart` and `payment_cubit_test.dart` — 100% coverage, all passing; payment use case test verifies execution under 50ms (NFR4)

9. **Zero warnings** on `flutter analyze` for all modified and created files; app launches and payment calculation works end-to-end (enter times → set wage → Calculate Payment button enables → tap → PaymentResultPage shows correct values)

## Tasks / Subtasks

- [ ] Task 1: Create new domain entities and use case (AC: #3, #4)
  - [ ] 1.1 Create `lib/src/features/payment/domain/entities/payment_result.dart` — `PaymentResult` value object with 5 fields, manual `==`/`hashCode`
  - [ ] 1.2 Create `lib/src/features/payment/domain/use_cases/calculate_payment_use_case.dart` — new location, `Either<GlobalFailure, PaymentResult>` return type, uses `CalculatePay` extension
  - [ ] 1.3 Create `lib/src/features/payment/domain/use_cases/use_cases.dart` — barrel export
  - [ ] 1.4 Delete `lib/src/features/payment/aplication/calculate_payment_use_case.dart` and `aplication/use_cases.dart` (old location)
- [ ] Task 2: Migrate PaymentState to sealed class (AC: #1)
  - [ ] 2.1 Rewrite `payment_state.dart` as standalone sealed class — remove `part of`, add own imports, define `PaymentInitial` and `PaymentReady`
- [ ] Task 3: Migrate PaymentCubit (AC: #2)
  - [ ] 3.1 Rewrite `payment_cubit.dart` — remove Freezed parts/annotations, inject `CalculatePaymentUseCase`, add internal fields, `setTimes`, `setWage`, `_tryEmitReady`, `calculate()` with exhaustive switch
  - [ ] 3.2 Delete `payment_cubit.freezed.dart`
  - [ ] 3.3 Update `payment_cubits.dart` — pass `const CalculatePaymentUseCase()` to `PaymentCubit` constructor; add import for new use case location
  - [ ] 3.4 Update `cubit.dart` barrel — ensure `payment_state.dart` is exported (via cubit's `export` directive or directly)
- [ ] Task 4: Update presentation widgets (AC: #5, #6)
  - [ ] 4.1 Rewrite `payment_result_page.dart` — receive `PaymentResult result`, replace all extension method calls with result field reads
  - [ ] 4.2 Rewrite `calculate_payment_button.dart` — `BlocBuilder`, handle Either from `calculate()`, `unawaited(showDialog(...))` on Right
- [ ] Task 5: Update cross-feature integrations (AC: #7)
  - [ ] 5.1 Update `list_times_screen.dart` — `setList(times)` → `setTimes(times)`
  - [ ] 5.2 Update `test/helpers/mocks.dart` — fix import path for `MockCalculatePaymentUseCase`
  - [ ] 5.3 Check `lib/src/shared/injections/use_cases_injection.dart` for any reference to old `aplication/calculate_payment_use_case.dart` — update import if found
- [ ] Task 6: Write use case test (AC: #8)
  - [ ] 6.1 Create `test/src/features/payment/domain/use_cases/calculate_payment_use_case_test.dart`
- [ ] Task 7: Write cubit test (AC: #8)
  - [ ] 7.1 Create `test/src/features/payment/presentation/cubit/payment_cubit_test.dart`
- [ ] Task 8: Verification (AC: #9)
  - [ ] 8.1 Run `flutter analyze` — zero warnings
  - [ ] 8.2 Run `flutter test` — all pass
  - [ ] 8.3 Verify app end-to-end: times → wage → button enables → tap → dialog shows correct result

## Dev Notes

### Current State to Replace

**`payment_cubit.dart` (current — REWRITE):**
```dart
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentState.initial());
  void setList(List<TimeEntry> list) { emit(state.copyWith(times: list)); }
  void setWage(double wageHourly) { emit(state.copyWith(wageHourly: wageHourly)); }
}
```
- Uses Freezed `part of`, `state.copyWith()` — REPLACE entirely

**`payment_state.dart` (current — REWRITE):**
```dart
part of 'payment_cubit.dart';
@freezed abstract class PaymentState with _$PaymentState {
  const factory PaymentState({@Default([]) List<TimeEntry> times, @Default(0.0) double wageHourly}) = _PaymentState;
  factory PaymentState.initial() => const PaymentState();
}
```
- `part of` pattern, Freezed `@freezed` — REPLACE with standalone sealed class

**`calculate_payment_use_case.dart` (current — MOVE + REWRITE):**
```dart
// Located at: lib/src/features/payment/aplication/calculate_payment_use_case.dart
class CalculatePaymentUseCase {
  const CalculatePaymentUseCase();
  double call(List<TimeEntry> times, double wageHourly) {
    return times.calculatePayment(wageHourly);
  }
}
```
- Returns `double`, no `Either` wrapping, wrong folder — MOVE to `domain/use_cases/`, UPDATE return type

**`calculate_payment_button.dart` (current — REWRITE):**
```dart
BlocConsumer<PaymentCubit, PaymentState>(
  // TODO(epic3): replace with BlocBuilder (listener is no-op)
  listener: (context, state) => state,  // no-op listener
  builder: (context, state) {
    return FloatingActionButton.extended(
      onPressed: state.times.isEmpty   // direct field access
        ? null
        : () { unawaited(showDialog<void>(
            builder: (_) => PaymentResultPage(times: state.times, wageHourly: state.wageHourly)));
          },
      label: const Text('Calculate Payment'),
    );
  },
)
```
- `BlocConsumer` with no-op listener (BS-1 violation), accesses `state.times` — REPLACE with `BlocBuilder` + sealed state check

**Cross-feature (current — UPDATE):**
- `list_times_screen.dart` line 15: `context.read<PaymentCubit>().setList(times)` → `.setTimes(times)`
- `fetch_wage_screen.dart` calls `context.read<PaymentCubit>().setWage(state.wage.value)` — already correct, NO CHANGE needed

### Target Architecture — Exact Specifications

#### PaymentResult (`payment/domain/entities/payment_result.dart`)

```dart
class PaymentResult {
  const PaymentResult({
    required this.totalHours,
    required this.totalMinutes,
    required this.wageHourly,
    required this.totalPayment,
    required this.workedDays,
  });

  final int totalHours;
  final int totalMinutes;
  final double wageHourly;
  final double totalPayment;
  final int workedDays;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResult &&
          totalHours == other.totalHours &&
          totalMinutes == other.totalMinutes &&
          wageHourly == other.wageHourly &&
          totalPayment == other.totalPayment &&
          workedDays == other.workedDays;

  @override
  int get hashCode =>
      Object.hash(totalHours, totalMinutes, wageHourly, totalPayment, workedDays);
}
```
- **NOT Freezed** — no persistence, no JSON, no copyWith needed
- Plain Dart class with manual equality (same pattern as `FetchWageLoaded.==` from story 3.4)

#### CalculatePaymentUseCase (`payment/domain/use_cases/calculate_payment_use_case.dart`)

```dart
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

class CalculatePaymentUseCase {
  const CalculatePaymentUseCase();

  Either<GlobalFailure, PaymentResult> call(
    List<TimeEntry> times,
    double wageHourly,
  ) {
    try {
      return right(
        PaymentResult(
          totalHours: times.totalHours,
          totalMinutes: times.totalMinutes,
          wageHourly: wageHourly,
          totalPayment: times.calculatePayment(wageHourly),
          workedDays: times.length,
        ),
      );
    } catch (e) {
      return left(GlobalFailure.fromException(e));
    }
  }
}
```
- Reuses `CalculatePay` extension from `time_entry.dart` (`totalHours`, `totalMinutes`, `calculatePayment`)
- Architecture allows `payment/domain/` to import `times/domain/entities/` ✅
- Wraps in `try/catch` for defensive Either pattern — pure math so Left is unreachable in practice
- `const` constructor — no dependencies

#### PaymentState (`payment/presentation/cubit/payment_state.dart`)

```dart
import 'package:collection/collection.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

sealed class PaymentState {
  const PaymentState();
}

final class PaymentInitial extends PaymentState {
  const PaymentInitial();

  @override
  bool operator ==(Object other) => other is PaymentInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class PaymentReady extends PaymentState {
  const PaymentReady({required this.times, required this.wageHourly});

  final List<TimeEntry> times;
  final double wageHourly;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReady &&
          const ListEquality<TimeEntry>().equals(times, other.times) &&
          wageHourly == other.wageHourly;

  @override
  int get hashCode =>
      Object.hash(const ListEquality<TimeEntry>().hash(times), wageHourly);
}
```
- **Standalone file** — no `part of`; cubit file exports this via `export 'payment_state.dart'`
- **No `@immutable`** — `PaymentReady` carries `List<TimeEntry>` (mutable), same as `ListTimesLoaded`
- `ListEquality<TimeEntry>` from `package:collection` — follows `ListTimesLoaded` pattern for list equality
- `PaymentInitial` must override `==` so BLoC deduplication works correctly
- **No Freezed** — sealed Dart 3 native pattern

#### PaymentCubit (`payment/presentation/cubit/payment_cubit.dart`)

```dart
import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

export 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this._calculatePaymentUseCase) : super(const PaymentInitial());

  final CalculatePaymentUseCase _calculatePaymentUseCase;

  List<TimeEntry> _times = const [];
  double _wageHourly = 0;

  void setTimes(List<TimeEntry> times) {
    _times = times;
    _tryEmitReady();
  }

  void setWage(double wageHourly) {
    _wageHourly = wageHourly;
    _tryEmitReady();
  }

  Either<GlobalFailure, PaymentResult> calculate() {
    return switch (state) {
      PaymentInitial() =>
        left(const InternalError('payment data not available')),
      PaymentReady(:final times, :final wageHourly) =>
        _calculatePaymentUseCase(times, wageHourly),
    };
  }

  void _tryEmitReady() {
    if (_times.isNotEmpty && _wageHourly > 0) {
      emit(PaymentReady(times: _times, wageHourly: _wageHourly));
    } else {
      emit(const PaymentInitial());
    }
  }
}
```
- `export 'payment_state.dart'` — cubit file re-exports state (same pattern as other BLoC files)
- `_times = const []` — starts empty (const list, safe)
- `_wageHourly = 0` — 0 means "not set" (wage is always > 0 in practice)
- `_tryEmitReady()`: BLoC auto-deduplicates — if `PaymentInitial` emitted while already `PaymentInitial`, no rebuild occurs
- `calculate()`: exhaustive `switch` on state — compiler-enforced, no `is` checks
- `calculate()` is **synchronous** — pure math, no `async`/`await`
- **DO NOT** import `action_state.dart` — `PaymentCubit` has no `ActionState` lifecycle (no create/update/delete feedback loop)

#### PaymentCubits — Updated DI (`payment/presentation/cubit/payment_cubits.dart`)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';

class PaymentCubits {
  static List<BlocProvider> list() => [
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(
            const CalculatePaymentUseCase(),
          ),
        ),
      ];
}
```
- `const CalculatePaymentUseCase()` — no dependencies, instantiated inline
- Update import path: `aplication/` → `domain/use_cases/`

#### PaymentResultPage — Updated (`payment/presentation/pages/payment_result_page.dart`)

Replace `(List<TimeEntry> times, double wageHourly)` params with `(PaymentResult result)`:
```dart
import 'package:flutter/material.dart';
import 'package:time_money/src/features/payment/domain/entities/payment_result.dart';
// Remove: import of TimeEntry (no longer needed)

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({required this.result, super.key});
  final PaymentResult result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // ...keep existing structure...
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Hours:'), subtitle: Text('${result.totalHours}')),
          ListTile(title: const Text('Minutes:'), subtitle: Text('${result.totalMinutes}')),
          ListTile(title: const Text('Hourly:'), subtitle: Text('${result.wageHourly} Dolars')),
          ListTile(title: const Text('Worked days:'), subtitle: Text('${result.workedDays}')),
          const Divider(),
          Card(
            child: Center(
              child: Text(
                '\$/. ${result.totalPayment.toStringAsFixed(2)}',
                // ...keep existing style...
              ),
            ),
          ),
        ],
      ),
      // ...keep existing actions...
    );
  }
}
```
- **No behavior change** — visual output identical to pre-migration
- Hardcoded strings (`'Result Info:'`, `'Dolars'`, `'Save'`) are preexisting — leave as-is (NFR17 out of scope for this story)

#### CalculatePaymentButton — Updated (`home/presentation/widgets/calculate_payment_button.dart`)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:time_money/src/features/payment/presentation/pages/pages.dart';

class CalculatePaymentButton extends StatelessWidget {
  const CalculatePaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed: state is! PaymentReady
              ? null
              : () {
                  final result = context.read<PaymentCubit>().calculate();
                  result.fold(
                    (_) {},
                    (paymentResult) => unawaited(
                      showDialog<void>(
                        context: context,
                        builder: (_) => PaymentResultPage(result: paymentResult),
                      ),
                    ),
                  );
                },
          label: const Text('Calculate Payment'),
        );
      },
    );
  }
}
```
- **BS-1**: `BlocBuilder` replaces `BlocConsumer` with no-op listener — no side effects, pure UI rendering
- `calculate()` is synchronous — no `async/await` in `onPressed`
- `result.fold((_) {}, ...)` — Left path is no-op (button disabled during `PaymentInitial`, so Left is unreachable in practice)
- `unawaited(showDialog<void>(...))` — follows pattern from `home_page.dart` and existing codebase

### Cross-Feature Impact

**`lib/src/features/times/presentation/pages/list_times_screen.dart` — UPDATE ONE LINE:**
```dart
// Line 15 (current):
context.read<PaymentCubit>().setList(times);
// After:
context.read<PaymentCubit>().setTimes(times);
```
- BlocConsumer listener is meaningful (syncs times to PaymentCubit) — keep `BlocConsumer`, only rename method
- `listenWhen` guard (P-2) would be an optimization here but is OUT OF SCOPE — only rename the method, do not refactor this widget
- The `bloc: context.read<ListTimesBloc>()..add(const ListTimesRequested())` line — NO CHANGE

**`lib/src/features/wage/presentation/pages/fetch_wage_screen.dart` — NO CHANGE:**
- Already calls `context.read<PaymentCubit>().setWage(state.wage.value)` ✅ — from story 3.4

**`test/helpers/mocks.dart` — UPDATE IMPORT ONLY:**
```dart
// Current:
import 'package:time_money/src/features/payment/aplication/calculate_payment_use_case.dart';
// After:
import 'package:time_money/src/features/payment/domain/use_cases/calculate_payment_use_case.dart';
```
- `MockCalculatePaymentUseCase` class definition — NO CHANGE

### Testing Requirements

#### `calculate_payment_use_case_test.dart`

- **No mock dependencies** — use case is pure (no repository); tests use real `TimeEntry` objects
- Use `const useCase = CalculatePaymentUseCase()` directly

**Required tests:**
```
Standard input:
  - times: [TimeEntry(hour:3,minutes:30), TimeEntry(hour:1,minutes:45)]
  - wage: 20.0
  - Expected: totalHours=5, totalMinutes=15, totalPayment=105.0, workedDays=2
  - Verify: 5h15m → (315 min / 60) * 20 = 105.0 ✓

Zero entries:
  - times: [], wage: 20.0
  - Expected: Right(PaymentResult(0, 0, 20.0, 0.0, 0)) — not Left

Zero wage:
  - times: [TimeEntry(hour:1,minutes:0)], wage: 0.0
  - Expected: Right(PaymentResult(1, 0, 0.0, 0.0, 1))

Single entry exact hours:
  - times: [TimeEntry(hour:2,minutes:0)], wage: 15.0
  - Expected: totalPayment=30.0

Large data set (NFR4 — under 50ms):
  - Generate 100 TimeEntry objects
  - Time the call via Stopwatch
  - Expect result.isRight() && duration.inMilliseconds < 50
```

**Test formula verification:**
```dart
// totalHours = total duration in complete hours
// totalMinutes = remaining minutes after full hours
// totalPayment = (totalHours * wage) + (totalMinutes * wage / 60)
// Equivalent to: (totalDurationMinutes / 60) * wage
```

#### `payment_cubit_test.dart`

- **No mocks** — use `const CalculatePaymentUseCase()` directly (pure, no I/O)
- Use `blocTest<PaymentCubit, PaymentState>` from `bloc_test`
- **No `wait:` parameter** — all PaymentCubit operations are synchronous (no async delays, no `AppDurations.actionFeedback`); do NOT copy `wait: const Duration(seconds: 2)` from story 3.4 BLoC tests
- Helper: `const testEntry = TimeEntry(hour: 2, minutes: 30, id: 1)`

**Required tests:**
```
Initial state:
  test: initial state is PaymentInitial

setWage alone (no times):
  act: c.setWage(15.0)
  expect: [] // PaymentInitial has no change, BLoC deduplicates

setTimes alone (non-empty, no wage):
  act: c.setTimes([testEntry])
  expect: [] // wage=0, _tryEmitReady emits PaymentInitial which == current state

setTimes with empty list alone:
  act: c.setTimes([])
  expect: [] // already PaymentInitial, no change

wage then times → PaymentReady:
  act: c.setWage(15.0); c.setTimes([testEntry])
  expect: [PaymentReady(times: [testEntry], wageHourly: 15.0)]

times then wage → PaymentReady:
  act: c.setTimes([testEntry]); c.setWage(15.0)
  expect: [PaymentReady(times: [testEntry], wageHourly: 15.0)]
  // Only ONE emission (setTimes emits PaymentInitial == current → no change; setWage emits PaymentReady)

update times while PaymentReady:
  act: c.setWage(15.0); c.setTimes([testEntry]); c.setTimes([testEntry, testEntry2])
  expect: [
    PaymentReady(times: [testEntry], wageHourly: 15.0),
    PaymentReady(times: [testEntry, testEntry2], wageHourly: 15.0),
  ]

setTimes empty resets from PaymentReady:
  act: c.setWage(15.0); c.setTimes([testEntry]); c.setTimes([])
  expect: [
    PaymentReady(times: [testEntry], wageHourly: 15.0),
    const PaymentInitial(),
  ]

calculate() when PaymentReady → Right:
  test (not blocTest, since calculate() returns value not emits):
    cubit.setTimes([testEntry]); cubit.setWage(20.0)
    result = cubit.calculate()
    expect(result.isRight(), true)
    // Verify: testEntry = TimeEntry(hour:2, minutes:30)
    // totalHours=2, totalMinutes=30, totalPayment=(2*20)+(30*20/60)=40+10=50.0

calculate() when PaymentInitial → Left:
  test:
    result = PaymentCubit(const CalculatePaymentUseCase()).calculate()
    expect(result.isLeft(), true)
```

**Note:** `calculate()` doesn't emit state → use `test()` not `blocTest()` for calculate() assertions. Only state-transition tests use `blocTest`.

### Project Structure Notes

**New files (create):**
- `lib/src/features/payment/domain/entities/payment_result.dart`
- `lib/src/features/payment/domain/use_cases/calculate_payment_use_case.dart`
- `lib/src/features/payment/domain/use_cases/use_cases.dart`
- `test/src/features/payment/domain/use_cases/calculate_payment_use_case_test.dart`
- `test/src/features/payment/presentation/cubit/payment_cubit_test.dart`

**Modified files (rewrite):**
- `lib/src/features/payment/presentation/cubit/payment_state.dart`
- `lib/src/features/payment/presentation/cubit/payment_cubit.dart`
- `lib/src/features/payment/presentation/cubit/payment_cubits.dart`
- `lib/src/features/payment/presentation/cubit/cubit.dart` (verify exports)
- `lib/src/features/payment/presentation/pages/payment_result_page.dart`
- `lib/src/features/home/presentation/widgets/calculate_payment_button.dart`

**Modified files (one-line change):**
- `lib/src/features/times/presentation/pages/list_times_screen.dart` (setList → setTimes)
- `test/helpers/mocks.dart` (import path only)
- `lib/src/shared/injections/use_cases_injection.dart` (if it references CalculatePaymentUseCase — check and update import if found)

**Deleted files:**
- `lib/src/features/payment/aplication/calculate_payment_use_case.dart`
- `lib/src/features/payment/aplication/use_cases.dart`
- `lib/src/features/payment/presentation/cubit/payment_cubit.freezed.dart`

**Unchanged files (verified):**
- `lib/src/features/wage/presentation/pages/fetch_wage_screen.dart` — `setWage()` call already correct ✅
- `lib/src/features/home/presentation/pages/home_page.dart` — no payment-related code to change ✅
- `lib/src/features/home/presentation/widgets/widgets.dart` — barrel unchanged ✅
- `lib/src/features/payment/presentation/pages/pages.dart` — barrel unchanged ✅

### Anti-Patterns — NEVER Do

From stories 3.2, 3.3, 3.4 (cumulative lessons — all mandatory):
- Use `copyWith()` on PaymentState — construct new sealed variants explicitly
- Use `@freezed` on PaymentState or PaymentResult — Freezed is ONLY for domain entities (TimeEntry, WageHourly)
- Use `part of` / `part` for state files — standalone with own imports
- Access `state.times` or `state.wageHourly` directly outside cubit — use pattern matching
- Use `if/else` chains on state types — always exhaustive `switch`
- Use `BlocConsumer` when listener does nothing — use `BlocBuilder` (BS-1)
- Use `FutureOr<void>` for async helpers — use `Future<void>` (P-1)
- Skip `==` and `hashCode` on `PaymentInitial` — without it, BLoC deduplication fails for this variant
- Use `isNotEmpty` check in `CalculatePaymentButton` on old `state.times` field — state doesn't have a `times` field anymore, use `state is PaymentReady`
- Import from `payment/aplication/` — old folder deleted, always `payment/domain/use_cases/`
- Make `calculate()` async — it's pure math, synchronous only

### Story 3.4 Patterns to Follow (Reference)

The established patterns from stories 3.2-3.4 apply directly:
- **Standalone state file**: no `part of`, own imports, `export` from cubit file
- **Equality**: data-carrying variants override `==` and `hashCode` (required for BLoC deduplication)
- **`final class`** for all concrete sealed variants
- **BS-1 guard**: `BlocConsumer` only when listener does meaningful work — `CalculatePaymentButton` has no side effects → `BlocBuilder`
- **Absolute imports**: always `package:time_money/src/...`

**Key difference from BLoC migrations (3.2-3.4):** PaymentCubit has NO `event` sealed class — it uses direct method calls (`setTimes`, `setWage`, `calculate`) not BLoC event dispatching. This is correct for Cubits. Do NOT add an event layer.

### Accumulated Deferred Items → Story 3.6

> **SCOPE BOUNDARY — story 3.5:** Do NOT address, fix, or refactor any of these items during story 3.5 implementation. They are documented here exclusively for traceability so `create-story 3.6` picks them up. Touching these items in story 3.5 is scope creep.

These items were explicitly deferred across stories 3.1–3.4 and must NOT be ignored again in 3.6. The `create-story 3.6` agent must address each one as part of the "Domain Entities & Naming Conventions Final Pass" or flag them for a dedicated cleanup decision.

#### 🔴 High Priority — Affects Test Correctness

**DEFERRED-1: GlobalFailure equality (origin: stories 3.3 CR + 3.4 CR)**
- `GlobalFailure` sealed class variants (`InternalError`, `UnexpectedError`, etc.) do NOT override `==` and `hashCode`
- Impact: BLoC tests that do `expect(state.failure, const InternalError('...')` may pass via `identical()` (same `const` instance) rather than structural equality — making tests fragile and misleading
- Action for 3.6: verify GlobalFailure and ValueFailure variants all override `==` and `hashCode` correctly; if not, add them
- Source: 3.3 change log "deferred as pre-existing — GlobalFailure equality"; 3.4 change log same

#### 🟡 Medium Priority — Dead Code / Code Quality

**DEFERRED-2: `EmptyWageHourlyView` orphaned widget (origin: story 3.4)**
- `lib/src/features/wage/presentation/widgets/wage_hourly_other_view.dart` contains `EmptyWageHourlyView` which is exported from `widgets.dart` barrel but never used — `FetchWageBloc` has no `FetchWageEmpty` state after sealed class migration
- Action for 3.6: delete `EmptyWageHourlyView` from the file; if `ShimmerWageHourlyView` (also in that file) is still used, keep it
- Source: 3.4 dev notes line "defer cleanup to Story 3.6 naming pass"

**DEFERRED-3: StackTrace discarded in `error_view.dart` (origin: story 3.1 D-3)**
- `error_view.dart` captures `StackTrace` in error patterns but discards it without logging
- Impact: debugging is harder when errors occur silently
- Action for 3.6: either log via `BlocObserver` or remove the StackTrace capture; consistent with error handling patterns
- Source: 3.1 change log "D-3 deferred to 3.x"

#### 🟢 Low Priority — Accepted Pre-Existing Patterns

**DEFERRED-4: `_ActionWidget` no-op buttons (origin: stories 3.3, 3.4 — pre-existing)**
- `list_times_screen.dart` and `fetch_wage_screen.dart` have `_ActionWidget` that renders a broken `ElevatedButton(onPressed: () {}, child: Text('error'))` — no retry logic
- Decision: UI/UX is out of scope per PRD. Leave as-is or clean up the dead widget body in 3.6 if it's trivial
- Source: 3.4 change log "deferred as pre-existing — _ActionWidget no-op"

**DEFERRED-5: Emit-after-close race (origin: story 3.3 CR)**
- All BLoCs that use `Future.delayed(AppDurations.actionFeedback)` before resetting state could theoretically call `emit()` after the BLoC is closed if the widget is disposed during the delay
- BLoC 9.x handles this with `addError()` which is logged by `BlocObserver` — NOT a crash
- Decision: low risk, acceptable as-is. Do NOT add `isClosed` guards (anti-pattern in BLoC 9.x)
- Source: 3.3 change log "deferred as pre-existing — emit-after-close race"

**DEFERRED-6: Double-tap concurrency (origin: story 3.3 CR)**
- Action buttons (UpdateTime, DeleteTime, SetWage) don't disable during `Loading` state to prevent double-submit — except `SetWageButton` which got P-1 fix in 3.4
- Story 3.4 P-1 applied the fix to `SetWageButton.onPressed`. `UpdateTimeButton` and `DeleteTimeButton` don't have this guard
- Action for 3.6: apply same pattern — disable `onPressed` when state is `*Loading`
- Source: 3.3 change log "deferred as pre-existing"; 3.4 P-1 fix reference

### References

- [epics.md — Epic 3, Story 3.5, FR12-FR14, FR44] | [architecture.md — Cross-Feature Composition, Feature Boundaries]
- [3-4-wage-feature-sealed-class-bloc-migration.md — Anti-patterns (BS-1, P-1, P-2), sealed class patterns]
- [time_entry.dart — CalculatePay extension (totalHours, totalMinutes, calculatePayment)]

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6

### Debug Log References

N/A

### Completion Notes List

### File List
