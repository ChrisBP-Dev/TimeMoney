// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_time_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateTimeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTimeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateTimeEvent()';
}


}

/// @nodoc
class $UpdateTimeEventCopyWith<$Res>  {
$UpdateTimeEventCopyWith(UpdateTimeEvent _, $Res Function(UpdateTimeEvent) __);
}


/// Adds pattern-matching-related methods to [UpdateTimeEvent].
extension UpdateTimeEventPatterns on UpdateTimeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _ChangeHour value)?  changeHour,TResult Function( _ChangeMinutes value)?  changeMinutes,TResult Function( _Update value)?  update,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _ChangeHour() when changeHour != null:
return changeHour(_that);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that);case _Update() when update != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _ChangeHour value)  changeHour,required TResult Function( _ChangeMinutes value)  changeMinutes,required TResult Function( _Update value)  update,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _ChangeHour():
return changeHour(_that);case _ChangeMinutes():
return changeMinutes(_that);case _Update():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _ChangeHour value)?  changeHour,TResult? Function( _ChangeMinutes value)?  changeMinutes,TResult? Function( _Update value)?  update,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _ChangeHour() when changeHour != null:
return changeHour(_that);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that);case _Update() when update != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TimeEntry time)?  init,TResult Function( String value)?  changeHour,TResult Function( String value)?  changeMinutes,TResult Function()?  update,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that.time);case _ChangeHour() when changeHour != null:
return changeHour(_that.value);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that.value);case _Update() when update != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TimeEntry time)  init,required TResult Function( String value)  changeHour,required TResult Function( String value)  changeMinutes,required TResult Function()  update,}) {final _that = this;
switch (_that) {
case _Init():
return init(_that.time);case _ChangeHour():
return changeHour(_that.value);case _ChangeMinutes():
return changeMinutes(_that.value);case _Update():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TimeEntry time)?  init,TResult? Function( String value)?  changeHour,TResult? Function( String value)?  changeMinutes,TResult? Function()?  update,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that.time);case _ChangeHour() when changeHour != null:
return changeHour(_that.value);case _ChangeMinutes() when changeMinutes != null:
return changeMinutes(_that.value);case _Update() when update != null:
return update();case _:
  return null;

}
}

}

/// @nodoc


class _Init implements UpdateTimeEvent {
  const _Init({required this.time});
  

 final  TimeEntry time;

/// Create a copy of UpdateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitCopyWith<_Init> get copyWith => __$InitCopyWithImpl<_Init>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,time);

@override
String toString() {
  return 'UpdateTimeEvent.init(time: $time)';
}


}

/// @nodoc
abstract mixin class _$InitCopyWith<$Res> implements $UpdateTimeEventCopyWith<$Res> {
  factory _$InitCopyWith(_Init value, $Res Function(_Init) _then) = __$InitCopyWithImpl;
@useResult
$Res call({
 TimeEntry time
});


$TimeEntryCopyWith<$Res> get time;

}
/// @nodoc
class __$InitCopyWithImpl<$Res>
    implements _$InitCopyWith<$Res> {
  __$InitCopyWithImpl(this._self, this._then);

  final _Init _self;
  final $Res Function(_Init) _then;

/// Create a copy of UpdateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? time = null,}) {
  return _then(_Init(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeEntry,
  ));
}

/// Create a copy of UpdateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<$Res> get time {
  
  return $TimeEntryCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}

/// @nodoc


class _ChangeHour implements UpdateTimeEvent {
  const _ChangeHour({required this.value});
  

 final  String value;

/// Create a copy of UpdateTimeEvent
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
  return 'UpdateTimeEvent.changeHour(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeHourCopyWith<$Res> implements $UpdateTimeEventCopyWith<$Res> {
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

/// Create a copy of UpdateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeHour(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ChangeMinutes implements UpdateTimeEvent {
  const _ChangeMinutes({required this.value});
  

