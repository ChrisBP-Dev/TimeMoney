/// Tests for [ObjectboxWageRepository].
///
/// Verifies that the repository correctly delegates to
/// [WageObjectboxDatasource], maps `WageHourlyBox` models to [WageHourly]
/// domain entities, returns a default [WageHourly] when the stream is empty,
/// and wraps results in `Right` on success or `Left` with a `GlobalFailure`
/// on exception for fetch, set, and update operations.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Mock for the ObjectBox wage datasource used to stub low-level persistence.
class MockWageObjectboxDatasource extends Mock
    implements WageObjectboxDatasource {}

void main() {
  late MockWageObjectboxDatasource mockDatasource;
  late ObjectboxWageRepository repository;

  setUpAll(() {
    registerFallbackValue(WageHourlyBox(value: 0));
  });

  setUp(() {
    mockDatasource = MockWageObjectboxDatasource();
    repository = ObjectboxWageRepository(mockDatasource);
  });

  const testWage = WageHourly(id: 1, value: 25);

  // Fetch operation: reactive stream from ObjectBox,
  // mapping WageHourlyBox -> WageHourly and handling
  // empty-database and exception edge cases.
  group('fetchWageHourly', () {
    // Happy path: datasource emits a populated list.
    // Verifies the Box-to-Entity mapping is correct so
    // the domain layer receives a valid WageHourly.
    test('returns Right with correctly mapped WageHourly stream on success',
        () async {
      when(() => mockDatasource.watchAll()).thenAnswer(
        (_) => Stream.value([WageHourlyBox(id: 1, value: 25)]),
      );

      final result = repository.fetchWageHourly();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());
      final wage = await stream.first;
      expect(wage, testWage);
    });

    // Edge case: first launch or cleared database.
    // The repo must provide a safe default WageHourly
    // so the UI never encounters a null wage.
    test('returns Right with default WageHourly when stream emits empty list',
        () async {
      when(() => mockDatasource.watchAll()).thenAnswer(
        (_) => Stream.value(<WageHourlyBox>[]),
      );

      final result = repository.fetchWageHourly();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());
      final wage = await stream.first;
      expect(wage, const WageHourly());
    });

    // Failure path: ObjectBox throws (e.g. corrupt DB).
    // Must wrap in Left(GlobalFailure) so upper layers
    // handle errors functionally, not via exceptions.
    test('returns Left with GlobalFailure on exception', () {
      when(() => mockDatasource.watchAll()).thenThrow(Exception('db error'));

      final result = repository.fetchWageHourly();

      expect(result.isLeft(), true);
    });
  });

  // Set operation: persists the initial wage during
  // first-time setup. Distinct from update because the
  // entity has no pre-existing ID in the store.
  group('setWageHourly', () {
    // Happy path: datasource.put succeeds and returns
    // the assigned ID. Confirms delegation and that the
    // domain entity is echoed back unchanged.
    test('returns Right with WageHourly on success', () async {
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.setWageHourly(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(() => mockDatasource.put(any())).called(1);
    });

    // Failure path: persistence error is wrapped in
    // Left(GlobalFailure) so callers stay exception-free.
    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.setWageHourly(testWage);

      expect(result.isLeft(), true);
    });
  });

  // Update operation: modifies an existing wage record.
  // Same datasource.put call as set, but conceptually
  // the entity already has an ID assigned.
  group('update', () {
    // Happy path: put overwrites the existing row.
    // Verifies the repo returns the domain entity and
    // delegates exactly once to the datasource.
    test('returns Right with WageHourly on success', () async {
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.update(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(() => mockDatasource.put(any())).called(1);
    });

    // Failure path: update exceptions are caught and
    // returned as Left, keeping error handling uniform.
    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.update(testWage);

      expect(result.isLeft(), true);
    });
  });
}
