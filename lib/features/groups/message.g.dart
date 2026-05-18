// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  groupId: json['groupId'] as String,
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  taggedUserIds:
      (json['taggedUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'senderId': instance.senderId,
  'groupId': instance.groupId,
  'content': instance.content,
  'timestamp': instance.timestamp.toIso8601String(),
  'taggedUserIds': instance.taggedUserIds,
};
