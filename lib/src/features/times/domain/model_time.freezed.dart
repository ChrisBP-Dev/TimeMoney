// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModelTime {

 int get hour; int get minutes; int get id;
/// Create a copy of ModelTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelTimeCopyWith<ModelTime> get copyWith => _$ModelTimeCopyWithImpl<ModelTime>(this as ModelTime, _$identity);

  /// Serializes this ModelTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minutes,id);

@override
String toString() {
  return 'ModelTime(hour: $hour, minutes: $minutes, id: $id)';
}


}

/// @nodoc
abstract mixin class $ModelTimeCopyWith<$Res>  {
  factory $ModelTimeCopyWith(ModelTime value, $Res Function(ModelTime) _then) = _$ModelTimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minutes, int id
});




}
/// @nodoc
class _$ModelTimeCopyWithImpl<$Res>
    implements $ModelTimeCopyWith<$Res> {
  _$ModelTimeCopyWithImpl(this._self, this._then);

  final ModelTime _self;
  final $Res Function(ModelTime) _then;

/// Create a copy of ModelTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minutes = null,Object? id = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelTime].
extension ModelTimePatterns on ModelTime {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelTime() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelTime value)  $default,){
final _that = this;
switch (_that) {
case _ModelTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelTime value)?  $default,){
final _that = this;
switch (_that) {
case _ModelTime() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minutes,  int id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelTime() when $default != null:
return $default(_that.hour,_that.minutes,_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minutes,  int id)  $default,) {final _that = this;
switch (_that) {
case _ModelTime():
return $default(_that.hour,_that.minutes,_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minutes,  int id)?  $default,) {final _that = this;
switch (_that) {
case _ModelTime() when $default != null:
return $default(_that.hour,_that.minutes,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModelTime extends ModelTime {
  const _ModelTime({required this.hour, required this.minutes, this.id = 0}): super._();
  factory _ModelTime.fromJson(Map<String, dynamic> json) => _$ModelTimeFromJson(json);

@override final  int hour;
@override final  int minutes;
@override@JsonKey() final  int id;

/// Create a copy of ModelTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelTimeCopyWith<_ModelTime> get copyWith => __$ModelTimeCopyWithImpl<_ModelTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minutes,id);

@override
String toString() {
  return 'ModelTime(hour: $hour, minutes: $minutes, id: $id)';
}


}

/// @nodoc
abstract mixin class _$ModelTimeCopyWith<$Res> implements $ModelTimeCopyWith<$Res> {
  factory _$ModelTimeCopyWith(_ModelTime value, $Res Function(_ModelTime) _then) = __$ModelTimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minutes, int id
});




}
/// @nodoc
class __$ModelTimeCopyWithImpl<$Res>
    implements _$ModelTimeCopyWith<$Res> {
  __$ModelTimeCopyWithImpl(this._self, this._then);

  final _ModelTime _self;
  final $Res Function(_ModelTime) _then;

/// Create a copy of ModelTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minutes = null,Object? id = null,}) {
  return _then(_ModelTime(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
