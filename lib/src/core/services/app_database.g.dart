// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TimesTableTable extends TimesTable
    with TableInfo<$TimesTableTable, TimesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, hour, minutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'times_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
    );
  }

  @override
  $TimesTableTable createAlias(String alias) {
    return $TimesTableTable(attachedDatabase, alias);
  }
}

class TimesTableData extends DataClass implements Insertable<TimesTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Number of full hours tracked.
  final int hour;

  /// Additional minutes beyond full hours.
  final int minutes;
  const TimesTableData({
    required this.id,
    required this.hour,
    required this.minutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hour'] = Variable<int>(hour);
    map['minutes'] = Variable<int>(minutes);
    return map;
  }

  TimesTableCompanion toCompanion(bool nullToAbsent) {
    return TimesTableCompanion(
      id: Value(id),
      hour: Value(hour),
      minutes: Value(minutes),
    );
  }

  factory TimesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimesTableData(
      id: serializer.fromJson<int>(json['id']),
      hour: serializer.fromJson<int>(json['hour']),
      minutes: serializer.fromJson<int>(json['minutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hour': serializer.toJson<int>(hour),
      'minutes': serializer.toJson<int>(minutes),
    };
  }

  TimesTableData copyWith({int? id, int? hour, int? minutes}) => TimesTableData(
    id: id ?? this.id,
    hour: hour ?? this.hour,
    minutes: minutes ?? this.minutes,
  );
  TimesTableData copyWithCompanion(TimesTableCompanion data) {
    return TimesTableData(
      id: data.id.present ? data.id.value : this.id,
      hour: data.hour.present ? data.hour.value : this.hour,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimesTableData(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minutes: $minutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hour, minutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimesTableData &&
          other.id == this.id &&
          other.hour == this.hour &&
          other.minutes == this.minutes);
}

class TimesTableCompanion extends UpdateCompanion<TimesTableData> {
  final Value<int> id;
  final Value<int> hour;
  final Value<int> minutes;
  const TimesTableCompanion({
    this.id = const Value.absent(),
    this.hour = const Value.absent(),
    this.minutes = const Value.absent(),
  });
  TimesTableCompanion.insert({
    this.id = const Value.absent(),
    required int hour,
    required int minutes,
  }) : hour = Value(hour),
       minutes = Value(minutes);
  static Insertable<TimesTableData> custom({
    Expression<int>? id,
    Expression<int>? hour,
    Expression<int>? minutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hour != null) 'hour': hour,
      if (minutes != null) 'minutes': minutes,
    });
  }

  TimesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? hour,
    Value<int>? minutes,
  }) {
    return TimesTableCompanion(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minutes: minutes ?? this.minutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimesTableCompanion(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minutes: $minutes')
          ..write(')'))
        .toString();
  }
}

class $WageHourlyTableTable extends WageHourlyTable
    with TableInfo<$WageHourlyTableTable, WageHourlyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WageHourlyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wage_hourly_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WageHourlyTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WageHourlyTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WageHourlyTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $WageHourlyTableTable createAlias(String alias) {
    return $WageHourlyTableTable(attachedDatabase, alias);
  }
}

class WageHourlyTableData extends DataClass
    implements Insertable<WageHourlyTableData> {
  /// Auto-incrementing primary key.
  final int id;

  /// Hourly wage amount stored as a real (double) value.
  final double value;
  const WageHourlyTableData({required this.id, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['value'] = Variable<double>(value);
    return map;
  }

  WageHourlyTableCompanion toCompanion(bool nullToAbsent) {
    return WageHourlyTableCompanion(id: Value(id), value: Value(value));
  }

  factory WageHourlyTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WageHourlyTableData(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<double>(value),
    };
  }

  WageHourlyTableData copyWith({int? id, double? value}) =>
      WageHourlyTableData(id: id ?? this.id, value: value ?? this.value);
  WageHourlyTableData copyWithCompanion(WageHourlyTableCompanion data) {
    return WageHourlyTableData(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WageHourlyTableData(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WageHourlyTableData &&
          other.id == this.id &&
          other.value == this.value);
}

class WageHourlyTableCompanion extends UpdateCompanion<WageHourlyTableData> {
  final Value<int> id;
  final Value<double> value;
  const WageHourlyTableCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
  });
  WageHourlyTableCompanion.insert({
    this.id = const Value.absent(),
    required double value,
  }) : value = Value(value);
  static Insertable<WageHourlyTableData> custom({
    Expression<int>? id,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
    });
  }

  WageHourlyTableCompanion copyWith({Value<int>? id, Value<double>? value}) {
    return WageHourlyTableCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WageHourlyTableCompanion(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TimesTableTable timesTable = $TimesTableTable(this);
  late final $WageHourlyTableTable wageHourlyTable = $WageHourlyTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    timesTable,
    wageHourlyTable,
  ];
}

