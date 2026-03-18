# Story 3.2: Times Feature — List & Create BLoC Migration

Status: ready-for-dev

## Story

As a user,
I want to view my time entries in real time and create new ones using modern reactive patterns,
So that listing and creating time entries remains fast and reliable with proper visual feedback (FR1, FR2, FR5, FR6, FR40, FR43).

## Acceptance Criteria

1. **CreateTimeBloc sealed class migration**
   - `sealed class CreateTimeEvent` with variants: `CreateTimeHourChanged`, `CreateTimeMinutesChanged`, `CreateTimeSubmitted`, `CreateTimeReset`
   - `sealed class CreateTimeState` with variants: `CreateTimeInitial`, `CreateTimeLoading`, `CreateTimeSuccess`, `CreateTimeError`
   - All variants use `final class` with `const` constructors
   - Handler uses `result.fold()` to map Either to states
   - Success state triggers `AppDurations.actionFeedback` delay then resets to initial (FR5)

2. **ListTimesBloc sealed class migration with emit.forEach**
   - `sealed class ListTimesEvent` with `ListTimesRequested` variant
   - `sealed class ListTimesState` with variants: `ListTimesInitial`, `ListTimesLoading`, `ListTimesLoaded`, `ListTimesEmpty`, `ListTimesError`
   - Stream consumption uses `emit.forEach` internally — no StreamBuilder in UI (FR6, FR43)
   - Time entry list updates automatically when data changes (FR2)

3. **Widget pattern matching updates**
   - `BlocBuilder` widgets for ListTimesBloc and CreateTimeBloc use `switch` expressions with exhaustive pattern matching
   - Destructuring extracts state fields: e.g., `ListTimesLoaded(:final times)`
   - No `if/else` chains on state types remain

4. **Build verification**
   - `flutter analyze` — zero warnings
   - `flutter test` — all existing + new tests pass
   - App compiles and runs correctly

5. **Tests written alongside implementation (BMad aligned)**
   - `test/src/features/times/domain/use_cases/create_time_use_case_test.dart` — 100% coverage
   - `test/src/features/times/domain/use_cases/list_times_use_case_test.dart` — 100% coverage
   - `test/src/features/times/data/repositories/objectbox_times_repository_test.dart` — 100% coverage
   - `test/src/features/times/presentation/bloc/create_time_bloc_test.dart` — all state transitions: initial → loading → success → reset, initial → loading → error, hour/minutes changes, validation error
   - `test/src/features/times/presentation/bloc/list_times_bloc_test.dart` — stream subscription via emit.forEach, empty state, loaded state, error state

6. **Zero lint compliance**
   - `flutter analyze` produces zero warnings on all modified and new files

## Tasks / Subtasks

