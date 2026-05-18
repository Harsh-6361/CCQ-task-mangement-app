import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'lead.dart';
import 'meeting.dart';
import 'crm_repository.dart';
import 'crm_controller.dart';
import '../auth/auth_repository.dart';

class LeadDetailsScreen extends ConsumerWidget {
  final Lead lead;
  const LeadDetailsScreen({required this.lead, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final meetingsAsync = ref.watch(meetingsStreamProvider(lead.id));
    final leadsAsync = ref.watch(leadsStreamProvider(userId));
    final matchingLeads = leadsAsync.value?.where((item) => item.id == lead.id) ?? const <Lead>[];
    final currentLead = matchingLeads.isEmpty ? lead : matchingLeads.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentLead.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadHeader(context, ref, currentLead),
            const SizedBox(height: 24),
            const Text('Meeting History & Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: meetingsAsync.when(
                data: (meetings) => meetings.isEmpty
                    ? const Center(child: Text('No meetings recorded yet.'))
                    : ListView.builder(
                        itemCount: meetings.length,
                        itemBuilder: (context, index) {
                          final meeting = meetings[index];
                          return Card(
                            child: ListTile(
                              title: Text(DateFormat('MMM d, yyyy').format(meeting.date)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Feedback: ${meeting.feedback}'),
                                  if (meeting.followUpDate != null)
                                    Text(
                                      'Follow-up: ${DateFormat('MMM d').format(meeting.followUpDate!)}',
                                      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMeetingSheet(context, ref, userId),
        label: const Text('Add Meeting'),
        icon: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildLeadHeader(BuildContext context, WidgetRef ref, Lead currentLead) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Contact Details', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<LeadStatus>(
              initialValue: currentLead.status,
              decoration: const InputDecoration(
                labelText: 'Lead Status',
                border: OutlineInputBorder(),
              ),
              items: LeadStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(_formatLeadStatus(status)),
                    ),
                  )
                  .toList(),
              onChanged: (status) {
                if (status == null || status == currentLead.status) return;
                ref.read(crmControllerProvider.notifier).updateLeadStatus(currentLead, status);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lead moved to ${_formatLeadStatus(status)}')),
                );
              },
            ),
            const SizedBox(height: 8),
            Text('Created: ${DateFormat('MMM d, yyyy').format(currentLead.createdAt)}'),
          ],
        ),
      ),
    );
  }

  void _showAddMeetingSheet(BuildContext context, WidgetRef ref, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddMeetingSheet(leadId: lead.id, userId: userId),
    );
  }
}

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

class _AddMeetingSheet extends ConsumerStatefulWidget {
  final String leadId;
  final String userId;
  const _AddMeetingSheet({required this.leadId, required this.userId});

  @override
  ConsumerState<_AddMeetingSheet> createState() => _AddMeetingSheetState();
}

class _AddMeetingSheetState extends ConsumerState<_AddMeetingSheet> {
  final _feedbackController = TextEditingController();
  DateTime? _followUpDate;

  @override
  Widget build(BuildContext context) {
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
          const Text('Record Meeting Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            decoration: const InputDecoration(labelText: 'Meeting Feedback', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(_followUpDate == null ? 'Set Follow-up Date' : 'Follow-up: ${DateFormat('MMM d, yyyy').format(_followUpDate!)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _followUpDate = date);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_feedbackController.text.isNotEmpty) {
                ref.read(crmControllerProvider.notifier).addMeeting(
                      Meeting(
                        id: '',
                        leadId: widget.leadId,
                        date: DateTime.now(),
                        feedback: _feedbackController.text,
                        followUpDate: _followUpDate,
                        ownerId: widget.userId,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save Meeting Result'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
