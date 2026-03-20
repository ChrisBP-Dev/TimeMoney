/// Tests for [TimesDriftDatasource].
///
/// Verifies that the drift datasource correctly performs CRUD operations
/// and provides reactive stream behavior using a real in-memory drift
/// database. Each test exercises the datasource API and verifies
/// persistence via raw database queries.
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/services/app_database.dart';
import 'package:time_money/src/features/times/data/datasources/times_drift_datasource.dart';

void main() {
  late AppDatabase db;
  late TimesDriftDatasource datasource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    datasource = TimesDriftDatasource(db);
  });

  tearDown(() async {
    await db.close();
  });

  // All CRUD and reactive operations on the drift datasource,
  // using a real in-memory database to validate end-to-end behavior.
  group('TimesDriftDatasource', () {
    // Insert must persist the row and return its auto-generated id
    // so the repository layer can reference it later.
    test('insert returns auto-generated id and row is persisted', () async {
      final id = await datasource.insert(hour: 2, minutes: 30);

      expect(id, isPositive);

      final rows = await db.select(db.timesTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, id);
      expect(rows.first.hour, 2);
      expect(rows.first.minutes, 30);
    });

    // Sequential IDs confirm autoIncrement works correctly and
    // no ID reuse occurs across consecutive inserts.
    test('multiple inserts produce sequential auto-increment IDs', () async {
      final id1 = await datasource.insert(hour: 1, minutes: 0);
      final id2 = await datasource.insert(hour: 2, minutes: 15);
      final id3 = await datasource.insert(hour: 3, minutes: 45);

      expect(id1, 1);
      expect(id2, 2);
      expect(id3, 3);
    });

    // watchAll is the reactive API the repository uses to feed
    // the BLoC layer — must emit immediately and on every mutation.
    test('watchAll emits initial empty list then updated list after insert',
        () async {
      final stream = datasource.watchAll();

      final expectation = expectLater(
        stream,
        emitsInOrder([
          isEmpty,
          hasLength(1),
        ]),
      );

      // Allow the stream to emit its initial empty-table value.
      await pumpEventQueue();

      await datasource.insert(hour: 5, minutes: 10);

      await expectation;
    });

    // Empty table must return an empty list through the stream,
    // so downstream code can safely iterate without null checks.
    test('watchAll on empty table returns empty list', () async {
      final stream = datasource.watchAll();

      final expectation = expectLater(
        stream,
        emits(isEmpty),
      );

      await expectation;
    });

    // Update must modify only the targeted row so other entries
    // in the table are not accidentally changed. Returns the number
    // of affected rows so the repository can detect non-existent IDs.
    test('update modifies the correct row and returns affected row count',
        () async {
      final id = await datasource.insert(hour: 1, minutes: 0);

      final affectedRows =
          await datasource.update(id, hour: 8, minutes: 45);

      expect(affectedRows, 1);
      final rows = await db.select(db.timesTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.hour, 8);
      expect(rows.first.minutes, 45);
    });

    // Updating a non-existent ID must return 0 affected rows so the
    // repository layer can surface a failure instead of silently
    // succeeding.
    test('update returns 0 when targeting non-existent id', () async {
      final affectedRows =
          await datasource.update(999, hour: 1, minutes: 0);

      expect(affectedRows, 0);
    });

    // Remove must fully delete the row — partial deletes would
    // leave orphan data in the table.
    test('remove deletes the row', () async {
      final id = await datasource.insert(hour: 1, minutes: 0);

      await datasource.remove(id);

      final rows = await db.select(db.timesTable).get();
      expect(rows, isEmpty);
    });
  });
}
