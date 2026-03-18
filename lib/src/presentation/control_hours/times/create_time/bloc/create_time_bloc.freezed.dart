// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_time_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateTimeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTimeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTimeEvent()';
}


}

/// @nodoc
class $CreateTimeEventCopyWith<$Res>  {
$CreateTimeEventCopyWith(CreateTimeEvent _, $Res Function(CreateTimeEvent) __);
}


/// Adds pattern-matching-related methods to [CreateTimeEvent].
extension CreateTimeEventPatterns on CreateTimeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangeHour value)?  changeHour,TResult Function( _ChangeMinutes value)?  changeMinutes,TResult Function( _Create value)?  create,TResult Function( _Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeHour() when changeHour != null:
return changeHour(_that);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that);case _Create() when create != null:
return create(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangeHour value)  changeHour,required TResult Function( _ChangeMinutes value)  changeMinutes,required TResult Function( _Create value)  create,required TResult Function( _Reset value)  reset,}){
final _that = this;
switch (_that) {
case _ChangeHour():
return changeHour(_that);case _ChangeMinutes():
return changeMinutes(_that);case _Create():
return create(_that);case _Reset():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangeHour value)?  changeHour,TResult? Function( _ChangeMinutes value)?  changeMinutes,TResult? Function( _Create value)?  create,TResult? Function( _Reset value)?  reset,}){
final _that = this;
switch (_that) {
case _ChangeHour() when changeHour != null:
return changeHour(_that);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that);case _Create() when create != null:
return create(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  changeHour,TResult Function( String value)?  changeMinutes,TResult Function()?  create,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeHour() when changeHour != null:
return changeHour(_that.value);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that.value);case _Create() when create != null:
return create();case _Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  changeHour,required TResult Function( String value)  changeMinutes,required TResult Function()  create,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case _ChangeHour():
return changeHour(_that.value);case _ChangeMinutes():
return changeMinutes(_that.value);case _Create():
return create();case _Reset():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  changeHour,TResult? Function( String value)?  changeMinutes,TResult? Function()?  create,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case _ChangeHour() when changeHour != null:
return changeHour(_that.value);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that.value);case _Create() when create != null:
return create();case _Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class _ChangeHour implements CreateTimeEvent {
  const _ChangeHour({required this.value});
  

 final  String value;

/// Create a copy of CreateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeHourCopyWith<_ChangeHour> get copyWith => __$ChangeHourCopyWithImpl<_ChangeHour>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeHour&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'CreateTimeEvent.changeHour(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeHourCopyWith<$Res> implements $CreateTimeEventCopyWith<$Res> {
  factory _$ChangeHourCopyWith(_ChangeHour value, $Res Function(_ChangeHour) _then) = __$ChangeHourCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$ChangeHourCopyWithImpl<$Res>
    implements _$ChangeHourCopyWith<$Res> {
  __$ChangeHourCopyWithImpl(this._self, this._then);

  final _ChangeHour _self;
  final $Res Function(_ChangeHour) _then;

/// Create a copy of CreateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeHour(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ChangeMinutes implements CreateTimeEvent {
  const _ChangeMinutes({required this.value});
  

 final  String value;

/// Create a copy of CreateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeMinutesCopyWith<_ChangeMinutes> get copyWith => __$ChangeMinutesCopyWithImpl<_ChangeMinutes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeMinutes&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'CreateTimeEvent.changeMinutes(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeMinutesCopyWith<$Res> implements $CreateTimeEventCopyWith<$Res> {
  factory _$ChangeMinutesCopyWith(_ChangeMinutes value, $Res Function(_ChangeMinutes) _then) = __$ChangeMinutesCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$ChangeMinutesCopyWithImpl<$Res>
    implements _$ChangeMinutesCopyWith<$Res> {
  __$ChangeMinutesCopyWithImpl(this._self, this._then);

  final _ChangeMinutes _self;
  final $Res Function(_ChangeMinutes) _then;

/// Create a copy of CreateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeMinutes(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Create implements CreateTimeEvent {
  const _Create();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Create);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTimeEvent.create()';
}


}




