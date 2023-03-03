// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ModelTime _$ModelTimeFromJson(Map<String, dynamic> json) {
  return _ModelTime.fromJson(json);
}

/// @nodoc
mixin _$ModelTime {
  int get hour => throw _privateConstructorUsedError;
  int get minutes => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModelTimeCopyWith<ModelTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelTimeCopyWith<$Res> {
  factory $ModelTimeCopyWith(ModelTime value, $Res Function(ModelTime) then) =
      _$ModelTimeCopyWithImpl<$Res, ModelTime>;
  @useResult
  $Res call({int hour, int minutes, int id});
}

/// @nodoc
class _$ModelTimeCopyWithImpl<$Res, $Val extends ModelTime>
    implements $ModelTimeCopyWith<$Res> {
  _$ModelTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minutes = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ModelTimeCopyWith<$Res> implements $ModelTimeCopyWith<$Res> {
  factory _$$_ModelTimeCopyWith(
          _$_ModelTime value, $Res Function(_$_ModelTime) then) =
      __$$_ModelTimeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minutes, int id});
}

/// @nodoc
class __$$_ModelTimeCopyWithImpl<$Res>
    extends _$ModelTimeCopyWithImpl<$Res, _$_ModelTime>
    implements _$$_ModelTimeCopyWith<$Res> {
  __$$_ModelTimeCopyWithImpl(
      _$_ModelTime _value, $Res Function(_$_ModelTime) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minutes = null,
    Object? id = null,
  }) {
    return _then(_$_ModelTime(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ModelTime extends _ModelTime {
  const _$_ModelTime({required this.hour, required this.minutes, this.id = 0})
      : super._();

  factory _$_ModelTime.fromJson(Map<String, dynamic> json) =>
      _$$_ModelTimeFromJson(json);

  @override
  final int hour;
  @override
  final int minutes;
  @override
  @JsonKey()
  final int id;

  @override
  String toString() {
    return 'ModelTime(hour: $hour, minutes: $minutes, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ModelTime &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minutes, minutes) || other.minutes == minutes) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minutes, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ModelTimeCopyWith<_$_ModelTime> get copyWith =>
      __$$_ModelTimeCopyWithImpl<_$_ModelTime>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ModelTimeToJson(
      this,
    );
  }
}

abstract class _ModelTime extends ModelTime {
  const factory _ModelTime(
      {required final int hour,
      required final int minutes,
      final int id}) = _$_ModelTime;
  const _ModelTime._() : super._();

  factory _ModelTime.fromJson(Map<String, dynamic> json) =
      _$_ModelTime.fromJson;

  @override
  int get hour;
  @override
  int get minutes;
  @override
  int get id;
  @override
  @JsonKey(ignore: true)
  _$$_ModelTimeCopyWith<_$_ModelTime> get copyWith =>
      throw _privateConstructorUsedError;
}
