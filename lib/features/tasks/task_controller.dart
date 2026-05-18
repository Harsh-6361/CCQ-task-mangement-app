import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'task.dart';
import 'task_repository.dart';
import '../../common/services/notification_service.dart';
import '../admin/admin_repository.dart';
import '../admin/audit_log.dart';
import '../auth/auth_repository.dart';

part 'task_controller.g.dart';

@riverpod
class TaskController extends _$TaskController {
  @override
  FutureOr<void> build() {
    // Nothing to initialize
  }

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskRepositoryProvider).addTask(task);
      
      // Log Event
      try {
        await ref.read(adminRepositoryProvider).logEvent(AuditLog(
          id: '',
          actorId: ref.read(userIdProvider) ?? 'unknown',
          action: 'TASK_CREATED',
          targetId: task.title,
          timestamp: DateTime.now(),
        ));
      } catch (_) {}

      if (task.dueDate != null) {
        try {
          await ref.read(notificationServiceProvider).scheduleNotification(
            id: task.hashCode,
            title: 'Task Reminder',
            body: 'Don\'t forget: ${task.title}',
            scheduledDate: task.dueDate!,
          );
        } catch (_) {}
      }
    });
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(taskRepositoryProvider).updateTask(task));
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskRepositoryProvider).deleteTask(taskId);
      
      // Log Event
      try {
        await ref.read(adminRepositoryProvider).logEvent(AuditLog(
          id: '',
          actorId: ref.read(userIdProvider) ?? 'unknown',
          action: 'TASK_DELETED',
          targetId: taskId,
          timestamp: DateTime.now(),
        ));
      } catch (_) {}
    });
  }
}

@riverpod
List<Task> filteredTasks(Ref ref, {TaskStatus? status, String? category}) {
  final activeUserId = ref.watch(activeUserContextProvider);
  if (activeUserId == null) return [];
  
  final tasksAsync = ref.watch(tasksStreamProvider(activeUserId));
  
  return tasksAsync.when(
    data: (tasks) {
      return tasks.where((task) {
        final matchesStatus = status == null || task.status == status;
        final matchesCategory = category == null || task.category == category;
        return matchesStatus && matchesCategory;
      }).toList();
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
}
