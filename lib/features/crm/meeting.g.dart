// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meeting _$MeetingFromJson(Map<String, dynamic> json) => _Meeting(
  id: json['id'] as String,
  leadId: json['leadId'] as String,
  date: DateTime.parse(json['date'] as String),
  feedback: json['feedback'] as String? ?? '',
  followUpDate: json['followUpDate'] == null
      ? null
      : DateTime.parse(json['followUpDate'] as String),
  ownerId: json['ownerId'] as String,
);

Map<String, dynamic> _$MeetingToJson(_Meeting instance) => <String, dynamic>{
  'id': instance.id,
  'leadId': instance.leadId,
  'date': instance.date.toIso8601String(),
  'feedback': instance.feedback,
  'followUpDate': instance.followUpDate?.toIso8601String(),
  'ownerId': instance.ownerId,
};
