import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String actorId,
    required String action, // e.g., 'TASK_DELETED', 'LEAD_CREATED'
    required String targetId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

  factory AuditLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AuditLog.fromJson({
      ...data,
      'id': doc.id,
      'timestamp': (data['timestamp'] as Timestamp).toDate().toIso8601String(),
    });
  }
}
