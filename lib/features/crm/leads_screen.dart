import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'crm_repository.dart';
import 'lead.dart';
import 'crm_controller.dart';
import 'lead_details_screen.dart';
import '../auth/auth_repository.dart';

class LeadsScreen extends ConsumerWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUserId = ref.watch(activeUserContextProvider);
    if (activeUserId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final leadsAsync = ref.watch(leadsStreamProvider(activeUserId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM Leads'),
      ),
      body: leadsAsync.when(
        data: (leads) => leads.isEmpty
            ? const Center(child: Text('No leads found.'))
            : ListView.builder(
                itemCount: leads.length,
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return ListTile(
                    title: Text(lead.name),
                    subtitle: Text('Status: ${lead.status.name}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeadDetailsScreen(lead: lead),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLeadDialog(context, ref, activeUserId),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddLeadDialog(BuildContext context, WidgetRef ref, String userId) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Lead'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Lead Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(crmControllerProvider.notifier).addLead(
                      Lead(
                        id: '',
                        name: nameController.text,
                        ownerId: userId,
                        createdAt: DateTime.now(),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