/// @nodoc


class _Reset implements CreateTimeEvent {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTimeEvent.reset()';
}


}




/// @nodoc
mixin _$CreateTimeState {

 ActionState<ModelTime> get currentState; int get hour; int get minutes;
/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTimeStateCopyWith<CreateTimeState> get copyWith => _$CreateTimeStateCopyWithImpl<CreateTimeState>(this as CreateTimeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTimeState&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,currentState,hour,minutes);

@override
String toString() {
  return 'CreateTimeState(currentState: $currentState, hour: $hour, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class $CreateTimeStateCopyWith<$Res>  {
  factory $CreateTimeStateCopyWith(CreateTimeState value, $Res Function(CreateTimeState) _then) = _$CreateTimeStateCopyWithImpl;
@useResult
$Res call({
 ActionState<ModelTime> currentState, int hour, int minutes
});


$ActionStateCopyWith<ModelTime, $Res> get currentState;

}
/// @nodoc
class _$CreateTimeStateCopyWithImpl<$Res>
    implements $CreateTimeStateCopyWith<$Res> {
  _$CreateTimeStateCopyWithImpl(this._self, this._then);

  final CreateTimeState _self;
  final $Res Function(CreateTimeState) _then;

/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentState = null,Object? hour = null,Object? minutes = null,}) {
  return _then(_self.copyWith(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<ModelTime>,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionStateCopyWith<ModelTime, $Res> get currentState {
  
  return $ActionStateCopyWith<ModelTime, $Res>(_self.currentState, (value) {
    return _then(_self.copyWith(currentState: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTimeState].
extension CreateTimeStatePatterns on CreateTimeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTimeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTimeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTimeState value)  $default,){
final _that = this;
switch (_that) {
case _CreateTimeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTimeState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTimeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActionState<ModelTime> currentState,  int hour,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTimeState() when $default != null:
return $default(_that.currentState,_that.hour,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActionState<ModelTime> currentState,  int hour,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _CreateTimeState():
return $default(_that.currentState,_that.hour,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActionState<ModelTime> currentState,  int hour,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _CreateTimeState() when $default != null:
return $default(_that.currentState,_that.hour,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc


class _CreateTimeState implements CreateTimeState {
  const _CreateTimeState({required this.currentState, this.hour = 0, this.minutes = 0});
  

@override final  ActionState<ModelTime> currentState;
@override@JsonKey() final  int hour;
@override@JsonKey() final  int minutes;

/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTimeStateCopyWith<_CreateTimeState> get copyWith => __$CreateTimeStateCopyWithImpl<_CreateTimeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTimeState&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,currentState,hour,minutes);

@override
String toString() {
  return 'CreateTimeState(currentState: $currentState, hour: $hour, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$CreateTimeStateCopyWith<$Res> implements $CreateTimeStateCopyWith<$Res> {
  factory _$CreateTimeStateCopyWith(_CreateTimeState value, $Res Function(_CreateTimeState) _then) = __$CreateTimeStateCopyWithImpl;
@override @useResult
$Res call({
 ActionState<ModelTime> currentState, int hour, int minutes
});


@override $ActionStateCopyWith<ModelTime, $Res> get currentState;

}
/// @nodoc
class __$CreateTimeStateCopyWithImpl<$Res>
    implements _$CreateTimeStateCopyWith<$Res> {
  __$CreateTimeStateCopyWithImpl(this._self, this._then);

  final _CreateTimeState _self;
  final $Res Function(_CreateTimeState) _then;

/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentState = null,Object? hour = null,Object? minutes = null,}) {
  return _then(_CreateTimeState(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<ModelTime>,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CreateTimeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionStateCopyWith<ModelTime, $Res> get currentState {
  
  return $ActionStateCopyWith<ModelTime, $Res>(_self.currentState, (value) {
    return _then(_self.copyWith(currentState: value));
  });
}
}

// dart format on
