// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_time_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateTimeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() create,
    required TResult Function() reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? create,
    TResult? Function()? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? create,
    TResult Function()? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Create value) create,
    required TResult Function(_Reset value) reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Create value)? create,
    TResult? Function(_Reset value)? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Create value)? create,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTimeEventCopyWith<$Res> {
  factory $CreateTimeEventCopyWith(
          CreateTimeEvent value, $Res Function(CreateTimeEvent) then) =
      _$CreateTimeEventCopyWithImpl<$Res, CreateTimeEvent>;
}

/// @nodoc
class _$CreateTimeEventCopyWithImpl<$Res, $Val extends CreateTimeEvent>
    implements $CreateTimeEventCopyWith<$Res> {
  _$CreateTimeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ChangeHourCopyWith<$Res> {
  factory _$$_ChangeHourCopyWith(
          _$_ChangeHour value, $Res Function(_$_ChangeHour) then) =
      __$$_ChangeHourCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_ChangeHourCopyWithImpl<$Res>
    extends _$CreateTimeEventCopyWithImpl<$Res, _$_ChangeHour>
    implements _$$_ChangeHourCopyWith<$Res> {
  __$$_ChangeHourCopyWithImpl(
      _$_ChangeHour _value, $Res Function(_$_ChangeHour) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_ChangeHour(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ChangeHour implements _ChangeHour {
  const _$_ChangeHour({required this.value});

  @override
  final String value;

  @override
  String toString() {
    return 'CreateTimeEvent.changeHour(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangeHour &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangeHourCopyWith<_$_ChangeHour> get copyWith =>
      __$$_ChangeHourCopyWithImpl<_$_ChangeHour>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() create,
    required TResult Function() reset,
  }) {
    return changeHour(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? create,
    TResult? Function()? reset,
  }) {
    return changeHour?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? create,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (changeHour != null) {
      return changeHour(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Create value) create,
    required TResult Function(_Reset value) reset,
  }) {
    return changeHour(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Create value)? create,
    TResult? Function(_Reset value)? reset,
  }) {
    return changeHour?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Create value)? create,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (changeHour != null) {
      return changeHour(this);
    }
    return orElse();
  }
}

abstract class _ChangeHour implements CreateTimeEvent {
  const factory _ChangeHour({required final String value}) = _$_ChangeHour;

  String get value;
  @JsonKey(ignore: true)
  _$$_ChangeHourCopyWith<_$_ChangeHour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ChangeMinutesCopyWith<$Res> {
  factory _$$_ChangeMinutesCopyWith(
          _$_ChangeMinutes value, $Res Function(_$_ChangeMinutes) then) =
      __$$_ChangeMinutesCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_ChangeMinutesCopyWithImpl<$Res>
    extends _$CreateTimeEventCopyWithImpl<$Res, _$_ChangeMinutes>
    implements _$$_ChangeMinutesCopyWith<$Res> {
  __$$_ChangeMinutesCopyWithImpl(
      _$_ChangeMinutes _value, $Res Function(_$_ChangeMinutes) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_ChangeMinutes(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ChangeMinutes implements _ChangeMinutes {
  const _$_ChangeMinutes({required this.value});

  @override
  final String value;

  @override
  String toString() {
    return 'CreateTimeEvent.changeMinutes(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangeMinutes &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangeMinutesCopyWith<_$_ChangeMinutes> get copyWith =>
      __$$_ChangeMinutesCopyWithImpl<_$_ChangeMinutes>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() create,
    required TResult Function() reset,
  }) {
    return changeMinutes(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? create,
    TResult? Function()? reset,
  }) {
    return changeMinutes?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? create,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (changeMinutes != null) {
      return changeMinutes(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Create value) create,
    required TResult Function(_Reset value) reset,
  }) {
    return changeMinutes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Create value)? create,
    TResult? Function(_Reset value)? reset,
  }) {
    return changeMinutes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Create value)? create,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (changeMinutes != null) {
      return changeMinutes(this);
    }
    return orElse();
  }
}

abstract class _ChangeMinutes implements CreateTimeEvent {
  const factory _ChangeMinutes({required final String value}) =
      _$_ChangeMinutes;

  String get value;
  @JsonKey(ignore: true)
  _$$_ChangeMinutesCopyWith<_$_ChangeMinutes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_CreateCopyWith<$Res> {
  factory _$$_CreateCopyWith(_$_Create value, $Res Function(_$_Create) then) =
      __$$_CreateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_CreateCopyWithImpl<$Res>
    extends _$CreateTimeEventCopyWithImpl<$Res, _$_Create>
    implements _$$_CreateCopyWith<$Res> {
  __$$_CreateCopyWithImpl(_$_Create _value, $Res Function(_$_Create) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Create implements _Create {
  const _$_Create();

  @override
  String toString() {
    return 'CreateTimeEvent.create()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Create);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() create,
    required TResult Function() reset,
  }) {
    return create();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? create,
    TResult? Function()? reset,
  }) {
    return create?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? create,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Create value) create,
    required TResult Function(_Reset value) reset,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Create value)? create,
    TResult? Function(_Reset value)? reset,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Create value)? create,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class _Create implements CreateTimeEvent {
  const factory _Create() = _$_Create;
}

/// @nodoc
abstract class _$$_ResetCopyWith<$Res> {
  factory _$$_ResetCopyWith(_$_Reset value, $Res Function(_$_Reset) then) =
      __$$_ResetCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ResetCopyWithImpl<$Res>
    extends _$CreateTimeEventCopyWithImpl<$Res, _$_Reset>
    implements _$$_ResetCopyWith<$Res> {
  __$$_ResetCopyWithImpl(_$_Reset _value, $Res Function(_$_Reset) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Reset implements _Reset {
  const _$_Reset();

  @override
  String toString() {
    return 'CreateTimeEvent.reset()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Reset);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() create,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? create,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? create,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Create value) create,
    required TResult Function(_Reset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Create value)? create,
    TResult? Function(_Reset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Create value)? create,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _Reset implements CreateTimeEvent {
  const factory _Reset() = _$_Reset;
}

/// @nodoc
mixin _$CreateTimeState {
  ActionState<ModelTime> get currentState => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minutes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateTimeStateCopyWith<CreateTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTimeStateCopyWith<$Res> {
  factory $CreateTimeStateCopyWith(
          CreateTimeState value, $Res Function(CreateTimeState) then) =
      _$CreateTimeStateCopyWithImpl<$Res, CreateTimeState>;
  @useResult
  $Res call({ActionState<ModelTime> currentState, int hour, int minutes});

  $ActionStateCopyWith<ModelTime, $Res> get currentState;
}

/// @nodoc
class _$CreateTimeStateCopyWithImpl<$Res, $Val extends CreateTimeState>
    implements $CreateTimeStateCopyWith<$Res> {
  _$CreateTimeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? hour = null,
    Object? minutes = null,
  }) {
    return _then(_value.copyWith(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<ModelTime>,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActionStateCopyWith<ModelTime, $Res> get currentState {
    return $ActionStateCopyWith<ModelTime, $Res>(_value.currentState, (value) {
      return _then(_value.copyWith(currentState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CreateTimeStateCopyWith<$Res>
    implements $CreateTimeStateCopyWith<$Res> {
  factory _$$_CreateTimeStateCopyWith(
          _$_CreateTimeState value, $Res Function(_$_CreateTimeState) then) =
      __$$_CreateTimeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ActionState<ModelTime> currentState, int hour, int minutes});

  @override
  $ActionStateCopyWith<ModelTime, $Res> get currentState;
}

/// @nodoc
class __$$_CreateTimeStateCopyWithImpl<$Res>
    extends _$CreateTimeStateCopyWithImpl<$Res, _$_CreateTimeState>
    implements _$$_CreateTimeStateCopyWith<$Res> {
  __$$_CreateTimeStateCopyWithImpl(
      _$_CreateTimeState _value, $Res Function(_$_CreateTimeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? hour = null,
    Object? minutes = null,
  }) {
    return _then(_$_CreateTimeState(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<ModelTime>,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_CreateTimeState implements _CreateTimeState {
  const _$_CreateTimeState(
      {required this.currentState, this.hour = 0, this.minutes = 0});

  @override
  final ActionState<ModelTime> currentState;
  @override
  @JsonKey()
  final int hour;
  @override
  @JsonKey()
  final int minutes;

  @override
  String toString() {
    return 'CreateTimeState(currentState: $currentState, hour: $hour, minutes: $minutes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateTimeState &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minutes, minutes) || other.minutes == minutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentState, hour, minutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreateTimeStateCopyWith<_$_CreateTimeState> get copyWith =>
      __$$_CreateTimeStateCopyWithImpl<_$_CreateTimeState>(this, _$identity);
}

abstract class _CreateTimeState implements CreateTimeState {
  const factory _CreateTimeState(
      {required final ActionState<ModelTime> currentState,
      final int hour,
      final int minutes}) = _$_CreateTimeState;

  @override
  ActionState<ModelTime> get currentState;
  @override
  int get hour;
  @override
  int get minutes;
  @override
  @JsonKey(ignore: true)
  _$$_CreateTimeStateCopyWith<_$_CreateTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}
