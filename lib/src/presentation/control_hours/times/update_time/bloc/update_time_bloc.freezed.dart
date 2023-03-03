// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_time_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UpdateTimeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ModelTime time) init,
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ModelTime time)? init,
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ModelTime time)? init,
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Init value) init,
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Update value) update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Init value)? init,
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Update value)? update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Init value)? init,
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTimeEventCopyWith<$Res> {
  factory $UpdateTimeEventCopyWith(
          UpdateTimeEvent value, $Res Function(UpdateTimeEvent) then) =
      _$UpdateTimeEventCopyWithImpl<$Res, UpdateTimeEvent>;
}

/// @nodoc
class _$UpdateTimeEventCopyWithImpl<$Res, $Val extends UpdateTimeEvent>
    implements $UpdateTimeEventCopyWith<$Res> {
  _$UpdateTimeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_InitCopyWith<$Res> {
  factory _$$_InitCopyWith(_$_Init value, $Res Function(_$_Init) then) =
      __$$_InitCopyWithImpl<$Res>;
  @useResult
  $Res call({ModelTime time});

  $ModelTimeCopyWith<$Res> get time;
}

/// @nodoc
class __$$_InitCopyWithImpl<$Res>
    extends _$UpdateTimeEventCopyWithImpl<$Res, _$_Init>
    implements _$$_InitCopyWith<$Res> {
  __$$_InitCopyWithImpl(_$_Init _value, $Res Function(_$_Init) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
  }) {
    return _then(_$_Init(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ModelTimeCopyWith<$Res> get time {
    return $ModelTimeCopyWith<$Res>(_value.time, (value) {
      return _then(_value.copyWith(time: value));
    });
  }
}

/// @nodoc

class _$_Init implements _Init {
  const _$_Init({required this.time});

  @override
  final ModelTime time;

  @override
  String toString() {
    return 'UpdateTimeEvent.init(time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Init &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitCopyWith<_$_Init> get copyWith =>
      __$$_InitCopyWithImpl<_$_Init>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ModelTime time) init,
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() update,
  }) {
    return init(time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ModelTime time)? init,
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? update,
  }) {
    return init?.call(time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ModelTime time)? init,
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? update,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Init value) init,
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Update value) update,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Init value)? init,
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Update value)? update,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Init value)? init,
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _Init implements UpdateTimeEvent {
  const factory _Init({required final ModelTime time}) = _$_Init;

  ModelTime get time;
  @JsonKey(ignore: true)
  _$$_InitCopyWith<_$_Init> get copyWith => throw _privateConstructorUsedError;
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
    extends _$UpdateTimeEventCopyWithImpl<$Res, _$_ChangeHour>
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
    return 'UpdateTimeEvent.changeHour(value: $value)';
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
    required TResult Function(ModelTime time) init,
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() update,
  }) {
    return changeHour(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ModelTime time)? init,
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? update,
  }) {
    return changeHour?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ModelTime time)? init,
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? update,
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
    required TResult Function(_Init value) init,
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Update value) update,
  }) {
    return changeHour(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Init value)? init,
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Update value)? update,
  }) {
    return changeHour?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Init value)? init,
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (changeHour != null) {
      return changeHour(this);
    }
    return orElse();
  }
}

abstract class _ChangeHour implements UpdateTimeEvent {
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
    extends _$UpdateTimeEventCopyWithImpl<$Res, _$_ChangeMinutes>
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
    return 'UpdateTimeEvent.changeMinutes(value: $value)';
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
    required TResult Function(ModelTime time) init,
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() update,
  }) {
    return changeMinutes(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ModelTime time)? init,
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? update,
  }) {
    return changeMinutes?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ModelTime time)? init,
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? update,
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
    required TResult Function(_Init value) init,
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Update value) update,
  }) {
    return changeMinutes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Init value)? init,
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Update value)? update,
  }) {
    return changeMinutes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Init value)? init,
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (changeMinutes != null) {
      return changeMinutes(this);
    }
    return orElse();
  }
}

abstract class _ChangeMinutes implements UpdateTimeEvent {
  const factory _ChangeMinutes({required final String value}) =
      _$_ChangeMinutes;

