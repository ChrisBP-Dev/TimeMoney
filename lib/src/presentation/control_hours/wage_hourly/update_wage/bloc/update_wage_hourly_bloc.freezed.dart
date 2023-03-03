// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_wage_hourly_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UpdateWageHourlyEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHourly,
    required TResult Function() update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHourly,
    TResult? Function()? update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHourly,
    TResult Function()? update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHourly value) changeHourly,
    required TResult Function(_Update value) update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHourly value)? changeHourly,
    TResult? Function(_Update value)? update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHourly value)? changeHourly,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateWageHourlyEventCopyWith<$Res> {
  factory $UpdateWageHourlyEventCopyWith(UpdateWageHourlyEvent value,
          $Res Function(UpdateWageHourlyEvent) then) =
      _$UpdateWageHourlyEventCopyWithImpl<$Res, UpdateWageHourlyEvent>;
}

/// @nodoc
class _$UpdateWageHourlyEventCopyWithImpl<$Res,
        $Val extends UpdateWageHourlyEvent>
    implements $UpdateWageHourlyEventCopyWith<$Res> {
  _$UpdateWageHourlyEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ChangeHourlyCopyWith<$Res> {
  factory _$$_ChangeHourlyCopyWith(
          _$_ChangeHourly value, $Res Function(_$_ChangeHourly) then) =
      __$$_ChangeHourlyCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$_ChangeHourlyCopyWithImpl<$Res>
    extends _$UpdateWageHourlyEventCopyWithImpl<$Res, _$_ChangeHourly>
    implements _$$_ChangeHourlyCopyWith<$Res> {
  __$$_ChangeHourlyCopyWithImpl(
      _$_ChangeHourly _value, $Res Function(_$_ChangeHourly) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_ChangeHourly(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ChangeHourly implements _ChangeHourly {
  const _$_ChangeHourly({required this.value});

  @override
  final String value;

  @override
  String toString() {
    return 'UpdateWageHourlyEvent.changeHourly(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangeHourly &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangeHourlyCopyWith<_$_ChangeHourly> get copyWith =>
      __$$_ChangeHourlyCopyWithImpl<_$_ChangeHourly>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) changeHourly,
    required TResult Function() update,
  }) {
    return changeHourly(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHourly,
    TResult? Function()? update,
  }) {
    return changeHourly?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHourly,
    TResult Function()? update,
    required TResult orElse(),
  }) {
    if (changeHourly != null) {
      return changeHourly(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeHourly value) changeHourly,
    required TResult Function(_Update value) update,
  }) {
    return changeHourly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHourly value)? changeHourly,
    TResult? Function(_Update value)? update,
  }) {
    return changeHourly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHourly value)? changeHourly,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (changeHourly != null) {
      return changeHourly(this);
    }
    return orElse();
  }
}

abstract class _ChangeHourly implements UpdateWageHourlyEvent {
  const factory _ChangeHourly({required final String value}) = _$_ChangeHourly;

