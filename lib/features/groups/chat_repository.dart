import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'message.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  Stream<List<Message>> watchMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(Message message) async {
    await _firestore
        .collection('groups')
        .doc(message.groupId)
        .collection('messages')
        .add({
      'senderId': message.senderId,
      'content': message.content,
      'timestamp': Timestamp.fromDate(message.timestamp),
      'taggedUserIds': message.taggedUserIds,
    });
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Message>> groupMessagesStream(Ref ref, String groupId) {
  return ref.watch(chatRepositoryProvider).watchMessages(groupId);
}
