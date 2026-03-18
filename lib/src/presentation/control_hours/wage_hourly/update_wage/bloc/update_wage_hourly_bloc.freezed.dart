// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_wage_hourly_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateWageHourlyEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWageHourlyEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateWageHourlyEvent()';
}


}

/// @nodoc
class $UpdateWageHourlyEventCopyWith<$Res>  {
$UpdateWageHourlyEventCopyWith(UpdateWageHourlyEvent _, $Res Function(UpdateWageHourlyEvent) __);
}


/// Adds pattern-matching-related methods to [UpdateWageHourlyEvent].
extension UpdateWageHourlyEventPatterns on UpdateWageHourlyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangeHourly value)?  changeHourly,TResult Function( _Update value)?  update,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeHourly() when changeHourly != null:
return changeHourly(_that);case _Update() when update != null:
return update(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangeHourly value)  changeHourly,required TResult Function( _Update value)  update,}){
final _that = this;
switch (_that) {
case _ChangeHourly():
return changeHourly(_that);case _Update():
return update(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangeHourly value)?  changeHourly,TResult? Function( _Update value)?  update,}){
final _that = this;
switch (_that) {
case _ChangeHourly() when changeHourly != null:
return changeHourly(_that);case _Update() when update != null:
return update(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  changeHourly,TResult Function()?  update,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeHourly() when changeHourly != null:
return changeHourly(_that.value);case _Update() when update != null:
return update();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  changeHourly,required TResult Function()  update,}) {final _that = this;
switch (_that) {
case _ChangeHourly():
return changeHourly(_that.value);case _Update():
return update();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  changeHourly,TResult? Function()?  update,}) {final _that = this;
switch (_that) {
case _ChangeHourly() when changeHourly != null:
return changeHourly(_that.value);case _Update() when update != null:
return update();case _:
  return null;

}
}

}

/// @nodoc


class _ChangeHourly implements UpdateWageHourlyEvent {
  const _ChangeHourly({required this.value});
  

 final  String value;

/// Create a copy of UpdateWageHourlyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeHourlyCopyWith<_ChangeHourly> get copyWith => __$ChangeHourlyCopyWithImpl<_ChangeHourly>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeHourly&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'UpdateWageHourlyEvent.changeHourly(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeHourlyCopyWith<$Res> implements $UpdateWageHourlyEventCopyWith<$Res> {
  factory _$ChangeHourlyCopyWith(_ChangeHourly value, $Res Function(_ChangeHourly) _then) = __$ChangeHourlyCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$ChangeHourlyCopyWithImpl<$Res>
    implements _$ChangeHourlyCopyWith<$Res> {
  __$ChangeHourlyCopyWithImpl(this._self, this._then);

  final _ChangeHourly _self;
  final $Res Function(_ChangeHourly) _then;

/// Create a copy of UpdateWageHourlyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeHourly(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Update implements UpdateWageHourlyEvent {
  const _Update();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Update);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateWageHourlyEvent.update()';
}


}




/// @nodoc
mixin _$UpdateWageHourlyState {

 WageHourly get wageHourly; ActionState<WageHourly> get currentState;
/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWageHourlyStateCopyWith<UpdateWageHourlyState> get copyWith => _$UpdateWageHourlyStateCopyWithImpl<UpdateWageHourlyState>(this as UpdateWageHourlyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWageHourlyState&&(identical(other.wageHourly, wageHourly) || other.wageHourly == wageHourly)&&(identical(other.currentState, currentState) || other.currentState == currentState));
}


@override
int get hashCode => Object.hash(runtimeType,wageHourly,currentState);

@override
String toString() {
  return 'UpdateWageHourlyState(wageHourly: $wageHourly, currentState: $currentState)';
}


}

