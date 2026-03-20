/// Tests for [ObjectboxTimesRepository].
///
/// Verifies that the repository correctly delegates to
/// [TimesObjectboxDatasource], maps `TimeBox` models to [TimeEntry] domain
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
import 'package:time_money/src/features/times/data/datasources/times_objectbox_datasource.dart';
import 'package:time_money/src/features/times/data/models/time_box.dart';
import 'package:time_money/src/features/times/data/repositories/objectbox_times_repository.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

/// Mock for the ObjectBox datasource used to stub low-level persistence calls.
class MockTimesObjectboxDatasource extends Mock
    implements TimesObjectboxDatasource {}

void main() {
  late MockTimesObjectboxDatasource mockDatasource;
  late ObjectboxTimesRepository repository;

  setUpAll(() {
    registerFallbackValue(TimeBox(hour: 0, minutes: 0));
  });

  setUp(() {
    mockDatasource = MockTimesObjectboxDatasource();
    repository = ObjectboxTimesRepository(mockDatasource);
  });

  // Reactive stream: the UI subscribes to live updates from the
  // database. Correct mapping from TimeBox to TimeEntry is critical.
  group('fetchTimesStream', () {
    // Happy path: datasource emits TimeBox list, repository must
    // convert each to a TimeEntry and wrap the stream in Right.
    test('returns Right with correctly mapped TimeEntry stream on success',
        () async {
      final boxes = [TimeBox(hour: 1, minutes: 30)];
      when(() => mockDatasource.watchAll())
          .thenAnswer((_) => Stream.value(boxes));

      final result = repository.fetchTimesStream();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());
      final items = await stream.first;
      expect(items, [const TimeEntry(hour: 1, minutes: 30)]);
    });

    // Failure path: if the datasource throws (e.g., ObjectBox
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
        (_) => Stream<List<TimeBox>>.error(Exception('stream error')),
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

    // Happy path: datasource.put returns the DB-assigned ID,
    // and the returned entity carries that ID instead of 0.
    test('returns Right with entity containing DB-assigned ID', () async {
      when(() => mockDatasource.put(any())).thenReturn(42);

      final result = await repository.create(testTime);

      expect(
        result,
        const Right<dynamic, TimeEntry>(
          TimeEntry(id: 42, hour: 1, minutes: 30),
        ),
      );
      verify(() => mockDatasource.put(any())).called(1);
    });

    // Failure path: database write fails, must surface a
    // GlobalFailure instead of letting the exception propagate.
    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.create(testTime);

      expect(result.isLeft(), true);
    });
  });

  // Update: modifies an existing time entry (e.g., user corrects
  // hours). Checks existence via contains() before calling put().
  group('update', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 45);

    // Happy path: entity exists in the store, put() succeeds.
    // Verifies the repo returns the domain entity unchanged.
    test('returns Right with time entry on success', () async {
      when(() => mockDatasource.contains(any())).thenReturn(true);
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.update(testTime);

      expect(result, const Right<dynamic, TimeEntry>(testTime));
      verify(() => mockDatasource.contains(any())).called(1);
      verify(() => mockDatasource.put(any())).called(1);
    });

    // Failure path: ensures update errors are caught and
    // wrapped as Left, preventing unhandled exceptions.
    test('returns Left on exception', () async {
      when(() => mockDatasource.contains(any())).thenReturn(true);
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.update(testTime);

      expect(result.isLeft(), true);
    });

    // Non-existent entry: when contains() returns false, the entry
    // does not exist and the repository must return Left.
    test('returns Left when entry does not exist', () async {
      when(() => mockDatasource.contains(any())).thenReturn(false);

      final result = await repository.update(testTime);

      expect(result.isLeft(), true);
      verifyNever(() => mockDatasource.put(any()));
    });
  });

  // Delete: removes a time entry. Returns Unit (not the entity)
  // because the deleted record has no meaningful value to return.
  group('delete', () {
    const testTime = TimeEntry(id: 1, hour: 1, minutes: 15);

    // Happy path: datasource.remove succeeds. Right(unit)
    // signals the UI to refresh without carrying payload data.
    test('returns Right with unit on success', () async {
      when(() => mockDatasource.remove(any())).thenReturn(true);

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

    // Non-existent entry: when remove() returns false, the entry
    // did not exist and the repository must return Left.
    test('returns Left when entry does not exist', () async {
      when(() => mockDatasource.remove(any())).thenReturn(false);

      final result = await repository.delete(testTime);

      expect(result.isLeft(), true);
    });
  });
}
