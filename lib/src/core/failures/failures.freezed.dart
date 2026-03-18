// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ValueFailure<T> implements DiagnosticableTreeMixin {

 T get failedValue;
/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValueFailureCopyWith<T, ValueFailure<T>> get copyWith => _$ValueFailureCopyWithImpl<T, ValueFailure<T>>(this as ValueFailure<T>, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ValueFailure<$T>'))
    ..add(DiagnosticsProperty('failedValue', failedValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValueFailure<T>&&const DeepCollectionEquality().equals(other.failedValue, failedValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failedValue));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ValueFailure<$T>(failedValue: $failedValue)';
}


}

/// @nodoc
abstract mixin class $ValueFailureCopyWith<T,$Res>  {
  factory $ValueFailureCopyWith(ValueFailure<T> value, $Res Function(ValueFailure<T>) _then) = _$ValueFailureCopyWithImpl;
@useResult
$Res call({
 T failedValue
});




}
/// @nodoc
class _$ValueFailureCopyWithImpl<T,$Res>
    implements $ValueFailureCopyWith<T, $Res> {
  _$ValueFailureCopyWithImpl(this._self, this._then);

  final ValueFailure<T> _self;
  final $Res Function(ValueFailure<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? failedValue = freezed,}) {
  return _then(_self.copyWith(
failedValue: freezed == failedValue ? _self.failedValue : failedValue // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [ValueFailure].
extension ValueFailurePatterns<T> on ValueFailure<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CharacterLimitExceeded<T> value)?  characterLimitExceeded,TResult Function( ShortOrNullCharacters<T> value)?  shortOrNullCharacters,TResult Function( InvalidFormat<T> value)?  invalidFormat,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CharacterLimitExceeded() when characterLimitExceeded != null:
return characterLimitExceeded(_that);case ShortOrNullCharacters() when shortOrNullCharacters != null:
return shortOrNullCharacters(_that);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CharacterLimitExceeded<T> value)  characterLimitExceeded,required TResult Function( ShortOrNullCharacters<T> value)  shortOrNullCharacters,required TResult Function( InvalidFormat<T> value)  invalidFormat,}){
final _that = this;
switch (_that) {
case CharacterLimitExceeded():
return characterLimitExceeded(_that);case ShortOrNullCharacters():
return shortOrNullCharacters(_that);case InvalidFormat():
return invalidFormat(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CharacterLimitExceeded<T> value)?  characterLimitExceeded,TResult? Function( ShortOrNullCharacters<T> value)?  shortOrNullCharacters,TResult? Function( InvalidFormat<T> value)?  invalidFormat,}){
final _that = this;
switch (_that) {
case CharacterLimitExceeded() when characterLimitExceeded != null:
return characterLimitExceeded(_that);case ShortOrNullCharacters() when shortOrNullCharacters != null:
return shortOrNullCharacters(_that);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T failedValue)?  characterLimitExceeded,TResult Function( T failedValue)?  shortOrNullCharacters,TResult Function( T failedValue)?  invalidFormat,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CharacterLimitExceeded() when characterLimitExceeded != null:
return characterLimitExceeded(_that.failedValue);case ShortOrNullCharacters() when shortOrNullCharacters != null:
return shortOrNullCharacters(_that.failedValue);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that.failedValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T failedValue)  characterLimitExceeded,required TResult Function( T failedValue)  shortOrNullCharacters,required TResult Function( T failedValue)  invalidFormat,}) {final _that = this;
switch (_that) {
case CharacterLimitExceeded():
return characterLimitExceeded(_that.failedValue);case ShortOrNullCharacters():
return shortOrNullCharacters(_that.failedValue);case InvalidFormat():
return invalidFormat(_that.failedValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T failedValue)?  characterLimitExceeded,TResult? Function( T failedValue)?  shortOrNullCharacters,TResult? Function( T failedValue)?  invalidFormat,}) {final _that = this;
switch (_that) {
case CharacterLimitExceeded() when characterLimitExceeded != null:
return characterLimitExceeded(_that.failedValue);case ShortOrNullCharacters() when shortOrNullCharacters != null:
return shortOrNullCharacters(_that.failedValue);case InvalidFormat() when invalidFormat != null:
return invalidFormat(_that.failedValue);case _:
  return null;

}
}

}

/// @nodoc


class CharacterLimitExceeded<T> with DiagnosticableTreeMixin implements ValueFailure<T> {
  const CharacterLimitExceeded({required this.failedValue});
  

@override final  T failedValue;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterLimitExceededCopyWith<T, CharacterLimitExceeded<T>> get copyWith => _$CharacterLimitExceededCopyWithImpl<T, CharacterLimitExceeded<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ValueFailure<$T>.characterLimitExceeded'))
    ..add(DiagnosticsProperty('failedValue', failedValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterLimitExceeded<T>&&const DeepCollectionEquality().equals(other.failedValue, failedValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failedValue));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ValueFailure<$T>.characterLimitExceeded(failedValue: $failedValue)';
}


}

