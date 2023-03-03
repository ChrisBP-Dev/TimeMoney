// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ResultPaymentState {
  List<ModelTime> get times => throw _privateConstructorUsedError;
  double get wageHourly => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResultPaymentStateCopyWith<ResultPaymentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultPaymentStateCopyWith<$Res> {
  factory $ResultPaymentStateCopyWith(
          ResultPaymentState value, $Res Function(ResultPaymentState) then) =
      _$ResultPaymentStateCopyWithImpl<$Res, ResultPaymentState>;
  @useResult
  $Res call({List<ModelTime> times, double wageHourly});
}

/// @nodoc
class _$ResultPaymentStateCopyWithImpl<$Res, $Val extends ResultPaymentState>
    implements $ResultPaymentStateCopyWith<$Res> {
  _$ResultPaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? times = null,
    Object? wageHourly = null,
  }) {
    return _then(_value.copyWith(
      times: null == times
          ? _value.times
          : times // ignore: cast_nullable_to_non_nullable
              as List<ModelTime>,
      wageHourly: null == wageHourly
          ? _value.wageHourly
          : wageHourly // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ResultPaymentStateCopyWith<$Res>
    implements $ResultPaymentStateCopyWith<$Res> {
  factory _$$_ResultPaymentStateCopyWith(_$_ResultPaymentState value,
          $Res Function(_$_ResultPaymentState) then) =
      __$$_ResultPaymentStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ModelTime> times, double wageHourly});
}

/// @nodoc
class __$$_ResultPaymentStateCopyWithImpl<$Res>
    extends _$ResultPaymentStateCopyWithImpl<$Res, _$_ResultPaymentState>
    implements _$$_ResultPaymentStateCopyWith<$Res> {
  __$$_ResultPaymentStateCopyWithImpl(
      _$_ResultPaymentState _value, $Res Function(_$_ResultPaymentState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? times = null,
    Object? wageHourly = null,
  }) {
    return _then(_$_ResultPaymentState(
      times: null == times
          ? _value._times
          : times // ignore: cast_nullable_to_non_nullable
              as List<ModelTime>,
      wageHourly: null == wageHourly
          ? _value.wageHourly
          : wageHourly // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_ResultPaymentState implements _ResultPaymentState {
  const _$_ResultPaymentState(
      {final List<ModelTime> times = const [], this.wageHourly = 0.0})
      : _times = times;

  final List<ModelTime> _times;
  @override
  @JsonKey()
  List<ModelTime> get times {
    if (_times is EqualUnmodifiableListView) return _times;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_times);
  }

  @override
  @JsonKey()
  final double wageHourly;

  @override
  String toString() {
    return 'ResultPaymentState(times: $times, wageHourly: $wageHourly)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ResultPaymentState &&
            const DeepCollectionEquality().equals(other._times, _times) &&
            (identical(other.wageHourly, wageHourly) ||
                other.wageHourly == wageHourly));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_times), wageHourly);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ResultPaymentStateCopyWith<_$_ResultPaymentState> get copyWith =>
      __$$_ResultPaymentStateCopyWithImpl<_$_ResultPaymentState>(
          this, _$identity);
}

abstract class _ResultPaymentState implements ResultPaymentState {
  const factory _ResultPaymentState(
      {final List<ModelTime> times,
      final double wageHourly}) = _$_ResultPaymentState;

  @override
  List<ModelTime> get times;
  @override
  double get wageHourly;
  @override
  @JsonKey(ignore: true)
  _$$_ResultPaymentStateCopyWith<_$_ResultPaymentState> get copyWith =>
      throw _privateConstructorUsedError;
}
