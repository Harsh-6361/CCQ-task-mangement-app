import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../tasks/task.dart';
import '../tasks/task_repository.dart';
import '../auth/auth_repository.dart';

class DailyHistoryScreen extends ConsumerWidget {
  const DailyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(activeUserContextProvider);
    if (userId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final tasksAsync = ref.watch(tasksStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: tasksAsync.when(
        data: (tasks) {
          final completedTasks = tasks.where((t) => t.status == TaskStatus.done).toList();
          
          if (completedTasks.isEmpty) {
            return const Center(child: Text('No completed tasks yet. Keep going!'));
          }

          // Group by date
          final grouped = <String, List<Task>>{};
          for (final task in completedTasks) {
            final dateStr = DateFormat('MMMM d, yyyy').format(task.createdAt);
            grouped.putIfAbsent(dateStr, () => []).add(task);
          }

          final sortedDates = grouped.keys.toList();

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final dayTasks = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ...dayTasks.map((task) => ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(task.title),
                    subtitle: Text(task.category),
                  )),
                  const Divider(),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