/// @nodoc
abstract mixin class $CharacterLimitExceededCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $CharacterLimitExceededCopyWith(CharacterLimitExceeded<T> value, $Res Function(CharacterLimitExceeded<T>) _then) = _$CharacterLimitExceededCopyWithImpl;
@override @useResult
$Res call({
 T failedValue
});




}
/// @nodoc
class _$CharacterLimitExceededCopyWithImpl<T,$Res>
    implements $CharacterLimitExceededCopyWith<T, $Res> {
  _$CharacterLimitExceededCopyWithImpl(this._self, this._then);

  final CharacterLimitExceeded<T> _self;
  final $Res Function(CharacterLimitExceeded<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failedValue = freezed,}) {
  return _then(CharacterLimitExceeded<T>(
failedValue: freezed == failedValue ? _self.failedValue : failedValue // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ShortOrNullCharacters<T> with DiagnosticableTreeMixin implements ValueFailure<T> {
  const ShortOrNullCharacters({required this.failedValue});
  

@override final  T failedValue;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShortOrNullCharactersCopyWith<T, ShortOrNullCharacters<T>> get copyWith => _$ShortOrNullCharactersCopyWithImpl<T, ShortOrNullCharacters<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ValueFailure<$T>.shortOrNullCharacters'))
    ..add(DiagnosticsProperty('failedValue', failedValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShortOrNullCharacters<T>&&const DeepCollectionEquality().equals(other.failedValue, failedValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failedValue));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ValueFailure<$T>.shortOrNullCharacters(failedValue: $failedValue)';
}


}

/// @nodoc
abstract mixin class $ShortOrNullCharactersCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $ShortOrNullCharactersCopyWith(ShortOrNullCharacters<T> value, $Res Function(ShortOrNullCharacters<T>) _then) = _$ShortOrNullCharactersCopyWithImpl;
@override @useResult
$Res call({
 T failedValue
});




}
/// @nodoc
class _$ShortOrNullCharactersCopyWithImpl<T,$Res>
    implements $ShortOrNullCharactersCopyWith<T, $Res> {
  _$ShortOrNullCharactersCopyWithImpl(this._self, this._then);

  final ShortOrNullCharacters<T> _self;
  final $Res Function(ShortOrNullCharacters<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failedValue = freezed,}) {
  return _then(ShortOrNullCharacters<T>(
failedValue: freezed == failedValue ? _self.failedValue : failedValue // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class InvalidFormat<T> with DiagnosticableTreeMixin implements ValueFailure<T> {
  const InvalidFormat({required this.failedValue});
  

@override final  T failedValue;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidFormatCopyWith<T, InvalidFormat<T>> get copyWith => _$InvalidFormatCopyWithImpl<T, InvalidFormat<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ValueFailure<$T>.invalidFormat'))
    ..add(DiagnosticsProperty('failedValue', failedValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidFormat<T>&&const DeepCollectionEquality().equals(other.failedValue, failedValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failedValue));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ValueFailure<$T>.invalidFormat(failedValue: $failedValue)';
}


}

/// @nodoc
abstract mixin class $InvalidFormatCopyWith<T,$Res> implements $ValueFailureCopyWith<T, $Res> {
  factory $InvalidFormatCopyWith(InvalidFormat<T> value, $Res Function(InvalidFormat<T>) _then) = _$InvalidFormatCopyWithImpl;
@override @useResult
$Res call({
 T failedValue
});




}
/// @nodoc
class _$InvalidFormatCopyWithImpl<T,$Res>
    implements $InvalidFormatCopyWith<T, $Res> {
  _$InvalidFormatCopyWithImpl(this._self, this._then);

  final InvalidFormat<T> _self;
  final $Res Function(InvalidFormat<T>) _then;

/// Create a copy of ValueFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failedValue = freezed,}) {
  return _then(InvalidFormat<T>(
failedValue: freezed == failedValue ? _self.failedValue : failedValue // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc
mixin _$GlobalFailure<F> implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalFailure<F>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GlobalFailure<$F>()';
}


}

/// @nodoc
class $GlobalFailureCopyWith<F,$Res>  {
$GlobalFailureCopyWith(GlobalFailure<F> _, $Res Function(GlobalFailure<F>) __);
}


/// Adds pattern-matching-related methods to [GlobalFailure].
extension GlobalFailurePatterns<F> on GlobalFailure<F> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerError<F> value)?  serverError,TResult Function( NotConnection<F> value)?  notConnection,TResult Function( TimeOutExceeded<F> value)?  timeOutExceeded,TResult Function( LocalError<F> value)?  internalError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that);case NotConnection() when notConnection != null:
return notConnection(_that);case TimeOutExceeded() when timeOutExceeded != null:
return timeOutExceeded(_that);case LocalError() when internalError != null:
return internalError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerError<F> value)  serverError,required TResult Function( NotConnection<F> value)  notConnection,required TResult Function( TimeOutExceeded<F> value)  timeOutExceeded,required TResult Function( LocalError<F> value)  internalError,}){
final _that = this;
switch (_that) {
case ServerError():
return serverError(_that);case NotConnection():
return notConnection(_that);case TimeOutExceeded():
return timeOutExceeded(_that);case LocalError():
return internalError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerError<F> value)?  serverError,TResult? Function( NotConnection<F> value)?  notConnection,TResult? Function( TimeOutExceeded<F> value)?  timeOutExceeded,TResult? Function( LocalError<F> value)?  internalError,}){
final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that);case NotConnection() when notConnection != null:
return notConnection(_that);case TimeOutExceeded() when timeOutExceeded != null:
return timeOutExceeded(_that);case LocalError() when internalError != null:
return internalError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( F failure)?  serverError,TResult Function()?  notConnection,TResult Function()?  timeOutExceeded,TResult Function( dynamic err,  StackTrace? st)?  internalError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that.failure);case NotConnection() when notConnection != null:
return notConnection();case TimeOutExceeded() when timeOutExceeded != null:
return timeOutExceeded();case LocalError() when internalError != null:
return internalError(_that.err,_that.st);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( F failure)  serverError,required TResult Function()  notConnection,required TResult Function()  timeOutExceeded,required TResult Function( dynamic err,  StackTrace? st)  internalError,}) {final _that = this;
switch (_that) {
case ServerError():
return serverError(_that.failure);case NotConnection():
return notConnection();case TimeOutExceeded():
return timeOutExceeded();case LocalError():
return internalError(_that.err,_that.st);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( F failure)?  serverError,TResult? Function()?  notConnection,TResult? Function()?  timeOutExceeded,TResult? Function( dynamic err,  StackTrace? st)?  internalError,}) {final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that.failure);case NotConnection() when notConnection != null:
return notConnection();case TimeOutExceeded() when timeOutExceeded != null:
return timeOutExceeded();case LocalError() when internalError != null:
return internalError(_that.err,_that.st);case _:
  return null;

}
}

}

