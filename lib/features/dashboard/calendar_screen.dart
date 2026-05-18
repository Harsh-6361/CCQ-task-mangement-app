import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../tasks/task.dart';
import '../tasks/task_repository.dart';
import '../crm/meeting.dart';
import '../crm/crm_repository.dart';
import '../auth/auth_repository.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(activeUserContextProvider);
    if (userId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final tasksAsync = ref.watch(tasksStreamProvider(userId));
    final meetingsAsync = ref.watch(allMeetingsStreamProvider(userId));
    final assignedTasksAsync = ref.watch(assignedTasksStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildEventList(tasksAsync, meetingsAsync, assignedTasksAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(
    AsyncValue<List<Task>> tasksAsync,
    AsyncValue<List<Meeting>> meetingsAsync,
    AsyncValue<List<Task>> assignedTasksAsync,
  ) {
    return tasksAsync.when(
      data: (tasks) => meetingsAsync.when(
        data: (meetings) => assignedTasksAsync.when(
          data: (assigned) {
            final allEvents = <_CalendarEvent>[];

            for (final task in tasks) {
              if (task.dueDate != null && isSameDay(task.dueDate, _selectedDay)) {
                allEvents.add(_CalendarEvent(title: task.title, type: 'Personal Task', time: task.dueDate!));
              }
            }

            for (final meeting in meetings) {
              if (meeting.followUpDate != null && isSameDay(meeting.followUpDate, _selectedDay)) {
                allEvents.add(_CalendarEvent(title: 'Follow-up', type: 'CRM', time: meeting.followUpDate!));
              }
            }

            for (final task in assigned) {
              if (task.dueDate != null && isSameDay(task.dueDate, _selectedDay)) {
                allEvents.add(_CalendarEvent(title: task.title, type: 'Team Assignment', time: task.dueDate!));
              }
            }

            if (allEvents.isEmpty) {
              return const Center(child: Text('No events for this day'));
            }

            return ListView.builder(
              itemCount: allEvents.length,
              itemBuilder: (context, index) {
                final event = allEvents[index];
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.title),
                  subtitle: Text(event.type),
                  trailing: Text(DateFormat('HH:mm').format(event.time)),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

class _CalendarEvent {
  final String title;
  final String type;
  final DateTime time;
  _CalendarEvent({required this.title, required this.type, required this.time});
}
