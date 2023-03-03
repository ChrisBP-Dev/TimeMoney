// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ValueFailure<T> {
  T get failedValue => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) characterLimitExceeded,
    required TResult Function(T failedValue) shortOrNullCharacters,
    required TResult Function(T failedValue) invalidFormat,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? characterLimitExceeded,
    TResult? Function(T failedValue)? shortOrNullCharacters,
    TResult? Function(T failedValue)? invalidFormat,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? characterLimitExceeded,
    TResult Function(T failedValue)? shortOrNullCharacters,
    TResult Function(T failedValue)? invalidFormat,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterLimitExceeded<T> value)
        characterLimitExceeded,
    required TResult Function(ShortOrNullCharacters<T> value)
        shortOrNullCharacters,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult? Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValueFailureCopyWith<T, ValueFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueFailureCopyWith<T, $Res> {
  factory $ValueFailureCopyWith(
          ValueFailure<T> value, $Res Function(ValueFailure<T>) then) =
      _$ValueFailureCopyWithImpl<T, $Res, ValueFailure<T>>;
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class _$ValueFailureCopyWithImpl<T, $Res, $Val extends ValueFailure<T>>
    implements $ValueFailureCopyWith<T, $Res> {
  _$ValueFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_value.copyWith(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterLimitExceededCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$CharacterLimitExceededCopyWith(_$CharacterLimitExceeded<T> value,
          $Res Function(_$CharacterLimitExceeded<T>) then) =
      __$$CharacterLimitExceededCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$CharacterLimitExceededCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$CharacterLimitExceeded<T>>
    implements _$$CharacterLimitExceededCopyWith<T, $Res> {
  __$$CharacterLimitExceededCopyWithImpl(_$CharacterLimitExceeded<T> _value,
      $Res Function(_$CharacterLimitExceeded<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$CharacterLimitExceeded<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$CharacterLimitExceeded<T>
    with DiagnosticableTreeMixin
    implements CharacterLimitExceeded<T> {
  const _$CharacterLimitExceeded({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ValueFailure<$T>.characterLimitExceeded(failedValue: $failedValue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'ValueFailure<$T>.characterLimitExceeded'))
      ..add(DiagnosticsProperty('failedValue', failedValue));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterLimitExceeded<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterLimitExceededCopyWith<T, _$CharacterLimitExceeded<T>>
      get copyWith => __$$CharacterLimitExceededCopyWithImpl<T,
          _$CharacterLimitExceeded<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) characterLimitExceeded,
    required TResult Function(T failedValue) shortOrNullCharacters,
    required TResult Function(T failedValue) invalidFormat,
  }) {
    return characterLimitExceeded(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? characterLimitExceeded,
    TResult? Function(T failedValue)? shortOrNullCharacters,
    TResult? Function(T failedValue)? invalidFormat,
  }) {
    return characterLimitExceeded?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? characterLimitExceeded,
    TResult Function(T failedValue)? shortOrNullCharacters,
    TResult Function(T failedValue)? invalidFormat,
    required TResult orElse(),
  }) {
    if (characterLimitExceeded != null) {
      return characterLimitExceeded(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterLimitExceeded<T> value)
        characterLimitExceeded,
    required TResult Function(ShortOrNullCharacters<T> value)
        shortOrNullCharacters,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
  }) {
    return characterLimitExceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult? Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
  }) {
    return characterLimitExceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    required TResult orElse(),
  }) {
    if (characterLimitExceeded != null) {
      return characterLimitExceeded(this);
    }
    return orElse();
  }
}

abstract class CharacterLimitExceeded<T> implements ValueFailure<T> {
  const factory CharacterLimitExceeded({required final T failedValue}) =
      _$CharacterLimitExceeded<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$CharacterLimitExceededCopyWith<T, _$CharacterLimitExceeded<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShortOrNullCharactersCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$ShortOrNullCharactersCopyWith(_$ShortOrNullCharacters<T> value,
          $Res Function(_$ShortOrNullCharacters<T>) then) =
      __$$ShortOrNullCharactersCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$ShortOrNullCharactersCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$ShortOrNullCharacters<T>>
    implements _$$ShortOrNullCharactersCopyWith<T, $Res> {
  __$$ShortOrNullCharactersCopyWithImpl(_$ShortOrNullCharacters<T> _value,
      $Res Function(_$ShortOrNullCharacters<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$ShortOrNullCharacters<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ShortOrNullCharacters<T>
    with DiagnosticableTreeMixin
    implements ShortOrNullCharacters<T> {
  const _$ShortOrNullCharacters({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ValueFailure<$T>.shortOrNullCharacters(failedValue: $failedValue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty('type', 'ValueFailure<$T>.shortOrNullCharacters'))
      ..add(DiagnosticsProperty('failedValue', failedValue));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortOrNullCharacters<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortOrNullCharactersCopyWith<T, _$ShortOrNullCharacters<T>>
      get copyWith =>
          __$$ShortOrNullCharactersCopyWithImpl<T, _$ShortOrNullCharacters<T>>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) characterLimitExceeded,
    required TResult Function(T failedValue) shortOrNullCharacters,
    required TResult Function(T failedValue) invalidFormat,
  }) {
    return shortOrNullCharacters(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? characterLimitExceeded,
    TResult? Function(T failedValue)? shortOrNullCharacters,
    TResult? Function(T failedValue)? invalidFormat,
  }) {
    return shortOrNullCharacters?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? characterLimitExceeded,
    TResult Function(T failedValue)? shortOrNullCharacters,
    TResult Function(T failedValue)? invalidFormat,
    required TResult orElse(),
  }) {
    if (shortOrNullCharacters != null) {
      return shortOrNullCharacters(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterLimitExceeded<T> value)
        characterLimitExceeded,
    required TResult Function(ShortOrNullCharacters<T> value)
        shortOrNullCharacters,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
  }) {
    return shortOrNullCharacters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult? Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
  }) {
    return shortOrNullCharacters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    required TResult orElse(),
  }) {
    if (shortOrNullCharacters != null) {
      return shortOrNullCharacters(this);
    }
    return orElse();
  }
}

abstract class ShortOrNullCharacters<T> implements ValueFailure<T> {
  const factory ShortOrNullCharacters({required final T failedValue}) =
      _$ShortOrNullCharacters<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$ShortOrNullCharactersCopyWith<T, _$ShortOrNullCharacters<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidFormatCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidFormatCopyWith(
          _$InvalidFormat<T> value, $Res Function(_$InvalidFormat<T>) then) =
      __$$InvalidFormatCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$InvalidFormatCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidFormat<T>>
    implements _$$InvalidFormatCopyWith<T, $Res> {
  __$$InvalidFormatCopyWithImpl(
      _$InvalidFormat<T> _value, $Res Function(_$InvalidFormat<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$InvalidFormat<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$InvalidFormat<T>
    with DiagnosticableTreeMixin
    implements InvalidFormat<T> {
  const _$InvalidFormat({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ValueFailure<$T>.invalidFormat(failedValue: $failedValue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ValueFailure<$T>.invalidFormat'))
      ..add(DiagnosticsProperty('failedValue', failedValue));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidFormat<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidFormatCopyWith<T, _$InvalidFormat<T>> get copyWith =>
      __$$InvalidFormatCopyWithImpl<T, _$InvalidFormat<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) characterLimitExceeded,
    required TResult Function(T failedValue) shortOrNullCharacters,
    required TResult Function(T failedValue) invalidFormat,
  }) {
    return invalidFormat(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? characterLimitExceeded,
    TResult? Function(T failedValue)? shortOrNullCharacters,
    TResult? Function(T failedValue)? invalidFormat,
  }) {
    return invalidFormat?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? characterLimitExceeded,
    TResult Function(T failedValue)? shortOrNullCharacters,
    TResult Function(T failedValue)? invalidFormat,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CharacterLimitExceeded<T> value)
        characterLimitExceeded,
    required TResult Function(ShortOrNullCharacters<T> value)
        shortOrNullCharacters,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
  }) {
    return invalidFormat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult? Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
  }) {
    return invalidFormat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CharacterLimitExceeded<T> value)? characterLimitExceeded,
    TResult Function(ShortOrNullCharacters<T> value)? shortOrNullCharacters,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(this);
    }
    return orElse();
  }
}

