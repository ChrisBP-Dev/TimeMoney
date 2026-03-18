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

  setUpAll(() {
    registerFallbackValue(TimeBox(hour: 0, minutes: 0));
  });

  setUp(() {
    mockDatasource = MockTimesObjectboxDatasource();
    repository = ObjectboxTimesRepository(mockDatasource);
  });

  group('fetchTimesStream', () {
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
}
