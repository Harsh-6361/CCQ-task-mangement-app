// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  ownerId: json['ownerId'] as String,
  members:
      (json['members'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'ownerId': instance.ownerId,
  'members': instance.members,
  'createdAt': instance.createdAt.toIso8601String(),
};
