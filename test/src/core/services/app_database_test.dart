import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/services/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase', () {
    test('opens successfully with in-memory executor', () {
      expect(db, isA<AppDatabase>());
    });

    test('schema version is 1', () {
      expect(db.schemaVersion, 1);
    });

    test('close completes without error', () async {
      await expectLater(db.close(), completes);
      // Re-create for tearDown (already closed above).
      db = AppDatabase(NativeDatabase.memory());
    });

    group('TimesTable', () {
      test('insert and select roundtrip', () async {
        final id = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 2, minutes: 30),
            );
        final rows = await db.select(db.timesTable).get();

        expect(rows, hasLength(1));
        expect(rows.first.id, id);
        expect(rows.first.hour, 2);
        expect(rows.first.minutes, 30);
      });

      test('autoIncrement produces sequential IDs across multiple inserts',
          () async {
        final id1 = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 1, minutes: 0),
            );
        final id2 = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 2, minutes: 15),
            );
        final id3 = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 3, minutes: 45),
            );

        expect(id1, 1);
        expect(id2, 2);
        expect(id3, 3);
      });

      test('watch emits updated list after insert', () async {
        final stream = db.select(db.timesTable).watch();

        final expectation = expectLater(
          stream,
          emitsInOrder([
            isEmpty,
            hasLength(1),
          ]),
        );

        // Allow the stream to emit its initial empty-table value.
        await pumpEventQueue();

        await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 5, minutes: 10),
            );

        await expectation;
      });

      test('update modifies existing row', () async {
        final id = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 1, minutes: 0),
            );

        await (db.update(db.timesTable)
              ..where((t) => t.id.equals(id)))
            .write(
          const TimesTableCompanion(hour: Value(8), minutes: Value(45)),
        );

        final rows = await db.select(db.timesTable).get();
        expect(rows, hasLength(1));
        expect(rows.first.hour, 8);
        expect(rows.first.minutes, 45);
      });

      test('delete removes row', () async {
        final id = await db.into(db.timesTable).insert(
              TimesTableCompanion.insert(hour: 1, minutes: 0),
            );

        await (db.delete(db.timesTable)
              ..where((t) => t.id.equals(id)))
            .go();

        final rows = await db.select(db.timesTable).get();
        expect(rows, isEmpty);
      });

      test('select on empty table returns empty list', () async {
        final rows = await db.select(db.timesTable).get();
        expect(rows, isEmpty);
      });
    });

    group('WageHourlyTable', () {
      test('insert and select roundtrip', () async {
        final id = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 25.50),
            );
        final rows = await db.select(db.wageHourlyTable).get();

        expect(rows, hasLength(1));
        expect(rows.first.id, id);
        expect(rows.first.value, 25.50);
      });

      test('autoIncrement produces sequential IDs across multiple inserts',
          () async {
        final id1 = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 15),
            );
        final id2 = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 20),
            );
        final id3 = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 30.75),
            );

        expect(id1, 1);
        expect(id2, 2);
        expect(id3, 3);
      });

      test('watch emits updated record after insert', () async {
        final stream = db.select(db.wageHourlyTable).watch();

        final expectation = expectLater(
          stream,
          emitsInOrder([
            isEmpty,
            hasLength(1),
          ]),
        );

        // Allow the stream to emit its initial empty-table value.
        await pumpEventQueue();

        await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 42),
            );

        await expectation;
      });

      test('update modifies existing row', () async {
        final id = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 10),
            );

        await (db.update(db.wageHourlyTable)
              ..where((t) => t.id.equals(id)))
            .write(
          const WageHourlyTableCompanion(value: Value(99.99)),
        );

        final rows = await db.select(db.wageHourlyTable).get();
        expect(rows, hasLength(1));
        expect(rows.first.value, 99.99);
      });

      test('delete removes row', () async {
        final id = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 10),
            );

        await (db.delete(db.wageHourlyTable)
              ..where((t) => t.id.equals(id)))
            .go();

        final rows = await db.select(db.wageHourlyTable).get();
        expect(rows, isEmpty);
      });

      test('select on empty table returns empty list', () async {
        final rows = await db.select(db.wageHourlyTable).get();
        expect(rows, isEmpty);
      });
    });
  });
}
