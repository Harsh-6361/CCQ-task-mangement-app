import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'lead.freezed.dart';
part 'lead.g.dart';

enum LeadStatus { newLead, contacted, qualified, lost }

@freezed
abstract class Lead with _$Lead {
  const factory Lead({
    required String id,
    required String name,
    @Default({}) Map<String, String> contactInfo,
    @Default(LeadStatus.newLead) LeadStatus status,
    required String ownerId,
    required DateTime createdAt,
  }) = _Lead;

  factory Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);

  factory Lead.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lead.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
    });
  }
}
