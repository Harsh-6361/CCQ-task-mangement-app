// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lead _$LeadFromJson(Map<String, dynamic> json) => _Lead(
  id: json['id'] as String,
  name: json['name'] as String,
  contactInfo:
      (json['contactInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  status:
      $enumDecodeNullable(_$LeadStatusEnumMap, json['status']) ??
      LeadStatus.newLead,
  ownerId: json['ownerId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LeadToJson(_Lead instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactInfo': instance.contactInfo,
  'status': _$LeadStatusEnumMap[instance.status]!,
  'ownerId': instance.ownerId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$LeadStatusEnumMap = {
  LeadStatus.newLead: 'newLead',
  LeadStatus.contacted: 'contacted',
  LeadStatus.qualified: 'qualified',
  LeadStatus.lost: 'lost',
};
