import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../tasks/task.dart';
import '../tasks/task_repository.dart';
import '../crm/crm_repository.dart';
import '../crm/meeting.dart';

part 'dashboard_provider.freezed.dart';
part 'dashboard_provider.g.dart';

@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    @Default(0) int todoCount,
    @Default(0) int inProgressCount,
    @Default(0) int doneCount,
    @Default([]) List<Task> upcomingTasks,
    @Default([]) List<Task> assignedToMe,
    @Default([]) List<Meeting> upcomingFollowUps,
    @Default([]) List<Task> completedToday,
  }) = _DashboardData;
}

@riverpod
class DashboardController extends _$DashboardController {
  @override
  FutureOr<DashboardData> build(String userId) async {
    // In a real app, we'd listen to streams. For the dashboard summary, 
    // we can fetch the lists once or combine streams.
    // For simplicity in this initial build, we'll fetch them.
    
    final tasks = await ref.watch(tasksStreamProvider(userId).future);
    final meetings = await ref.watch(allMeetingsStreamProvider(userId).future);
    final assignedTasks = await ref.watch(assignedTasksStreamProvider(userId).future);
    
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    
    final todoCount = tasks.where((t) => t.status == TaskStatus.todo).length;
    final inProgressCount = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final doneCount = tasks.where((t) => t.status == TaskStatus.done).length;
    
    final upcomingTasks = tasks
        .where((t) => t.dueDate != null && t.dueDate!.isAfter(now) && t.status != TaskStatus.done)
        .toList();
        
    final completedToday = tasks
        .where((t) => t.status == TaskStatus.done && (t.dueDate != null && t.dueDate!.isAfter(todayStart) || t.createdAt.isAfter(todayStart)))
        .toList();

    final upcomingFollowUps = meetings
        .where((m) => m.followUpDate != null && m.followUpDate!.isAfter(now))
        .toList();

    final assignedToMe = assignedTasks
        .where((t) => t.status != TaskStatus.done)
        .toList();

    return DashboardData(
      todoCount: todoCount,
      inProgressCount: inProgressCount,
      doneCount: doneCount,
      upcomingTasks: upcomingTasks,
      assignedToMe: assignedToMe,
      completedToday: completedToday,
      upcomingFollowUps: upcomingFollowUps,
    );
  }
}
