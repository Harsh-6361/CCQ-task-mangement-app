import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/app_user.dart';
import 'group.dart';

part 'group_repository.g.dart';

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository(this._firestore);

  Stream<List<Group>> watchUserGroups(String userId) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => _sortGroupsNewestFirst(
              snapshot.docs.map((doc) => Group.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Group>> watchAllGroups() {
    return _firestore
        .collection('groups')
        .snapshots()
        .map((snapshot) => _sortGroupsNewestFirst(
              snapshot.docs.map((doc) => Group.fromFirestore(doc)).toList(),
            ));
  }

  Stream<Group> watchGroup(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((doc) => Group.fromFirestore(doc));
  }

  Stream<List<AppUser>> watchUsers() {
    return _firestore.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList(),
        );
  }

  Future<String> createGroup(Group group) async {
    final docRef = await _firestore.collection('groups').add({
      'name': group.name,
      'description': group.description,
      'ownerId': group.ownerId,
      'members': group.members,
      'createdAt': Timestamp.fromDate(group.createdAt),
    });
    return docRef.id;
  }

  Future<void> addMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }
}

List<Group> _sortGroupsNewestFirst(List<Group> groups) {
  return groups..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

@riverpod
GroupRepository groupRepository(Ref ref) {
  return GroupRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Group>> userGroupsStream(Ref ref, String userId) {
  return ref.watch(groupRepositoryProvider).watchUserGroups(userId);
}
