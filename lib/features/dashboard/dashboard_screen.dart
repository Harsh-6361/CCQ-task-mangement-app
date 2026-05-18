import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'dashboard_provider.dart';
import '../tasks/task.dart';
import '../crm/meeting.dart';
import '../auth/auth_repository.dart';
import 'history_screen.dart';
import 'calendar_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUserId = ref.watch(activeUserContextProvider);
    if (activeUserId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final dashboardAsync = ref.watch(dashboardControllerProvider(activeUserId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DailyHistoryScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardControllerProvider(activeUserId).future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatsRow(data),
              const SizedBox(height: 24),
              _buildSectionTitle('Assigned to Me (Teams)'),
              const SizedBox(height: 8),
              _buildTaskList(data.assignedToMe, isAssigned: true),
              const SizedBox(height: 24),
              _buildSectionTitle('CRM Follow-ups'),
              const SizedBox(height: 8),
              _buildFollowUpList(data.upcomingFollowUps),
              const SizedBox(height: 24),
              _buildSectionTitle('Upcoming My Tasks'),
              const SizedBox(height: 8),
              _buildTaskList(data.upcomingTasks),
              const SizedBox(height: 24),
              _buildSectionTitle('Completed Today'),
              const SizedBox(height: 8),
              _buildTaskList(data.completedToday),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatsRow(DashboardData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Todo', data.todoCount, Colors.blue),
        _buildStatCard('In Progress', data.inProgressCount, Colors.orange),
        _buildStatCard('Done', data.doneCount, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTaskList(List<Task> tasks, {bool isAssigned = false}) {
    if (tasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(isAssigned ? 'No team tasks assigned to you' : 'No tasks found'),
        ),
      );
    }
    return Column(
      children: tasks.map((task) => Card(
        color: isAssigned ? Colors.deepPurple.shade50 : null,
        child: ListTile(
          title: Text(task.title),
          subtitle: Text('${task.category}${task.groupId != null ? " • Team Task" : ""}'),
          trailing: task.dueDate != null 
              ? Text(DateFormat('MMM d').format(task.dueDate!)) 
              : null,
        ),
      )).toList(),
    );
  }

  Widget _buildFollowUpList(List<Meeting> meetings) {
    if (meetings.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No follow-ups scheduled'),
        ),
      );
    }
    return Column(
      children: meetings.map((meeting) => Card(
        color: Colors.orange.shade50,
        child: ListTile(
          leading: const Icon(Icons.notifications_active, color: Colors.orange),
          title: Text('Follow-up for Lead'),
          subtitle: Text(meeting.feedback),
          trailing: Text(
            DateFormat('MMM d').format(meeting.followUpDate!),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }
}
