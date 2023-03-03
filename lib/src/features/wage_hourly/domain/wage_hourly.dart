import 'package:freezed_annotation/freezed_annotation.dart';
part 'wage_hourly.freezed.dart';
part 'wage_hourly.g.dart';

@freezed
class WageHourly with _$WageHourly {
  const factory WageHourly({
    @Default(0) int id,
    @Default(15.0) double value,
  }) = _WageHourly;

  factory WageHourly.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$WageHourlyFromJson(json);
}
