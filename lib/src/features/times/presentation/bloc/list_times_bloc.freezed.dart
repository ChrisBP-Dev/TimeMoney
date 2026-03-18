// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_times_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListTimesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListTimesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesEvent()';
}


}

/// @nodoc
class $ListTimesEventCopyWith<$Res>  {
$ListTimesEventCopyWith(ListTimesEvent _, $Res Function(ListTimesEvent) __);
}


/// Adds pattern-matching-related methods to [ListTimesEvent].
extension ListTimesEventPatterns on ListTimesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetTimes value)?  getTimes,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetTimes() when getTimes != null:
return getTimes(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetTimes value)  getTimes,}){
final _that = this;
switch (_that) {
case _GetTimes():
return getTimes(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetTimes value)?  getTimes,}){
final _that = this;
switch (_that) {
case _GetTimes() when getTimes != null:
return getTimes(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getTimes,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetTimes() when getTimes != null:
return getTimes();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getTimes,}) {final _that = this;
switch (_that) {
case _GetTimes():
return getTimes();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getTimes,}) {final _that = this;
switch (_that) {
case _GetTimes() when getTimes != null:
return getTimes();case _:
  return null;

}
}

}

/// @nodoc


class _GetTimes implements ListTimesEvent {
  const _GetTimes();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetTimes);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesEvent.getTimes()';
}


}




/// @nodoc
mixin _$ListTimesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListTimesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesState()';
}


}

/// @nodoc
class $ListTimesStateCopyWith<$Res>  {
$ListTimesStateCopyWith(ListTimesState _, $Res Function(ListTimesState) __);
}


/// Adds pattern-matching-related methods to [ListTimesState].
extension ListTimesStatePatterns on ListTimesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Empty value)?  empty,TResult Function( _Error value)?  error,TResult Function( _HasDataStream value)?  hasDataStream,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Empty() when empty != null:
return empty(_that);case _Error() when error != null:
return error(_that);case _HasDataStream() when hasDataStream != null:
return hasDataStream(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Empty value)  empty,required TResult Function( _Error value)  error,required TResult Function( _HasDataStream value)  hasDataStream,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Empty():
return empty(_that);case _Error():
return error(_that);case _HasDataStream():
return hasDataStream(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Empty value)?  empty,TResult? Function( _Error value)?  error,TResult? Function( _HasDataStream value)?  hasDataStream,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Empty() when empty != null:
return empty(_that);case _Error() when error != null:
return error(_that);case _HasDataStream() when hasDataStream != null:
return hasDataStream(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  empty,TResult Function( GlobalFailure err)?  error,TResult Function( Stream<List<TimeEntry>> data)?  hasDataStream,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Empty() when empty != null:
return empty();case _Error() when error != null:
return error(_that.err);case _HasDataStream() when hasDataStream != null:
return hasDataStream(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  empty,required TResult Function( GlobalFailure err)  error,required TResult Function( Stream<List<TimeEntry>> data)  hasDataStream,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Empty():
return empty();case _Error():
return error(_that.err);case _HasDataStream():
return hasDataStream(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  empty,TResult? Function( GlobalFailure err)?  error,TResult? Function( Stream<List<TimeEntry>> data)?  hasDataStream,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Empty() when empty != null:
return empty();case _Error() when error != null:
return error(_that.err);case _HasDataStream() when hasDataStream != null:
return hasDataStream(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ListTimesState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesState.initial()';
}


}




/// @nodoc


class _Loading implements ListTimesState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesState.loading()';
}


}




/// @nodoc


class _Empty implements ListTimesState {
  const _Empty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListTimesState.empty()';
}


}




/// @nodoc


class _Error implements ListTimesState {
  const _Error(this.err);
  

 final  GlobalFailure err;

/// Create a copy of ListTimesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.err, err) || other.err == err));
}


@override
int get hashCode => Object.hash(runtimeType,err);

@override
String toString() {
  return 'ListTimesState.error(err: $err)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ListTimesStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 GlobalFailure err
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ListTimesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? err = null,}) {
  return _then(_Error(
null == err ? _self.err : err // ignore: cast_nullable_to_non_nullable
as GlobalFailure,
  ));
}


}

/// @nodoc


class _HasDataStream implements ListTimesState {
  const _HasDataStream(this.data);
  

 final  Stream<List<TimeEntry>> data;

/// Create a copy of ListTimesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HasDataStreamCopyWith<_HasDataStream> get copyWith => __$HasDataStreamCopyWithImpl<_HasDataStream>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HasDataStream&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ListTimesState.hasDataStream(data: $data)';
}


}

/// @nodoc
abstract mixin class _$HasDataStreamCopyWith<$Res> implements $ListTimesStateCopyWith<$Res> {
  factory _$HasDataStreamCopyWith(_HasDataStream value, $Res Function(_HasDataStream) _then) = __$HasDataStreamCopyWithImpl;
@useResult
$Res call({
 Stream<List<TimeEntry>> data
});




}
/// @nodoc
class __$HasDataStreamCopyWithImpl<$Res>
    implements _$HasDataStreamCopyWith<$Res> {
  __$HasDataStreamCopyWithImpl(this._self, this._then);

  final _HasDataStream _self;
  final $Res Function(_HasDataStream) _then;

/// Create a copy of ListTimesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_HasDataStream(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Stream<List<TimeEntry>>,
  ));
}


}

// dart format on
