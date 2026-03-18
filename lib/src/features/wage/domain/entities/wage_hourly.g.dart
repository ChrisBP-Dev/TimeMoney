// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wage_hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WageHourly _$WageHourlyFromJson(Map<String, dynamic> json) => _WageHourly(
  id: (json['id'] as num?)?.toInt() ?? 0,
  value: (json['value'] as num?)?.toDouble() ?? 15.0,
);

Map<String, dynamic> _$WageHourlyToJson(_WageHourly instance) =>
    <String, dynamic>{'id': instance.id, 'value': instance.value};
