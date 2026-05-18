import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus { todo, inProgress, done }

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    @Default('') String description,
    @Default('General') String category,
    @Default(TaskStatus.todo) TaskStatus status,
    DateTime? dueDate,
    required String ownerId,
    String? assignedToId,
    String? groupId,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task.fromJson({
      ...data,
      'id': doc.id,
      'dueDate': (data['dueDate'] as Timestamp?)?.toDate().toIso8601String(),
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
    });
  }
}
