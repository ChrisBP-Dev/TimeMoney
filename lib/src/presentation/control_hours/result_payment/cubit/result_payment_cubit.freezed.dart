// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultPaymentState {

 List<TimeEntry> get times; double get wageHourly;
/// Create a copy of ResultPaymentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultPaymentStateCopyWith<ResultPaymentState> get copyWith => _$ResultPaymentStateCopyWithImpl<ResultPaymentState>(this as ResultPaymentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultPaymentState&&const DeepCollectionEquality().equals(other.times, times)&&(identical(other.wageHourly, wageHourly) || other.wageHourly == wageHourly));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(times),wageHourly);

@override
String toString() {
  return 'ResultPaymentState(times: $times, wageHourly: $wageHourly)';
}


}

/// @nodoc
abstract mixin class $ResultPaymentStateCopyWith<$Res>  {
  factory $ResultPaymentStateCopyWith(ResultPaymentState value, $Res Function(ResultPaymentState) _then) = _$ResultPaymentStateCopyWithImpl;
@useResult
$Res call({
 List<TimeEntry> times, double wageHourly
});




}
/// @nodoc
class _$ResultPaymentStateCopyWithImpl<$Res>
    implements $ResultPaymentStateCopyWith<$Res> {
  _$ResultPaymentStateCopyWithImpl(this._self, this._then);

  final ResultPaymentState _self;
  final $Res Function(ResultPaymentState) _then;

/// Create a copy of ResultPaymentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? times = null,Object? wageHourly = null,}) {
  return _then(_self.copyWith(
times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<TimeEntry>,wageHourly: null == wageHourly ? _self.wageHourly : wageHourly // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultPaymentState].
extension ResultPaymentStatePatterns on ResultPaymentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultPaymentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultPaymentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultPaymentState value)  $default,){
final _that = this;
switch (_that) {
case _ResultPaymentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultPaymentState value)?  $default,){
final _that = this;
switch (_that) {
case _ResultPaymentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimeEntry> times,  double wageHourly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultPaymentState() when $default != null:
return $default(_that.times,_that.wageHourly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimeEntry> times,  double wageHourly)  $default,) {final _that = this;
switch (_that) {
case _ResultPaymentState():
return $default(_that.times,_that.wageHourly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimeEntry> times,  double wageHourly)?  $default,) {final _that = this;
switch (_that) {
case _ResultPaymentState() when $default != null:
return $default(_that.times,_that.wageHourly);case _:
  return null;

}
}

}

/// @nodoc


class _ResultPaymentState implements ResultPaymentState {
  const _ResultPaymentState({final  List<TimeEntry> times = const [], this.wageHourly = 0.0}): _times = times;
  

 final  List<TimeEntry> _times;
@override@JsonKey() List<TimeEntry> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

@override@JsonKey() final  double wageHourly;

/// Create a copy of ResultPaymentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultPaymentStateCopyWith<_ResultPaymentState> get copyWith => __$ResultPaymentStateCopyWithImpl<_ResultPaymentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultPaymentState&&const DeepCollectionEquality().equals(other._times, _times)&&(identical(other.wageHourly, wageHourly) || other.wageHourly == wageHourly));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_times),wageHourly);

@override
String toString() {
  return 'ResultPaymentState(times: $times, wageHourly: $wageHourly)';
}


}

/// @nodoc
abstract mixin class _$ResultPaymentStateCopyWith<$Res> implements $ResultPaymentStateCopyWith<$Res> {
  factory _$ResultPaymentStateCopyWith(_ResultPaymentState value, $Res Function(_ResultPaymentState) _then) = __$ResultPaymentStateCopyWithImpl;
@override @useResult
$Res call({
 List<TimeEntry> times, double wageHourly
});




}
/// @nodoc
class __$ResultPaymentStateCopyWithImpl<$Res>
    implements _$ResultPaymentStateCopyWith<$Res> {
  __$ResultPaymentStateCopyWithImpl(this._self, this._then);

  final _ResultPaymentState _self;
  final $Res Function(_ResultPaymentState) _then;

/// Create a copy of ResultPaymentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? times = null,Object? wageHourly = null,}) {
  return _then(_ResultPaymentState(
times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<TimeEntry>,wageHourly: null == wageHourly ? _self.wageHourly : wageHourly // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