typedef $$TimesTableTableCreateCompanionBuilder =
    TimesTableCompanion Function({
      Value<int> id,
      required int hour,
      required int minutes,
    });
typedef $$TimesTableTableUpdateCompanionBuilder =
    TimesTableCompanion Function({
      Value<int> id,
      Value<int> hour,
      Value<int> minutes,
    });

class $$TimesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TimesTableTable> {
  $$TimesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TimesTableTable> {
  $$TimesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimesTableTable> {
  $$TimesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);
}

class $$TimesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimesTableTable,
          TimesTableData,
          $$TimesTableTableFilterComposer,
          $$TimesTableTableOrderingComposer,
          $$TimesTableTableAnnotationComposer,
          $$TimesTableTableCreateCompanionBuilder,
          $$TimesTableTableUpdateCompanionBuilder,
          (
            TimesTableData,
            BaseReferences<_$AppDatabase, $TimesTableTable, TimesTableData>,
          ),
          TimesTableData,
          PrefetchHooks Function()
        > {
  $$TimesTableTableTableManager(_$AppDatabase db, $TimesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minutes = const Value.absent(),
              }) => TimesTableCompanion(id: id, hour: hour, minutes: minutes),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hour,
                required int minutes,
              }) => TimesTableCompanion.insert(
                id: id,
                hour: hour,
                minutes: minutes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimesTableTable,
      TimesTableData,
      $$TimesTableTableFilterComposer,
      $$TimesTableTableOrderingComposer,
      $$TimesTableTableAnnotationComposer,
      $$TimesTableTableCreateCompanionBuilder,
      $$TimesTableTableUpdateCompanionBuilder,
      (
        TimesTableData,
        BaseReferences<_$AppDatabase, $TimesTableTable, TimesTableData>,
      ),
      TimesTableData,
      PrefetchHooks Function()
    >;
typedef $$WageHourlyTableTableCreateCompanionBuilder =
    WageHourlyTableCompanion Function({Value<int> id, required double value});
typedef $$WageHourlyTableTableUpdateCompanionBuilder =
    WageHourlyTableCompanion Function({Value<int> id, Value<double> value});

class $$WageHourlyTableTableFilterComposer
    extends Composer<_$AppDatabase, $WageHourlyTableTable> {
  $$WageHourlyTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WageHourlyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WageHourlyTableTable> {
  $$WageHourlyTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WageHourlyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WageHourlyTableTable> {
  $$WageHourlyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$WageHourlyTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WageHourlyTableTable,
          WageHourlyTableData,
          $$WageHourlyTableTableFilterComposer,
          $$WageHourlyTableTableOrderingComposer,
          $$WageHourlyTableTableAnnotationComposer,
          $$WageHourlyTableTableCreateCompanionBuilder,
          $$WageHourlyTableTableUpdateCompanionBuilder,
          (
            WageHourlyTableData,
            BaseReferences<
              _$AppDatabase,
              $WageHourlyTableTable,
              WageHourlyTableData
            >,
          ),
          WageHourlyTableData,
          PrefetchHooks Function()
        > {
  $$WageHourlyTableTableTableManager(
    _$AppDatabase db,
    $WageHourlyTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WageHourlyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WageHourlyTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WageHourlyTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> value = const Value.absent(),
              }) => WageHourlyTableCompanion(id: id, value: value),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required double value}) =>
                  WageHourlyTableCompanion.insert(id: id, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WageHourlyTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WageHourlyTableTable,
      WageHourlyTableData,
      $$WageHourlyTableTableFilterComposer,
      $$WageHourlyTableTableOrderingComposer,
      $$WageHourlyTableTableAnnotationComposer,
      $$WageHourlyTableTableCreateCompanionBuilder,
      $$WageHourlyTableTableUpdateCompanionBuilder,
      (
        WageHourlyTableData,
        BaseReferences<
          _$AppDatabase,
          $WageHourlyTableTable,
          WageHourlyTableData
        >,
      ),
      WageHourlyTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TimesTableTableTableManager get timesTable =>
      $$TimesTableTableTableManager(_db, _db.timesTable);
  $$WageHourlyTableTableTableManager get wageHourlyTable =>
      $$WageHourlyTableTableTableManager(_db, _db.wageHourlyTable);
}