abstract class InvalidFormat<T> implements ValueFailure<T> {
  const factory InvalidFormat({required final T failedValue}) =
      _$InvalidFormat<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$InvalidFormatCopyWith<T, _$InvalidFormat<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GlobalFailure<F> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(F failure) serverError,
    required TResult Function() notConnection,
    required TResult Function() timeOutExceeded,
    required TResult Function(dynamic err, StackTrace? st) internalError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(F failure)? serverError,
    TResult? Function()? notConnection,
    TResult? Function()? timeOutExceeded,
    TResult? Function(dynamic err, StackTrace? st)? internalError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(F failure)? serverError,
    TResult Function()? notConnection,
    TResult Function()? timeOutExceeded,
    TResult Function(dynamic err, StackTrace? st)? internalError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerError<F> value) serverError,
    required TResult Function(NotConnection<F> value) notConnection,
    required TResult Function(TimeOutExceeded<F> value) timeOutExceeded,
    required TResult Function(LocalError<F> value) internalError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerError<F> value)? serverError,
    TResult? Function(NotConnection<F> value)? notConnection,
    TResult? Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult? Function(LocalError<F> value)? internalError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerError<F> value)? serverError,
    TResult Function(NotConnection<F> value)? notConnection,
    TResult Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult Function(LocalError<F> value)? internalError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalFailureCopyWith<F, $Res> {
  factory $GlobalFailureCopyWith(
          GlobalFailure<F> value, $Res Function(GlobalFailure<F>) then) =
      _$GlobalFailureCopyWithImpl<F, $Res, GlobalFailure<F>>;
}