  String get value;
  @JsonKey(ignore: true)
  _$$_ChangeMinutesCopyWith<_$_ChangeMinutes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_UpdateCopyWith<$Res> {
  factory _$$_UpdateCopyWith(_$_Update value, $Res Function(_$_Update) then) =
      __$$_UpdateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UpdateCopyWithImpl<$Res>
    extends _$UpdateTimeEventCopyWithImpl<$Res, _$_Update>
    implements _$$_UpdateCopyWith<$Res> {
  __$$_UpdateCopyWithImpl(_$_Update _value, $Res Function(_$_Update) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Update implements _Update {
  const _$_Update();

  @override
  String toString() {
    return 'UpdateTimeEvent.update()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Update);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ModelTime time) init,
    required TResult Function(String value) changeHour,
    required TResult Function(String value) changeMinutes,
    required TResult Function() update,
  }) {
    return update();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ModelTime time)? init,
    TResult? Function(String value)? changeHour,
    TResult? Function(String value)? changeMinutes,
    TResult? Function()? update,
  }) {
    return update?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ModelTime time)? init,
    TResult Function(String value)? changeHour,
    TResult Function(String value)? changeMinutes,
    TResult Function()? update,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Init value) init,
    required TResult Function(_ChangeHour value) changeHour,
    required TResult Function(_ChangeMinutes value) changeMinutes,
    required TResult Function(_Update value) update,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Init value)? init,
    TResult? Function(_ChangeHour value)? changeHour,
    TResult? Function(_ChangeMinutes value)? changeMinutes,
    TResult? Function(_Update value)? update,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Init value)? init,
    TResult Function(_ChangeHour value)? changeHour,
    TResult Function(_ChangeMinutes value)? changeMinutes,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _Update implements UpdateTimeEvent {
  const factory _Update() = _$_Update;
}

/// @nodoc
mixin _$UpdateTimeState {
  ActionState<ModelTime> get currentState => throw _privateConstructorUsedError;
  ModelTime? get time => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateTimeStateCopyWith<UpdateTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTimeStateCopyWith<$Res> {
  factory $UpdateTimeStateCopyWith(
          UpdateTimeState value, $Res Function(UpdateTimeState) then) =
      _$UpdateTimeStateCopyWithImpl<$Res, UpdateTimeState>;
  @useResult
  $Res call({ActionState<ModelTime> currentState, ModelTime? time});

  $ActionStateCopyWith<ModelTime, $Res> get currentState;
  $ModelTimeCopyWith<$Res>? get time;
}

/// @nodoc
class _$UpdateTimeStateCopyWithImpl<$Res, $Val extends UpdateTimeState>
    implements $UpdateTimeStateCopyWith<$Res> {
  _$UpdateTimeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<ModelTime>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActionStateCopyWith<ModelTime, $Res> get currentState {
    return $ActionStateCopyWith<ModelTime, $Res>(_value.currentState, (value) {
      return _then(_value.copyWith(currentState: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ModelTimeCopyWith<$Res>? get time {
    if (_value.time == null) {
      return null;
    }

    return $ModelTimeCopyWith<$Res>(_value.time!, (value) {
      return _then(_value.copyWith(time: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UpdateTimeStateCopyWith<$Res>
    implements $UpdateTimeStateCopyWith<$Res> {
  factory _$$_UpdateTimeStateCopyWith(
          _$_UpdateTimeState value, $Res Function(_$_UpdateTimeState) then) =
      __$$_UpdateTimeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ActionState<ModelTime> currentState, ModelTime? time});

  @override
  $ActionStateCopyWith<ModelTime, $Res> get currentState;
  @override
  $ModelTimeCopyWith<$Res>? get time;
}

/// @nodoc
class __$$_UpdateTimeStateCopyWithImpl<$Res>
    extends _$UpdateTimeStateCopyWithImpl<$Res, _$_UpdateTimeState>
    implements _$$_UpdateTimeStateCopyWith<$Res> {
  __$$_UpdateTimeStateCopyWithImpl(
      _$_UpdateTimeState _value, $Res Function(_$_UpdateTimeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? time = freezed,
  }) {
    return _then(_$_UpdateTimeState(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<ModelTime>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime?,
    ));
  }
}

/// @nodoc

class _$_UpdateTimeState implements _UpdateTimeState {
  const _$_UpdateTimeState(
      {this.currentState = const ActionState<ModelTime>.initial(),
      this.time = null});

  @override
  @JsonKey()
  final ActionState<ModelTime> currentState;
  @override
  @JsonKey()
  final ModelTime? time;

  @override
  String toString() {
    return 'UpdateTimeState(currentState: $currentState, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UpdateTimeState &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentState, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UpdateTimeStateCopyWith<_$_UpdateTimeState> get copyWith =>
      __$$_UpdateTimeStateCopyWithImpl<_$_UpdateTimeState>(this, _$identity);
}

abstract class _UpdateTimeState implements UpdateTimeState {
  const factory _UpdateTimeState(
      {final ActionState<ModelTime> currentState,
      final ModelTime? time}) = _$_UpdateTimeState;

  @override
  ActionState<ModelTime> get currentState;
  @override
  ModelTime? get time;
  @override
  @JsonKey(ignore: true)
  _$$_UpdateTimeStateCopyWith<_$_UpdateTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}
