import 'package:freezed_annotation/freezed_annotation.dart';
part 'wage_hourly.freezed.dart';
part 'wage_hourly.g.dart';

/// Domain entity representing the user's hourly wage rate.
///
/// Defaults to an [id] of `0` (new record) and a [value] of `15.0`.
@freezed
abstract class WageHourly with _$WageHourly {
  /// Creates a [WageHourly] with an optional [id] and hourly [value].
  const factory WageHourly({
    /// Unique identifier assigned by the persistence layer.
    @Default(0) int id,

    /// Hourly wage amount in the user's currency.
    @Default(15.0) double value,
  }) = _WageHourly;

  /// Deserializes a [WageHourly] from a JSON map.
  factory WageHourly.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$WageHourlyFromJson(json);
}
