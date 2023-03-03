// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wage_hourly.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WageHourly _$WageHourlyFromJson(Map<String, dynamic> json) {
  return _WageHourly.fromJson(json);
}

/// @nodoc
mixin _$WageHourly {
  int get id => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WageHourlyCopyWith<WageHourly> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WageHourlyCopyWith<$Res> {
  factory $WageHourlyCopyWith(
          WageHourly value, $Res Function(WageHourly) then) =
      _$WageHourlyCopyWithImpl<$Res, WageHourly>;
  @useResult
  $Res call({int id, double value});
}

/// @nodoc
class _$WageHourlyCopyWithImpl<$Res, $Val extends WageHourly>
    implements $WageHourlyCopyWith<$Res> {
  _$WageHourlyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WageHourlyCopyWith<$Res>
    implements $WageHourlyCopyWith<$Res> {
  factory _$$_WageHourlyCopyWith(
          _$_WageHourly value, $Res Function(_$_WageHourly) then) =
      __$$_WageHourlyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, double value});
}

/// @nodoc
class __$$_WageHourlyCopyWithImpl<$Res>
    extends _$WageHourlyCopyWithImpl<$Res, _$_WageHourly>
    implements _$$_WageHourlyCopyWith<$Res> {
  __$$_WageHourlyCopyWithImpl(
      _$_WageHourly _value, $Res Function(_$_WageHourly) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? value = null,
  }) {
    return _then(_$_WageHourly(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WageHourly implements _WageHourly {
  const _$_WageHourly({this.id = 0, this.value = 15.0});

  factory _$_WageHourly.fromJson(Map<String, dynamic> json) =>
      _$$_WageHourlyFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final double value;

  @override
  String toString() {
    return 'WageHourly(id: $id, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WageHourly &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WageHourlyCopyWith<_$_WageHourly> get copyWith =>
      __$$_WageHourlyCopyWithImpl<_$_WageHourly>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WageHourlyToJson(
      this,
    );
  }
}

abstract class _WageHourly implements WageHourly {
  const factory _WageHourly({final int id, final double value}) = _$_WageHourly;

  factory _WageHourly.fromJson(Map<String, dynamic> json) =
      _$_WageHourly.fromJson;

  @override
  int get id;
  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$_WageHourlyCopyWith<_$_WageHourly> get copyWith =>
      throw _privateConstructorUsedError;
}