/// @nodoc
abstract mixin class $UpdateWageHourlyStateCopyWith<$Res>  {
  factory $UpdateWageHourlyStateCopyWith(UpdateWageHourlyState value, $Res Function(UpdateWageHourlyState) _then) = _$UpdateWageHourlyStateCopyWithImpl;
@useResult
$Res call({
 WageHourly wageHourly, ActionState<WageHourly> currentState
});


$WageHourlyCopyWith<$Res> get wageHourly;$ActionStateCopyWith<WageHourly, $Res> get currentState;

}
/// @nodoc
class _$UpdateWageHourlyStateCopyWithImpl<$Res>
    implements $UpdateWageHourlyStateCopyWith<$Res> {
  _$UpdateWageHourlyStateCopyWithImpl(this._self, this._then);

  final UpdateWageHourlyState _self;
  final $Res Function(UpdateWageHourlyState) _then;

/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wageHourly = null,Object? currentState = null,}) {
  return _then(_self.copyWith(
wageHourly: null == wageHourly ? _self.wageHourly : wageHourly // ignore: cast_nullable_to_non_nullable
as WageHourly,currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<WageHourly>,
  ));
}
/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WageHourlyCopyWith<$Res> get wageHourly {
  
  return $WageHourlyCopyWith<$Res>(_self.wageHourly, (value) {
    return _then(_self.copyWith(wageHourly: value));
  });
}/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionStateCopyWith<WageHourly, $Res> get currentState {
  
  return $ActionStateCopyWith<WageHourly, $Res>(_self.currentState, (value) {
    return _then(_self.copyWith(currentState: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateWageHourlyState].
extension UpdateWageHourlyStatePatterns on UpdateWageHourlyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWageHourlyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWageHourlyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWageHourlyState value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWageHourlyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWageHourlyState value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWageHourlyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WageHourly wageHourly,  ActionState<WageHourly> currentState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWageHourlyState() when $default != null:
return $default(_that.wageHourly,_that.currentState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WageHourly wageHourly,  ActionState<WageHourly> currentState)  $default,) {final _that = this;
switch (_that) {
case _UpdateWageHourlyState():
return $default(_that.wageHourly,_that.currentState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WageHourly wageHourly,  ActionState<WageHourly> currentState)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWageHourlyState() when $default != null:
return $default(_that.wageHourly,_that.currentState);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateWageHourlyState implements UpdateWageHourlyState {
  const _UpdateWageHourlyState({this.wageHourly = const WageHourly(), this.currentState = const ActionState<WageHourly>.initial()});
  

@override@JsonKey() final  WageHourly wageHourly;
@override@JsonKey() final  ActionState<WageHourly> currentState;

/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWageHourlyStateCopyWith<_UpdateWageHourlyState> get copyWith => __$UpdateWageHourlyStateCopyWithImpl<_UpdateWageHourlyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWageHourlyState&&(identical(other.wageHourly, wageHourly) || other.wageHourly == wageHourly)&&(identical(other.currentState, currentState) || other.currentState == currentState));
}


@override
int get hashCode => Object.hash(runtimeType,wageHourly,currentState);

@override
String toString() {
  return 'UpdateWageHourlyState(wageHourly: $wageHourly, currentState: $currentState)';
}


}

/// @nodoc
abstract mixin class _$UpdateWageHourlyStateCopyWith<$Res> implements $UpdateWageHourlyStateCopyWith<$Res> {
  factory _$UpdateWageHourlyStateCopyWith(_UpdateWageHourlyState value, $Res Function(_UpdateWageHourlyState) _then) = __$UpdateWageHourlyStateCopyWithImpl;
@override @useResult
$Res call({
 WageHourly wageHourly, ActionState<WageHourly> currentState
});


@override $WageHourlyCopyWith<$Res> get wageHourly;@override $ActionStateCopyWith<WageHourly, $Res> get currentState;

}
/// @nodoc
class __$UpdateWageHourlyStateCopyWithImpl<$Res>
    implements _$UpdateWageHourlyStateCopyWith<$Res> {
  __$UpdateWageHourlyStateCopyWithImpl(this._self, this._then);

  final _UpdateWageHourlyState _self;
  final $Res Function(_UpdateWageHourlyState) _then;

/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wageHourly = null,Object? currentState = null,}) {
  return _then(_UpdateWageHourlyState(
wageHourly: null == wageHourly ? _self.wageHourly : wageHourly // ignore: cast_nullable_to_non_nullable
as WageHourly,currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<WageHourly>,
  ));
}

/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WageHourlyCopyWith<$Res> get wageHourly {
  
  return $WageHourlyCopyWith<$Res>(_self.wageHourly, (value) {
    return _then(_self.copyWith(wageHourly: value));
  });
}/// Create a copy of UpdateWageHourlyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionStateCopyWith<WageHourly, $Res> get currentState {
  
  return $ActionStateCopyWith<WageHourly, $Res>(_self.currentState, (value) {
    return _then(_self.copyWith(currentState: value));
  });
}
}

// dart format on