/// @nodoc
class _$GlobalFailureCopyWithImpl<F, $Res, $Val extends GlobalFailure<F>>
    implements $GlobalFailureCopyWith<F, $Res> {
  _$GlobalFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ServerErrorCopyWith<F, $Res> {
  factory _$$ServerErrorCopyWith(
          _$ServerError<F> value, $Res Function(_$ServerError<F>) then) =
      __$$ServerErrorCopyWithImpl<F, $Res>;
  @useResult
  $Res call({F failure});
}

/// @nodoc
class __$$ServerErrorCopyWithImpl<F, $Res>
    extends _$GlobalFailureCopyWithImpl<F, $Res, _$ServerError<F>>
    implements _$$ServerErrorCopyWith<F, $Res> {
  __$$ServerErrorCopyWithImpl(
      _$ServerError<F> _value, $Res Function(_$ServerError<F>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(_$ServerError<F>(
      freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as F,
    ));
  }
}

/// @nodoc

class _$ServerError<F> with DiagnosticableTreeMixin implements ServerError<F> {
  const _$ServerError(this.failure);

  @override
  final F failure;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GlobalFailure<$F>.serverError(failure: $failure)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.serverError'))
      ..add(DiagnosticsProperty('failure', failure));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerError<F> &&
            const DeepCollectionEquality().equals(other.failure, failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(failure));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerErrorCopyWith<F, _$ServerError<F>> get copyWith =>
      __$$ServerErrorCopyWithImpl<F, _$ServerError<F>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(F failure) serverError,
    required TResult Function() notConnection,
    required TResult Function() timeOutExceeded,
    required TResult Function(dynamic err, StackTrace? st) internalError,
  }) {
    return serverError(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(F failure)? serverError,
    TResult? Function()? notConnection,
    TResult? Function()? timeOutExceeded,
    TResult? Function(dynamic err, StackTrace? st)? internalError,
  }) {
    return serverError?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(F failure)? serverError,
    TResult Function()? notConnection,
    TResult Function()? timeOutExceeded,
    TResult Function(dynamic err, StackTrace? st)? internalError,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerError<F> value) serverError,
    required TResult Function(NotConnection<F> value) notConnection,
    required TResult Function(TimeOutExceeded<F> value) timeOutExceeded,
    required TResult Function(LocalError<F> value) internalError,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerError<F> value)? serverError,
    TResult? Function(NotConnection<F> value)? notConnection,
    TResult? Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult? Function(LocalError<F> value)? internalError,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerError<F> value)? serverError,
    TResult Function(NotConnection<F> value)? notConnection,
    TResult Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult Function(LocalError<F> value)? internalError,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerError<F> implements GlobalFailure<F> {
  const factory ServerError(final F failure) = _$ServerError<F>;

  F get failure;
  @JsonKey(ignore: true)
  _$$ServerErrorCopyWith<F, _$ServerError<F>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotConnectionCopyWith<F, $Res> {
  factory _$$NotConnectionCopyWith(
          _$NotConnection<F> value, $Res Function(_$NotConnection<F>) then) =
      __$$NotConnectionCopyWithImpl<F, $Res>;
}

/// @nodoc
class __$$NotConnectionCopyWithImpl<F, $Res>
    extends _$GlobalFailureCopyWithImpl<F, $Res, _$NotConnection<F>>
    implements _$$NotConnectionCopyWith<F, $Res> {
  __$$NotConnectionCopyWithImpl(
      _$NotConnection<F> _value, $Res Function(_$NotConnection<F>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NotConnection<F>
    with DiagnosticableTreeMixin
    implements NotConnection<F> {
  const _$NotConnection();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GlobalFailure<$F>.notConnection()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'GlobalFailure<$F>.notConnection'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotConnection<F>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(F failure) serverError,
    required TResult Function() notConnection,
    required TResult Function() timeOutExceeded,
    required TResult Function(dynamic err, StackTrace? st) internalError,
  }) {
    return notConnection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(F failure)? serverError,
    TResult? Function()? notConnection,
    TResult? Function()? timeOutExceeded,
    TResult? Function(dynamic err, StackTrace? st)? internalError,
  }) {
    return notConnection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(F failure)? serverError,
    TResult Function()? notConnection,
    TResult Function()? timeOutExceeded,
    TResult Function(dynamic err, StackTrace? st)? internalError,
    required TResult orElse(),
  }) {
    if (notConnection != null) {
      return notConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerError<F> value) serverError,
    required TResult Function(NotConnection<F> value) notConnection,
    required TResult Function(TimeOutExceeded<F> value) timeOutExceeded,
    required TResult Function(LocalError<F> value) internalError,
  }) {
    return notConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerError<F> value)? serverError,
    TResult? Function(NotConnection<F> value)? notConnection,
    TResult? Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult? Function(LocalError<F> value)? internalError,
  }) {
    return notConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerError<F> value)? serverError,
    TResult Function(NotConnection<F> value)? notConnection,
    TResult Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult Function(LocalError<F> value)? internalError,
    required TResult orElse(),
  }) {
    if (notConnection != null) {
      return notConnection(this);
    }
    return orElse();
  }
}

