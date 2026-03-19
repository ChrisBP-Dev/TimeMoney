import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/wage/data/datasources/wage_objectbox_datasource.dart';
import 'package:time_money/src/features/wage/data/models/wage_hourly_box.dart';
import 'package:time_money/src/features/wage/data/repositories/objectbox_wage_repository.dart';
import 'package:time_money/src/features/wage/domain/entities/wage_hourly.dart';

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

  group('fetchWageHourly', () {
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

    test('returns Left with GlobalFailure on exception', () {
      when(() => mockDatasource.watchAll()).thenThrow(Exception('db error'));

      final result = repository.fetchWageHourly();

      expect(result.isLeft(), true);
    });
  });

  group('setWageHourly', () {
    test('returns Right with WageHourly on success', () async {
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.setWageHourly(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(() => mockDatasource.put(any())).called(1);
    });

    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.setWageHourly(testWage);

      expect(result.isLeft(), true);
    });
  });

  group('update', () {
    test('returns Right with WageHourly on success', () async {
      when(() => mockDatasource.put(any())).thenReturn(1);

      final result = await repository.update(testWage);

      expect(result, const Right<dynamic, WageHourly>(testWage));
      verify(() => mockDatasource.put(any())).called(1);
    });

    test('returns Left on exception', () async {
      when(() => mockDatasource.put(any())).thenThrow(Exception('fail'));

      final result = await repository.update(testWage);

      expect(result.isLeft(), true);
    });
  });
}
