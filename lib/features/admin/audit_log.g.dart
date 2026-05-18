// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: json['id'] as String,
  actorId: json['actorId'] as String,
  action: json['action'] as String,
  targetId: json['targetId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'actorId': instance.actorId,
  'action': instance.action,
  'targetId': instance.targetId,
  'timestamp': instance.timestamp.toIso8601String(),
  'metadata': instance.metadata,
};
