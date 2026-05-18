// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? 'General',
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.todo,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  ownerId: json['ownerId'] as String,
  assignedToId: json['assignedToId'] as String?,
  groupId: json['groupId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'ownerId': instance.ownerId,
  'assignedToId': instance.assignedToId,
  'groupId': instance.groupId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
};
