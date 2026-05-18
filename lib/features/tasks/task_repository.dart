import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'task.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository(this._firestore);

  Stream<List<Task>> watchTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _sortNewestFirst(
              snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Task>> watchGroupTasks(String groupId) {
    return _firestore
        .collection('tasks')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) => _sortNewestFirst(
              snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
            ));
  }

  Stream<List<Task>> watchAssignedTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('assignedToId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _sortNewestFirst(
              snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
            ));
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'status': task.status.name,
      'dueDate': task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
      'ownerId': task.ownerId,
      'assignedToId': task.assignedToId,
      'groupId': task.groupId,
      'createdAt': Timestamp.fromDate(task.createdAt),
    });
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'status': task.status.name,
      'dueDate': task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
      'assignedToId': task.assignedToId,
      'groupId': task.groupId,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}

List<Task> _sortNewestFirst(List<Task> tasks) {
  return tasks..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Task>> tasksStream(Ref ref, String userId) {
  return ref.watch(taskRepositoryProvider).watchTasks(userId);
}

@riverpod
Stream<List<Task>> groupTasksStream(Ref ref, String groupId) {
  return ref.watch(taskRepositoryProvider).watchGroupTasks(groupId);
}

@riverpod
Stream<List<Task>> assignedTasksStream(Ref ref, String userId) {
  return ref.watch(taskRepositoryProvider).watchAssignedTasks(userId);
}
