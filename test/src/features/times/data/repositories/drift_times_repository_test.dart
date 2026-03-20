/// Tests for [DriftTimesRepository].
///
/// Verifies that the repository correctly delegates to
/// [TimesDriftDatasource], maps [TimesTableData] rows to [TimeEntry] domain
/// entities, and wraps results in `Right` on success or `Left` with a
/// `GlobalFailure` on exception for every CRUD operation and the reactive
/// stream. Also validates that DB-assigned IDs are propagated back, that
/// operations on non-existent entries return `Left`, and that stream errors
/// are transformed to [GlobalFailure].
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';
import 'package:time_money/src/features/times/data/repositories/drift_times_repository.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Mock for the drift datasource used to stub low-level persistence calls.
class MockTimesDriftDatasource extends Mock implements TimesDriftDatasource {}

void main() {
  late MockTimesDriftDatasource mockDatasource;
  late DriftTimesRepository repository;

  setUp(() {
    mockDatasource = MockTimesDriftDatasource();
    repository = DriftTimesRepository(mockDatasource);
  });

  // Reactive stream: the UI subscribes to live updates from the
  // database. Correct mapping from TimesTableData to TimeEntry is critical.
  group('fetchTimesStream', () {
    // Happy path: datasource emits TimesTableData list, repository must
    // convert each to a TimeEntry and wrap the stream in Right.
    test('returns Right with correctly mapped TimeEntry stream on success',
        () async {
      when(() => mockDatasource.watchAll()).thenAnswer(
        (_) =>
            Stream.value([const TimesTableData(id: 1, hour: 1, minutes: 30)]),
      );

      final result = repository.fetchTimesStream();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());
      final items = await stream.first;
      expect(items, [const TimeEntry(id: 1, hour: 1, minutes: 30)]);
    });

    // Failure path: if the datasource throws (e.g., database
    // corruption), callers get a Left so the UI can show an error.
    test('returns Left with GlobalFailure on exception', () {
      when(() => mockDatasource.watchAll()).thenThrow(Exception('db error'));

      final result = repository.fetchTimesStream();

      expect(result.isLeft(), true);
    });

    // Stream error: a runtime error emitted mid-stream must be
    // transformed to GlobalFailure so the BLoC onError catches it.
    test('stream handleError transforms runtime errors to GlobalFailure',
        () async {
      when(() => mockDatasource.watchAll()).thenAnswer(
        (_) => Stream<List<TimesTableData>>.error(Exception('stream error')),
      );

      final result = repository.fetchTimesStream();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());

      await expectLater(
        stream,
        emitsError(isA<GlobalFailure>()),
      );
    });
  });

  // Create: persists a new time entry the user just logged.
  // Verifies data-layer round-trip and proper Either wrapping.
  group('create', () {
    const testTime = TimeEntry(hour: 1, minutes: 30);

    // Happy path: datasource.insert returns the DB-assigned ID,
    // and the returned entity carries that ID instead of 0.
    test('returns Right with entity containing DB-assigned ID', () async {
      when(
        () => mockDatasource.insert(
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).thenAnswer((_) async => 42);

      final result = await repository.create(testTime);

      expect(
        result,
        const Right<dynamic, TimeEntry>(
          TimeEntry(id: 42, hour: 1, minutes: 30),
        ),
      );
      verify(
        () => mockDatasource.insert(
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).called(1);
    });

    // Failure path: database write fails, must surface a
    // GlobalFailure instead of letting the exception propagate.
    test('returns Left on exception', () async {
      when(
        () => mockDatasource.insert(
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).thenThrow(Exception('fail'));

      final result = await repository.create(testTime);

      expect(result.isLeft(), true);
    });
  });

  // Update: modifies an existing time entry (e.g., user corrects
  // hours). Uses update() with id + named params unlike ObjectBox's put().
  group('update', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 45);

    // Happy path: datasource accepts the update (1 row affected)
    // and the repository returns the domain entity unchanged.
    test('returns Right with time entry on success', () async {
      when(
        () => mockDatasource.update(
          any(),
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.update(testTime);

      expect(result, const Right<dynamic, TimeEntry>(testTime));
      verify(
        () => mockDatasource.update(
          any(),
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).called(1);
    });

    // Failure path: ensures update errors are caught and
    // wrapped as Left, preventing unhandled exceptions.
    test('returns Left on exception', () async {
      when(
        () => mockDatasource.update(
          any(),
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).thenThrow(Exception('fail'));

      final result = await repository.update(testTime);

      expect(result.isLeft(), true);
    });

    // Non-existent entry: when update affects 0 rows, the entry
    // does not exist and the repository must return Left.
    test('returns Left when no rows affected (non-existent entry)', () async {
      when(
        () => mockDatasource.update(
          any(),
          hour: any(named: 'hour'),
          minutes: any(named: 'minutes'),
        ),
      ).thenAnswer((_) async => 0);

      final result = await repository.update(testTime);

      expect(result.isLeft(), true);
    });
  });

  // Delete: removes a time entry. Returns Unit (not the entity)
  // because the deleted record has no meaningful value to return.
  group('delete', () {
    const testTime = TimeEntry(id: 1, hour: 1, minutes: 15);

    // Happy path: datasource.remove succeeds. Right(unit)
    // signals the UI to refresh without carrying payload data.
    test('returns Right with unit on success', () async {
      when(() => mockDatasource.remove(any())).thenAnswer((_) async => 1);

      final result = await repository.delete(testTime);

      expect(result, const Right<dynamic, Unit>(unit));
      verify(() => mockDatasource.remove(any())).called(1);
    });

    // Failure path: deletion can fail (e.g., missing record);
    // must be caught and returned as Left for the UI layer.
    test('returns Left on exception', () async {
      when(() => mockDatasource.remove(any())).thenThrow(Exception('fail'));

      final result = await repository.delete(testTime);

      expect(result.isLeft(), true);
    });

    // Non-existent entry: when remove deletes 0 rows, the entry
    // does not exist and the repository must return Left.
    test('returns Left when no rows deleted (non-existent entry)', () async {
      when(() => mockDatasource.remove(any())).thenAnswer((_) async => 0);

      final result = await repository.delete(testTime);

      expect(result.isLeft(), true);
    });
  });
}