abstract class NotConnection<F> implements GlobalFailure<F> {
  const factory NotConnection() = _$NotConnection<F>;
}

/// @nodoc
abstract class _$$TimeOutExceededCopyWith<F, $Res> {
  factory _$$TimeOutExceededCopyWith(_$TimeOutExceeded<F> value,
          $Res Function(_$TimeOutExceeded<F>) then) =
      __$$TimeOutExceededCopyWithImpl<F, $Res>;
}

/// @nodoc
class __$$TimeOutExceededCopyWithImpl<F, $Res>
    extends _$GlobalFailureCopyWithImpl<F, $Res, _$TimeOutExceeded<F>>
    implements _$$TimeOutExceededCopyWith<F, $Res> {
  __$$TimeOutExceededCopyWithImpl(
      _$TimeOutExceeded<F> _value, $Res Function(_$TimeOutExceeded<F>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TimeOutExceeded<F>
    with DiagnosticableTreeMixin
    implements TimeOutExceeded<F> {
  const _$TimeOutExceeded();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GlobalFailure<$F>.timeOutExceeded()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'GlobalFailure<$F>.timeOutExceeded'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimeOutExceeded<F>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(F failure) serverError,
    required TResult Function() notConnection,
    required TResult Function() timeOutExceeded,
    required TResult Function(dynamic err, StackTrace? st) internalError,
  }) {
    return timeOutExceeded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(F failure)? serverError,
    TResult? Function()? notConnection,
    TResult? Function()? timeOutExceeded,
    TResult? Function(dynamic err, StackTrace? st)? internalError,
  }) {
    return timeOutExceeded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(F failure)? serverError,
    TResult Function()? notConnection,
    TResult Function()? timeOutExceeded,
    TResult Function(dynamic err, StackTrace? st)? internalError,
    required TResult orElse(),
  }) {
    if (timeOutExceeded != null) {
      return timeOutExceeded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerError<F> value) serverError,
    required TResult Function(NotConnection<F> value) notConnection,
    required TResult Function(TimeOutExceeded<F> value) timeOutExceeded,
    required TResult Function(LocalError<F> value) internalError,
  }) {
    return timeOutExceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerError<F> value)? serverError,
    TResult? Function(NotConnection<F> value)? notConnection,
    TResult? Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult? Function(LocalError<F> value)? internalError,
  }) {
    return timeOutExceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerError<F> value)? serverError,
    TResult Function(NotConnection<F> value)? notConnection,
    TResult Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult Function(LocalError<F> value)? internalError,
    required TResult orElse(),
  }) {
    if (timeOutExceeded != null) {
      return timeOutExceeded(this);
    }
    return orElse();
  }
}

