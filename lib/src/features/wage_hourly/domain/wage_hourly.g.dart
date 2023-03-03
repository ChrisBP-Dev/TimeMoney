// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wage_hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WageHourly _$$_WageHourlyFromJson(Map<String, dynamic> json) =>
    _$_WageHourly(
      id: json['id'] as int? ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 15.0,
    );

Map<String, dynamic> _$$_WageHourlyToJson(_$_WageHourly instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };
