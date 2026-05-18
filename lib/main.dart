import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/crm/leads_screen.dart';
import 'features/groups/groups_screen.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/profile_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/admin/admin_screen.dart';
import 'common/widgets/main_layout.dart';
import 'common/services/notification_service.dart';
import 'common/services/app_update_service.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _shellNavigatorTasksKey = GlobalKey<NavigatorState>(debugLabel: 'tasks');
final _shellNavigatorCRMKey = GlobalKey<NavigatorState>(debugLabel: 'crm');
final _shellNavigatorGroupsKey = GlobalKey<NavigatorState>(debugLabel: 'groups');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final _shellNavigatorAdminKey = GlobalKey<NavigatorState>(debugLabel: 'admin');

final _routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      if (authState.isLoading) return null;
      if (state.uri.path == '/splash') {
         final isLoggedIn = authState.value != null;
         return isLoggedIn ? '/' : '/login';
      }

      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/signup';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTasksKey,
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCRMKey,
            routes: [
              GoRoute(
                path: '/crm',
                builder: (context, state) => const LeadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorGroupsKey,
            routes: [
              GoRoute(
                path: '/teams',
                builder: (context, state) => const GroupsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAdminKey,
            routes: [
              GoRoute(
                path: '/admin',
                builder: (context, state) => const AdminScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _checkedUpdate = false;

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(_routerProvider);

    if (!_checkedUpdate) {
      _checkedUpdate = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeCheckForUpdate());
    }

    return MaterialApp.router(
      title: 'CCQ PVT. LTD. Task Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routerConfig: router,
    );
  }

  Future<void> _maybeCheckForUpdate() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    final update = await AppUpdateService().checkForUpdate();
    if (!mounted || update == null) return;

    await _showUpdateDialog(update);
  }

  Future<void> _showUpdateDialog(UpdateInfo update) async {
    final versionLabel = update.versionName.isEmpty
        ? 'A newer version is available.'
        : 'Version ${update.versionName} is available.';

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
              if (!mounted || opened) return;
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
