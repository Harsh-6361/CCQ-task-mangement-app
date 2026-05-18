import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'lead.dart';
import 'meeting.dart';
import 'crm_repository.dart';
import '../../common/services/notification_service.dart';
import '../admin/admin_repository.dart';
import '../admin/audit_log.dart';
import '../auth/auth_repository.dart';

part 'crm_controller.g.dart';

@riverpod
class CrmController extends _$CrmController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> addLead(Lead lead) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(crmRepositoryProvider).addLead(lead);
      
      try {
        await ref.read(adminRepositoryProvider).logEvent(AuditLog(
          id: '',
          actorId: ref.read(userIdProvider) ?? 'unknown',
          action: 'LEAD_CREATED',
          targetId: lead.name,
          timestamp: DateTime.now(),
        ));
      } catch (_) {}
    });
  }

  Future<void> addMeeting(Meeting meeting) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(crmRepositoryProvider).addMeeting(meeting);
      
      try {
        await ref.read(adminRepositoryProvider).logEvent(AuditLog(
          id: '',
          actorId: ref.read(userIdProvider) ?? 'unknown',
          action: 'MEETING_LOGGED',
          targetId: meeting.leadId,
          timestamp: DateTime.now(),
        ));
      } catch (_) {}

      if (meeting.followUpDate != null) {
        try {
          await ref.read(notificationServiceProvider).scheduleNotification(
            id: meeting.hashCode,
            title: 'CRM Follow-up',
            body: 'Time to follow up on meeting: ${meeting.feedback}',
            scheduledDate: meeting.followUpDate!,
          );
        } catch (_) {}
      }
    });
  }

  Future<void> updateLeadStatus(Lead lead, LeadStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(crmRepositoryProvider).updateLeadStatus(lead.id, status);

      try {
        await ref.read(adminRepositoryProvider).logEvent(AuditLog(
          id: '',
          actorId: ref.read(userIdProvider) ?? 'unknown',
          action: 'LEAD_STATUS_UPDATED',
          targetId: lead.id,
          timestamp: DateTime.now(),
          metadata: {
            'leadName': lead.name,
            'from': lead.status.name,
            'to': status.name,
          },
        ));
      } catch (_) {}
    });
  }
}
