/// Tests for [DriftWageRepository].
///
/// Verifies that the repository correctly delegates to
/// [WageDriftDatasource], maps [WageHourlyTableData] rows to [WageHourly]
/// domain entities, returns a default [WageHourly] when the stream is empty,
/// and wraps results in `Right` on success or `Left` with a `GlobalFailure`
/// on exception for fetch, set, and update operations.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_drift_datasource.dart';
import 'package:time_money/src/features/wage/data/repositories/drift_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

/// Mock for the drift wage datasource used to stub low-level persistence calls.
class MockWageDriftDatasource extends Mock implements WageDriftDatasource {}

void main() {
  late MockWageDriftDatasource mockDatasource;
  late DriftWageRepository repository;

  setUp(() {
    mockDatasource = MockWageDriftDatasource();
    repository = DriftWageRepository(mockDatasource);
  });

  const testWage = WageHourly(id: 1, value: 25);

  // Fetch operation: reactive stream from drift,
  // mapping WageHourlyTableData -> WageHourly and handling
  // empty-database and exception edge cases.
  group('fetchWageHourly', () {
    // Happy path: datasource emits a populated list.
    // Verifies the TableData-to-Entity mapping is correct so
    // the domain layer receives a valid WageHourly.
    test('returns Right with correctly mapped WageHourly stream on success',
        () async {
      when(() => mockDatasource.watchAll()).thenAnswer(
        (_) => Stream.value([const WageHourlyTableData(id: 1, value: 25)]),
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
        (_) => Stream.value(<WageHourlyTableData>[]),
      );

      final result = repository.fetchWageHourly();

      expect(result.isRight(), true);
      final stream = result.getOrElse((_) => throw Exception());
      final wage = await stream.first;
      expect(wage, const WageHourly());
    });

    // Failure path: drift throws (e.g. corrupt DB).
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
    // Happy path: datasource.insert succeeds and returns
    // the assigned ID. Confirms delegation and that the
    // domain entity is echoed back unchanged.
    test('returns Right with WageHourly on success', () async {
      when(
        () => mockDatasource.insert(value: any(named: 'value')),
      ).thenAnswer((_) async => 1);

      final result = await repository.setWageHourly(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(() => mockDatasource.insert(value: any(named: 'value'))).called(1);
    });

    // Failure path: persistence error is wrapped in
    // Left(GlobalFailure) so callers stay exception-free.
    test('returns Left on exception', () async {
      when(
        () => mockDatasource.insert(value: any(named: 'value')),
      ).thenThrow(Exception('fail'));

      final result = await repository.setWageHourly(testWage);

      expect(result.isLeft(), true);
    });
  });

  // Update operation: modifies an existing wage record.
  // Uses update(id, value:) unlike ObjectBox's single put() call.
  group('update', () {
    // Happy path: datasource accepts the update and the
    // repository returns the domain entity unchanged.
    test('returns Right with WageHourly on success', () async {
      when(
        () => mockDatasource.update(any(), value: any(named: 'value')),
      ).thenAnswer((_) async {});

      final result = await repository.update(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(
        () => mockDatasource.update(any(), value: any(named: 'value')),
      ).called(1);
    });

    // Failure path: update exceptions are caught and
    // returned as Left, keeping error handling uniform.
    test('returns Left on exception', () async {
      when(
        () => mockDatasource.update(any(), value: any(named: 'value')),
      ).thenThrow(Exception('fail'));

      final result = await repository.update(testWage);

      expect(result.isLeft(), true);
    });
  });
}
