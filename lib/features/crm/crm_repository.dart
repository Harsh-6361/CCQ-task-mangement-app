import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'lead.dart';
import 'meeting.dart';

part 'crm_repository.g.dart';

class CrmRepository {
  final FirebaseFirestore _firestore;

  CrmRepository(this._firestore);

// Leads
  Stream<List<Lead>> watchLeads(String userId) {
    return _firestore
        .collection('leads')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _sortLeadsNewestFirst(
              snapshot.docs.map((doc) => Lead.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Lead>> watchAllLeads() {
    return _firestore
        .collection('leads')
        .snapshots()
        .map((snapshot) => _sortLeadsNewestFirst(
              snapshot.docs.map((doc) => Lead.fromFirestore(doc)).toList(),
            ));
  }

  Future<void> addLead(Lead lead) async {
    await _firestore.collection('leads').add({
      'name': lead.name,
      'contactInfo': lead.contactInfo,
      'status': lead.status.name,
      'ownerId': lead.ownerId,
      'createdAt': Timestamp.fromDate(lead.createdAt),
    });
  }

  Future<void> updateLeadStatus(String leadId, LeadStatus status) async {
    await _firestore.collection('leads').doc(leadId).update({
      'status': status.name,
    });
  }

  // Meetings
  Stream<List<Meeting>> watchMeetingsForLead(String leadId) {
    return _firestore
        .collection('meetings')
        .where('leadId', isEqualTo: leadId)
        .snapshots()
        .map((snapshot) => _sortMeetingsNewestFirst(
              snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Meeting>> watchAllMeetings(String userId) {
    return _firestore
        .collection('meetings')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _sortMeetingsNewestFirst(
              snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList(),
            ));
  }

  Future<void> addMeeting(Meeting meeting) async {
    await _firestore.collection('meetings').add({
      'leadId': meeting.leadId,
      'date': Timestamp.fromDate(meeting.date),
      'feedback': meeting.feedback,
      'followUpDate': meeting.followUpDate != null 
          ? Timestamp.fromDate(meeting.followUpDate!) 
          : null,
      'ownerId': meeting.ownerId,
    });
  }
}

List<Lead> _sortLeadsNewestFirst(List<Lead> leads) {
  return leads..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

List<Meeting> _sortMeetingsNewestFirst(List<Meeting> meetings) {
  return meetings..sort((a, b) => b.date.compareTo(a.date));
}

@riverpod
CrmRepository crmRepository(Ref ref) {
  return CrmRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Lead>> leadsStream(Ref ref, String userId) {
  return ref.watch(crmRepositoryProvider).watchLeads(userId);
}

@riverpod
Stream<List<Lead>> allLeadsStream(Ref ref) {
  return ref.watch(crmRepositoryProvider).watchAllLeads();
}

@riverpod
Stream<List<Meeting>> meetingsStream(Ref ref, String leadId) {
  return ref.watch(crmRepositoryProvider).watchMeetingsForLead(leadId);
}

@riverpod
Stream<List<Meeting>> allMeetingsStream(Ref ref, String userId) {
  return ref.watch(crmRepositoryProvider).watchAllMeetings(userId);
}