 final  String value;

/// Create a copy of UpdateTimeEvent
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
  return 'UpdateTimeEvent.changeMinutes(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeMinutesCopyWith<$Res> implements $UpdateTimeEventCopyWith<$Res> {
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

/// Create a copy of UpdateTimeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeMinutes(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Update implements UpdateTimeEvent {
  const _Update();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Update);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateTimeEvent.update()';
}


}




/// @nodoc
mixin _$UpdateTimeState {

 ActionState<TimeEntry> get currentState; TimeEntry? get time;
/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTimeStateCopyWith<UpdateTimeState> get copyWith => _$UpdateTimeStateCopyWithImpl<UpdateTimeState>(this as UpdateTimeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTimeState&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,currentState,time);

@override
String toString() {
  return 'UpdateTimeState(currentState: $currentState, time: $time)';
}


}

/// @nodoc
abstract mixin class $UpdateTimeStateCopyWith<$Res>  {
  factory $UpdateTimeStateCopyWith(UpdateTimeState value, $Res Function(UpdateTimeState) _then) = _$UpdateTimeStateCopyWithImpl;
@useResult
$Res call({
 ActionState<TimeEntry> currentState, TimeEntry? time
});


$TimeEntryCopyWith<$Res>? get time;

}
/// @nodoc
class _$UpdateTimeStateCopyWithImpl<$Res>
    implements $UpdateTimeStateCopyWith<$Res> {
  _$UpdateTimeStateCopyWithImpl(this._self, this._then);

  final UpdateTimeState _self;
  final $Res Function(UpdateTimeState) _then;

/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentState = null,Object? time = freezed,}) {
  return _then(_self.copyWith(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<TimeEntry>,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeEntry?,
  ));
}
/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $TimeEntryCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateTimeState].
extension UpdateTimeStatePatterns on UpdateTimeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTimeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTimeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTimeState value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTimeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTimeState value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTimeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActionState<TimeEntry> currentState,  TimeEntry? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTimeState() when $default != null:
return $default(_that.currentState,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActionState<TimeEntry> currentState,  TimeEntry? time)  $default,) {final _that = this;
switch (_that) {
case _UpdateTimeState():
return $default(_that.currentState,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActionState<TimeEntry> currentState,  TimeEntry? time)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTimeState() when $default != null:
return $default(_that.currentState,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateTimeState implements UpdateTimeState {
  const _UpdateTimeState({this.currentState = const ActionInitial<TimeEntry>(), this.time = null});
  

@override@JsonKey() final  ActionState<TimeEntry> currentState;
@override@JsonKey() final  TimeEntry? time;

/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTimeStateCopyWith<_UpdateTimeState> get copyWith => __$UpdateTimeStateCopyWithImpl<_UpdateTimeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTimeState&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,currentState,time);

@override
String toString() {
  return 'UpdateTimeState(currentState: $currentState, time: $time)';
}


}

/// @nodoc
abstract mixin class _$UpdateTimeStateCopyWith<$Res> implements $UpdateTimeStateCopyWith<$Res> {
  factory _$UpdateTimeStateCopyWith(_UpdateTimeState value, $Res Function(_UpdateTimeState) _then) = __$UpdateTimeStateCopyWithImpl;
@override @useResult
$Res call({
 ActionState<TimeEntry> currentState, TimeEntry? time
});


@override $TimeEntryCopyWith<$Res>? get time;

}
/// @nodoc
class __$UpdateTimeStateCopyWithImpl<$Res>
    implements _$UpdateTimeStateCopyWith<$Res> {
  __$UpdateTimeStateCopyWithImpl(this._self, this._then);

  final _UpdateTimeState _self;
  final $Res Function(_UpdateTimeState) _then;

/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentState = null,Object? time = freezed,}) {
  return _then(_UpdateTimeState(
currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as ActionState<TimeEntry>,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeEntry?,
  ));
}

/// Create a copy of UpdateTimeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<$Res>? get time {
    if (_self.time == null) {
    return null;
  }

  return $TimeEntryCopyWith<$Res>(_self.time!, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}

// dart format on
