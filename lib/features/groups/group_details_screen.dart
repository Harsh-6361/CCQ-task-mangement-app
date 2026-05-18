import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../auth/app_user.dart';
import '../auth/auth_repository.dart';
import '../tasks/task.dart';
import '../tasks/task_repository.dart';
import 'chat_repository.dart';
import 'group.dart';
import 'group_repository.dart';
import 'message.dart';

class GroupDetailsScreen extends ConsumerStatefulWidget {
  final Group group;
  const GroupDetailsScreen({required this.group, super.key});

  @override
  ConsumerState<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeUserId = ref.watch(activeUserContextProvider);
    if (activeUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = ref.watch(currentUserProfileProvider).value;
    final isAdmin = profile?.role == 'admin';

    return StreamBuilder<Group>(
      stream: ref.watch(groupRepositoryProvider).watchGroup(widget.group.id),
      initialData: widget.group,
      builder: (context, snapshot) {
        final group = snapshot.data ?? widget.group;
        final isMember = group.members.contains(activeUserId);
        final canView = isMember || isAdmin;

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            bottom: canView
                ? TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Chat', icon: Icon(Icons.chat)),
                      Tab(text: 'Tasks', icon: Icon(Icons.task)),
                      Tab(text: 'Members', icon: Icon(Icons.people)),
                    ],
                  )
                : null,
          ),
          body: canView
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChatTab(activeUserId, group, isAdmin: isAdmin, isMember: isMember),
                    _buildTasksTab(group),
                    _buildMembersTab(group, activeUserId),
                  ],
                )
              : _buildAccessRestricted(),
        );
      },
    );
  }

  Widget _buildChatTab(
    String userId,
    Group group, {
    required bool isAdmin,
    required bool isMember,
  }) {
    final canSend = isMember || isAdmin;
    final messagesAsync = ref.watch(groupMessagesStreamProvider(group.id));
    final usersStream = ref.watch(groupRepositoryProvider).watchUsers();
    final showAdminBanner = isAdmin && !isMember;

    return Container(
      color: const Color(0xFFECE5DD),
      child: Column(
        children: [
          if (showAdminBanner)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: const [
                      Icon(Icons.security),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Admin view: you are not a member of this group.'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<AppUser>>(
              stream: usersStream,
              builder: (context, usersSnapshot) {
                final users = usersSnapshot.data ?? const <AppUser>[];
                final usersById = {for (final user in users) user.uid: user};

                return messagesAsync.when(
                  data: (messages) => ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == userId;
                      final sender = usersById[msg.senderId];
                      final senderLabel = _displayName(sender, msg.senderId);

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isMe ? 12 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Column(
                                crossAxisAlignment:
                                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    Text(
                                      senderLabel,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: Colors.teal.shade700,
                                      ),
                                    ),
                                  Text(msg.content),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('HH:mm').format(msg.timestamp),
                                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: canSend,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(userId, group.id, canSend: canSend),
                      decoration: InputDecoration(
                        hintText: canSend
                            ? 'Type a message...'
                            : 'Only added members can send messages.',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(userId, group.id, canSend: canSend),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String userId, String groupId, {required bool canSend}) async {
    if (!canSend) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not added to this group.')),
      );
      return;
    }

    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
            Message(
              id: '',
              senderId: userId,
              groupId: groupId,
              content: content,
              timestamp: DateTime.now(),
            ),
          );
      _messageController.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send message: $error')),
      );
    }
  }

  Widget _buildAccessRestricted() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'You are not added to this group yet. Ask a team admin to add you.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _displayName(AppUser? user, String fallbackId) {
    if (user == null) return _shortId(fallbackId);
    final email = user.email;
    final atIndex = email.indexOf('@');
    return atIndex > 0 ? email.substring(0, atIndex) : email;
  }

  String _shortId(String uid) {
    return uid.length <= 8 ? uid : uid.substring(0, 8);
  }

  Widget _buildTasksTab(Group group) {
    final tasksAsync = ref.watch(groupTasksStreamProvider(group.id));

    return tasksAsync.when(
      data: (tasks) => tasks.isEmpty
          ? const Center(child: Text('No group tasks found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  child: CheckboxListTile(
                    value: task.status == TaskStatus.done,
                    title: Text(task.title),
                    subtitle: Text('Assigned to: ${task.assignedToId ?? "Unassigned"}'),
                    onChanged: (val) {
                      final newStatus = val! ? TaskStatus.done : TaskStatus.todo;
                      ref.read(taskRepositoryProvider).updateTask(
                            task.copyWith(status: newStatus),
                          );
                    },
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildMembersTab(Group group, String userId) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final canManage = group.ownerId == userId || profile?.role == 'admin';

    return StreamBuilder<List<AppUser>>(
      stream: ref.watch(groupRepositoryProvider).watchUsers(),
      builder: (context, snapshot) {
        final users = snapshot.data ?? const <AppUser>[];
        final usersById = {for (final user in users) user.uid: user};
        final availableUsers = users.where((user) => !group.members.contains(user.uid)).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${group.members.length} members',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (canManage)
                  FilledButton.icon(
                    onPressed: availableUsers.isEmpty
                        ? null
                        : () => _showAddMemberDialog(group, availableUsers),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (group.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(group.description),
              ),
            ...group.members.map((memberId) {
              final member = usersById[memberId];
              final isOwner = memberId == group.ownerId;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(isOwner ? Icons.workspace_premium : Icons.person),
                  ),
                  title: Text(member?.email ?? memberId),
                  subtitle: Text(isOwner ? 'Owner' : memberId),
                  trailing: canManage && !isOwner
                      ? IconButton(
                          tooltip: 'Remove member',
                          icon: const Icon(Icons.person_remove),
                          onPressed: () => _removeMember(group, memberId),
                        )
                      : null,
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _showAddMemberDialog(Group group, List<AppUser> users) {
    String? selectedUserId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Team Member'),
          content: DropdownButtonFormField<String>(
            initialValue: selectedUserId,
            decoration: const InputDecoration(
              labelText: 'User',
              border: OutlineInputBorder(),
            ),
            items: users
                .map(
                  (user) => DropdownMenuItem(
                    value: user.uid,
                    child: Text(user.email),
                  ),
                )
                .toList(),
            onChanged: (value) => setDialogState(() => selectedUserId = value),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: selectedUserId == null
                  ? null
                  : () async {
                      await ref.read(groupRepositoryProvider).addMember(group.id, selectedUserId!);
                      if (context.mounted) Navigator.pop(context);
                    },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeMember(Group group, String memberId) async {
    await ref.read(groupRepositoryProvider).removeMember(group.id, memberId);
  }
}
