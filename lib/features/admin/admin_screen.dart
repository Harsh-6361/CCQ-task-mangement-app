import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../auth/app_user.dart';
import '../crm/lead.dart';
import '../crm/meeting.dart';
import '../groups/group.dart';
import '../tasks/task.dart';
import 'admin_repository.dart';
import 'audit_log.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Audit Logs', icon: Icon(Icons.list_alt)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    final usersAsync = ref.watch(allUsersStreamProvider);

    return usersAsync.when(
      data: (users) => ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == 'admin' ? Colors.red.shade100 : Colors.blue.shade100,
                child: Icon(user.role == 'admin' ? Icons.security : Icons.person),
              ),
              title: Text(user.email),
              subtitle: Text('Role: ${user.role} - UID: ${_shortId(user.uid)}'),
              trailing: PopupMenuButton<String>(
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'view', child: Text('View Activity')),
                  PopupMenuItem(value: 'permissions', child: Text('Edit Permissions')),
                  PopupMenuItem(value: 'role', child: Text('Change Role')),
                ],
                onSelected: (val) => _handleUserAction(user, val),
              ),
              onTap: () => _openUserActivity(user),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  void _handleUserAction(AppUser user, String action) {
    if (action == 'view') {
      _openUserActivity(user);
    } else if (action == 'permissions') {
      _showPermissionsDialog(user);
    } else if (action == 'role') {
      _showRoleDialog(user);
    }
  }

  void _openUserActivity(AppUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminUserActivityScreen(user: user)),
    );
  }

  void _showPermissionsDialog(AppUser user) {
    final perms = Map<String, bool>.from(user.permissions);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Permissions: ${user.email}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: perms.keys.map((key) {
              return CheckboxListTile(
                title: Text(key.toUpperCase()),
                value: perms[key],
                onChanged: (val) => setDialogState(() => perms[key] = val!),
              );
            }).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                ref.read(adminRepositoryProvider).updateUserPermissions(user.uid, perms);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleDialog(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User'),
              onTap: () {
                ref.read(adminRepositoryProvider).setUserRole(user.uid, 'user');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Admin'),
              onTap: () {
                ref.read(adminRepositoryProvider).setUserRole(user.uid, 'admin');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsTab() {
    final logsAsync = ref.watch(auditLogsStreamProvider);

    return logsAsync.when(
      data: (logs) => _AuditLogList(logs: logs),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

class AdminUserActivityScreen extends ConsumerStatefulWidget {
  const AdminUserActivityScreen({required this.user, super.key});

  final AppUser user;

  @override
  ConsumerState<AdminUserActivityScreen> createState() => _AdminUserActivityScreenState();
}

class _AdminUserActivityScreenState extends ConsumerState<AdminUserActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(adminRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.email),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Tasks'),
            Tab(text: 'CRM'),
            Tab(text: 'Teams'),
            Tab(text: 'Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(user: widget.user, repo: repo),
          _TasksTab(stream: repo.watchUserTasks(widget.user.uid)),
          _CrmTab(
            leadsStream: repo.watchUserLeads(widget.user.uid),
            meetingsStream: repo.watchUserMeetings(widget.user.uid),
          ),
          _TeamsTab(stream: repo.watchUserGroups(widget.user.uid)),
          StreamBuilder<List<AuditLog>>(
            stream: repo.watchRecentAuditLogsForUser(widget.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              return _AuditLogList(logs: snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.user, required this.repo});

  final AppUser user;
  final AdminRepository repo;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: repo.watchUserTasks(user.uid),
      builder: (context, taskSnap) => StreamBuilder<List<Lead>>(
        stream: repo.watchUserLeads(user.uid),
        builder: (context, leadSnap) => StreamBuilder<List<Meeting>>(
          stream: repo.watchUserMeetings(user.uid),
          builder: (context, meetingSnap) => StreamBuilder<List<Group>>(
            stream: repo.watchUserGroups(user.uid),
            builder: (context, groupSnap) {
              final tasks = taskSnap.data ?? const <Task>[];
              final leads = leadSnap.data ?? const <Lead>[];
              final meetings = meetingSnap.data ?? const <Meeting>[];
              final groups = groupSnap.data ?? const <Group>[];
              final done = tasks.where((task) => task.status == TaskStatus.done).length;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: Text(user.email),
                      subtitle: Text('Role: ${user.role} - UID: ${user.uid}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _MetricCard(label: 'Tasks', value: tasks.length),
                      _MetricCard(label: 'Done', value: done),
                      _MetricCard(label: 'Leads', value: leads.length),
                      _MetricCard(label: 'Meetings', value: meetings.length),
                      _MetricCard(label: 'Teams', value: groups.length),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This admin view reads app activity records only.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab({required this.stream});

  final Stream<List<Task>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final tasks = snapshot.data!;
        if (tasks.isEmpty) return const Center(child: Text('No tasks found.'));

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              child: ListTile(
                leading: Icon(
                  task.status == TaskStatus.done
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                title: Text(task.title),
                subtitle: Text(
                  '${task.category} - ${task.status.name}'
                  '${task.assignedToId == null ? '' : ' - Assigned: ${_shortId(task.assignedToId!)}'}',
                ),
                trailing: task.dueDate == null
                    ? null
                    : Text(DateFormat('MMM d').format(task.dueDate!)),
              ),
            );
          },
        );
      },
    );
  }
}

class _CrmTab extends StatelessWidget {
  const _CrmTab({required this.leadsStream, required this.meetingsStream});

  final Stream<List<Lead>> leadsStream;
  final Stream<List<Meeting>> meetingsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Lead>>(
      stream: leadsStream,
      builder: (context, leadSnap) => StreamBuilder<List<Meeting>>(
        stream: meetingsStream,
        builder: (context, meetingSnap) {
          if (!leadSnap.hasData || !meetingSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final leads = leadSnap.data!;
          final meetings = meetingSnap.data!;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text('Leads', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (leads.isEmpty)
                const Card(child: ListTile(title: Text('No leads found.')))
              else
                ...leads.map(
                  (lead) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_search),
                      title: Text(lead.name),
                      subtitle: Text(_formatLeadStatus(lead.status)),
                      trailing: Text(DateFormat('MMM d').format(lead.createdAt)),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Meetings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (meetings.isEmpty)
                const Card(child: ListTile(title: Text('No meetings found.')))
              else
                ...meetings.map(
                  (meeting) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.forum_outlined),
                      title: Text(DateFormat('MMM d, yyyy').format(meeting.date)),
                      subtitle: Text(meeting.feedback),
                      trailing: meeting.followUpDate == null
                          ? null
                          : Text('Follow: ${DateFormat('MMM d').format(meeting.followUpDate!)}'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TeamsTab extends StatelessWidget {
  const _TeamsTab({required this.stream});

  final Stream<List<Group>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final groups = snapshot.data!;
        if (groups.isEmpty) return const Center(child: Text('No teams found.'));

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: groups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final group = groups[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: Text(group.name),
                subtitle: Text('${group.members.length} members - Owner: ${_shortId(group.ownerId)}'),
              ),
            );
          },
        );
      },
    );
  }
}

class _AuditLogList extends StatelessWidget {
  const _AuditLogList({required this.logs});

  final List<AuditLog> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const Center(child: Text('No audit logs found.'));

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: logs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: Text(log.action.replaceAll('_', ' ')),
            subtitle: Text('By: ${_shortId(log.actorId)} - Target: ${_shortId(log.targetId)}'),
            trailing: Text(DateFormat('MMM d, HH:mm').format(log.timestamp)),
          ),
        );
      },
    );
  }
}

String _shortId(String id) => id.length <= 8 ? id : '${id.substring(0, 8)}...';

String _formatLeadStatus(LeadStatus status) {
  switch (status) {
    case LeadStatus.newLead:
      return 'New Lead';
    case LeadStatus.contacted:
      return 'Contacted';
    case LeadStatus.qualified:
      return 'Qualified';
    case LeadStatus.lost:
      return 'Lost';
  }
}
