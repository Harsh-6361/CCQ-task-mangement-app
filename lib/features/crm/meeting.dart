import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

@freezed
abstract class Meeting with _$Meeting {
  const factory Meeting({
    required String id,
    required String leadId,
    required DateTime date,
    @Default('') String feedback,
    DateTime? followUpDate,
    required String ownerId,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meeting.fromJson({
      ...data,
      'id': doc.id,
      'date': (data['date'] as Timestamp).toDate().toIso8601String(),
      'followUpDate': (data['followUpDate'] as Timestamp?)?.toDate().toIso8601String(),
    });
  }
}