- [ ] Task 1: Migrate ListTimesBloc to sealed classes (AC: #2, #3)
  - [ ] 1.1 Convert `list_times_event.dart` → standalone sealed class (remove `part of`, Freezed)
  - [ ] 1.2 Convert `list_times_state.dart` → standalone sealed class with 5 variants + `==`/`hashCode` on data variants; delete `DataListTime` extension
  - [ ] 1.3 Convert `list_times_bloc.dart` → import+re-export event/state files, use `emit.forEach` for stream, remove Freezed imports/`part` directives
  - [ ] 1.4 Delete `lib/src/features/times/presentation/bloc/list_times_bloc.freezed.dart`

- [ ] Task 2: Migrate CreateTimeBloc to sealed classes (AC: #1, #3)
  - [ ] 2.1 Convert `create_time_event.dart` → standalone sealed class with 4 variants
  - [ ] 2.2 Convert `create_time_state.dart` → standalone sealed class with form data on base + 4 variants + `==`/`hashCode`
  - [ ] 2.3 Convert `create_time_bloc.dart` → import+re-export event/state files, register `on<CreateTimeReset>` handler (D-5 fix), replace all `state.copyWith(...)` with explicit state construction
  - [ ] 2.4 Delete `lib/src/features/times/presentation/bloc/create_time_bloc.freezed.dart`

- [ ] Task 3: Update consumer widgets (AC: #3)
  - [ ] 3.1 `list_times_screen.dart` → `.when()` → `switch`, add PaymentCubit update in listener, `ListTimesEvent.getTimes()` → `ListTimesRequested()`, `hasDataStream` → `ListTimesLoaded`
  - [ ] 3.2 `list_times_data_view.dart` → remove `StreamBuilder`/`CatchErrorBuilder`, param `Stream<List<TimeEntry>>` → `List<TimeEntry>`, remove PaymentCubit import/call, remove empty check
  - [ ] 3.3 `create_time_button.dart` → `BlocConsumer` → `BlocBuilder` (D-2), `state.currentState` → `state` switch, `CreateTimeEvent.create()` → `CreateTimeSubmitted()`
  - [ ] 3.4 `create_hour_field.dart` → `BlocConsumer` → `BlocListener` (D-1/D-2), `CreateTimeEvent.changeHour(...)` → `CreateTimeHourChanged(...)`, add controller clear on reset
  - [ ] 3.5 `create_minutes_field.dart` → same pattern as 3.4

- [ ] Task 4: Build verification (AC: #4)
  - [ ] 4.1 Run `dart run build_runner build --delete-conflicting-outputs` (regenerate remaining Freezed files — delete/update BLoCs still use Freezed)
  - [ ] 4.2 `flutter analyze` — zero warnings
  - [ ] 4.3 `flutter test` — existing 26 core tests pass

- [ ] Task 5: Write use case tests (AC: #5)
  - [ ] 5.1 `test/src/features/times/domain/use_cases/create_time_use_case_test.dart`
  - [ ] 5.2 `test/src/features/times/domain/use_cases/list_times_use_case_test.dart`

- [ ] Task 6: Write repository test (AC: #5)
  - [ ] 6.1 `test/src/features/times/data/repositories/objectbox_times_repository_test.dart`

- [ ] Task 7: Write BLoC tests (AC: #5)
  - [ ] 7.1 `test/src/features/times/presentation/bloc/create_time_bloc_test.dart`
  - [ ] 7.2 `test/src/features/times/presentation/bloc/list_times_bloc_test.dart`

- [ ] Task 8: Final verification (AC: #4, #6)
  - [ ] 8.1 `flutter analyze` — zero warnings
  - [ ] 8.2 `flutter test` — all tests pass (core + new)

## Dev Notes

### Critical Migration: ListTimesBloc

**FROM (Freezed, StreamBuilder in UI):**
```dart
// list_times_event.dart
part of 'list_times_bloc.dart';
@freezed
abstract class ListTimesEvent with _$ListTimesEvent {
  const factory ListTimesEvent.getTimes() = _GetTimes;
}

// list_times_state.dart
part of 'list_times_bloc.dart';
@freezed
abstract class ListTimesState with _$ListTimesState {
  const factory ListTimesState.initial() = _Initial;
  const factory ListTimesState.loading() = _Loading;
  const factory ListTimesState.empty() = _Empty;
  const factory ListTimesState.error(GlobalFailure err) = _Error;
  const factory ListTimesState.hasDataStream(Stream<List<TimeEntry>> data) = _HasDataStream;
}
// DataListTime extension — DELETE entirely

// list_times_bloc.dart
part 'list_times_event.dart';
part 'list_times_state.dart';
part 'list_times_bloc.freezed.dart';
class ListTimesBloc extends Bloc<ListTimesEvent, ListTimesState> {
  ListTimesBloc(ListTimesUseCase useCase)
      : _timesListUseCase = useCase, super(const _Initial()) {
    on<_GetTimes>((event, emit) {
      emit(const ListTimesState.loading());
      _timesListUseCase.call().fold(
        (error) => emit(ListTimesState.error(error)),
        (times) => emit(ListTimesState.hasDataStream(times)),
      );
    });
  }
}
```

**TO (Sealed classes, emit.forEach, no StreamBuilder):**
```dart
// list_times_event.dart — standalone, no part of
sealed class ListTimesEvent {
  const ListTimesEvent();
}

final class ListTimesRequested extends ListTimesEvent {
  const ListTimesRequested();
}

// list_times_state.dart — standalone, own imports
import 'package:flutter/foundation.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

sealed class ListTimesState {
  const ListTimesState();
}

final class ListTimesInitial extends ListTimesState {
  const ListTimesInitial();
}

final class ListTimesLoading extends ListTimesState {
  const ListTimesLoading();
}

final class ListTimesLoaded extends ListTimesState {
  const ListTimesLoaded(this.times);
  final List<TimeEntry> times;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesLoaded && listEquals(times, other.times);

  @override
  int get hashCode => Object.hashAll(times);
}

final class ListTimesEmpty extends ListTimesState {
  const ListTimesEmpty();
}

final class ListTimesError extends ListTimesState {
  const ListTimesError(this.failure);
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTimesError && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

// list_times_bloc.dart — import + re-export, emit.forEach
import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/list_times_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_state.dart';

export 'list_times_event.dart';
export 'list_times_state.dart';

class ListTimesBloc extends Bloc<ListTimesEvent, ListTimesState> {
  ListTimesBloc(ListTimesUseCase useCase)
      : _listTimesUseCase = useCase,
        super(const ListTimesInitial()) {
    on<ListTimesRequested>(_onListTimesRequested);
  }

  final ListTimesUseCase _listTimesUseCase;

  Future<void> _onListTimesRequested(
    ListTimesRequested event,
    Emitter<ListTimesState> emit,
  ) async {
    emit(const ListTimesLoading());

    final result = _listTimesUseCase.call();

    await result.fold(
      (failure) async => emit(ListTimesError(failure)),
      (stream) => emit.forEach<List<TimeEntry>>(
        stream,
        onData: (times) => times.isEmpty
            ? const ListTimesEmpty()
            : ListTimesLoaded(times),
        onError: (error, _) => ListTimesError(
          GlobalFailure.fromException(error),
        ),
      ),
    );
  }
}
```

**Key behavioral change:** The BLoC now consumes the stream internally via `emit.forEach`. The UI uses `BlocBuilder` only — no `StreamBuilder`. When the BLoC is closed, the stream subscription is automatically cancelled (BLoC 9.x lifecycle management).

### Critical Migration: CreateTimeBloc

**FROM (Freezed events/state with ActionState wrapper):**
```dart
// create_time_event.dart — part of
@freezed
abstract class CreateTimeEvent with _$CreateTimeEvent {
  const factory CreateTimeEvent.changeHour({required String value}) = _ChangeHour;
  const factory CreateTimeEvent.changeMinutes({required String value}) = _ChangeMinutes;
  const factory CreateTimeEvent.create() = _Create;
  const factory CreateTimeEvent.reset() = _Reset;  // D-5: NO handler registered!
}

// create_time_state.dart — part of, uses ActionState<T> wrapper
@freezed
abstract class CreateTimeState with _$CreateTimeState {
  const factory CreateTimeState({
    required ActionState<TimeEntry> currentState,
    @Default(0) int hour,
    @Default(0) int minutes,
  }) = _CreateTimeState;
  factory CreateTimeState.initial() => const CreateTimeState(
        currentState: ActionInitial<TimeEntry>(),
      );
}
```

**TO (Sealed classes, form data on base, no ActionState wrapper):**
```dart
// create_time_event.dart — standalone
sealed class CreateTimeEvent {
  const CreateTimeEvent();
}

final class CreateTimeHourChanged extends CreateTimeEvent {
  const CreateTimeHourChanged({required this.value});
  final String value;
}

final class CreateTimeMinutesChanged extends CreateTimeEvent {
  const CreateTimeMinutesChanged({required this.value});
  final String value;
}

final class CreateTimeSubmitted extends CreateTimeEvent {
  const CreateTimeSubmitted();
}

final class CreateTimeReset extends CreateTimeEvent {
  const CreateTimeReset();
}

// create_time_state.dart — standalone, form data on sealed base
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

sealed class CreateTimeState {
  const CreateTimeState({this.hour = 0, this.minutes = 0});
  final int hour;
  final int minutes;
}

final class CreateTimeInitial extends CreateTimeState {
  const CreateTimeInitial({super.hour, super.minutes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeInitial &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(hour, minutes);
}

final class CreateTimeLoading extends CreateTimeState {
  const CreateTimeLoading({required super.hour, required super.minutes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeLoading &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(hour, minutes);
}

final class CreateTimeSuccess extends CreateTimeState {
  const CreateTimeSuccess(
    this.timeEntry, {
    required super.hour,
    required super.minutes,
  });
  final TimeEntry timeEntry;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeSuccess &&
          timeEntry == other.timeEntry &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(timeEntry, hour, minutes);
}

final class CreateTimeError extends CreateTimeState {
  const CreateTimeError(
    this.failure, {
    required super.hour,
    required super.minutes,
  });
  final GlobalFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimeError &&
          failure == other.failure &&
          hour == other.hour &&
          minutes == other.minutes;

  @override
  int get hashCode => Object.hash(failure, hour, minutes);
}

// create_time_bloc.dart — import + re-export, explicit state construction
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:time_money/src/core/constants/app_durations.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_event.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_state.dart';

export 'create_time_event.dart';
export 'create_time_state.dart';

class CreateTimeBloc extends Bloc<CreateTimeEvent, CreateTimeState> {
  CreateTimeBloc(CreateTimeUseCase useCase)
      : _createTimeUseCase = useCase,
        super(const CreateTimeInitial()) {
    on<CreateTimeHourChanged>(_onHourChanged);
    on<CreateTimeMinutesChanged>(_onMinutesChanged);
    on<CreateTimeSubmitted>(_onSubmitted);
    on<CreateTimeReset>(_onReset);  // D-5 FIX: was missing
  }

  final CreateTimeUseCase _createTimeUseCase;

  FutureOr<void> _onHourChanged(
    CreateTimeHourChanged event,
    Emitter<CreateTimeState> emit,
  ) {
    final hour = int.tryParse(event.value);
    if (hour == null) return _emitError(emit);
    emit(CreateTimeInitial(hour: hour, minutes: state.minutes));
  }

  FutureOr<void> _onMinutesChanged(
    CreateTimeMinutesChanged event,
    Emitter<CreateTimeState> emit,
  ) {
    final minutes = int.tryParse(event.value);
    if (minutes == null) return _emitError(emit);
    emit(CreateTimeInitial(hour: state.hour, minutes: minutes));
  }

  Future<void> _onSubmitted(
    CreateTimeSubmitted event,
    Emitter<CreateTimeState> emit,
  ) async {
    emit(CreateTimeLoading(hour: state.hour, minutes: state.minutes));
    await Future<void>.delayed(AppDurations.actionFeedback);

    if (state.minutes == 0 && state.hour == 0) return _emitError(emit);

    final time = TimeEntry(hour: state.hour, minutes: state.minutes);
    final result = await _createTimeUseCase.call(time);

    result.fold(
      (failure) => emit(
        CreateTimeError(failure, hour: state.hour, minutes: state.minutes),
      ),
      (timeEntry) => emit(
        CreateTimeSuccess(timeEntry, hour: state.hour, minutes: state.minutes),
      ),
    );

    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(const CreateTimeInitial());  // Resets form (hour=0, minutes=0)
  }

  void _onReset(CreateTimeReset event, Emitter<CreateTimeState> emit) {
    emit(const CreateTimeInitial());
  }

  FutureOr<void> _emitError(Emitter<CreateTimeState> emit) async {
    emit(
      CreateTimeError(
        const InternalError('invalid number'),
        hour: state.hour,
        minutes: state.minutes,
      ),
    );
    await Future<void>.delayed(AppDurations.actionFeedback);
    emit(CreateTimeInitial(hour: state.hour, minutes: state.minutes));
  }
}
```

**Key design:** Form data (`hour`, `minutes`) lives on the sealed base class so it persists across state transitions. No `copyWith` needed — construct new variant instances with explicit field values. After success, `const CreateTimeInitial()` resets form (defaults to `hour=0, minutes=0`). On validation error, `CreateTimeInitial(hour: state.hour, minutes: state.minutes)` preserves user input.

### State Equality Pattern

Data-carrying state variants MUST override `==` and `hashCode` for `bloc_test` compatibility. Without overrides, `bloc_test` cannot compare emitted states by value.

- **Const singleton states** (Initial, Loading, Empty): identity equality via const — no override needed
- **Data states** (Loaded, Error, Success): override `==` + `hashCode` using field comparison
- **List fields**: use `listEquals` from `package:flutter/foundation.dart` (presentation layer can import Flutter)
- **Primitive/Object fields**: use `==` directly (TimeEntry has Freezed-generated equality)

### Consumer Update Reference

**File: `list_times_screen.dart`**
```dart
// BEFORE
BlocConsumer<ListTimesBloc, ListTimesState>(
  listener: (context, state) => state,  // D-2: no-op
  bloc: context.read<ListTimesBloc>()..add(const ListTimesEvent.getTimes()),
  builder: (context, state) {
    return state.when(
      initial: ShimmerListTimesView.new,
      loading: ShimmerListTimesView.new,
      empty: () => const EmptyListTimesView(actionWidget: _ActionWidget()),
      error: (err) => ErrorListTimesView(err, actionWidget: const _ActionWidget()),
      hasDataStream: (goals) => ListTimesDataView(goalsStream: goals),
    );
  },
)

// AFTER — meaningful listener (D-2 fix), switch expression, PaymentCubit moved here
BlocConsumer<ListTimesBloc, ListTimesState>(
  listener: (context, state) {
    if (state case ListTimesLoaded(:final times)) {
      context.read<PaymentCubit>().setList(times);
    }
  },
  bloc: context.read<ListTimesBloc>()..add(const ListTimesRequested()),
  builder: (context, state) => switch (state) {
    ListTimesInitial() => const ShimmerListTimesView(),
    ListTimesLoading() => const ShimmerListTimesView(),
    ListTimesEmpty() => const EmptyListTimesView(actionWidget: _ActionWidget()),
    ListTimesError(:final failure) => ErrorListTimesView(
      failure,
      actionWidget: const _ActionWidget(),
    ),
    ListTimesLoaded(:final times) => ListTimesDataView(times: times),
  },
)
// ADD import: package:time_money/src/features/payment/presentation/cubit/payment_cubit.dart
```

**File: `list_times_data_view.dart`**
```dart
// BEFORE — StreamBuilder, CatchErrorBuilder, PaymentCubit call, empty check
class ListTimesDataView extends StatelessWidget {
  const ListTimesDataView({required this.goalsStream, super.key});
  final Stream<List<TimeEntry>> goalsStream;
  Widget build(BuildContext context) {
    return StreamBuilder<List<TimeEntry>>(
      stream: goalsStream,
      builder: (context, snapshot) => CatchErrorBuilder<List<TimeEntry>>(
        snapshot: snapshot,
        builder: (times) {
          context.read<PaymentCubit>().setList(times);
          if (times.isEmpty) return const EmptyListTimesView();
          return Scrollbar(...ListView.builder(...)...);
        },
      ),
    );
  }
}

// AFTER — simple list rendering, no stream, no PaymentCubit, no empty check
class ListTimesDataView extends StatelessWidget {
  const ListTimesDataView({required this.times, super.key});
  final List<TimeEntry> times;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: ListView.builder(
        itemCount: times.length,
        itemBuilder: (_, i) => TimeCard(time: times[i]),
      ),
    );
  }
}
// REMOVE imports: PaymentCubit, CatchErrorBuilder, EmptyListTimesView (if only used here)
```

**File: `create_time_button.dart`**
```dart
// BEFORE — BlocConsumer no-op listener, state.currentState switch
BlocConsumer<CreateTimeBloc, CreateTimeState>(
  listener: (context, state) => state,  // D-2: no-op
  builder: (_, state) => FilledButton(
    onPressed: () async {
      context.read<CreateTimeBloc>().add(const CreateTimeEvent.create());
      ...
    },
    child: switch (state.currentState) {
      ActionInitial() => const Text('Create'),
      ActionLoading() => ...,
      ActionSuccess() => ...,
      ActionError() => ...,
    },
  ),
)

// AFTER — BlocBuilder (D-2 fix), direct state switch
BlocBuilder<CreateTimeBloc, CreateTimeState>(
  builder: (context, state) => FilledButton(
    onPressed: () async {
      context.read<CreateTimeBloc>().add(const CreateTimeSubmitted());
      await Future<void>.delayed(AppDurations.actionFeedback);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    },
    child: switch (state) {
      CreateTimeInitial() => const Text('Create'),
      CreateTimeLoading() => const SizedBox(
          height: 20, width: 20,
          child: CircularProgressIndicator(color: Colors.white),
        ),
      CreateTimeSuccess() => const Text('Success'),
      CreateTimeError() => const Text('Error'),
    },
  ),
)
// REMOVE import: action_state.dart (no longer needed — switching on CreateTimeState, not ActionState)
```

**File: `create_hour_field.dart`**
```dart
// BEFORE — BlocConsumer no-op listener, Freezed event constructor
BlocConsumer<CreateTimeBloc, CreateTimeState>(
  listener: (context, state) => state,  // D-2: no-op
  builder: (context, state) {
    return CustomCreateField(
      onChanged: (value) => context.read<CreateTimeBloc>().add(
        CreateTimeEvent.changeHour(value: value),
      ),
    );
  },
)

// AFTER — BlocListener for controller sync (D-1/D-2 fix), sealed event
BlocListener<CreateTimeBloc, CreateTimeState>(
  listenWhen: (previous, current) =>
      current is CreateTimeInitial && current.hour == 0 && current.minutes == 0,
  listener: (context, state) => _controller.clear(),
  child: CustomCreateField(
    title: 'Hour',
    controller: _controller,
    onChanged: (value) => context.read<CreateTimeBloc>().add(
      CreateTimeHourChanged(value: value),
    ),
  ),
)
```

**File: `create_minutes_field.dart`** — same pattern as `create_hour_field.dart` with `CreateTimeMinutesChanged`.

### Stream Consumption: emit.forEach Pattern

**Why emit.forEach:** The architecture mandates BLoC-internal stream consumption (BLoC 9.x pattern). No `StreamBuilder` in widgets. The BLoC subscribes to the reactive ObjectBox `watch()` stream and emits new states on each data event. When the BLoC is closed, the subscription is automatically cancelled.

**Pattern:**
```dart
await result.fold(
  (failure) async => emit(ListTimesError(failure)),
  (stream) => emit.forEach<List<TimeEntry>>(
    stream,
    onData: (times) => times.isEmpty
        ? const ListTimesEmpty()
        : ListTimesLoaded(times),
    onError: (error, _) => ListTimesError(
      GlobalFailure.fromException(error),
    ),
  ),
);
```

**Critical:** Both `fold` branches must return compatible types. The left branch returns `Future<void>` (hence `async`), the right branch returns `Future<void>` (from `emit.forEach`). The outer `await` keeps the event handler alive while the stream is active.

**onError:** Provided to keep the stream alive on transient errors. Without `onError`, a stream error terminates the handler.

### Tech Debt Addressed in This Story

| ID | Description | Fix |
|----|-------------|-----|
| D-1 | TextEditingController not synced with bloc state | `BlocListener` with `listenWhen` clears controller on form reset |
| D-2 | BlocConsumer listener is no-op in create widgets + list screen | `BlocConsumer` → `BlocBuilder` (button) or `BlocListener` (fields); list screen listener gets meaningful PaymentCubit update |
| D-5 | CreateTimeEvent `_Reset` has no registered `on<_Reset>` handler | Add `on<CreateTimeReset>(_onReset)` handler that emits `const CreateTimeInitial()` |

**NOT addressed (deferred):**
| ID | Description | Deferred To |
|----|-------------|------------|
| D-3 | StackTrace captured but discarded in error_view | 3.x |
| D-4 | DeleteTimeBloc `.fold()` result not emitted | 3.3 |
| W1 | times/wage data views import PaymentCubit (cross-feature) | 3.5 — partially mitigated here by moving call from data view to screen listener |

### Testing Patterns

**Shared mocks from `test/helpers/mocks.dart`:**
- `MockTimesRepository` — for use case tests
- `MockCreateTimeUseCase` — for CreateTimeBloc test
- `MockListTimesUseCase` — for ListTimesBloc test

**Local mock for repository test:**
```dart
// In objectbox_times_repository_test.dart
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';

class MockTimesObjectboxDatasource extends Mock implements TimesObjectboxDatasource {}
```

**Use case test pattern:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/domain/use_cases/create_time_use_case.dart';
import '../../../../helpers/helpers.dart';

void main() {
  late MockTimesRepository mockRepository;
  late CreateTimeUseCase useCase;

  setUp(() {
    mockRepository = MockTimesRepository();
    useCase = CreateTimeUseCase(mockRepository);
  });

  const testTime = TimeEntry(hour: 1, minutes: 30);

  group('CreateTimeUseCase', () {
    test('returns Right with TimeEntry on success', () async {
      when(() => mockRepository.create(testTime))
          .thenAnswer((_) async => const Right(testTime));

      final result = await useCase.call(testTime);

      expect(result, const Right<GlobalFailure, TimeEntry>(testTime));
      verify(() => mockRepository.create(testTime)).called(1);
    });

    test('returns Left with GlobalFailure on error', () async {
      when(() => mockRepository.create(testTime))
          .thenAnswer((_) async => const Left(NotConnection()));

      final result = await useCase.call(testTime);

      expect(result.isLeft(), true);
      verify(() => mockRepository.create(testTime)).called(1);
    });
  });
}
```

**ListTimesUseCase test:** Same pattern but synchronous — `call()` returns `Either<GlobalFailure, Stream<...>>` not `Future`.

**Repository test pattern:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

class MockTimesObjectboxDatasource extends Mock
    implements TimesObjectboxDatasource {}

void main() {
  late MockTimesObjectboxDatasource mockDatasource;
  late ObjectboxTimesRepository repository;

  setUp(() {
    mockDatasource = MockTimesObjectboxDatasource();
    repository = ObjectboxTimesRepository(mockDatasource);
  });

  group('fetchTimesStream', () {
    test('returns Right with mapped stream on success', () {
      final boxes = [TimeBox(hour: 1, minutes: 30)];
      when(() => mockDatasource.watchAll())
          .thenAnswer((_) => Stream.value(boxes));

      final result = repository.fetchTimesStream();

      expect(result.isRight(), true);
    });

    test('returns Left with GlobalFailure on exception', () {
      when(() => mockDatasource.watchAll()).thenThrow(Exception('db error'));

      final result = repository.fetchTimesStream();

      expect(result.isLeft(), true);
    });
  });

  group('create', () {
    const testTime = TimeEntry(hour: 1, minutes: 30);

    test('returns Right with time entry on success', () async {
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.create(testTime);

      expect(result, const Right<dynamic, TimeEntry>(testTime));
      verify(() => mockDatasource.put(any())).called(1);
    });

    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.create(testTime);

      expect(result.isLeft(), true);
    });
  });
  // Similarly for delete, update
}
```

**BLoC test pattern (ListTimesBloc with emit.forEach):**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/list_times_bloc.dart';
import '../../../../helpers/helpers.dart';

void main() {
  late MockListTimesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockListTimesUseCase();
  });

  const testTime = TimeEntry(hour: 1, minutes: 30, id: 1);

  group('ListTimesBloc', () {
    test('initial state is ListTimesInitial', () {
      expect(ListTimesBloc(mockUseCase).state, const ListTimesInitial());
    });

    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, loaded] when stream emits data',
      build: () {
        when(() => mockUseCase.call())
            .thenReturn(Right(Stream.value([testTime])));
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        ListTimesLoaded([testTime]),
      ],
    );

    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, empty] when stream emits empty list',
      build: () {
        when(() => mockUseCase.call())
            .thenReturn(Right(Stream.value(<TimeEntry>[])));
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        const ListTimesEmpty(),
      ],
    );

    blocTest<ListTimesBloc, ListTimesState>(
      'emits [loading, error] when use case returns Left',
      build: () {
        when(() => mockUseCase.call())
            .thenReturn(const Left(NotConnection()));
        return ListTimesBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(const ListTimesRequested()),
      expect: () => [
        const ListTimesLoading(),
        const ListTimesError(NotConnection()),
      ],
    );
  });
}
```

**BLoC test pattern (CreateTimeBloc):**
Test cases to cover:
- Initial state is `CreateTimeInitial(hour: 0, minutes: 0)`
- `CreateTimeHourChanged` with valid int → emits `CreateTimeInitial(hour: parsed, minutes: previous)`
- `CreateTimeHourChanged` with invalid string → emits error then recovers to initial (preserving form data)
- `CreateTimeMinutesChanged` — mirror of hour
- `CreateTimeSubmitted` success → loading → success → initial (form cleared)
- `CreateTimeSubmitted` error → loading → error → initial (form preserved)
- `CreateTimeSubmitted` with hour=0, minutes=0 → loading → validation error → initial
- `CreateTimeReset` → emits `CreateTimeInitial()` (D-5 fix verified)

**Important:** `CreateTimeBloc` uses `Future.delayed(AppDurations.actionFeedback)` between state transitions. In `blocTest`, use `wait: Duration(seconds: 2)` or similar to allow async handlers to complete. Alternatively, since `blocTest` waits for the handler to finish, the delays are included automatically.

### Approach Order

**Recommended execution order:**
1. Convert `list_times_event.dart` and `list_times_state.dart` to standalone sealed classes
2. Convert `list_times_bloc.dart` to use sealed classes + emit.forEach
3. Delete `list_times_bloc.freezed.dart`
4. Convert `create_time_event.dart` and `create_time_state.dart` to standalone sealed classes
5. Convert `create_time_bloc.dart` to use sealed classes + add reset handler
6. Delete `create_time_bloc.freezed.dart`
7. Update consumer widgets (list_times_screen, list_times_data_view, create_time_button, create_hour_field, create_minutes_field)
8. Run `dart run build_runner build --delete-conflicting-outputs` (regenerate delete/update BLoC Freezed files if source files reference changed types)
9. `flutter analyze` — zero warnings
10. Write use case tests
11. Write repository test
12. Write BLoC tests
13. Final `flutter analyze` + `flutter test`

### Barrel File Note

The bloc barrel (`lib/src/features/times/presentation/bloc/bloc.dart`) currently exports only bloc files. Since the migrated bloc files use `export 'event.dart'` and `export 'state.dart'` internally, the barrel does NOT need changes — events and states are accessible via the bloc file exports.

**DO NOT** add separate exports for event/state files to the barrel — they're re-exported by their bloc files.

### Import Changes After Part-of Removal

When event/state files change from `part of 'bloc.dart'` to standalone files, they lose access to the parent file's imports. Each file needs its own imports:

| File | Required Imports |
|------|-----------------|
| `list_times_event.dart` | None (no external types in event fields) |
| `list_times_state.dart` | `flutter/foundation.dart`, `failures.dart`, `time_entry.dart` |
| `create_time_event.dart` | None (uses only `String`) |
| `create_time_state.dart` | `failures.dart`, `time_entry.dart` |

### Anti-Patterns — NEVER Do

- **NEVER** use `.when()` pattern matching — use native `switch` expressions
- **NEVER** use `if/else` chains on sealed class types — always exhaustive `switch`
- **NEVER** use `StreamBuilder` in widgets for BLoC-managed streams — use `BlocBuilder` only
- **NEVER** edit `.freezed.dart` files in delete/update BLoC folders — those are Story 3.3 scope
- **NEVER** use `BlocConsumer` with no-op listener — use `BlocBuilder` if no listener needed, or add meaningful listener
- **NEVER** use `state.copyWith(...)` — construct new sealed class variant instances
- **NEVER** use `part of` / `part` for new sealed class event/state files — standalone with own imports
- **NEVER** throw exceptions from repository implementations — always `left(GlobalFailure.fromException(e))`
- **NEVER** use relative imports — always `package:time_money/src/...`
- **NEVER** skip `AppDurations.actionFeedback` delay between action state transitions — UI animations depend on it

### Files NOT to Touch (Scoped to Other Stories)

- `delete_time_bloc.dart` / `delete_time_event.dart` / `delete_time_state.dart` — Story 3.3
- `update_time_bloc.dart` / `update_time_event.dart` / `update_time_state.dart` — Story 3.3
- All wage feature files — Story 3.4
- `payment_cubit.dart` — Story 3.5
- `error_list_times_view.dart` — already migrated in 3.1 (GlobalFailure parameter)
- `list_times_other_view.dart` — display-only widgets, no BLoC interaction
- Domain entities (`time_entry.dart`) — keep Freezed (architecture decision)
- Use case files (`create_time_use_case.dart`, `list_times_use_case.dart`) — no changes needed, already correct
- Repository files (`times_repository.dart`, `objectbox_times_repository.dart`) — no changes needed
- Datasource files (`times_objectbox_datasource.dart`) — no changes needed

### Project Structure Notes

- Use cases are at `lib/src/features/times/domain/use_cases/` (NOT `aplication/`) — moved during Epic 2 restructure
- Repository implementation at `lib/src/features/times/data/repositories/` (NOT `infraestructure/`)
- `project-context.md` references the old `aplication/`/`infraestructure/` paths — trust actual file system paths
- Test files mirror source: `lib/src/features/times/domain/use_cases/X.dart` → `test/src/features/times/domain/use_cases/X_test.dart`
- `aplication/` typo in payment feature path is intentional — do NOT "fix" it
- W1 cross-feature import: `ListTimesScreen` will import `PaymentCubit` after migration (moved from `ListTimesDataView`). This is a known cross-feature coupling deferred to story 3.5

### Testing Standards

- **Test framework:** `flutter_test`, `bloc_test` ^10.0.0, `mocktail` ^1.0.0
- **Mock pattern:** `class MockX extends Mock implements X {}` (mocktail, NOT mockito)
- **BLoC test pattern:** `blocTest<BlocType, StateType>()` with `build`, `act`, `expect`
- **Test file naming:** Mirror source path exactly
- **Coverage target:** 100% on use cases, BLoCs, repositories
- **Test command:** `flutter test --coverage --test-randomize-ordering-seed random`

### Dependencies — Verify Before Starting

Confirm in `pubspec.yaml`:
- `bloc: ^9.2.0`
- `flutter_bloc: ^9.1.1`
- `bloc_test: ^10.0.0` (dev)
- `mocktail: ^1.0.0` (dev)
- `fpdart` (Either monad — used in repository/use case types)

### References

- [Source: _bmad-output/planning-artifacts/epics.md — Epic 3, Story 3.2 acceptance criteria]
- [Source: _bmad-output/planning-artifacts/architecture.md — BLoC sealed class patterns, emit.forEach, testing standards, state naming conventions, event naming conventions]
- [Source: _bmad-output/planning-artifacts/prd.md — FR1, FR2, FR5, FR6, FR40, FR43]
- [Source: _bmad-output/implementation-artifacts/3-1-core-sealed-classes-test-infrastructure-core-tests.md — Previous story learnings, tech debt D-1/D-2/D-5, Consumer Update Reference, sealed class patterns, test infrastructure]
- [Source: _bmad-output/project-context.md — Current tech stack, test configuration, conventions]
- [Source: lib/src/features/times/presentation/bloc/ — Current BLoC source code analysis]
- [Source: lib/src/features/times/presentation/widgets/ — Current widget source code analysis]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### Change Log

### File List
