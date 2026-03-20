/// Tests for [AppDatabase] drift infrastructure.
///
/// Verifies that the drift database opens with an in-memory executor,
/// reports the correct schema version, closes cleanly, and supports
/// full CRUD + reactive `watch()` operations on both `TimesTable`
/// and `WageHourlyTable`. Each table group covers insert-select
/// roundtrips, autoIncrement sequencing, stream reactivity, updates,
/// deletes, and empty-table edge cases.
library;

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

  // Core database lifecycle and schema validation
  // before exercising individual table operations.
  group('AppDatabase', () {
    // Sanity check: the database must instantiate without
    // errors so all subsequent table tests can rely on it.
    test('opens successfully with in-memory executor', () {
      expect(db, isA<AppDatabase>());
    });

    // Schema version must be 1 for the initial release;
    // drift uses this to decide whether migrations run.
    test('schema version is 1', () {
      expect(db.schemaVersion, 1);
    });

    // Ensures the database releases resources cleanly,
    // preventing file-handle leaks in production.
    test('close completes without error', () async {
      await expectLater(db.close(), completes);
      // Re-create for tearDown (already closed above).
      db = AppDatabase(NativeDatabase.memory());
    });

    // CRUD and reactivity tests for the times table,
    // mirroring the TimeEntry domain entity columns.
    group('TimesTable', () {
      // Roundtrip proves the table schema matches the
      // companion insert API and the generated data class.
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

      // Sequential IDs confirm autoIncrement works and
      // no ID reuse occurs across consecutive inserts.
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

      // Reactive stream is how the BLoC layer observes
      // time entries — must emit on every table mutation.
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

      // Update must modify only the targeted row so
      // concurrent entries are not accidentally changed.
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

      // Delete must fully remove the row — partial
      // deletes would leave orphan data in the table.
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

      // Empty table must return an empty list, not null,
      // so downstream code can safely iterate without checks.
      test('select on empty table returns empty list', () async {
        final rows = await db.select(db.timesTable).get();
        expect(rows, isEmpty);
      });
    });

    // CRUD and reactivity tests for the wage hourly table,
    // mirroring the WageHourly domain entity columns.
    group('WageHourlyTable', () {
      // Roundtrip proves the real-column schema stores
      // and retrieves double values without precision loss.
      test('insert and select roundtrip', () async {
        final id = await db.into(db.wageHourlyTable).insert(
              WageHourlyTableCompanion.insert(value: 25.50),
            );
        final rows = await db.select(db.wageHourlyTable).get();

        expect(rows, hasLength(1));
        expect(rows.first.id, id);
        expect(rows.first.value, 25.50);
      });

      // Sequential IDs confirm autoIncrement works and
      // no ID reuse occurs across consecutive inserts.
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

      // Reactive stream is how the BLoC layer observes
      // wage changes — must emit on every table mutation.
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

      // Update must modify only the targeted row so
      // concurrent wage records are not accidentally changed.
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

      // Delete must fully remove the row — partial
      // deletes would leave orphan data in the table.
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

      // Empty table must return an empty list, not null,
      // so downstream code can safely iterate without checks.
      test('select on empty table returns empty list', () async {
        final rows = await db.select(db.wageHourlyTable).get();
        expect(rows, isEmpty);
      });
    });
  });
}