abstract class TimeOutExceeded<F> implements GlobalFailure<F> {
  const factory TimeOutExceeded() = _$TimeOutExceeded<F>;
}

/// @nodoc
abstract class _$$LocalErrorCopyWith<F, $Res> {
  factory _$$LocalErrorCopyWith(
          _$LocalError<F> value, $Res Function(_$LocalError<F>) then) =
      __$$LocalErrorCopyWithImpl<F, $Res>;
  @useResult
  $Res call({dynamic err, StackTrace? st});
}

/// @nodoc
class __$$LocalErrorCopyWithImpl<F, $Res>
    extends _$GlobalFailureCopyWithImpl<F, $Res, _$LocalError<F>>
    implements _$$LocalErrorCopyWith<F, $Res> {
  __$$LocalErrorCopyWithImpl(
      _$LocalError<F> _value, $Res Function(_$LocalError<F>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? err = freezed,
    Object? st = freezed,
  }) {
    return _then(_$LocalError<F>(
      freezed == err
          ? _value.err
          : err // ignore: cast_nullable_to_non_nullable
              as dynamic,
      freezed == st
          ? _value.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$LocalError<F> with DiagnosticableTreeMixin implements LocalError<F> {
  const _$LocalError(this.err, [this.st]);

  @override
  final dynamic err;
  @override
  final StackTrace? st;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GlobalFailure<$F>.internalError(err: $err, st: $st)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GlobalFailure<$F>.internalError'))
      ..add(DiagnosticsProperty('err', err))
      ..add(DiagnosticsProperty('st', st));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalError<F> &&
            const DeepCollectionEquality().equals(other.err, err) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(err), st);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalErrorCopyWith<F, _$LocalError<F>> get copyWith =>
      __$$LocalErrorCopyWithImpl<F, _$LocalError<F>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(F failure) serverError,
    required TResult Function() notConnection,
    required TResult Function() timeOutExceeded,
    required TResult Function(dynamic err, StackTrace? st) internalError,
  }) {
    return internalError(err, st);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(F failure)? serverError,
    TResult? Function()? notConnection,
    TResult? Function()? timeOutExceeded,
    TResult? Function(dynamic err, StackTrace? st)? internalError,
  }) {
    return internalError?.call(err, st);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(F failure)? serverError,
    TResult Function()? notConnection,
    TResult Function()? timeOutExceeded,
    TResult Function(dynamic err, StackTrace? st)? internalError,
    required TResult orElse(),
  }) {
    if (internalError != null) {
      return internalError(err, st);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerError<F> value) serverError,
    required TResult Function(NotConnection<F> value) notConnection,
    required TResult Function(TimeOutExceeded<F> value) timeOutExceeded,
    required TResult Function(LocalError<F> value) internalError,
  }) {
    return internalError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerError<F> value)? serverError,
    TResult? Function(NotConnection<F> value)? notConnection,
    TResult? Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult? Function(LocalError<F> value)? internalError,
  }) {
    return internalError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerError<F> value)? serverError,
    TResult Function(NotConnection<F> value)? notConnection,
    TResult Function(TimeOutExceeded<F> value)? timeOutExceeded,
    TResult Function(LocalError<F> value)? internalError,
    required TResult orElse(),
  }) {
    if (internalError != null) {
      return internalError(this);
    }
    return orElse();
  }
}

abstract class LocalError<F> implements GlobalFailure<F> {
  const factory LocalError(final dynamic err, [final StackTrace? st]) =
      _$LocalError<F>;

  dynamic get err;
  StackTrace? get st;
  @JsonKey(ignore: true)
  _$$LocalErrorCopyWith<F, _$LocalError<F>> get copyWith =>
      throw _privateConstructorUsedError;
}
