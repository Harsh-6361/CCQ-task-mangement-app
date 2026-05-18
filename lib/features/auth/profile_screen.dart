import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/services/app_update_service.dart';
import '../../common/services/notification_service.dart';
import '../auth/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final profile = ref.watch(currentUserProfileProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: authState.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user?.email ?? 'No Email',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SelectableText(
              'User ID: ${user?.uid ?? "Unknown"}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (profile != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Chip(
                  avatar: Icon(profile.role == 'admin' ? Icons.security : Icons.person),
                  label: Text(profile.role.toUpperCase()),
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                subtitle: const Text('Allow reminders and view scheduled alerts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showNotificationSettings(context, ref),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.security_outlined),
                title: const Text('Security'),
                subtitle: const Text('Password reset and account details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSecuritySettings(context, ref, user?.email),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.system_update_alt),
                title: const Text('App updates'),
                subtitle: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version;
                    final buildNumber = snapshot.data?.buildNumber;
                    if (version == null || buildNumber == null) {
                      return const Text('Check for the latest version');
                    }
                    return Text('Current version: $version ($buildNumber)');
                  },
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _checkForUpdates(context),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<int>(
              future: ref.read(notificationServiceProvider).pendingNotificationCount(),
              builder: (context, snapshot) {
                final count = snapshot.data;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.alarm),
                  title: const Text('Scheduled reminders'),
                  subtitle: Text(count == null ? 'Checking...' : '$count reminders waiting'),
                );
              },
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () async {
                final allowed = await ref
                    .read(notificationServiceProvider)
                    .requestAndroidPermissions();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      allowed ? 'Notifications enabled' : 'Notifications were not allowed',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Enable Android Reminders'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSecuritySettings(BuildContext context, WidgetRef ref, String? email) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Security',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.mail_outline),
              title: const Text('Account email'),
              subtitle: Text(email ?? 'No email on this account'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: email == null
                  ? null
                  : () async {
                      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset sent to $email')),
                      );
                    },
              icon: const Icon(Icons.lock_reset),
              label: const Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkForUpdates(BuildContext context) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updates are only available on Android.')),
      );
      return;
    }

    final info = await AppUpdateService().fetchUpdateInfo();
    if (!context.mounted) return;

    if (info == null || info.apkUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not check for updates.')),
      );
      return;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    if (info.versionCode <= localVersionCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are on the latest version.')),
      );
      return;
    }

    await _showUpdateDialog(context, info);
  }

  Future<void> _showUpdateDialog(BuildContext context, UpdateInfo update) async {
    final versionLabel = update.versionName.isEmpty
        ? 'A newer version is available.'
        : 'Version ${update.versionName} is available.'

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(versionLabel),
            if (update.notes != null && update.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(update.notes!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final opened = await launchUrl(
                Uri.parse(update.apkUrl),
                mode: LaunchMode.externalApplication,
              );
              if (!context.mounted || opened) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open update link.')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}
