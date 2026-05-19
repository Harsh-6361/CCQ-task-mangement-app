import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_controller.dart';
import '../groups/group_repository.dart';
import '../auth/auth_repository.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskStatus? _filterStatus;
  String? _filterCategory;

  @override
  Widget build(BuildContext context) {
    final activeUserId = ref.watch(activeUserContextProvider);
    if (activeUserId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final tasks = ref.watch(filteredTasksProvider(status: _filterStatus, category: _filterCategory));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks found. Add one!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskTile(task: task);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context, activeUserId),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TaskStatus>(
              initialValue: _filterStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...TaskStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))),
              ],
              onChanged: (val) => setState(() => _filterStatus = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _filterCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: 'Work', child: Text('Work')),
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
              ],
              onChanged: (val) => setState(() => _filterCategory = val),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddTaskSheet(userId: userId),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  final Task task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Checkbox(
        value: task.status == TaskStatus.done,
        onChanged: (val) {
          final newStatus = val! ? TaskStatus.done : TaskStatus.todo;
          ref.read(taskControllerProvider.notifier).updateTask(task.copyWith(status: newStatus));
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text('${task.category} - ${task.dueDate != null ? DateFormat('MMM d').format(task.dueDate!) : 'No date'}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => ref.read(taskControllerProvider.notifier).deleteTask(task.id),
      ),
    );
  }
}

class _AddTaskSheet extends ConsumerStatefulWidget {
  final String userId;
  const _AddTaskSheet({required this.userId});

  @override
  ConsumerState<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<_AddTaskSheet> {
  final _titleController = TextEditingController();
  String _category = 'Work';
  DateTime? _dueDate;
  String? _selectedGroupId;
  String? _assignedToId;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(userGroupsStreamProvider(widget.userId));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Work', child: Text('Work')),
                    DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                    DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                  ],
                  onChanged: (val) => setState(() => _category = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: groupsAsync.when(
                  data: (groups) => DropdownButtonFormField<String?>(
                    initialValue: _selectedGroupId,
                    decoration: const InputDecoration(labelText: 'Team', border: OutlineInputBorder()),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      ...groups.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name))),
                    ],
                    onChanged: (val) => setState(() {
                      _selectedGroupId = val;
                      _assignedToId = null; 
                    }),
                  ),
                  loading: () => const SizedBox(),
                  error: (error, stackTrace) => const SizedBox(),
                ),
              ),
            ],
          ),
if (_selectedGroupId != null) ...[
            const SizedBox(height: 16),
            groupsAsync.when(
              data: (groups) {
                final group = groups.firstWhere((g) => g.id == _selectedGroupId);
                if (group.members.isEmpty) {
                  return const Text('No members in this team');
                }
                return _MemberDropdown(
                  members: group.members,
                  selectedId: _assignedToId,
                  onChanged: (val) => setState(() => _assignedToId = val),
                );
              },
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
            ),
          ],
          const SizedBox(height: 16),
          ListTile(
            title: Text(_dueDate == null ? 'Select Due Date' : 'Due Date: ${DateFormat('MMM d, yyyy').format(_dueDate!)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _dueDate = date);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Task'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final task = Task(
      id: '', 
      title: title,
      category: _category,
      dueDate: _dueDate,
      ownerId: widget.userId,
      assignedToId: _assignedToId,
      groupId: _selectedGroupId,
      createdAt: DateTime.now(),
    );

    await ref.read(taskControllerProvider.notifier).addTask(task);
    if (!mounted) return;

    final state = ref.read(taskControllerProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create task: ${state.error}')),
      );
      return;
    }

Navigator.pop(context);
  }
}

class _MemberDropdown extends ConsumerWidget {
  final List<String> members;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MemberDropdown({
    required this.members,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersByIdsProvider(members));

    return usersAsync.when(
      data: (users) => DropdownButtonFormField<String?>(
        initialValue: selectedId,
        decoration: const InputDecoration(labelText: 'Assign To', border: OutlineInputBorder()),
        items: [
          const DropdownMenuItem(value: null, child: Text('Unassigned')),
          ...users.map((u) => DropdownMenuItem(value: u.uid, child: Text(u.email))),
        ],
        onChanged: onChanged,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => DropdownButtonFormField<String?>(
        initialValue: selectedId,
        decoration: const InputDecoration(labelText: 'Assign To', border: OutlineInputBorder()),
        items: [
          const DropdownMenuItem(value: null, child: Text('Unassigned')),
          ...members.map((m) => DropdownMenuItem(value: m, child: Text(m))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