  String get value;
  @JsonKey(ignore: true)
  _$$_ChangeHourlyCopyWith<_$_ChangeHourly> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_UpdateCopyWith<$Res> {
  factory _$$_UpdateCopyWith(_$_Update value, $Res Function(_$_Update) then) =
      __$$_UpdateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UpdateCopyWithImpl<$Res>
    extends _$UpdateWageHourlyEventCopyWithImpl<$Res, _$_Update>
    implements _$$_UpdateCopyWith<$Res> {
  __$$_UpdateCopyWithImpl(_$_Update _value, $Res Function(_$_Update) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Update implements _Update {
  const _$_Update();

  @override
  String toString() {
    return 'UpdateWageHourlyEvent.update()';
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
    required TResult Function(String value) changeHourly,
    required TResult Function() update,
  }) {
    return update();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? changeHourly,
    TResult? Function()? update,
  }) {
    return update?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? changeHourly,
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
    required TResult Function(_ChangeHourly value) changeHourly,
    required TResult Function(_Update value) update,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeHourly value)? changeHourly,
    TResult? Function(_Update value)? update,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeHourly value)? changeHourly,
    TResult Function(_Update value)? update,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _Update implements UpdateWageHourlyEvent {
  const factory _Update() = _$_Update;
}

/// @nodoc
mixin _$UpdateWageHourlyState {
  WageHourly get wageHourly => throw _privateConstructorUsedError;
  ActionState<WageHourly> get currentState =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateWageHourlyStateCopyWith<UpdateWageHourlyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateWageHourlyStateCopyWith<$Res> {
  factory $UpdateWageHourlyStateCopyWith(UpdateWageHourlyState value,
          $Res Function(UpdateWageHourlyState) then) =
      _$UpdateWageHourlyStateCopyWithImpl<$Res, UpdateWageHourlyState>;
  @useResult
  $Res call({WageHourly wageHourly, ActionState<WageHourly> currentState});

  $WageHourlyCopyWith<$Res> get wageHourly;
  $ActionStateCopyWith<WageHourly, $Res> get currentState;
}

/// @nodoc
class _$UpdateWageHourlyStateCopyWithImpl<$Res,
        $Val extends UpdateWageHourlyState>
    implements $UpdateWageHourlyStateCopyWith<$Res> {
  _$UpdateWageHourlyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wageHourly = null,
    Object? currentState = null,
  }) {
    return _then(_value.copyWith(
      wageHourly: null == wageHourly
          ? _value.wageHourly
          : wageHourly // ignore: cast_nullable_to_non_nullable
              as WageHourly,
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<WageHourly>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WageHourlyCopyWith<$Res> get wageHourly {
    return $WageHourlyCopyWith<$Res>(_value.wageHourly, (value) {
      return _then(_value.copyWith(wageHourly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ActionStateCopyWith<WageHourly, $Res> get currentState {
    return $ActionStateCopyWith<WageHourly, $Res>(_value.currentState, (value) {
      return _then(_value.copyWith(currentState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UpdateWageHourlyStateCopyWith<$Res>
    implements $UpdateWageHourlyStateCopyWith<$Res> {
  factory _$$_UpdateWageHourlyStateCopyWith(_$_UpdateWageHourlyState value,
          $Res Function(_$_UpdateWageHourlyState) then) =
      __$$_UpdateWageHourlyStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WageHourly wageHourly, ActionState<WageHourly> currentState});

  @override
  $WageHourlyCopyWith<$Res> get wageHourly;
  @override
  $ActionStateCopyWith<WageHourly, $Res> get currentState;
}

/// @nodoc
class __$$_UpdateWageHourlyStateCopyWithImpl<$Res>
    extends _$UpdateWageHourlyStateCopyWithImpl<$Res, _$_UpdateWageHourlyState>
    implements _$$_UpdateWageHourlyStateCopyWith<$Res> {
  __$$_UpdateWageHourlyStateCopyWithImpl(_$_UpdateWageHourlyState _value,
      $Res Function(_$_UpdateWageHourlyState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wageHourly = null,
    Object? currentState = null,
  }) {
    return _then(_$_UpdateWageHourlyState(
      wageHourly: null == wageHourly
          ? _value.wageHourly
          : wageHourly // ignore: cast_nullable_to_non_nullable
              as WageHourly,
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as ActionState<WageHourly>,
    ));
  }
}

/// @nodoc

class _$_UpdateWageHourlyState implements _UpdateWageHourlyState {
  const _$_UpdateWageHourlyState(
      {this.wageHourly = const WageHourly(),
      this.currentState = const ActionState<WageHourly>.initial()});

  @override
  @JsonKey()
  final WageHourly wageHourly;
  @override
  @JsonKey()
  final ActionState<WageHourly> currentState;

  @override
  String toString() {
    return 'UpdateWageHourlyState(wageHourly: $wageHourly, currentState: $currentState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UpdateWageHourlyState &&
            (identical(other.wageHourly, wageHourly) ||
                other.wageHourly == wageHourly) &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, wageHourly, currentState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UpdateWageHourlyStateCopyWith<_$_UpdateWageHourlyState> get copyWith =>
      __$$_UpdateWageHourlyStateCopyWithImpl<_$_UpdateWageHourlyState>(
          this, _$identity);
}

abstract class _UpdateWageHourlyState implements UpdateWageHourlyState {
  const factory _UpdateWageHourlyState(
      {final WageHourly wageHourly,
      final ActionState<WageHourly> currentState}) = _$_UpdateWageHourlyState;

  @override
  WageHourly get wageHourly;
  @override
  ActionState<WageHourly> get currentState;
  @override
  @JsonKey(ignore: true)
  _$$_UpdateWageHourlyStateCopyWith<_$_UpdateWageHourlyState> get copyWith =>
      throw _privateConstructorUsedError;
}
