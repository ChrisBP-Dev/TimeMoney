// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wage_hourly.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WageHourly {

 int get id; double get value;
/// Create a copy of WageHourly
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WageHourlyCopyWith<WageHourly> get copyWith => _$WageHourlyCopyWithImpl<WageHourly>(this as WageHourly, _$identity);

  /// Serializes this WageHourly to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WageHourly&&(identical(other.id, id) || other.id == id)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,value);

@override
String toString() {
  return 'WageHourly(id: $id, value: $value)';
}


}

/// @nodoc
abstract mixin class $WageHourlyCopyWith<$Res>  {
  factory $WageHourlyCopyWith(WageHourly value, $Res Function(WageHourly) _then) = _$WageHourlyCopyWithImpl;
@useResult
$Res call({
 int id, double value
});




}
/// @nodoc
class _$WageHourlyCopyWithImpl<$Res>
    implements $WageHourlyCopyWith<$Res> {
  _$WageHourlyCopyWithImpl(this._self, this._then);

  final WageHourly _self;
  final $Res Function(WageHourly) _then;

/// Create a copy of WageHourly
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? value = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WageHourly].
extension WageHourlyPatterns on WageHourly {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WageHourly value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WageHourly() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WageHourly value)  $default,){
final _that = this;
switch (_that) {
case _WageHourly():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WageHourly value)?  $default,){
final _that = this;
switch (_that) {
case _WageHourly() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WageHourly() when $default != null:
return $default(_that.id,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  double value)  $default,) {final _that = this;
switch (_that) {
case _WageHourly():
return $default(_that.id,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  double value)?  $default,) {final _that = this;
switch (_that) {
case _WageHourly() when $default != null:
return $default(_that.id,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WageHourly implements WageHourly {
  const _WageHourly({this.id = 0, this.value = 15.0});
  factory _WageHourly.fromJson(Map<String, dynamic> json) => _$WageHourlyFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  double value;

/// Create a copy of WageHourly
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WageHourlyCopyWith<_WageHourly> get copyWith => __$WageHourlyCopyWithImpl<_WageHourly>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WageHourlyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WageHourly&&(identical(other.id, id) || other.id == id)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,value);

@override
String toString() {
  return 'WageHourly(id: $id, value: $value)';
}


}

/// @nodoc
abstract mixin class _$WageHourlyCopyWith<$Res> implements $WageHourlyCopyWith<$Res> {
  factory _$WageHourlyCopyWith(_WageHourly value, $Res Function(_WageHourly) _then) = __$WageHourlyCopyWithImpl;
@override @useResult
$Res call({
 int id, double value
});




}
/// @nodoc
class __$WageHourlyCopyWithImpl<$Res>
    implements _$WageHourlyCopyWith<$Res> {
  __$WageHourlyCopyWithImpl(this._self, this._then);

  final _WageHourly _self;
  final $Res Function(_WageHourly) _then;

/// Create a copy of WageHourly
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? value = null,}) {
  return _then(_WageHourly(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
