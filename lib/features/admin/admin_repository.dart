import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/app_user.dart';
import '../crm/lead.dart';
import '../crm/meeting.dart';
import '../groups/group.dart';
import '../tasks/task.dart';
import 'audit_log.dart';

part 'admin_repository.g.dart';

class AdminRepository {
  final FirebaseFirestore _firestore;

  AdminRepository(this._firestore);

  // User Management
  Stream<List<AppUser>> watchAllUsers() {
    return _firestore.collection('users').snapshots().map(
          (snap) => snap.docs.map((doc) => AppUser.fromFirestore(doc)).toList(),
        );
  }

  Future<void> updateUserPermissions(String uid, Map<String, bool> permissions) async {
    await _firestore.collection('users').doc(uid).update({
      'permissions': permissions,
    });
  }

  Future<void> setUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({
      'role': role,
    });
  }

  // Audit Logs
  Stream<List<AuditLog>> watchAuditLogs() {
    return _firestore
        .collection('audit_logs')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => AuditLog.fromFirestore(doc)).toList(),
        );
  }

  Future<void> logEvent(AuditLog log) async {
    await _firestore.collection('audit_logs').add({
      'actorId': log.actorId,
      'action': log.action,
      'targetId': log.targetId,
      'timestamp': Timestamp.fromDate(log.timestamp),
      'metadata': log.metadata,
    });
  }

  Stream<List<Task>> watchUserTasks(String uid) {
    return _firestore
        .collection('tasks')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) => _sortTasksNewestFirst(
              snap.docs.map((doc) => Task.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Lead>> watchUserLeads(String uid) {
    return _firestore
        .collection('leads')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) => _sortLeadsNewestFirst(
              snap.docs.map((doc) => Lead.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Meeting>> watchUserMeetings(String uid) {
    return _firestore
        .collection('meetings')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) => _sortMeetingsNewestFirst(
              snap.docs.map((doc) => Meeting.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Group>> watchUserGroups(String uid) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Group.fromFirestore(doc)).toList());
  }

  Stream<List<AuditLog>> watchRecentAuditLogsForUser(String uid) {
    return watchAuditLogs().map(
      (logs) => logs.where((log) => log.actorId == uid).toList(),
    );
  }
}

List<Task> _sortTasksNewestFirst(List<Task> tasks) {
  return tasks..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

List<Lead> _sortLeadsNewestFirst(List<Lead> leads) {
  return leads..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

List<Meeting> _sortMeetingsNewestFirst(List<Meeting> meetings) {
  return meetings..sort((a, b) => b.date.compareTo(a.date));
}

@riverpod
AdminRepository adminRepository(Ref ref) {
  return AdminRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<AppUser>> allUsersStream(Ref ref) {
  return ref.watch(adminRepositoryProvider).watchAllUsers();
}

@riverpod
Stream<List<AuditLog>> auditLogsStream(Ref ref) {
  return ref.watch(adminRepositoryProvider).watchAuditLogs();
}
