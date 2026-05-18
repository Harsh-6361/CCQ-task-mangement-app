import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/auth/auth_repository.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider).value;
    final isAdmin = userProfile?.role == 'admin';

    final permissions = userProfile?.permissions ?? {};

    final destinations = <({int branchIndex, NavigationDestination destination})>[
      (
        branchIndex: 0,
        destination: const NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
      ),
      if (permissions['tasks'] ?? true)
        (
          branchIndex: 1,
          destination: const NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
        ),
      if (permissions['crm'] ?? true)
        (
          branchIndex: 2,
          destination: const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'CRM',
          ),
        ),
      if (permissions['teams'] ?? true)
        (
          branchIndex: 3,
          destination: const NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Teams',
          ),
        ),
      (
        branchIndex: 4,
        destination: const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ),
      if (isAdmin)
        (
          branchIndex: 5,
          destination: const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ),
    ];
    final selectedIndex = destinations.indexWhere(
      (entry) => entry.branchIndex == navigationShell.currentIndex,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 32,
                width: 32,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 24),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CCQ Task Mgmt',
              style: GoogleFonts.libreBaskerville(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ],
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          destinations[index].branchIndex,
        ),
        destinations: destinations.map((entry) => entry.destination).toList(),
      ),
    );
  }
}
