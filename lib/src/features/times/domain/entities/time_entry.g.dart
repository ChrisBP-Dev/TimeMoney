// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => _TimeEntry(
  hour: (json['hour'] as num).toInt(),
  minutes: (json['minutes'] as num).toInt(),
  id: (json['id'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TimeEntryToJson(_TimeEntry instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minutes': instance.minutes,
      'id': instance.id,
    };
