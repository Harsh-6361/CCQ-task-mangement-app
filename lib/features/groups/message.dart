import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String senderId,
    required String groupId,
    required String content,
    required DateTime timestamp,
    @Default([]) List<String> taggedUserIds,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawTimestamp = data['timestamp'];
    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      parsedTimestamp = DateTime.fromMillisecondsSinceEpoch(0);
    }
    return Message.fromJson({
      ...data,
      'id': doc.id,
      'timestamp': parsedTimestamp.toIso8601String(),
    });
  }
}