/// @nodoc


class ServerError<F> with DiagnosticableTreeMixin implements GlobalFailure<F> {
  const ServerError(this.failure);
  

 final  F failure;

/// Create a copy of GlobalFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerErrorCopyWith<F, ServerError<F>> get copyWith => _$ServerErrorCopyWithImpl<F, ServerError<F>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.serverError'))
    ..add(DiagnosticsProperty('failure', failure));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerError<F>&&const DeepCollectionEquality().equals(other.failure, failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failure));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GlobalFailure<$F>.serverError(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ServerErrorCopyWith<F,$Res> implements $GlobalFailureCopyWith<F, $Res> {
  factory $ServerErrorCopyWith(ServerError<F> value, $Res Function(ServerError<F>) _then) = _$ServerErrorCopyWithImpl;
@useResult
$Res call({
 F failure
});




}
/// @nodoc
class _$ServerErrorCopyWithImpl<F,$Res>
    implements $ServerErrorCopyWith<F, $Res> {
  _$ServerErrorCopyWithImpl(this._self, this._then);

  final ServerError<F> _self;
  final $Res Function(ServerError<F>) _then;

/// Create a copy of GlobalFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = freezed,}) {
  return _then(ServerError<F>(
freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as F,
  ));
}


}

/// @nodoc


class NotConnection<F> with DiagnosticableTreeMixin implements GlobalFailure<F> {
  const NotConnection();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.notConnection'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotConnection<F>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GlobalFailure<$F>.notConnection()';
}


}




/// @nodoc


class TimeOutExceeded<F> with DiagnosticableTreeMixin implements GlobalFailure<F> {
  const TimeOutExceeded();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.timeOutExceeded'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeOutExceeded<F>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GlobalFailure<$F>.timeOutExceeded()';
}


}




/// @nodoc


class LocalError<F> with DiagnosticableTreeMixin implements GlobalFailure<F> {
  const LocalError(this.err, [this.st]);
  

 final  dynamic err;
 final  StackTrace? st;

/// Create a copy of GlobalFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalErrorCopyWith<F, LocalError<F>> get copyWith => _$LocalErrorCopyWithImpl<F, LocalError<F>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.internalError'))
    ..add(DiagnosticsProperty('err', err))..add(DiagnosticsProperty('st', st));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalError<F>&&const DeepCollectionEquality().equals(other.err, err)&&(identical(other.st, st) || other.st == st));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(err),st);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GlobalFailure<$F>.internalError(err: $err, st: $st)';
}


}

/// @nodoc
abstract mixin class $LocalErrorCopyWith<F,$Res> implements $GlobalFailureCopyWith<F, $Res> {
  factory $LocalErrorCopyWith(LocalError<F> value, $Res Function(LocalError<F>) _then) = _$LocalErrorCopyWithImpl;
@useResult
$Res call({
 dynamic err, StackTrace? st
});




}
/// @nodoc
class _$LocalErrorCopyWithImpl<F,$Res>
    implements $LocalErrorCopyWith<F, $Res> {
  _$LocalErrorCopyWithImpl(this._self, this._then);

  final LocalError<F> _self;
  final $Res Function(LocalError<F>) _then;

/// Create a copy of GlobalFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? err = freezed,Object? st = freezed,}) {
  return _then(LocalError<F>(
freezed == err ? _self.err : err // ignore: cast_nullable_to_non_nullable
as dynamic,freezed == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
