import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'group.dart';
import 'group_repository.dart';
import 'group_details_screen.dart';
import '../auth/auth_repository.dart';

enum GroupFilter { all, joined, notJoined }

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  GroupFilter _filter = GroupFilter.joined;

  @override
  Widget build(BuildContext context) {
    final activeUserId = ref.watch(activeUserContextProvider);
    if (activeUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = ref.watch(currentUserProfileProvider).value;
    final isAdmin = profile?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Teams (Admin)' : 'My Teams'),
      ),
      body: StreamBuilder<List<Group>>(
        stream: ref.watch(groupRepositoryProvider).watchAllGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final groups = snapshot.data ?? const <Group>[];
          final joined = groups.where((g) => g.members.contains(activeUserId)).toList();
          final notJoined = groups.where((g) => !g.members.contains(activeUserId)).toList();

          final visibleGroups = switch (_filter) {
            GroupFilter.all => groups,
            GroupFilter.joined => joined,
            GroupFilter.notJoined => notJoined,
          };

          return Column(
            children: [
              _buildFilterRow(joined.length, notJoined.length),
              const Divider(height: 1),
              Expanded(
                child: visibleGroups.isEmpty
                    ? Center(
                        child: Text(
                          _filter == GroupFilter.joined
                              ? 'No added teams yet.'
                              : _filter == GroupFilter.notJoined
                                  ? 'No other teams found.'
                                  : 'No teams found.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: visibleGroups.length,
                        itemBuilder: (context, index) {
                          final group = visibleGroups[index];
                          final isMember = group.members.contains(activeUserId);
                          final canOpen = isMember || isAdmin;

                          return ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.group)),
                            title: Text(group.name),
                            subtitle: Text('${group.members.length} members'),
                            trailing: _buildMembershipBadge(isMember),
                            onTap: () {
                              if (canOpen) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupDetailsScreen(group: group),
                                  ),
                                );
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ask a team admin to add you to this group.'),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context, ref, activeUserId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterRow(int joinedCount, int notJoinedCount) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: _filter == GroupFilter.all,
            onSelected: (_) => setState(() => _filter = GroupFilter.all),
          ),
          ChoiceChip(
            label: Text('Added ($joinedCount)'),
            selected: _filter == GroupFilter.joined,
            onSelected: (_) => setState(() => _filter = GroupFilter.joined),
          ),
          ChoiceChip(
            label: Text('Not Added ($notJoinedCount)'),
            selected: _filter == GroupFilter.notJoined,
            onSelected: (_) => setState(() => _filter = GroupFilter.notJoined),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBadge(bool isMember) {
    final color = isMember ? Colors.green : Colors.orange;
    final label = isMember ? 'Added' : 'Not added';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref, String userId) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
              autofocus: true,
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(groupRepositoryProvider).createGroup(
                      Group(
                        id: '',
                        name: nameController.text,
                        description: descController.text,
                        ownerId: userId,
                        members: [userId],
                        createdAt: DateTime.now(),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
