// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModelTime _$ModelTimeFromJson(Map<String, dynamic> json) => _ModelTime(
  hour: (json['hour'] as num).toInt(),
  minutes: (json['minutes'] as num).toInt(),
  id: (json['id'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ModelTimeToJson(_ModelTime instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minutes': instance.minutes,
      'id': instance.id,
    };
